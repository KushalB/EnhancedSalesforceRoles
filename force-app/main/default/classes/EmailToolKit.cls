/**
 * @description       :
 * @author            : kushalbasu2@gmail.com
 * @group             :
 * @last modified on  : 01-09-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 **/
public class EmailToolKit {
  static final string userfirstname = UserInfo.getFirstName();
  static final string useremail = UserInfo.getUserEmail();
  static final String repoUrl = 'https://github.com/KushalB/EnhancedSalesforceRoles';

  public static String addMergeFieldInfo(
    String emailBody,
    String downloadLink
  ) {
    emailBody = emailBody.replaceAll('UserFirstName', userfirstname);
    emailBody = emailBody.replaceAll('fileDownloadLink', downloadLink);
    emailBody = emailBody.replaceAll('useremail', useremail);
    emailBody = emailBody.replaceAll('repourl', repoUrl);
    return emailBody;
  }
  public static void sendFileToEmail(Document fileDoc) {
    if (fileDoc != null) {
      Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
      String[] toAddresses = new List<String>{ UserInfo.getUserEmail() };
      mail.setToAddresses(toAddresses);
      mail.setSenderDisplayName('Enhanced Salesforce Role Engine');
      String fileDownloadUrl =
        URL.getSalesforceBaseUrl().toExternalForm() +
        '/servlet/servlet.FileDownload?file=' +
        fileDoc.id;
      EmailTemplate emlTmplt = [
        SELECT id, HtmlValue, Body, Subject
        FROM EmailTemplate
        WHERE DeveloperName = 'EnhancedEmailRole_Success'
        LIMIT 1
      ];
      String emailHtmlBody = emlTmplt.HtmlValue;
      emailHtmlBody = addMergeFieldInfo(emailHtmlBody, fileDownloadUrl);
      String emailTextBody = emlTmplt.body;
      emailTextBody = addMergeFieldInfo(emailTextBody, fileDownloadUrl);
      mail.setHtmlBody(emailHtmlBody);
      mail.setPlainTextBody(emailTextBody);
      mail.setSubject(emlTmplt.Subject);
      Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ mail });
    }
  }
}
