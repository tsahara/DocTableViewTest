//
//  Document.swift
//  DocTableViewTest
//
//  Created by Tomoyuki Sahara on 12/16/15.
//  Copyright © 2015 Tomoyuki Sahara. All rights reserved.
//

import Cocoa

class Document: NSDocument, NSTableViewDataSource, NSOutlineViewDataSource {

    @IBOutlet weak var table: NSTableView!
    
    var last_selected: Int = -1

    override init() {
        super.init()
        // Add your subclass-specific initialization here.

        outlineviewinit()
    }
    
    var headers: [Header] = []
    func outlineviewinit() {
        let ip_h = Header(name: "ip")
        ip_h.add_field(Field(name: "version", desc: "IPv6"))
        ip_h.add_field(Field(name: "src address", desc: "172.16.0.1"))
        headers.append(ip_h)
        
        let tcp_h = Header(name: "tcp")
        tcp_h.add_field(Field(name: "src port", desc: "50000"))
        tcp_h.add_field(Field(name: "dst port", desc: "80"))
        headers.append(tcp_h)
        
        print("headers => \(headers.map { $0.name })")
    }

    override func windowControllerDidLoadNib(aController: NSWindowController) {
        super.windowControllerDidLoadNib(aController)
        // Add any code here that needs to be executed once the windowController has loaded the document's window.
    }

    override class func autosavesInPlace() -> Bool {
        return true
    }

    override var windowNibName: String? {
        // Returns the nib file name of the document
        // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this property and override -makeWindowControllers instead.
        return "Document"
    }

    override func dataOfType(typeName: String) throws -> NSData {
        // Insert code here to write your document to data of the specified type. If outError != nil, ensure that you create and set an appropriate error when returning nil.
        // You can also choose to override fileWrapperOfType:error:, writeToURL:ofType:error:, or writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
        throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
    }

    override func readFromData(data: NSData, ofType typeName: String) throws {
        // Insert code here to read your document from the given data of the specified type. If outError != nil, ensure that you create and set an appropriate error when returning false.
        // You can also choose to override readFromFileWrapper:ofType:error: or readFromURL:ofType:error: instead.
        // If you override either of these, you should also override -isEntireFileLoaded to return false if the contents are lazily loaded.
        throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
    }

    
    //
    // NSTableView
    //
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return 9
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row rowIndex: Int) -> NSView? {
        let cellView = tableView.makeViewWithIdentifier(tableColumn!.identifier, owner: self) as! NSTableCellView
        cellView.textField!.stringValue = "cell row=\(rowIndex)"
        //print("column : \(tableColumn?.identifier)")
        return cellView
    }
   
//    func tableView(tableView: NSTableView, didAddRowView rowView: NSTableRowView, forRow row: Int) {
//        if row == tableView.selectedRow + 2 {
//            rowView.backgroundColor = NSColor.selectedTextBackgroundColor()
//        }
//    }
    
    func tableViewSelectionDidChange(notification: NSNotification) {
        if last_selected != -1 {
            let rowView2 = self.table!.rowViewAtRow(last_selected + 2, makeIfNecessary: true)
            rowView2!.backgroundColor = NSColor.whiteColor()
        }

        let selected = self.table!.selectedRow
        let rowView = self.table!.rowViewAtRow(selected + 2, makeIfNecessary: true)
        rowView!.backgroundColor = NSColor.selectedTextBackgroundColor()
        last_selected = selected
    }

    //
    // NSOutlineView
    //
    func outlineView(outlineView: NSOutlineView, numberOfChildrenOfItem item: AnyObject?) -> Int {
        if (item == nil) {
            return headers.count
        } else {
            let h = item as! Header
            return h.fields.count
        }
    }
    
    func outlineView(outlineView: NSOutlineView, isItemExpandable item: AnyObject) -> Bool {
        if item is Header {
            return true
        } else {
            return false
        }
    }

    func outlineView(outlineView: NSOutlineView, child index: Int, ofItem item: AnyObject?) -> AnyObject {
        if item == nil {
            print("1: \(headers[index].name)")
            return headers[index]
        } else if item is Header {
            let h = item as! Header
            return h.fields[index]
        }

        return 1
    }
    
    func outlineView(outlineView: NSOutlineView, objectValueForTableColumn tableColumn: NSTableColumn?, byItem item: AnyObject?) -> AnyObject? {
        if item is Header {
            let h = item as! Header
            print("header -> \(h.name)")
            return h.name
        } else if item is Field {
            let f = item as! Field
            return f.name
        }
        return "fuga"
    }
}

class Field {
    var name: String
    var desc: String
    init(name: String, desc: String) {
        self.name = name
        self.desc = desc
    }
}

class Header {
    var name: String
    var fields: [Field] = []
    init(name: String) {
        self.name = name
    }
    
    func add_field(field: Field) {
        fields.append(field)
    }
}

