# updating WAFv2::IPSets with aws cli and _curl_
### implementing same solution with serverless automation

The current solution provides a way to perform IPSet managment with _curl_
and the `aws` cli. By filling in these environment variables 

* AWS::WAFv2::Ipset _id_
* AWS::WAFv2::Ipset _name_
* public API for your list of allowed ip addresses

# Initial steps

**note:** If you already have an IPSet in AWS you can manage
then skip this section.

## building the ipset with cloud formation

`cd ip-set/cloudformation`

and run the script:

`./cfn_run.bash`

this will provision your WAFv2::IPSet
and add a couple of IPs as well
after you create your IPset obtain the _ARN_ to populate your
`.env` file

```
export IPSET_ID="********************************ef04"
export NAME="ip set name"
export IP_LIST_API="https://example.com/ips"
```
one can now invoke

`ip-set-sync.bash`

Which will pull any new IPs from a `IP_LIST_API` and update this list.

**note:** it is a public API for this exercise

interactive edit mode
`ip-set-sync.bash edit-with-vim`

Now, that we can manage our IPSet via the command line my goal is to routinely
perform this action using **Amazon Lambda** and **EventBridge**

## Serverless Cron experiments (WIP)

I'm reviewing two approaches using https://www.serverless.com/

* nodeJS - the included example here has some issues:
  + [ ] `serverless invoke  --function cronHandler` - completely drops at the invocation of wafv2.getIPSet
  + [x] `serverless invoke local --function cronHandler` - works like you would expect it to
  + [ ] WIP https://github.com/copremesis/wafv2-ipset-serverless-experiments/issues/1
  + [ ]  the `cronHandler` lambda goes silent when it attempts to utilize the wafv2 library
```shell
  2022-03-27 19:44:13.249 INFO    BEGIN WAF UPDATE
  ***CODE NOT EXECUTIONG HERE***
  2022-03-27 19:44:13.263 INFO    END WAF UPDATE
```

* python - just the blank cron skeleton from the serverless framework 
  - [ ] it may make sense to attempt to solve this same problem using _python_
  - [ ] review existing solution [here](https://github.com/aws-samples/aws-waf-ipset-auto-update-aws-ip-ranges)
