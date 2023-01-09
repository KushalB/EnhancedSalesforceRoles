/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 01-09-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public inherited sharing class XMLToolKit extends FileToolkit{
    Dom.Document doc; 
    Dom.XmlNode rootNode;
    public XMLToolKit() {
        super();
        doc = new Dom.Document();
    }
    public override void addChild(Object parent, id userRoleId){
        Dom.XmlNode parentNode = (Dom.XmlNode) parent;
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
                    addChild(currentNode,usrRlId);
                }
            }
        }else{
            throw new RoleExtractionException('Unknown Role Id : '+userRoleId);
        }
    }
    public override Document genDoc(){
        if(rootRoleId!=null && userRoleMap.containsKey(rootRoleId)){
            addChild(null,rootRoleId);
        }else{
            throw new RoleExtractionException('Unknown Root Role Id : '+rootRoleId);
        }
        if(doc!=null){
            String xmlStr = doc.toXmlString();
            String fileName = getFileName()+'.xml';
            this.docFile = createDocument(fileName,xmlStr);
            insert this.docFile;
            sendFileToEmail();
        }else{
            throw new RoleExtractionException('Doc is null!');
        }
        return this.docFile;
    }
}
