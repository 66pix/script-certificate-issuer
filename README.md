# certificate-issuer
Wrapper arounds letsencrypt.sh and route53.rb to create and upload ssl certs to amazon

## Usage

```
export AWS_ACCESS_KEY_ID="..."
export AWS_SECRET_ACCESS_KEY="..."

./cert-issuer.sh -d domain.com -d sub.domain.com
```
