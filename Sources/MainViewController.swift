//
//  MainViewController.swift
//  DetachablePopover
//
//  Created by Lukas Kubanek on 25.10.2014.
//  Copyright (c) 2014 Lukas Kubanek. All rights reserved.
//

import AppKit

class MainViewController: NSViewController, NSPopoverDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var appearanceSelection: NSMatrix!
    @IBOutlet weak var positionSelection: NSMatrix!
    @IBOutlet weak var windowTypeSelection: NSMatrix!
    
    @IBOutlet weak var showButton: NSButton!
    @IBOutlet weak var hideButton: NSButton!
    
    // MARK: - Popover and Detached Window Controller
    
    lazy var popover: NSPopover = {
        let popover = NSPopover()
        popover.behavior = .Semitransient
        popover.contentViewController = ContentViewController()
        popover.delegate = self
        return popover
    }()
    
    private var detachedWindowControllerLoaded = false
    
    lazy var detachedWindowController: DetachedWindowController = {
        let detachedWindowController = DetachedWindowController(windowNibName: "DetachedWindowController")
        detachedWindowController.contentViewController = ContentViewController()
        
        self.detachedWindowControllerLoaded = true
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "detachedWindowWillClose:", name: NSWindowWillCloseNotification, object: detachedWindowController.window)
        
        return detachedWindowController
    }()
    
    // MARK: - Actions
    
    @IBAction func show(sender: NSButton) {
        if (customDetachedWindowVisible) {
            detachedWindowController.window?.makeKeyAndOrderFront(nil)
        } else {
            popover.appearance = appearanceForSelectedRadioButton(appearanceSelection.selectedRow)
            
            let positioningView = sender
            let positioningRect = NSZeroRect
            let preferredEdge = preferredEdgeForSelectedRadioButton(positionSelection.selectedRow)
            
            popover.showRelativeToRect(positioningRect, ofView: positioningView, preferredEdge: preferredEdge)
        }
    }
    
    @IBAction func hide(sender: NSButton) {
        if (popoverVisible) {
            popover.performClose(nil)
        } else if (customDetachedWindowVisible) {
            detachedWindowController.close()
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
        enableHideButton()
    }
    
    func popoverDidClose(notification: NSNotification) {
        let closeReason = notification.userInfo![NSPopoverCloseReasonKey] as! String
        if (closeReason == NSPopoverCloseReasonStandard) {
            disableHideButton()
        }
    }
    
    // MARK: - Notifications Handling
    
    @objc func detachedWindowWillClose(notification: NSNotification) {
        disableHideButton()
    }
    
    // MARK: - Helpers
    
    private var popoverVisible: Bool {
        get { return popover.shown }
    }
    
    private var customDetachedWindowVisible : Bool {
        get { return detachedWindowControllerLoaded && detachedWindowController.window!.visible }
    }
    
    private func enableHideButton() {
        hideButton.enabled = true
    }
    
    private func disableHideButton() {
        hideButton.enabled = false
    }
    
    private func appearanceForSelectedRadioButton(radioButton: Int) -> NSAppearance {
        switch radioButton {
        case 0: return NSAppearance(named: NSAppearanceNameAqua)!
        case 1: return NSAppearance(named: NSAppearanceNameVibrantDark)!
        case 2: return NSAppearance(named: NSAppearanceNameVibrantLight)!
        default: fatalError("Unsupported appearence selected")
        }
    }
    
    private func preferredEdgeForSelectedRadioButton(radioButton: Int) -> NSRectEdge {
        switch radioButton {
        case 0: return .MaxX
        case 1: return .MaxY
        case 2: return .MinX
        case 3: return .MinY
        default: fatalError("Unsupported preferred edge selected")
        }
    }
    
    // MARK: - Deinitialization
    
    deinit {
        if (detachedWindowControllerLoaded) {
            NSNotificationCenter.defaultCenter().removeObserver(self)
        }
    }
    
}
