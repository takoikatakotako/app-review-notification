import json
import sys
import urllib
from typing import Optional
from datetime import datetime
import boto3
from boto3.session import Session

# App StoreのAPIからレビューを取得する
def fetch_review_entries(app_id: str):
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
def send_slack_message(slack_token: str, title: str, rating: int, author_name: str, content: str):    
    # PythonオブジェクトをJSONに変換する
    rate_str = ':star:' * rating
    blocks = { 
        "blocks": [
            {
                "type": "section",
                "text": {
                    "type": "mrkdwn",
                    "text": f"*{title}*\n{rate_str} by {author_name}\n {content}"
                }
            }
        ]
    }
    json_data = json.dumps(blocks).encode("utf-8")

    # httpリクエストを準備してPOST
    url = slack_token
    method = 'POST'
    headers = {'Content-Type': 'application/json'}
    request = urllib.request.Request(url, data=json_data, method=method, headers=headers)
    with urllib.request.urlopen(request) as response:
        response_body = response.read().decode("utf-8")
        print(response_body)


# items を更新
def update_items(table, items):
    # iOS の中にあるIDをチェック
    for item in items:
        for app_id in item['ios']:
            try:
                # レビューのエントリーを取得
                entries = fetch_review_entries(app_id)
                for entry in entries:
                    entry_id = entry['id']['label']
                    if entry_id not in sent_entry_ids :
                        slack_token = item['slackToken']
                        title = entry['title']['label']
                        rating = entry['im:rating']['label']
                        author_name = entry['author']['name']['label']
                        content = entry['content']['label']

                        send_slack_message(slack_token, title, int(rating), author_name, content)
                        
                        # 送信済みIdを追加
                        item['ios'][app_id]['sentEntryIds'].append(entry_id)

            except Exception as e:
                fail_date_time = datetime.now().isoformat()
                item['failDateTime'].append(fail_date_time)
                break;

        # 更新する
        table.put_item(Item=item)


def main(profile: Optional[str]):
    dynamodb = boto3.resource('dynamodb')

    # profileを引数に与えられた場合
    if profile is not None:
        session = Session(profile_name='sandbox')
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
    args = sys.argv
    if len(args) == 1:
        main(None)
    else:
        profile = args[1]
        main(profile)
