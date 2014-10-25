//
//  MainViewController.swift
//  DetachablePopover
//
//  Created by Lukas Kubanek on 25.10.2014.
//  Copyright (c) 2014 Lukas Kubanek. All rights reserved.
//

import AppKit

class MainViewController: NSViewController, NSPopoverDelegate {
    
    @IBOutlet weak var appearanceSelection: NSMatrix!
    @IBOutlet weak var positionSelection: NSMatrix!
    
    var currentPopover: NSPopover?
    
    // MARK: - Storyboard Segue
    
    override func prepareForSegue(segue: NSStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "DetachablePopover" {
            let popoverSegue = segue as CustomizablePopoverSegue
            let button = sender as NSButton
            
            let popover = popoverSegue.popover
            popover.behavior = .Transient
            popover.appearance = appearanceForSelectedRadioButton(appearanceSelection.selectedRow)
            popover.delegate = self
            currentPopover = popover
            
            popoverSegue.positioningView = button
            popoverSegue.preferredEdge = preferredEdgeForSelectedRadioButton(positionSelection.selectedRow)
        }
    }
    
    // MARK: - Popover Delegate
    
    func popoverShouldDetach(popover: NSPopover) -> Bool {
        return true
    }
    
    // MARK: - Helper Methods
    
    private func appearanceForSelectedRadioButton(radioButton: Int) -> NSAppearance {
        switch radioButton {
        case 0: return NSAppearance(named: NSAppearanceNameAqua)!
        case 1: return NSAppearance(named: NSAppearanceNameVibrantDark)!
        case 2: return NSAppearance(named: NSAppearanceNameVibrantLight)!
        default: return appearanceForSelectedRadioButton(0)
        }
    }
    
    private func preferredEdgeForSelectedRadioButton(radioButton: Int) -> NSRectEdge {
        switch radioButton {
        case 0: return NSMinXEdge
        case 1: return NSMinYEdge
        case 2: return NSMaxXEdge
        case 3: return NSMaxYEdge
        default: return preferredEdgeForSelectedRadioButton(0)
        }
    }
    
}
