# AWS EC2 Management

### This repository provides a script to automate the controls of EC2 instances on AWS using the aws cli.

---

## Setup steps:

1. Install the aws cli on your MacOS:

Guide available [here](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html).

2. Clone this repository locally:

```sh
git clone https://github.com/roller1187/aws-management.git
```

3. If you wish to SSH into your EC2 instance, make sure your private key:
    - **Is located in your ~/.ssh directory**
    - **Its name matches the local variable $USER on your Mac**. 

e.g. 
```sh
echo $USER
```

4. Follow the instructions for initial setup available [here](https://docs.google.com/document/d/1UcgGkFnv-zZJUWrVIspSYaJH_6fsbllTaBbpiQmx574/view) for MacOS

5. Execute this script anytime you need to interact with you EC2 instances! (Remember to be on VPN)

** Syntax:  manageaws.sh start|stop|status|connect <Instance Tag> [region] **

```sh
manageaws.sh status aromero-bastion us-east-2
```
