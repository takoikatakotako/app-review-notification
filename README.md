# app-review-terraform


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