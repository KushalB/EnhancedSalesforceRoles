# 🌟 Enhanced Salesforce Roles

Managing a large number of user roles in Salesforce can be a challenging task, especially in organizations with more than 1000 roles. As a Salesforce developer or admin, getting a holistic view of the role hierarchy becomes cumbersome. The default "expand all" feature is ineffective for orgs with a significant number of roles, requiring manual expansion of each role individually. Unfortunately, there is no out-of-the-box solution or readily available workaround to address this issue.
💡 Introducing Enhanced Salesforce Role

Enhanced Salesforce Role is a lightweight tool developed in Apex that enhances the default Salesforce role display page. It provides a quick bird's eye view of the role hierarchy in organizations where the number of configured roles is enormous. This tool not only presents the role hierarchy but also allows you to export the roles as JSON and XML formats.
# ⚠️ Disclaimer

    The Salesforce Enhanced Role tool consists of a single Apex class containing several helper functions.
    Each function is self-explanatory and includes additional comments.
    We encourage you to review the code thoroughly to ensure confidence in its impact on your org.

# 🚀 Quickstart

Once the code is deployed to your org, you can easily invoke the entry function by calling the UserRoleExportHelper.run() function. You can find the code snippet here.
# ⚙️ How to Install

    🚀 <a href="https://login.salesforce.com/packaging/installPackage.apexp?p0=04t7F000005dEcU" target="_blank">
        <img alt="Deploy to Production"
        src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/deploy.png"> <br> Production <br>
      </a>
    🧪 <a href="https://test.salesforce.com/packaging/installPackage.apexp?p0=04t7F000005dEcU" target="_blank">
        <img alt="Deploy to Production"
            src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/deploy.png"> <br> Sandbox
      </a>

Please note that thorough testing and review of the code are recommended before installation to ensure compatibility and prevent any unintended impact on your Salesforce org.

We hope that Enhanced Salesforce Roles simplifies and improves your role management experience. If you have any questions, feedback, or suggestions, please don't hesitate to reach out. Happy role managing! 🎉