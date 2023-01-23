import { LightningElement } from "lwc";
import {
  EXAMPLES_COLUMNS_DEFINITION_BASIC,
  EXAMPLES_DATA_LAZY_LOADING
} from "./sampleData";

export default class TreeGridLazyLoading extends LightningElement {
  gridLoadingState = false;

  // definition of columns for the tree grid
  gridColumns = EXAMPLES_COLUMNS_DEFINITION_BASIC;

  // initial data provided to the tree grid
  gridData = EXAMPLES_DATA_LAZY_LOADING;

  // list of names for rows that are expanded
  gridExpandedRows = ["123556", "123556-B", "123557"];

  // when a row is toggled we retrieve values and dynamically load children if needed
  handleRowToggle(event) {
    // retrieve the unique identifier of the row being expanded
    const rowName = event.detail.name;

    // does the component have children content for this row already?
    const hasChildrenContent = event.detail.hasChildrenContent;

    /*
     ** additional event.detail values available:
     **
     ** => the new expanded state for this row
     **    const isExpanded = event.detail.isExpanded;
     **
     ** => the complete row data
     **    const row = event.detail.row;
     */

    // if hasChildrenContent is false then we need to react and add children
    if (hasChildrenContent === false) {
      this.gridLoadingState = true;

      // call a method to retrieve the updated data tree that includes the missing children
      this.retrieveUpdatedData(rowName).then((newData) => {
        this.gridData = newData;
        this.gridLoadingState = false;
      });
    }
  }

  // mimic a delay in retrieving the data (2 second delay)
  retrieveUpdatedData(rowName) {
    return new Promise((resolve) => {
      // mimic server delay
      // eslint-disable-next-line @lwc/lwc/no-async-operation
      window.setTimeout(() => {
        // add children to data
        const updatedData = this.addChildrenToRow(
          this.gridData,
          rowName,
          this.childrenData[rowName]
        );

        resolve(updatedData);
      }, 2000);
    });
  }

  // add the new child rows at the desired location
  addChildrenToRow(data, rowName, children) {
    // step through the array using recursion until we find the correct row to update
    const newData = data.map((row) => {
      // does this row have a properly formatted _children key with content?
      let hasChildrenContent = false;
      if (
        // eslint-disable-next-line no-prototype-builtins
        row.hasOwnProperty("_children") &&
        Array.isArray(row._children) &&
        row._children.length > 0
      ) {
        hasChildrenContent = true;
      }

      // if this is the row that was toggled then add the child content
      if (row.name === rowName) {
        row._children = children;
        // otherwise keep searching for the correct row by recursively searching the tree
      } else if (hasChildrenContent) {
        this.addChildrenToRow(row._children, rowName, children);
      }

      return row;
    });

    return newData;
  }

  // child data to be added later
  childrenData = {
    "123556-A": [
      {
        name: "123556-A-A",
        accountName: "Acme Corporation (Oakland)",
        employees: 745,
        phone: "837-555-1212",
        accountOwner: "http://example.com/john-doe",
        accountOwnerName: "John Doe",
        billingCity: "New York, NY"
      },
      {
        name: "123556-A-B",
        accountName: "Acme Corporation (San Francisco)",
        employees: 578,
        phone: "837-555-1212",
        accountOwner: "http://example.com/jane-doe",
        accountOwnerName: "Jane Doe",
        billingCity: "Los Angeles, CA"
      }
    ],

    "123556-B-B": [
      {
        name: "123556-B-B-A",
        accountName: "Allied Technologies",
        employees: 390,
        phone: "837-555-1212",
        accountOwner: "http://example.com/jane-doe",
        accountOwnerName: "Jane Doe",
        billingCity: "Los Angeles, CA",
        _children: [
          {
            name: "123556-B-B-A-A",
            accountName: "Allied Technologies (UV)",
            employees: 270,
            phone: "837-555-1212",
            accountOwner: "http://example.com/john-doe",
            accountOwnerName: "John Doe",
            billingCity: "San Francisco, CA"
          }
        ]
      }
    ]
  };
}
