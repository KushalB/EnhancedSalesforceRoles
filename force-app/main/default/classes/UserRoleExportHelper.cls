/**
 * @description       : 
 * @author            : kushal.basu@salesforce.com
 * @group             : 
 * @last modified on  : 01-09-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class UserRoleExportHelper {
    public enum ExportType {XML,JSON}
    public static FileToolkit getToolKitInstance(ExportType type){
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
    @future 
    public static void startExtraction(boolean isXml){
        ExportType type = (isXml?ExportType.XML:ExportType.JSON);
        FileToolkit toolKit = getToolKitInstance(type);
        toolKit.genDoc();
    }
}