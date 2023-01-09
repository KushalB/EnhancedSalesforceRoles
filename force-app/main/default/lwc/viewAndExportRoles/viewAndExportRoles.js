import { LightningElement } from "lwc";

export default class LightningExampleAccordionBasic extends LightningElement {
  activeSectionMessage = "";

  handleToggleSection(event) {
    this.activeSectionMessage =
      "Open section name:  " + event.detail.openSections;
  }

  handleSetActiveSectionC() {
    const accordion = this.template.querySelector(".example-accordion");

    accordion.activeSectionName = "C";
  }
}
