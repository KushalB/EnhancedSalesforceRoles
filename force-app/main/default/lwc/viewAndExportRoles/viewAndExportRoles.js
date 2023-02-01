import { LightningElement } from "lwc";
import LightningAlert from "lightning/alert";
import getText from "@salesforce/apex/UserRoleExportHelper.lwcControllertoExportasText";
import sendEmail from "@salesforce/apex/UserRoleExportHelper.lwcControllertoExportasEmail";
import getJson from "@salesforce/apex/UserRoleExportHelper.getJsonForTree";

export const KEYFIELD = "RoleName";

export default class ViewAndExportRoles extends LightningElement {
  text = "";
  isXml = true;
  gridData = "";
  connectedCallback() {
    getJson()
      .then((result) => {
        this.text = result;
        this.gridData = JSON.parse(this.text);
      })
      .catch((error) => {
        this.text = error;
        LightningAlert.open({
          message: this.text,
          theme: "error",
          label: "Error!" // this is the header text
        });
      });
  }
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
        LightningAlert.open({
          message: "Success",
          theme: "success",
          label: "Success!" // this is the header text
        });
      })
      .catch((error) => {
        this.text = error;
        LightningAlert.open({
          message: this.text,
          theme: "error",
          label: "Error!" // this is the header text
        });
      });
  }
  handleClickonSend() {
    sendEmail({ isXml: this.isXml })
      .then((result) => {
        this.text = result;
        LightningAlert.open({
          message: "File sent to user email successfully!",
          theme: "success",
          label: "Success!" // this is the header text
        });
      })
      .catch((error) => {
        this.text = error;
        LightningAlert.open({
          message: this.text,
          theme: "error",
          label: "Error!" // this is the header text
        });
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
  handleRowAction(event) {
    console.log(event.detail.row);
  }
  gridColumns = [
    {
      type: "url",
      fieldName: "roleURL",
      label: "URL",
      typeAttributes: {
        label: { fieldName: "RoleLabel" },
        target: "blank",
        tooltip: "View Role"
      }
    },
    {
      type: "text",
      fieldName: "RoleAPIName",
      label: "Role API Name",
      initialWidth: 300
    },
    {
      type: "number",
      fieldName: "userNumbers",
      label: "Number of Active Users On Role",
      initialWidth: 300
    }
  ];
}
