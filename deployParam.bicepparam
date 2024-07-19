using './main.bicep'

// 仮想ネットワークのアドレスプレフィックス
param vnetAddressPrefix = '172.16.0.0/16'
// デフォルトサブネットのアドレスプレフィックス
param defaultSubnetAddressPrefix = '172.16.1.0/24'
// 接続許可するIPアドレス
param myPublicIP = ''
// リソース名のプレフィックス
param namePrefix = 'bicep-example'
// 仮想マシンで作成するユーザ名
param adminUsername = 'azureuser'
// SSH公開鍵
param publicKey = readEnvironmentVariable('SSH_PUBLIC_KEY','not set')
// ドメイン名(アクセスする際は、<ドメイン名>.<リージョン>.cloudapp.azure.com となる)
param vmDomain = 'bicep-vm'
