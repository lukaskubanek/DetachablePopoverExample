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
    @IBOutlet weak var windowTypeSelection: NSMatrix!
    @IBOutlet weak var showHideButton: NSButton!
    
    lazy var popover: NSPopover = {
        let popover = NSPopover()
        popover.behavior = .Semitransient
        popover.contentViewController = ContentViewController(nibName: "ContentViewController", bundle: nil)!
        popover.delegate = self
        return popover
    }()
    
    lazy var detachedWindowController: DetachedWindowController = {
        let detachedWindowController = DetachedWindowController(windowNibName: "DetachedWindowController")
        detachedWindowController.contentViewController = ContentViewController(nibName: "ContentViewController", bundle: nil)!
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "detachedWindowWillClose:", name: NSWindowWillCloseNotification, object: detachedWindowController.window)
        
        return detachedWindowController
    }()
    
    // MARK: - Interface Builder Actions
    
    @IBAction func showOrHide(sender: NSButton) {
        let popoverVisible = popover.shown
        let customDetachedWindowVisible = detachedWindowController.window!.visible
        
        if (popoverVisible) {
            popover.performClose(sender)
        } else if (customDetachedWindowVisible) {
            detachedWindowController.close()
        } else {
            popover.appearance = appearanceForSelectedRadioButton(appearanceSelection.selectedRow)
            
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
    
    func detachableWindowForPopover(popover: NSPopover) -> NSWindow? {
        return (windowTypeSelection.selectedRow == 1) ? detachedWindowController.window : nil
    }
    
    func popoverDidShow(notification: NSNotification) {
        displayHide()
    }
    
    func popoverDidClose(notification: NSNotification) {
        let closeReason = notification.userInfo![NSPopoverCloseReasonKey] as String
        if (closeReason == NSPopoverCloseReasonStandard) {
            displayShow()
        }
    }
    
    // MARK: - Notifications Handling
    
    @objc func detachedWindowWillClose(notification: NSNotification) {
        displayShow()
    }
    
    // MARK: - Helper Methods
    
    private func displayHide() {
        showHideButton.title = "Hide"
    }
    
    private func displayShow() {
        showHideButton.title = "Show"
    }
    
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
    
    // MARK: - Deinitialization
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
}
