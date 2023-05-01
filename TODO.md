# TODO
The highest priority items will be addressed in April to make it possible to run the sensors throughout May. After that, the LaTeX paper will be the focus throughout the month of May (while the captures run in scale). Lower priority items will be addressed in late June and beyond.

### As soon as possible
* Improve resource and variable naming.
* Improve tcpdump filter syntax/semantics in order to make it more elegant and readable at scale/long term.
* Be sure that there is enough disk space;

### Late June and beyond
* Use OpenRC to wrap my own scripts as supervised daemons, rather than running directly from the shell as in the last 3 lines of code of the startup_script.sh file.
* Develop the honeypot solutions.
* Expand to Azure.
* Split/refactor/modularize Terraform files and state in order to improve performance, reliability, code quality and readability.
    * This has some importance for reliability because, if something happens to the state file, the entire infrastructure will no longer be recognized by Terraform.
    * Performance is also impacted a little bit, as each run iterates/checks through dozens of EC2 resources.
    * **Would it be worth the burden of managing each region as a separate environment in different root modules with different states for a few seconds of performance?**
* Make everything parametrized and abstract. Avoid hardcoding/hardwiring things.