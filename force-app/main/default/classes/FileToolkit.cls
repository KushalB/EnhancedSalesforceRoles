/**
 * @description       : This is an abstract class to create Files
 * @author            : github.com/kushalb
 * @group             : Utility
 * @last modified on  : 02-02-2023
 * @last modified by  : github.com/kushalb
 **/
public abstract class FileToolkit {
  protected Map<Id, UserRole> userRoleMap;
  protected Map<Id, List<Id>> userParentChildRoleMap;
  protected id rootRoleId;
  protected Document docFile;
  protected Map<String, Integer> userNumPerRolesMap;
  protected FileToolkit() {
    userRoleMap = new Map<Id, UserRole>(
      [SELECT id, DeveloperName, Name, ParentRoleId FROM UserRole]
    );
    userParentChildRoleMap = new Map<Id, List<Id>>();
    for (UserRole usrRlObj : userRoleMap.values()) {
      if (usrRlObj.ParentRoleId == null) {
        userParentChildRoleMap.put(usrRlObj.id, new List<Id>());
        rootRoleId = usrRlObj.id;
      } else if (userParentChildRoleMap.containsKey(usrRlObj.ParentRoleId)) {
        userParentChildRoleMap.get(usrRlObj.ParentRoleId).add(usrRlObj.id);
      } else {
        userParentChildRoleMap.put(
          usrRlObj.ParentRoleId,
          new List<Id>{ usrRlObj.id }
        );
      }
    }
    userNumPerRolesMap = new Map<String, Integer>();
    AggregateResult[] userPerRoles = [
      SELECT UserRole.DeveloperName, COUNT(id)
      FROM User
      GROUP BY UserRole.DeveloperName
    ];
    for (AggregateResult tempVar : userPerRoles) {
      userNumPerRolesMap.put(
        String.valueOf(tempVar.get('DeveloperName')),
        Integer.valueOf(tempVar.get('expr0'))
      );
    }
  }
  protected void setRoot(id rootId) {
    this.rootRoleId = rootId;
  }
  public abstract void addChild(Object parent, id userRoleId);
  public abstract Document genDoc();
  public abstract String genDocBody();
  protected String getFileName() {
    return 'Roles of ' +
      UserInfo.getOrganizationName() +
      ' as of ' +
      DateTime.now().format('yyyy-mm-dd_hh-mm');
  }
  protected Document createDocument(String name, String body) {
    this.docFile = new Document();
    docFile.folderId = UserInfo.getUserId();
    docFile.Name = name;
    docFile.Body = Blob.valueOf(body);
    return docFile;
  }
  protected void sendFileToEmail() {
    EmailToolKit.sendFileToEmail(this.docFile);
  }
}
