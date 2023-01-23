import { LightningElement } from "lwc";
import getText from "@salesforce/apex/UserRoleExportHelper.lwcControllertoExportasText";
import sendEmail from "@salesforce/apex/UserRoleExportHelper.lwcControllertoExportasEmail";

export const KEYFIELD = "RoleName";

export default class ViewAndExportRoles extends LightningElement {
  text = "";
  isXml = true;
  //gridData="";
  get options() {
    return [
      { label: "XML", value: "XML" },
      { label: "JSON", value: "JSON" }
    ];
  }
  optionSelectionHandler(event) {
    let type = event.detail.value;
    if (type === "XML") {
      this.isXml = true;
    } else {
      this.isXml = false;
    }
  }
  handleClickonShow() {
    getText({ isXml: this.isXml })
      .then((result) => {
        this.text = result;
        // this.gridData = result;
      })
      .catch((error) => {
        this.text = error;
      });
  }
  handleClickonSend() {
    sendEmail({ isXml: this.isXml })
      .then((result) => {
        this.text = result;
      })
      .catch((error) => {
        this.text = error;
      });
  }
  handleClickonClear() {
    this.text = "";
  }
  clickToExpandAll() {
    const grid = this.template.querySelector("lightning-tree-grid");
    grid.expandAll();
  }

  clickToCollapseAll() {
    const grid = this.template.querySelector("lightning-tree-grid");
    grid.collapseAll();
  }
  gridColumns = [
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
    }
  ];
  gridData = JSON.parse(
    '[{"RoleName":"CEO","RoleLabel":"CEO","roleId":"00E7F000001YhbCUAS","_children":[{"RoleName":"CFO","RoleLabel":"CFO","roleId":"00E7F000001YhbJUAS","_children":[]},{"RoleName":"COO","RoleLabel":"COO","roleId":"00E7F000001YhbTUAS","_children":[]},{"RoleName":"SVPCustomerServiceSupport","RoleLabel":"SVP, Customer Service & Support","roleId":"00E7F000001YhbHUAS","_children":[{"RoleName":"CustomerSupportInternational","RoleLabel":"Customer Support, International","roleId":"00E7F000001YhbQUAS","_children":[]},{"RoleName":"CustomerSupportNorthAmerica","RoleLabel":"Customer Support, North America","roleId":"00E7F000001YhbLUAS","_children":[]},{"RoleName":"InstallationRepairServices","RoleLabel":"Installation & Repair Services","roleId":"00E7F000001YhbOUAS","_children":[]}]},{"RoleName":"SVPHumanResources","RoleLabel":"SVP, Human Resources","roleId":"00E7F000001YhbSUAS","_children":[]},{"RoleName":"SVPSalesMarketing","RoleLabel":"SVP, Sales & Marketing","roleId":"00E7F000001YhbDUAS","_children":[{"RoleName":"VPInternationalSales","RoleLabel":"VP, International Sales","roleId":"00E7F000001YhbRUAS","_children":[]},{"RoleName":"VPMarketing","RoleLabel":"VP, Marketing","roleId":"00E7F000001YhbGUAS","_children":[{"RoleName":"MarketingTeam","RoleLabel":"Marketing Team","roleId":"00E7F000001YhbNUAS","_children":[]}]},{"RoleName":"VPNorthAmericanSales","RoleLabel":"VP, North American Sales","roleId":"00E7F000001YhbEUAS","_children":[{"RoleName":"DirectorChannelSales","RoleLabel":"Director, Channel Sales","roleId":"00E7F000001YhbIUAS","_children":[{"RoleName":"ChannelSalesTeam","RoleLabel":"Channel Sales Team","roleId":"00E7F000001YhbMUAS","_children":[]}]},{"RoleName":"DirectorDirectSales","RoleLabel":"Director, Direct Sales","roleId":"00E7F000001YhbFUAS","_children":[{"RoleName":"EasternSalesTeam","RoleLabel":"Eastern Sales Team","roleId":"00E7F000001YhbPUAS","_children":[]},{"RoleName":"WesternSalesTeam","RoleLabel":"Western Sales Team","roleId":"00E7F000001YhbKUAS","_children":[]}]}]}]}]}]'
  );
}
