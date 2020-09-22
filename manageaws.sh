#!/bin/bash

echo ""
echo "*** IMPORTANT ***"
echo "YOU MUST BE ON THE VPN FOR THIS SCRIPT TO WORK"
echo ""

if [ $# -eq 0 ] || [ "$1" == "--help" ] || [ "$1" == "-h" ] || [ "$1" == "help" ]   
  then
    echo "No arguments supplied"
    echo "Syntax:  manageaws.sh start|stop|status|connect <Instance Tag> [region]"
    echo "   e.g.  manageaws.sh status aromero-bastion us-east-2"
    echo ""
    echo "NOTE: default region is us-east-1"
    echo ""
    exit 1
fi

python3 -m venv it-aws
source it-aws/bin/activate
kinit ${USER}@REDHAT.COM

export AWS_PROFILE=saml

if [ "$1" == "start" ] || [ "$1" == "stop" ] || [ "$1" == "status" ] || [ "$1" == "connect" ]; then
  action="$1"
  filter="$2"
elif [ "$2" == "start" ] || [ "$2" == "stop" ] || [ "$2" == "status" ] || [ "$2" == "connect" ]; then
  filter=$1
  action=$2

else
  action="start"
  filter="$1"
fi

if [ "$3" == "" ]; then
  region="us-east-1"
else
  region="$3"
fi

printf "\nACTION: '$action'\nFILTER: '$filter'\nREGION: '$region'\n\n"

~/src/aws-automation/aws-saml.py > /dev/null

instances=$(aws --profile "saml" ec2 describe-instances --filters Name=tag:OpenShiftClusterName,Values=$filter --query 'Reservations[*].Instances[*].[InstanceId,Tags[?Key==`Application`].Value]' --region $region --output text)

for instance in $instances
do
  if [ "$action" == "connect" ]; then
    ssh -i ~/.ssh/${USER}.pem ec2-user@$(aws --profile "saml" ec2 describe-instances --instance-ids $instance --region=$region | jq -r '.Reservations[0].Instances[0].PublicDnsName')
  elif [ "$action" == "status" ]; then
    echo "Instance id $instance is:" $(aws --profile "saml" ec2 describe-instances --instance-ids $instance --region=$region | jq -r '.Reservations[0].Instances[0].State.Name')
  else
    output=$(aws --profile "saml" ec2 $action-instances --instance-ids $instance --region $region)
    currentState=$(echo $output | jq -r '.[] | .[].CurrentState.Name')
    previousState=$(echo $output | jq -r '.[] | .[].PreviousState.Name')
    echo Instance $instance was $previousState and it\'s now $currentState
  fi
done
