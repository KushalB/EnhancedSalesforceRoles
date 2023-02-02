/**
 * @description       : Class to generate XML File
 * @author            : github.com/kushalb
 * @group             : Utility
 * @last modified on  : 02-02-2023
 * @last modified by  : github.com/kushalb
 **/
public inherited sharing class XMLToolKit extends FileToolkit {
  Dom.Document doc;
  Dom.XmlNode rootNode;
  public XMLToolKit() {
    super();
    doc = new Dom.Document();
  }
  public override void addChild(Object parent, id userRoleId) {
    Dom.XmlNode parentNode = (Dom.XmlNode) parent;
    if (userRoleId != null && userRoleMap.containsKey(userRoleId)) {
      Dom.XmlNode currentNode;
      UserRole role = userRoleMap.get(userRoleId);
      if (parentNode != null) {
        currentNode = parentNode.addChildElement(
          role.DeveloperName,
          null,
          null
        );
      } else {
        currentNode = doc.createRootElement(role.DeveloperName, null, null);
      }

      currentNode.setAttribute('id', role.Id);
      currentNode.setAttribute('Label', role.Name);

      if (
        userParentChildRoleMap.containsKey(userRoleId) &&
        !userParentChildRoleMap.get(userRoleId).isEmpty()
      ) {
        for (id usrRlId : userParentChildRoleMap.get(userRoleId)) {
          addChild(currentNode, usrRlId);
        }
      }
    } else {
      throw new RoleExtractionException('Unknown Role Id : ' + userRoleId);
    }
  }
  public override Document genDoc() {
    String xmlStr = genDocBody();
    if (String.isNotBlank(xmlStr)) {
      String fileName = getFileName() + '.xml';
      this.docFile = createDocument(fileName, xmlStr);
      insert this.docFile;
      sendFileToEmail();
    } else {
      throw new RoleExtractionException('Doc is Blank!');
    }
    return this.docFile;
  }
  public override String genDocBody() {
    String xmlStr;
    if (rootRoleId != null && userRoleMap.containsKey(rootRoleId)) {
      addChild(null, rootRoleId);
    } else {
      throw new RoleExtractionException('Unknown Root Role Id : ' + rootRoleId);
    }
    if (doc != null) {
      xmlStr = doc.toXmlString();
    }
    return xmlStr;
  }
}
