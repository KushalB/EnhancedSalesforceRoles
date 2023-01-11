import { LightningElement } from "lwc";
import getDocXML from "@salesforce/apex/UserRoleExportHelper.lwcControllertoExportasXML";
import getDocJson from "@salesforce/apex/UserRoleExportHelper.lwcControllertoExportasJSON";
import sendEmail from "@salesforce/apex/UserRoleExportHelper.lwcControllertoExportasEmail";

export default class ViewAndExportRoles extends LightningElement {
  text =
    "You can either load the roles in xml/json format, else you can export to your email";
  handleClickonLoadXML() {
    getDocXML()
      .then((result) => {
        this.text = result;
      })
      .catch((error) => {
        this.text = error;
      });
  }
  handleClickonLoadJSON() {
    getDocJson()
      .then((result) => {
        this.text = result;
      })
      .catch((error) => {
        this.text = error;
      });
  }
  handleClickonEmailXml() {
    sendEmail({ isXml: true })
      .then((result) => {
        this.text = result;
      })
      .catch((error) => {
        this.text = error;
      });
  }
  handleClickonEmailJSON() {
    sendEmail({ isXml: false })
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
