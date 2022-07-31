import json
import boto3
import uuid
import traceback

def lambda_handler(event, context):
    return {
        'statusCode': 200,
        'body': '{"message": "何もしない"}'
    }
