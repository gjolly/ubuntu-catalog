#!/bin/bash

url="https://login.microsoftonline.com/${AZURE_TENANT_ID}/oauth2/token"

payload="grant_type=client_credentials&client_id=${AZURE_CLIENT_ID}&client_secret=${AZURE_CLIENT_SECRET}&resource=https%3A%2F%2Fmanagement.azure.com%2F"

export TOKEN="$(curl -s "$url" -d"$payload" | jq -r '.access_token')"
