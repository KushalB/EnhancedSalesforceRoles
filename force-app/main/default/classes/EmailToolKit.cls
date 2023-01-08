/**
 * @description       : 
 * @author            : kushalbasu2@gmail.com
 * @group             : 
 * @last modified on  : 01-08-2023
 * @last modified by  : kushalbasu2@gmail.com
**/
public interface EmailToolKit {
    String addMergeFieldInfo(String emailBody,String downloadLink);
    void sendFileToEmail();
}
