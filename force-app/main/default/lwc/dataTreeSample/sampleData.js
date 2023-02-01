/**
 * Default settings values
 */
export const KEYFIELD = "RoleName";

/**
 * Columns definition
 * :: used in examples
 */

export const EXAMPLES_COLUMNS_DEFINITION_BASIC = [
  {
    type: "text",
    fieldName: "RoleName",
    label: "Role Name",
    initialWidth: 300
  },
  {
    type: "text",
    fieldName: "RoleAPIName",
    label: "Role API Name",
    initialWidth: 300
  },
  {
    type: "number",
    fieldName: "userNums",
    label: "Number of Users",
    initialWidth: 300
  }
];

/**
 * Sample data
 * :: valid basic version, no missing _children content
 */
export const EXAMPLES_DATA_BASIC = JSON.parse(
  '[{"RoleName":"CEO","_children":[{"RoleName":"CFO","_children":[]},{"RoleName":"COO"},{"RoleName":"SVPCustomerServiceSupport","_children":[{"RoleName":"CustomerSupportInternational"},{"RoleName":"CustomerSupportNorthAmerica"},{"RoleName":"InstallationRepairServices"}]}]}]'
);
//export const EXAMPLES_DATA_BASIC = JSON.parse('[[{RoleName:CEO,_children:[{RoleName:CFO,_children:[]}]]');
