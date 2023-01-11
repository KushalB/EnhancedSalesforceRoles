/**
 * @description       :
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             :
 * @last modified on  : 01-11-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 **/
public with sharing class JSONToolkit extends FileToolkit {
  RolePOJO rootRole;
  public JSONToolkit() {
    super();
  }
  public override void addChild(Object parent, id userRoleId) {
    RolePOJO parentRole = (RolePOJO) parent;
    if (userRoleId != null && userRoleMap.containsKey(userRoleId)) {
      UserRole role = userRoleMap.get(userRoleId);
      RolePOJO currentRole = new RolePOJO();
      currentRole.RoleName = role.DeveloperName;
      if (parentRole != null) {
        parentRole.childRoles.add(currentRole);
      } else {
        rootRole = currentRole;
      }
      if (
        userParentChildRoleMap.containsKey(userRoleId) &&
        !userParentChildRoleMap.get(userRoleId).isEmpty()
      ) {
        for (id usrRlId : userParentChildRoleMap.get(userRoleId)) {
          addChild(currentRole, usrRlId);
        }
      }
    } else {
      throw new RoleExtractionException('Unknown Role Id : ' + userRoleId);
    }
  }
  public override Document genDoc() {
    if (rootRoleId != null) {
      String jsonStr = genDocBody();
      String fileName = getFileName() + '.json';
      this.docFile = createDocument(fileName, jsonStr);
      insert this.docFile;
      sendFileToEmail();
    } else {
      throw new RoleExtractionException('Doc is null!');
    }
    return this.docFile;
  }
  public override String genDocBody() {
    if (rootRoleId != null && userRoleMap.containsKey(rootRoleId)) {
      addChild(null, rootRoleId);
    } else {
      throw new RoleExtractionException('Unknown Root Role Id : ' + rootRoleId);
    }
    String jsonStr = JSON.serializePretty(rootRole, true);
    return jsonStr;
  }
  public class RolePOJO {
    String RoleName;
    RolePOJO[] childRoles;
    RolePOJO() {
      childRoles = new List<RolePOJO>();
    }
  }
}
