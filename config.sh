#!/usr/bin/env bash

# Path to certificate authority (default: https://acme-v01.api.letsencrypt.org/directory)

# Prod
CA="https://acme-v01.api.letsencrypt.org/directory"

# Staging
# CA="https://acme-staging.api.letsencrypt.org/directory"

# Path to license agreement (default: https://letsencrypt.org/documents/LE-SA-v1.0.1-July-27-2015.pdf)
LICENSE="https://letsencrypt.org/documents/LE-SA-v1.0.1-July-27-2015.pdf"

# Which challenge should be used? Currently http-01 and dns-01 are supported
CHALLENGETYPE="dns-01"

# Base directory for account key, generated certificates and list of domains (default: $SCRIPTDIR -- uses config directory if undefined)
BASEDIR=$SCRIPTDIR
KEYSIZE="4096"
HOOK=./route53-hook.rb

CONTACT_EMAIL=$CONTACT_EMAIL

LOCKFILE="${BASEDIR}/lock"
