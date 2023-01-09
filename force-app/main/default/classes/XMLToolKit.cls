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
    Document fileDoc;
    public XMLToolKit() {
        super();
        doc = new Dom.Document();
    }
    public override void setRoot(id rootId){

    }
    public override void addChild(Object parent, id userRoleId){

    }
    public override Document genDoc(){
        return null;
    }
    public override String getFileName(){
        return null;
    }
}
