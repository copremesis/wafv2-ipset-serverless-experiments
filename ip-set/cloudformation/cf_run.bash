#!/usr/bin/env bash -e
bucket_name=contact-trace-records-ctrs3bucket-1v2krbhr1f6pp
stack_name=ip-set

#in your team channel create a connector and
#it will provide you with this webhook

some_var="someVal"

aws cloudformation package \
  --template-file template.yml \
  --output-template-file serverless-output.yml \
  --s3-bucket $bucket_name

aws cloudformation deploy \
  --template-file serverless-output.yml \
  --stack-name $stack_name \
  --capabilities CAPABILITY_NAMED_IAM \
  --parameter-overrides \
    "someVar=${some_var}"
