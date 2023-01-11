import { LightningElement } from "lwc";
import getText from "@salesforce/apex/UserRoleExportHelper.lwcControllertoExportasText";
import sendEmail from "@salesforce/apex/UserRoleExportHelper.lwcControllertoExportasEmail";

export default class ViewAndExportRoles extends LightningElement {
  text =
    "You can either load the roles in xml/json format, else you can export to your email";
  //value = 'XML';
  isXml = true;
  get options() {
    return [
      { label: "XML", value: "XML" },
      { label: "JSON", value: "JSON" }
    ];
  }
  optionSelectionHandler(event) {
    this.isXml = event.detail.value;
  }
  handleClickonShow() {
    getText({ isXml: this.isXml })
      .then((result) => {
        this.text = result;
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
}
