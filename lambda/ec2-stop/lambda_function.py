#!/usr/bin/env python3

import os
import boto3
import botocore.exceptions

region = os.environ["AWS_REGION"]
ec2 = boto3.client('ec2', region_name=region)

match_substring = os.environ['MATCH_STRING']


def get_stoppable_instance_ids() -> [str]:
    def process_response(ec2_response):
        instance_ids = []
        for reservation in ec2_response['Reservations']:
            for instance in reservation['Instances']:
                instance_ids.append(instance['InstanceId'])
        return instance_ids

    filters = [{'Name': 'tag:Name', 'Values': [f'*{match_substring}*']}]

    try:
        response = ec2.describe_instances(Filters=filters)
        instances = process_response(response)
        while 'NextToken' in response:
            response = ec2.describe_instances(NextToken=response['NextToken'], Filters=filters)
            instances = instances + process_response(response)
    except botocore.exceptions.ClientError:
        print('Failed to describe instances')
        raise

    return instances


def stop_instances(instance_ids: [str]):
    print(f'Stopping instances {instance_ids}')
    try:
        ec2.stop_instances(InstanceIds=instance_ids)
    except botocore.exceptions.ClientError:
        print('Failed to stop instances')
        raise


def lambda_handler(event, context):
    print('Starting ec2-stop lambda')
    instances = get_stoppable_instance_ids()
    print(f'Found {len(instances)} stoppable instances.')
    if len(instances) > 0:
        stop_instances(instances)
    print('Done')
