from __future__ import print_function
import json
import sys
import boto3

def getDesiredTasks(asg_capacity, ecs_services_per_instance):
    return asg_capacity * ecs_services_per_instance

def lambda_handler (event, context):
    print (event['Records'])
    print (event['Records'][0])
    print (event['Records'][0]['Sns'])
    print (event['Records'][0]['Sns']['Message'])
    print (json.loads(event['Records'][0]['Sns']['Message'])['AutoScalingGroupName'])
    asg_name = json.loads(event['Records'][0]['Sns']['Message'])['AutoScalingGroupName']

    # Get ASG information
    autoscale = boto3.client('autoscaling')
    groups = autoscale.describe_auto_scaling_groups(AutoScalingGroupNames=[asg_name])
    asg_desired_capacity = groups['AutoScalingGroups'][0]['DesiredCapacity']
    asg_tags = groups['AutoScalingGroups'][0]['Tags']
    found_cluster_name = False
    found_services_per_instance = False
    for tag in asg_tags:
        if tag['Key'] == 'ecs_cluster_name':
            ecs_cluster_name = tag['Value']
            found_cluster_name = True
        if tag['Key'] == 'ecs_services_per_instance':
            ecs_services_per_instance = int(tag['Value'])
            found_services_per_instance = True
    if not found_cluster_name:
        print ("Could not identify cluster_name. Is ASG tagged appropriately?")
        sys.exit(1)
    if not found_services_per_instance:
        print ("Could not identify services_per_instance. Is ASG tagged appropriately?")
        sys.exit(1)        
    new_service_desiredtasks = getDesiredTasks(asg_desired_capacity,ecs_services_per_instance)

    # Get ECS information
    # Can only have one service in this cluster for this to work
    ecs = boto3.client('ecs')
    ecs_service_name = ecs.list_services(cluster=ecs_cluster_name)['serviceArns'][0]
    servicedesc =  ecs.describe_services(cluster=ecs_cluster_name, services=[ecs_service_name])
    service_desiredtasks = servicedesc['services'][0]['desiredCount']

    #new_service_desiredtasks = 4
    # If desired tasks are inconsistent with the number of ASG instances, then fix the service definition
    if service_desiredtasks != new_service_desiredtasks and new_service_desiredtasks >= 1:
        print ("Setting desired tasks from %s to %s " % (service_desiredtasks, new_service_desiredtasks))
        ecs.update_service(cluster=ecs_cluster_name, service=ecs_service_name, desiredCount=new_service_desiredtasks)
    return "success!"
