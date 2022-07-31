import json
import boto3
import uuid
import traceback

def main(slack_token: str):
    # Itemを削除
    dynamo_db = boto3.resource('dynamodb')
    table = dynamo_db.Table('slack-table')
    table.delete_item(Key={"slackToken": slack_token})

    # 何もしなくてokの場合
    return {
        'statusCode': 200,
        'body': '{"message": "何もしない"}'
    }


def lambda_handler(event, context):
    try:
        body = json.loads(event['body'])
        slack_token = body['slackToken']
        return main(slack_token)
    except Exception as e:
        print(e)
        return {
            'statusCode': 500,
            'body': '{"message": "すでに作成されている場合"}'
        }
