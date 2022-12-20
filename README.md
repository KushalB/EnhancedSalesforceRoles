# Enhanced Salesforce Roles

For large organisation where there are more than 1000 user roles configured, it is quite painfull as a Saleforce developer or admin to get a holistic view of the Role Heirarchy easily.
Since the expand all feature doesn't work for orgs having more than 1000 roles, we have to select and expand each roles one by one. There is no out of the box feature or readily available 
hack that can help in the situation

## Thus, Introducing Enhanced Salesforce Role

Salesforce Enhanced Role is a lightweight tool written on Apex, that is extremely helpful in a situation where we need to quickly get a birdeye view of the Role hierarchy of an org.
This tool creates the XML equivalent of the Role hierarchy and saves as a document in the org that can be downloaded, reviewed and analysed quite easily.

## Disclaimer

- The Salesforce Enhanced Role tool comes with a single Apex class consisting several helper functions. 
- Each of the functions are self explanatory along with additional comments.
- I will encourage you to review the code so that you feel confident on whether this will mess anything up on the org that you're going to use it.

## Quickstart

- Once the code is deployed to your org, you can simply invoke the entry function 
by calling UserRoleExportHelper.run() function. The snippet can be found [here](https://github.com/KushalB/EnhancedSalesforceRoles/blob/master/scripts/apex/runRoleManager.apex)

## How to install

<a href="https://githubsfdeploy.herokuapp.com?owner=KushalB&repo=EnhancedSalesforceRoles" target="blank">
  <img alt="Deploy to Salesforce"
       src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/deploy.png">
</a>

