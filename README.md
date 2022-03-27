# updating WAFv2::IPSets with aws cli and serverless automation

## building the ipset with cloud formation

`cd ip-set/cloudformation`

and run the script:

`./cfn_run.bash`

this will provision your WAFv2::IPSet
and add a couple of IPs as well

after you create your IPset obtain the _ARN_ to populate your
`env` file

```
export IPSET_ID="********************************ef04"
export NAME="ip set name"
export IP_LIST_API="https://example.com/ips"
```
one can now invoke

`ip-set-sync.bash`

Which will pull any new IPs from a vendor API and update this list.

interactive edit mode
`ip-set-sync.bash edit-with-vim`

## Serverless Cron experiments (WIP)

I'm reviewing two approaches using https://www.serverless.com/

* nodeJS - the included example here has some issues:
  + [ ] `serverless invoke  --function cronHandler` - completely drops at the invokation of wafv2.getIPSet
  + [x] `serverless invoke local --function cronHandler` - works like you would expect it to

* python - just the blank cron skeleton from the serverless framework 
  - [ ] it may make sense to attempt to solve this same problem using _python_
  - [ ] review existing solution [here](https://github.com/aws-samples/aws-waf-ipset-auto-update-aws-ip-ranges/blob/main/lambda/update_aws_waf_ipset.py)
