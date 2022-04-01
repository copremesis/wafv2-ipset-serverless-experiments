#!/bin/bash


if [[ -z .env ]]; then
  echo "Please create a file '.env' using '.env.example' as a guide"
  exit
fi

source ./.env  # see .env.example for details

#set proper env vars
#ie AWS_PROFILE, cacheFile, etc.
#see env.example

aws wafv2 get-ip-set \
    --name $IPSET_NAME \
    --scope REGIONAL \
    --id $IPSET_ID  > $cacheFile

lockToken=$(jq -r '.LockToken' $cacheFile) 

#IMPORTANT step otherwise your previous IP-Set is BYE BYE
#cacheing the output above is one safety net
#but be sure to note that AWS version of update is delete and re-create

#allow admin the oportunity to delete any test ips
#ie: 192.168.x.x or 10.x.x.x

if [[ $1 == "edit-with-vim" ]]; then
  vim "$cacheFile"
fi

arr=( $(jq -r '.IPSet.Addresses[]' $cacheFile) ) 

vendorIpList=$(curl -s $IP_LIST_API | jq -c '.[]' | sed 's/"//g')
echo "pulling 3rd Party Ips (here we can add as many resources to scan as we wish mabye use https://graphql.org/ to consolidate APIs"

for ip in $vendorIpList 
do
  # if no block add /32 otherwise AWS wigs out
  newIp=$([[ "$ip" == *\/* ]] && echo $ip || echo "$ip/32")
  arr+=( "${newIp}" )
done

#echo $lockToken
#echo "Augmented set: ${arr[@]}"

echo "hold my beer..."
aws wafv2 update-ip-set \
    --name=$IPSET_NAME \
    --scope=REGIONAL \
    --id=$IPSET_ID \
    --addresses "${arr[@]}" \
    --lock-token=$lockToken 

