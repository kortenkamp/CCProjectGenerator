//
//  ViewController.swift
//  CCProjectGenerator
//
//  Created by Andrey Volodin on 18.02.16.
//  Copyright © 2016 cocos2d. All rights reserved.
//

import Cocoa
import Foundation

typealias AttributedString = Foundation.NSAttributedString

class ViewController: NSViewController {

    @IBOutlet weak var createButton: NSButton!
    @IBOutlet weak var chipmunkCheckbox: NSButton!
    @IBOutlet weak var ccbCheckbox: NSButton!
    @IBOutlet weak var langSelector: NSPopUpButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set fancy black background color
        let viewLayer = CALayer()
        viewLayer.backgroundColor = CGColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        view.wantsLayer = true
        view.layer = viewLayer
        
        // Color label
        chipmunkCheckbox.attributedTitle = AttributedString(string: chipmunkCheckbox.title, attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor) : NSColor.white]))
        
        ccbCheckbox.attributedTitle = AttributedString(string: ccbCheckbox.title, attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor) : NSColor.white]))
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


    @IBAction func createButtonPressed(_ sender: AnyObject) {
        let saveDialog = NSSavePanel()
        
        saveDialog.beginSheetModal(for: NSApplication.shared.mainWindow!) { (result: NSApplication.ModalResponse) -> Void in
            if result == NSApplication.ModalResponse.OK {
                var fileName = saveDialog.url!.path
                let fileNameRaw = (fileName as NSString).deletingPathExtension
                
                //check validity
                let validChars = NSMutableCharacterSet.alphanumeric()
                validChars.addCharacters(in: "_- ")
                let invalidChars = validChars.inverted
  

                let lastPathComponent = (fileNameRaw as NSString).lastPathComponent
                if lastPathComponent.rangeOfCharacter(from: invalidChars) == nil {
                    
                    fileName = fileName + "/" + lastPathComponent + ".ccbproj"
                    
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(0) / Double(NSEC_PER_SEC), execute: { () -> Void in
                        let lang = CCBProgrammingLanguage(rawValue: Int8(self.langSelector.selectedItem!.tag))
                        CCBProjectCreator.createDefaultProject(atPath: fileName, withChipmunk: self.chipmunkCheckbox.state == NSControl.StateValue.on, withCCB: self.ccbCheckbox.state == NSControl.StateValue.on, programmingLanguage:lang!)
                    })
                    
                }
            }
            
        }
    }
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}
