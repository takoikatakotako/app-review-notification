# app-review-terraform


WebFront

https://sandbox-web-front-bucket.s3.ap-northeast-1.amazonaws.com/index.html

# SetUp

`credentials.tf` を作ります。

```
locals {
  access_key = ${ACCESS_KEY}
  secret_key = ${SECRET_KEY}
}
```


# API

## 登録API

### 渡すもの
- slackToken
- appId

### Path
registration

### やること

1. DynamoDBにトークンが登録されているかチェックする
2. 新規登録の場合はDynamoDBに初期データを保存する

### 初期データ

```
{
  "<slackToken>": {
    "status": "xxxx",
    "failDateTime": [
    ],
    "ios": {
      "appId": {
        "sentEntryIds": [
          "xxxxxxxx",
          "xxxxxxxx"   
        ]
      }
    },
    "android": { 
    }
  }
}
```



# Docker

```
cd notification_worker/Docker
docker build -t app-review:latest .


export AWS_ACCESS_KEY_ID=YOURACCESSKEY
export AWS_SECRET_ACCESS_KEY=YOURSECRETKEY

docker run --rm app-review:latest


```