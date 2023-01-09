/**
 * @description       : 
 * @author            : kushalbasu2@gmail.com
 * @group             : 
 * @last modified on  : 01-09-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public abstract class FileToolkit {
    Map<Id,UserRole> userRoleMap;
    Map<Id,List<Id>> userParentChildRoleMap;
    id rootRoleId;
    public FileToolkit(){
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
    public abstract void setRoot(id rootId);
    public abstract void addChild(Object parent, id userRoleId);
    public abstract Document genDoc();
    public abstract String getFileName();
}
