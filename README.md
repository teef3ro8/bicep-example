# リソースグループの作成
コマンドを実行し、リソースグループを作成する
```sh
az group create --location "作成したいリージョン" --resource-group "作成したいリソースグループ名"
```

# sshの鍵の設定
コマンドを実行する
```sh
export SSH_PUBLIC_KEY=`cat ~/.ssh/<利用する公開鍵>`
```

# 設定ファイルの編集
[deployParam.bicepparam](./deployParam.bicepparam)を変更する

# Bicepのデプロイ
```
az deployment group create --resource-group "作成したリソースグループ名" --template-file main.bicep --parameters deployParameter.bicepparam
```