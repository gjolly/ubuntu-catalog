#!/bin/bash -eu

. ./auth.sh

url_offers="https://management.azure.com/subscriptions/${AZURE_SUBSCRIPTION_ID}/providers/Microsoft.Compute/locations/francecentral/publishers/Canonical/artifacttypes/vmimage/offers?api-version=2021-07-01"

offers="$(curl -s "$url_offers" -H "Authorization: Bearer $TOKEN" | jq -r ".[].name")"

for offer in $offers; do
  if [[ "$offer" =~ ^0001-com-ubuntu-server-[a-z]+$ ]] || [[ "$offer" = 'UbuntuServer' ]]; then
    url_skus="https://management.azure.com/subscriptions/${AZURE_SUBSCRIPTION_ID}/providers/Microsoft.Compute/locations/francecentral/publishers/Canonical/artifacttypes/vmimage/offers/${offer}/skus?api-version=2021-07-01"

    skus="$(curl -s "$url_skus" -H "Authorization: Bearer $TOKEN" | jq -r ".[].name")"

    for sku in $skus; do
      url_image="https://management.azure.com/subscriptions/${AZURE_SUBSCRIPTION_ID}/providers/Microsoft.Compute/locations/francecentral/publishers/Canonical/artifacttypes/vmimage/offers/${offer}/skus/${sku}/versions?\$top=1&\$orderby=name%20desc&api-version=2021-07-01"

      image="$(curl -s "$url_image" -H "Authorization: Bearer $TOKEN" | jq -r ".[0].name")"
      echo "Canonical:$offer:$sku:$image"
    done
  fi
done
