/**
 * @description       : Unit Tests for UserRoleExportHelper
 * @author            : github.com/kushalb
 * @group             : Unit Tests
 * @last modified on  : 02-02-2023
 * @last modified by  : github.com/kushalb
 **/
@isTest
private class UserRoleExportHelperTest {
  @testSetup
  private static void testSetup() {
  }
  @isTest
  private static void testJsonTree() {
    // Test data setup

    // Actual test
    Test.startTest();
    String jsonText = UserRoleExportHelper.getJsonForTree();
    Test.stopTest();

    // Asserts
    System.assert(
      jsonText != null,
      'JSON Text is Null. You need atleast one Role configured to deploy!'
    );
  }
  @isTest
  private static void testEmailExport() {
    // Test data setup

    // Actual test
    Test.startTest();
    UserRoleExportHelper.lwcControllertoExportasEmail(true);
    Test.stopTest();

    // Asserts
    Document[] docs = [SELECT id FROM Document WHERE name LIKE 'Roles of%'];
    System.assertEquals(1, docs.size(), 'Role Document Not created!');
  }
}
