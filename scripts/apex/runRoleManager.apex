/**
 * @description       : 
 * @author            : github.com/kushalb
 * @group             : 
 * @last modified on  : 05-01-2025
 * @last modified by  : github.com/kushalb
**/
//UserRoleExportHelper.run();

UserRoleExportHelper.startExtraction(true);
UserRoleExportHelper.startExtraction(false);




AggregateResult[] groupedResults = [SELECT UserRole.DeveloperName, COUNT(id) FROM User GROUP BY UserRole.DeveloperName];

for (AggregateResult ar : groupedResults)  {
    System.debug('ar: '+ar);
}



Double result = CompanyNameMatcher.calculateSimilarity('Nestle', 'HUL India Pvt Ltd');
System.debug('result: '+result);


Unable to activate the Apex Language Server - Local Java runtime (Library/Java/JavaVirtualMachines/openjdk-23.0.2/Contents/Home) is unsupported. Set the salesforcedx-vscode-apex.java.home VS Code setting to a runtime outside of the current project. For more information, go to [Set Your Java Version](https://developer.salesforce.com/docs/platform/sfvscode-extensions/guide/java-setup.html).