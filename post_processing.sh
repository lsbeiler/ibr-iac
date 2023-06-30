#!/bin/bash
## You need to install the aws-cli package in order to download files from S3.
## You need to install the tcpreplay suite in order to run tcprewrite.
## You need to install the Wireshark suite in order to run mergecap.
## GNU coreutils, bash, findutils and gzip packages are also required, but are usually already installed.
## Arch-based: sudo pacman -Sy aws-cli-v2 tcpreplay wireshark-qt
## Debian-based: sudo apt update && sudo apt install -y awscli tcpreplay wireshark
## Fedora: sudo dnf install awscli2 tcpreplay wireshark
set -e

# Variables related to AWS.
# If your system is NOT already authenticated with AWS otherwise, set the keys below.
#AWS_ACCESS_KEY_ID=""
#AWS_SECRET_ACCESS_KEY=""
BUCKET_NAME=ibr-data-aws

# Variables related to the local environment.
LOCAL_DIR_NAME=$1
REWRITE_OUTPUT_PREFIX=final
MERGED_OUTPUT_FILENAME_PREFIX=merged_ibr

# Synchronize S3 bucket with our local working directory.
echo "Maybe you already put the files in the $LOCAL_DIR_NAME directory or maybe you want to create the directory and sync it with S3 now, answer below."
echo -n "Sync $LOCAL_DIR_NAME with s3://$BUCKET_NAME now? (y/N): " && read x && [[ "$x" == "y" ]] && aws s3 sync s3://$BUCKET_NAME $LOCAL_DIR_NAME;

# Enter the working directory.
cd $LOCAL_DIR_NAME

# Gunzip the *.pcap.gz files.
echo -e "\nGunzipping files..."
gunzip -r .

# Remove empty files.
echo "Removing empty files..."
find . -type f -empty -print -delete

# PCAPs captured before May and/or after June 1st are discarded.
echo "Removing unwanted PCAPs..."
find ! -name '*202305*' ! -name '*20230601*' -delete

# Remove PCAPs that this script may have rewritten in past runs.
find -name "$REWRITE_OUTPUT_PREFIX-*.pcap" -delete

# Iterate through files overwriting internal IPs (RFC1918) of EC2 instances with their respective public external addresses.
# The destination IP fields of each packet in each file will be rewritten.
for f in *.pcap; do
  publicAddress=$(echo "$f" | cut -d '-' -f4)
  echo "Rewriting $f..."
  tcprewrite --fixcsum --infile=$f --outfile=$REWRITE_OUTPUT_PREFIX-$f --dstipmap=172.16.0.0/12:$publicAddress
done;

# Move the original files elsewhere.
mkdir original_pcaps
echo "Moving the original PCAPs elsewhere..."
find -name '*.pcap' ! -name "$REWRITE_OUTPUT_PREFIX-*.pcap" -exec mv -t original_pcaps {} +

# Remove the special prefix from the rewritten files.
echo "Removing the differentiating prefix from the rewritten files..."
for f in $REWRITE_OUTPUT_PREFIX-*.pcap; do 
  if [[ -f $f ]]; then
    mv "$f" "$(echo "$f" | sed "s/$REWRITE_OUTPUT_PREFIX-//")"; 
  fi
done;

# Merge the rewritten captures from each global region into a single file per region.
REGION_PREFIXES=$(ls *pcap | cut -d '-' -f1,2,3 | sed 's/.$//' | sort | uniq)
for rp in $REGION_PREFIXES; do
  mkdir -p merges/$rp/
  echo "Merging the rewritten PCAPs from $rp into merges/$rp/..."
  mergecap -w merges/$rp/${MERGED_OUTPUT_FILENAME_PREFIX}_$rp.pcap $rp*.pcap
done;

# Merge ALL of the rewritten PCAPs into a new given file.
echo -e "\nMerging all the rewritten PCAPs..."
mkdir -p merges/all/
mergecap -w merges/all/$MERGED_OUTPUT_FILENAME_PREFIX.pcap *.pcap

# Fetch some statistics.
export LC_NUMERIC="en_US.UTF-8"
TOTAL_GLOBAL_PKTS=$(tcpdump -qtnp -r $CAPTUREDIR/all/*.pcap 2>/dev/null | wc -l)
CAPTUREDIR=$LOCAL_DIR_NAME/merges

echo "Fetching statistics..."
for subdir in $CAPTUREDIR/*; do
  cd $subdir
  for f in $subdir/*.pcap; do
    TOTAL_PKTS=$(tcpdump -qtnp -r $f 2>/dev/null | wc -l)
    PERCENTAGE=$(awk "BEGIN {print (($TOTAL_PKTS/$TOTAL_GLOBAL_PKTS)*100)}")
    TOTAL_TCP=$(tcpdump -qtnp -r $f 'tcp' 2>/dev/null | wc -l)
    TOTAL_UDP=$(tcpdump -qtnp -r $f 'udp' 2>/dev/null | wc -l)
    TOTAL_ICMP=$(tcpdump -qtnp -r $f 'icmp' 2>/dev/null | wc -l)
    TOP10_SRC_IPS=$(tcpdump -qtnnp -r $f 2>/dev/null | awk '{print $2}' | cut -d '.' -f1,2,3,4 | sort | uniq -c | sort -nr | head -10)
    TOP10_TCP_PORTS=$(tcpdump -qtnnp -r $f 'tcp' 2>/dev/null | cut -d '.' -f 9 | cut -d ':' -f1 | sort | uniq -c | sort -nr | head -10)
    TOP10_UDP_PORTS=$(tcpdump -qtnnp -r $f 'udp' 2>/dev/null | cut -d '.' -f 9 | cut -d ':' -f1 | sort | uniq -c | sort -nr | head -10)
    # echo "\textbf{$(basename $subdir)} & $(printf "%'d" $TOTAL_PKTS) ($(printf "%.2f\n" $PERCENTAGE)\%) & $(printf "%'d" $TOTAL_TCP) & $(printf "%'d" $TOTAL_UDP) & $(printf "%'d" $TOTAL_ICMP) \\\ \hline"
    echo "$(basename $subdir)'s total packets: $(printf "%'d" $TOTAL_PKTS) ($(printf "%.2f\n" $PERCENTAGE)\%)"
    echo "$(basename $subdir)'s total TCP packets: $(printf "%'d" $TOTAL_TCP)"
    echo "$(basename $subdir)'s total UDP packets: $(printf "%'d" $TOTAL_UDP)"
    echo "$(basename $subdir)'s total ICMP packets: $(printf "%'d" $TOTAL_ICMP)"
    # TODO: Print the TOP 10s.
  done;
  echo "---------------------"
done;

# Gzip the merged file.
echo "Gzipping each file inside the merges directory..."
gzip -r merges/
echo "Finished successfully!"
