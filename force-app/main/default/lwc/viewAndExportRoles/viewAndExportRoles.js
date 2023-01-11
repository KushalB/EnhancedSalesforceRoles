import { LightningElement } from "lwc";
import getText from "@salesforce/apex/UserRoleExportHelper.lwcControllertoExportasText";
import sendEmail from "@salesforce/apex/UserRoleExportHelper.lwcControllertoExportasEmail";

export default class ViewAndExportRoles extends LightningElement {
  text = "";
  isXml = true;
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
