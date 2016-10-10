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
[[ -d letsencrypt.sh ]] || git clone https://github.com/lukas2511/dehydrated.git

# Install aws cli & bundle if not present
if ! type "aws" > /dev/null; then
    pip install awscli
fi
if ! type "bundle" > /dev/null; then
    gem install bundle
fi

# Create the certificates for the given domains
./dehydrated/dehydrated -f ./config.sh --cron $@

DATE=`date +%Y-%m-%d`
EXPIRATION_DATE=$(date -v +80d +%Y-%m-%d)

# Upload each certificate to AWS
for CERTIFICATE_FILE in ./dehydrated/certs/*
do
    CERTIFICATE="${CERTIFICATE_FILE##*/}-${DATE}_${EXPIRATION_DATE}"
    aws iam upload-server-certificate \
        --server-certificate-name ${CERTIFICATE} \
        --certificate-body file://${CERTIFICATE_FILE}/cert.pem \
        --private-key file://${CERTIFICATE_FILE}/privkey.pem \
        --certificate-chain file://${CERTIFICATE_FILE}/chain.pem
done

rm -rf dehydrated
