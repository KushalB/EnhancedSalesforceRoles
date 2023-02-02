# Enhanced Salesforce Roles

For large organisation where there are more than 1000 user roles configured, it is quite painfull as a Saleforce developer or admin to get a holistic view of the Role Heirarchy easily.
Since the expand all feature doesn't work for orgs having more than 1000 roles, we have to select and expand each roles one by one. There is no out of the box feature or readily available
hack that can help in the situation

## Thus, Introducing Enhanced Salesforce Role

Salesforce Enhanced Role is a lightweight tool written on Apex, that enhances the default salesforce role display page in a situation where we need to quickly get a birdeye view of the Role hierarchy of an org where the number of roles configured in the org is gigantic. This tool shows the role hierarchy along with the ability to export the roles as JSON and XML.

## Quickstart

- To use this app you have to install the unmanaged package.
- Once the package is installed in your org, you can simply open the "Enhanced Role" lightning app on your org.
- That's it!

## Installation

<a href="https://login.salesforce.com/packaging/installPackage.apexp?p0=04t7F000005dEcU" target="_blank">
  <img alt="Deploy to Production"
       src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/deploy.png"> <br> Production <br>
</a>
<a href="https://test.salesforce.com/packaging/installPackage.apexp?p0=04t7F000005dEcU" target="_blank">
  <img alt="Deploy to Production"
       src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/deploy.png"> <br> Sandbox
</a>
