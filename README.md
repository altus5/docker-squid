squid のよる https 対応のプロキシー
=================================

squid を使った http/https のプロキシーサーバーの Docker イメージです。
https もキャッシュする場合は、 ssl_bump と、自己認証局で証明書を作成して、
squid.cond に設定することで、キャッシュすることができるようになります。

このプロキシーは、composer や、 yum などのレスポンスが遅かったり、
ダウンしていて、開発が滞ることがないように、開発環境に配置することを
想定しています。  
そのため、セキュリティについては、考えられていないことを、ご注意ください。

## Quickstart

デフォルト設定のままで、起動する場合のコマンド例は、次のとおり。  
http がプロキシーされます。

```
docker run -d -p 3128:3128 altus5/squid
```

## Configuration

### httpsキャッシュの有効

#### 独自CAの証明書
次のコンテナを使うと、素早く作成できます。あわせて、使ってみてください。
https://hub.docker.com/r/altus5/cfssl/

#### squid.conf

上記の独自CAで作成した証明書が、./etc/cfssl に作成されたものとして、
httpsをキャッシュする設定例を squid.conf に作成してあります。

### コマンド例

```
docker run \
  -d \
  -p 3128:3128 \
  -p 3129:3129 \
  -v $(pwd)/squid:/opt/squid \
  -v $(pwd)/squid.conf:/etc/squid/squid.conf \
  -v $(pwd)/log/:/var/log/squid/ \
  -v $(pwd)/etc/cfssl/ca.pem:/etc/cert/ca.pem \
  -v $(pwd)/etc/cfssl/ca-key.pem:/etc/cert/ca-key.pem \
  altus5/squid:0.5.0
```

* /opt/squid  
キャッシュデータの配置場所。  
* /etc/squid/squid.conf  
squid.conf を置き換える場合に。
* /var/log/squid/  
ログファイルを見る場合に。
* /etc/cert/ca.pem  /etc/cert/ca-key.pem  
独自CAの証明書を設置する場合。  
証明書のパスは、 squid.conf で指定しているので、それに合わせる。

## クライアント設定

**wget**  
export http_proxy=http://192.168.33.10:3128  
export https_proxy=http://192.168.33.10:3129  
httpsの場合は、独自CAのエラー回避のために、 --no-check-certificate を付ける。

**curl**  
export http_proxy=http://192.168.33.10:3128  
export https_proxy=http://192.168.33.10:3129  
httpsの場合は、独自CAのエラー回避のために、 --insecure を付ける。

