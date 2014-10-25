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
    @IBOutlet weak var showHideButton: NSButton!
    
    lazy var popover: NSPopover = {
        let popover = NSPopover()
        popover.behavior = .Semitransient
        popover.delegate = self
        return popover
    }()
    
    lazy var popoverViewController: PopoverViewController = {
        return PopoverViewController(nibName: "PopoverView", bundle: nil)!
    }()
    
    // MARK: - Interface Builder Actions
    
    @IBAction func showOrHide(sender: NSButton) {
        if (popover.shown) {
            popover.performClose(sender)
        } else {
            popover.appearance = appearanceForSelectedRadioButton(appearanceSelection.selectedRow)
            popover.contentViewController = popoverViewController
            
            let positioningView = sender
            let positioningRect = NSZeroRect
            let preferredEdge = preferredEdgeForSelectedRadioButton(positionSelection.selectedRow)
            popover.showRelativeToRect(positioningRect, ofView: positioningView, preferredEdge: preferredEdge)
        }
    }
    
    // MARK: - Popover Delegate
    
    func popoverShouldDetach(popover: NSPopover) -> Bool {
        return true
    }
    
    func popoverDidShow(notification: NSNotification) {
        showHideButton.title = "Hide"
    }
    
    func popoverDidClose(notification: NSNotification) {
        showHideButton.title = "Show"
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
