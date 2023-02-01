//UserRoleExportHelper.run();

UserRoleExportHelper.startExtraction(true);
UserRoleExportHelper.startExtraction(false);




AggregateResult[] groupedResults = [SELECT UserRole.DeveloperName, COUNT(id) FROM User GROUP BY UserRole.DeveloperName];

for (AggregateResult ar : groupedResults)  {
    System.debug('ar: '+ar);
}