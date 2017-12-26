//
//  ViewController.swift
//  XTransform
//
//  Created by markus on 21.12.17.
//  Copyright © 2017 markus. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    var xmlTransformed : XMLDocument?
    var xmlDocument: XMLDocument?
    var xslDocument: XMLDocument?
    
    @IBOutlet weak var xmlValidIndicator: NSImageView!
    @IBOutlet weak var xslValidIndicator: NSImageView!
    
    @IBOutlet weak var xmlFilePathField: NSTextField!
    @IBOutlet weak var xslFilePathField: NSTextField!
    
    @IBOutlet weak var transformButton: NSButton!
    
    var validateDoc: (URL)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func chooseXML(_ sender: Any) {
        selectFile(type: "xml", action: validateXML)
        
    }
    func validateXML(url: URL) {
        xmlFilePathField.stringValue = url.absoluteString
        do {
            xmlDocument = try XMLDocument(contentsOf: url, options: .documentValidate)
            xmlValidIndicator.image = NSImage(named: NSImage.Name(rawValue: "valid"))
        } catch (_) {
            xmlValidIndicator.image = NSImage(named: NSImage.Name(rawValue: "invalid"))
        }
        validateTranformButton()
    }
    
    @IBAction func chooseXSL(_ sender: Any) {
        selectFile(type: "xsl", action: validateXSL)
    }
    
    func validateXSL(url: URL) {
        xslFilePathField.stringValue = url.absoluteString
        do {
            xslDocument = try XMLDocument(contentsOf: url, options: .documentValidate)
            xslValidIndicator.image = NSImage(named: NSImage.Name(rawValue: "valid"))
        } catch (_) {
            xslValidIndicator.image = NSImage(named: NSImage.Name(rawValue: "invalid"))
        }
        validateTranformButton()
    }
    
    func validateTranformButton() {
        if(xmlValidIndicator.image?.name()?.rawValue == "valid" && xslValidIndicator.image?.name()?.rawValue == "valid") {
            transformButton.isEnabled = true
        } else {
            transformButton.isEnabled = false
        }
    }
    
    @IBAction func transform(_ sender: Any) {
        let task = Process()
        task.launchPath = "/usr/bin/xsltproc"
        task.arguments = [(xslDocument?.uri)!, (xmlDocument?.uri)!]
        let pipe = Pipe()
        task.standardOutput = pipe
        task.launch()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let xsltResult = String(data: data, encoding: .utf8)!
        
        let panel = NSSavePanel()
        panel.nameFieldLabel = "Save XML"
        panel.message = "Choose the path "
        panel.canCreateDirectories = true
        panel.allowedFileTypes = ["html"]
        
        panel.beginSheetModal(for: self.view.window!, completionHandler: { response in
            
            if let fileURL = panel.url {
                
                try! xsltResult.write(to: fileURL, atomically: true, encoding: .utf8)
                
                
            }
        })
    }
    
    func selectFile(type : String, action: @escaping (URL) -> ())  {
        let panel = NSOpenPanel()
        panel.nameFieldLabel = "Open " + type + " file"
        
        panel.beginSheetModal(for: self.view.window!, completionHandler: { response in
            if let url = panel.url {
                action(url)
            }
        })
    }
}

