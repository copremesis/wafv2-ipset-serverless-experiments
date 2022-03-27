'use strict';

const logJson = (object) => {
  console.log(JSON.stringify(object, null, 2));
}

const update_ipset = async (wafv2) => {
  console.log('BEGIN WAF UPDATE');
  await wafv2.getIPSet({
    Id: process.env.IPSET_ID, 
    Name: process.env.NAME,  
    Scope: 'REGIONAL',       
  }, async (err, data) => {
    if (err) console.error(err, err.stack); // an error occurred
    else  {
      let lockToken = data.LockToken;
      //add address to the list
      let addresses = data.IPSet.Addresses.map(ip => ip);
      addresses.push('8.8.8.8/32');
      addresses.push('7.7.7.7/32');
      addresses.push('6.6.6.6/32');
      logJson(addresses);
      const params = {
        Addresses: addresses,
        Id: process.env.IPSET_ID, 
        LockToken: lockToken,
        Name: process.env.NAME, 
        Scope: 'REGIONAL', 
        Description: 'scheduled sync'
      };
      await wafv2.updateIPSet(params, (err, data) => {
        if (err) console.error(err, err.stack); // an error occurred
        else     console.log(data);           // successful response
      });
    }
  });
  console.log('END WAF UPDATE');
}

module.exports.run = async (event, context) => {
  const AWS = require("aws-sdk");
  AWS.config.update({region:'us-west-2'});
  logJson(event);
  const wafv2 = new AWS.WAFV2({apiVersion: '2019-07-29'});
  logJson(process.env);
  try {
    await update_ipset(wafv2);
  } catch(e) {
    console.log(e)
  }
  return "ok";
};

//module.exports.run();
