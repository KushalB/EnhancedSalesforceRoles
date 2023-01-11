/**
 * @description       :
 * @author            : kushal.basu@salesforce.com
 * @group             :
 * @last modified on  : 01-11-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 **/
public with sharing class UserRoleExportHelper {
  public enum ExportType {
    XML,
    JSON
  }
  public static FileToolkit getToolKitInstance(ExportType type) {
    FileToolkit toolKit;
    switch on type {
      when XML {
        toolKit = new XMLToolKit();
      }
      when JSON {
        toolKit = new JSONToolkit();
      }
    }
    return toolKit;
  }
  @AuraEnabled
  public static string lwcControllertoExportasXML() {
    try {
      ExportType type = ExportType.XML;
      FileToolkit toolkitObj = getToolKitInstance(type);
      return toolkitObj.genDocBody();
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }
  @AuraEnabled
  public static string lwcControllertoExportasJSON() {
    try {
      ExportType type = ExportType.JSON;
      FileToolkit toolkitObj = getToolKitInstance(type);
      return toolkitObj.genDocBody();
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }
  @AuraEnabled
  public static string lwcControllertoExportasEmail(boolean isXml) {
    try {
      //TODO: EMAIL SENDING
      startExtraction(isXml);
      return 'Successfully Sent';
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }
  @future
  public static void startExtraction(boolean isXml) {
    ExportType type = (isXml ? ExportType.XML : ExportType.JSON);
    FileToolkit toolKit = getToolKitInstance(type);
    toolKit.genDoc();
  }
}
