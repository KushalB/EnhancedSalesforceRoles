/**
 * @description       : This is a Helper class to formulate Email Body and Send Email
 * @author            : github.com/kushalb
 * @group             : Utility
 * @last modified on  : 02-02-2023
 * @last modified by  : github.com/kushalb
 **/
public class EmailToolKit {
  static final string userfirstname = UserInfo.getFirstName();
  static final string useremail = UserInfo.getUserEmail();
  static final String repoUrl = 'shorturl.at/aLT03';

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
