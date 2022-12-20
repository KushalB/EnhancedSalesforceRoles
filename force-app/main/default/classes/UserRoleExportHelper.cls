/**
 * @description       : 
 * @author            : kushal.basu@salesforce.com
 * @group             : 
 * @last modified on  : 12-20-2022
 * @last modified by  : kushalbasu2@gmail.com
**/
public with sharing class UserRoleExportHelper {
    Map<Id,UserRole> userRoleMap;
    Map<Id,List<Id>> userParentChildRoleMap;
    id rootRoleId;
    Dom.Document doc; 
    Dom.XmlNode rootNode;
    /**
    * @description To initialise the variables.
    * @author kushalbasu2@gmail.com | 12-19-2022 
    **/
    public UserRoleExportHelper() {
        doc = new Dom.Document();
        userRoleMap = new Map<Id,UserRole>([SELECT id,DeveloperName,ParentRoleId FROM UserRole]);
        userParentChildRoleMap = new Map<Id,List<Id>>();
        for(UserRole usrRlObj :  userRoleMap.values()){
            if(usrRlObj.ParentRoleId==null){
                userParentChildRoleMap.put(usrRlObj.id,new List<Id>());
                rootRoleId = usrRlObj.id;
            }else if(userParentChildRoleMap.containsKey(usrRlObj.ParentRoleId)){
                userParentChildRoleMap.get(usrRlObj.ParentRoleId).add(usrRlObj.id);
            }else{
                userParentChildRoleMap.put(usrRlObj.ParentRoleId,new List<Id>{usrRlObj.id});
            }
        }
    }
    /**
    * @description To set the custom root node if we want to ignore the default root role configured in the system
    * @author kushalbasu2@gmail.com | 12-19-2022 
    * @param rootId 
    **/
    public void setRootNode(id rootId){
        this.rootRoleId = rootId;
    }
    /**
    * @description To start traversing the role heirarchy configured in the org and create the Dom.XmlNode strucure
    * @author kushalbasu2@gmail.com | 12-19-2022 
    **/
    public void startExtracting(){
        if(rootRoleId!=null && userRoleMap.containsKey(rootRoleId)){
            addRoleAsChildNode(null,rootRoleId);
        }else{
            throw new UserRoleExportException('Unknown Root Role Id : '+rootRoleId);
        }
    }
    
    /**
    * @description To recursively call itself for each child roles available.
    * @author kushalbasu2@gmail.com | 12-19-2022 
    * @param parentNode 
    * @param userRoleId 
    **/
    private void addRoleAsChildNode(Dom.XmlNode parentNode,id userRoleId){
        if(userRoleId!=null && userRoleMap.containsKey(userRoleId)){
            Dom.XmlNode currentNode;
            UserRole role = userRoleMap.get(userRoleId);
            if(parentNode!=null){
                currentNode = parentNode.addChildElement(role.DeveloperName,null, null);
            }else{
                currentNode = doc.createRootElement(role.DeveloperName,null, null);
            }
            if(userParentChildRoleMap.containsKey(userRoleId) && !userParentChildRoleMap.get(userRoleId).isEmpty()){
                for(id usrRlId : userParentChildRoleMap.get(userRoleId)){
                    addRoleAsChildNode(currentNode,usrRlId);
                }
            }
        }else{
            throw new UserRoleExportException('Unknown Role Id : '+userRoleId);
        }
    }
    /**
    * @description To generate and store Role Hierarchy as XML Document
    * @author kushalbasu2@gmail.com | 12-19-2022 
    **/
    public void generateRoleXMlDocument(){
        if(doc!=null){
            String xmlStr = doc.toXmlString();
            insert createDocument('Roles.xml',xmlStr);
        }else{
            throw new UserRoleExportException('Doc is null!');
        }
    }
    /**
    * @description To generate and store Role Hierarchy as JSON Document
    * @author kushalbasu2@gmail.com | 12-19-2022 
    **/
    public void generateRoleJsonDocument(){
        if(doc!=null){
            String jsonStr = JSON.serialize(doc, true);
            insert createDocument('Roles.json',jsonStr);
        }else{
            throw new UserRoleExportException('Doc is null!');
        }
    }
    private Document createDocument(String name, String body){
        Document docFile = new Document();
        docFile.folderId = UserInfo.getUserId();
        docFile.Name = name;
        docFile.Body = Blob.valueOf(body);
        return docFile;
    }
    public class UserRoleExportException extends Exception{

    }
    @future
    public static void run(){
        UserRoleExportHelper usrHlp = new UserRoleExportHelper();
        usrHlp.startExtracting();
        usrHlp.generateRoleXMlDocument();
    }
}