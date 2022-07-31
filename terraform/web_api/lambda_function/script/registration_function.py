import json
import boto3
import uuid
import traceback

def main(slack_token: str, app_id: str):

    # Item がすでに存在するかチェック
    dynamo_db = boto3.resource('dynamodb')
    table = dynamo_db.Table('slack-table')
    response = table.get_item(Key={"slackToken": slack_token})

    # Item が無く、新規作成の場合
    if 'Item' not in response:
        item = {
            'slackToken': slack_token,
            'status': 'New',
            'failDateTime': [],
            'ios': {
                app_id: {
                    'sentEntryIds': []
                }
            },
            'android': {}
        }
        table.put_item(Item=item)
        return {
            'statusCode': 200,
            'body': '{"message": "新規作成完了"}'
        }


    # すでにItemが作成されている場合
    item = response['Item']
    ios = item['ios']
    
    # アプリIDが登録されていない場合
    if app_id not in ios:
        ios[app_id] = {
            'sentEntryIds': []
        }
        item['ios'] = ios
        table.put_item(Item=item)
        return {
            'statusCode': 200,
            'body': '{"message": "追加完了"}'
        }


    # 何もしなくてokの場合
    return {
        'statusCode': 200,
        'body': '{"message": "何もしない"}'
    }


def lambda_handler(event, context):
    try:
        body = json.loads(event['body'])
        slack_token = body['slackToken']
        app_id = body['appId']
        return main(slack_token, app_id)
    except Exception as e:
        print(e)
        return {
            'statusCode': 500,
            'body': '{"message": "すでに作成されている場合"}'
        }
