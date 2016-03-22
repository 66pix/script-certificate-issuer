#!/bin/bash

function usage() {
    echo "Usage: "
    echo "$0 -e you@domain.com -d domain.com -d sub.domain.com"
    exit 1
}

if [ -z "$1" ]; then
    usage;
fi

# Clone letsencrypt if not present
[[ -d letsencrypt.sh ]] || git clone https://github.com/lukas2511/letsencrypt.sh.git

# Install aws cli & bundle if not present
if ! type "aws" > /dev/null; then
    pip install awscli
fi
if ! type "bundle" > /dev/null; then
    gem install bundle
fi

# Create the certificates for the given domains
./letsencrypt.sh/letsencrypt.sh -f ./config.sh --cron $@

# Upload each certifiate to AWS
for CERTIFICATE_FILE in ./letsencrypt.sh/certs/*
do
    CERTIFICATE="${CERTIFICATE_FILE##*/}"
    aws iam upload-server-certificate \
        --server-certificate-name $CERTIFICATE \
        --certificate-body file://$CERTIFICATE_FILE/cert.pem \
        --private-key file://$CERTIFICATE_FILE/privkey.pem \
        --certificate-chain file://$CERTIFICATE_FILE/chain.pem
done
