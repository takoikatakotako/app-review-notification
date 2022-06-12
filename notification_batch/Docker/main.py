import json
import urllib
from datetime import datetime
import boto3
from boto3.session import Session

# App StoreのAPIからレビューを取得する
def fetch_review_entries(app_id: str, content: str):
    url = f'https://itunes.apple.com/jp/rss/customerreviews/id={app_id}/sortBy=mostRecent/json'
    response = urllib.request.urlopen(url)
    content = json.loads(response.read().decode('utf8'))
    feed = content['feed']
    
    # レビューがついていない場合はentryのキーが存在しない
    if 'entry' not in feed:
        return []
    else:
        return feed['entry']


# Slackにメッセージを送る
def send_slack_message(slack_token: str):
    url = slack_token
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


# items を更新
def update_items(table, items):
    # iOS の中にあるIDをチェック
    for item in items:
        ios = item['ios']

        for app_id in ios:
            # 新たに送信したレビューのidを格納する
            sent_entry_ids = ios[app_id]['sentEntryIds']

            # レビューのエントリーを取得
            entries = fetch_review_entries(app_id)
            for entry in entries:
                entry_id = entry['id']['label']
                if entry_id not in sent_entry_ids :
                    slack_token = item['slackToken']
                    title = entry['title']['label']
	                author_name = entry['author']['name']['label']
	                content = entry['content']['label']

                    try:
                        send_slack_message(slack_token, content)
                    except Exception as e:
                        fail_date_time = datetime.now().isoformat()
                        item['failDateTime'].append(fail_date_time)
                        break 2;

                    # 送信済みIdに追加
                    sent_entry_ids.append(entry_id)

            # 送信済みのEntryIdを更新する
            ios[app_id]['sentEntryIds'] = sent_entry_ids

        # 更新する
        item['ios'] = ios
        table.put_item(Item=item)


def main():
    # Settion
    profile = 'sandbox'
    session = Session(profile_name=profile)
    dynamodb = session.resource('dynamodb')
    table = dynamodb.Table('slack-table')

    # Get Items
    response = table.scan()
    items = response['Items']
    update_items(table, items)

    while 'LastEvaluatedKey' in response:
        response = table.scan(ExclusiveStartKey=response['LastEvaluatedKey'])
        items = response['Items']
        update_items(table, items)


if __name__ == "__main__":
    main()
