import json
import boto3
import urllib



def lambda_handler(event, context):
    
    print(event)
    print(context)
    
    
    
    # body = json.loads(event['body'])
    
    # token = body['token']
    # app_id = body['appId']
    
    token = 'hello'

    # すでにあるかチェック
    
    
    # 保存する
    dynamoDB = boto3.resource('dynamodb')
    table = dynamoDB.Table('slack-table')
    
    # table.put_item(
    #     Item = {
    #         'slackToken': token
    #     }
    # )
    response = table.get_item(Key={"slackToken": "xxxx"})
    item = response['Item']
    sent_entries = item['sentEntries']


    # チェックする
    url = 'https://itunes.apple.com/jp/rss/customerreviews/id=674401547/sortBy=mostRecent/json'

    response = urllib.request.urlopen(url)
    content = json.loads(response.read().decode('utf8'))

    feed = content['feed']
    entries = feed['entry']


    
    new_ids = []


    for entry in entries:
        id = entry['id']['label']
        
        if id not in sent_entries :

            url = 'xxx'
            method = "POST"
            headers = {"Content-Type" : "application/json"}

            # PythonオブジェクトをJSONに変換する
            obj = {'text' : 'Hello, World!'} 
            json_data = json.dumps(obj).encode("utf-8")

            # httpリクエストを準備してPOST
            request = urllib.request.Request(url, data=json_data, method=method, headers=headers)
            with urllib.request.urlopen(request) as response:
                response_body = response.read().decode("utf-8")
                print(response_body)
                new_ids.append(id)

            
    # マージ
    sent_entries += new_ids


    # 更新
    item['sentEntries'] = sent_entries

    #         
    table.put_item(Item=item)




    return {
        'statusCode': 200,
        'body': json.dumps(item)
    }
