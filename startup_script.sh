#!/bin/sh

# Tells the Linux kernel to disable the implementation of the IPv6 protocol, since IPv6 is out of the scope of this project.
sysctl -w net.ipv6.conf.all.disable_ipv6=1
sysctl -w net.ipv6.conf.default.disable_ipv6=1

# Move the SSH port to another one, out of our 'researching range'.
sed -i 's/#Port 22/Port 65535/' /etc/ssh/sshd_config
service sshd restart

# Ensure proper UTC time synchronization with busybox's ntpd.
setup-timezone -z UTC
setup-ntp busybox

# Install all the needed packages.
apk add --no-cache tcpdump aws-cli curl jq

# Alpine's AMI packages doas instead of sudo, hence this is a helpful alias for most people.
echo 'alias sudo="doas"' >> /etc/profile

export HAPPY_ENDING_EXECUTABLE="/usr/local/bin/happy-ending"
export TERMINATION_PROBES_EXECUTABLE="/usr/local/bin/probe-ec2-termination"
export EC2_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)
export EC2_ZONE=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)
export NET_DEV="eth0"
export SAVE_DIR="/tmp"

# Composing the tcpdump filter.
export RFC1918_ADDRESSES="not src net 172.16.0.0/12 and not src net 10.0.0.0/8 and not src net 192.168.0.0/16"
export LINK_LOCAL="not net 169.254.0.0/16"
export LEGITIMATE_SSH_PORT="not port 65535"
# Copying data to S3 generates traffic to the S3 APIs in the bucket's respective region, this needs to be filtered.
export FILTERED_S3_CIDR=$(curl -s https://ip-ranges.amazonaws.com/ip-ranges.json | jq -r '.prefixes[] | select(.service=="S3") | select(.region=='\"${S3_REGION}\"') | .ip_prefix' | xargs printf -- ' and not net %s ')

# Set the tcpdump filters.
TCPDUMP_FILTERS="$RFC1918_ADDRESSES and $LINK_LOCAL and $LEGITIMATE_SSH_PORT $FILTERED_S3_CIDR"

# Create and enable swapfile.
dd if=/dev/zero of=/swapfile bs=1024 count=1000024
chmod 0600 /swapfile
mkswap /swapfile
swapon /swapfile

# Create the script to pass into the `-z postrotate-command` tcpdump argument. This very same script will also be called when EC2 wants to terminate the instance.
# tcpdump will call this script every time it rotates (e.g. each 3600s).
cat << EOF > $HAPPY_ENDING_EXECUTABLE
#!/bin/sh

if [[ -z "\$1" ]]; then
  CURRENT_PCAP=\$(ls $SAVE_DIR/*pcap)
else
  CURRENT_PCAP=\$1
fi

# Save instance metadata on termination.
BASE_URL="http://169.254.169.254/latest/meta-data/"
for metadata in \$(curl -s \$BASE_URL); do
  if [ "\$${metadata: -1}" != "/" ]; then
    echo "\$metadata is \$(curl -s \$BASE_URL/\$metadata)" >> \$CURRENT_PCAP.txt
  fi
done
echo "Dropped packets: " \$(grep $NET_DEV /proc/net/dev | awk '{print \$5}') >> \$CURRENT_PCAP.txt
echo "tcpdumpd status: " \$(rc-service tcpdumpd status) >> \$CURRENT_PCAP.txt

gzip \$CURRENT_PCAP
aws s3 mv \$(dirname \$CURRENT_PCAP | tail -1) s3://${S3_NAME}/ --recursive --exclude "*" --include "\$CURRENT_PCAP*"
EOF
chmod +x $HAPPY_ENDING_EXECUTABLE

# Create and run the script responsible for probing AWS APIs to check if a termination is about to happen. It will be called by cron every minute.
cat << EOF > $TERMINATION_PROBES_EXECUTABLE
#!/bin/sh

# It returns 200 if there's a termination about to happen.
HTTP_STATUS=\$(curl -s -w %\{http_code} -o /dev/null http://169.254.169.254/latest/meta-data/spot/instance-action)

if [[ "\$HTTP_STATUS" -eq 200 ]]; then
  rc-service tcpdumpd stop
fi
EOF
chmod +x $TERMINATION_PROBES_EXECUTABLE
echo "*	*	*	*	*	$TERMINATION_PROBES_EXECUTABLE" >> /etc/crontabs/root
rc-update  add crond default
rc-service crond start

# Create the service responsible for wrapping and supervisioning tcpdump.
cat << EOF > /etc/init.d/tcpdumpd
#!/sbin/openrc-run
name="tcpdumpd"
description="tcpdump running as a supervised daemon"

supervisor="supervise-daemon"
command="/usr/bin/tcpdump"
command_args="-G 43200 -i $NET_DEV -z $HAPPY_ENDING_EXECUTABLE -w $SAVE_DIR/$EC2_ZONE-$EC2_IP-\%Y\%m\%d-\%H\%M.pcap $TCPDUMP_FILTERS"
pidfile=/run/tcpdumpd.pid

stop_post()
{
  $HAPPY_ENDING_EXECUTABLE
}
EOF
chmod +x /etc/init.d/tcpdumpd
rc-update  add tcpdumpd default
rc-service tcpdumpd start