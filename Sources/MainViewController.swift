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
        popover.behavior = .semitransient
        popover.contentViewController = ContentViewController()
        popover.delegate = self
        return popover
    }()
    
    private var detachedWindowControllerLoaded = false
    
    lazy var detachedWindowController: DetachedWindowController = {
        let detachedWindowController = DetachedWindowController(windowNibName: NSNib.Name(rawValue: "DetachedWindowController"))
        detachedWindowController.contentViewController = ContentViewController()
        
        self.detachedWindowControllerLoaded = true
        NotificationCenter.default.addObserver(self, selector: #selector(detachedWindowWillClose(notification:)), name: NSWindow.willCloseNotification, object: detachedWindowController.window)
        
        return detachedWindowController
    }()
    
    // MARK: - Actions
    
    @IBAction func show(sender: NSButton) {
        if (customDetachedWindowVisible) {
            detachedWindowController.window?.makeKeyAndOrderFront(nil)
        } else {
            popover.appearance = appearanceForSelectedRadioButton(radioButton: appearanceSelection.selectedRow)
            
            let positioningView = sender
            let positioningRect = NSZeroRect
            let preferredEdge = preferredEdgeForSelectedRadioButton(radioButton: positionSelection.selectedRow)
            
            popover.show(relativeTo: positioningRect, of: positioningView, preferredEdge: preferredEdge)
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
    
    func popoverShouldDetach(_ popover: NSPopover) -> Bool {
        return true
    }
    
    func detachableWindow(for popover: NSPopover) -> NSWindow? {
        return (windowTypeSelection.selectedRow == 1) ? detachedWindowController.window : nil
    }
    
    func popoverDidShow(_ notification: Notification) {
        enableHideButton()
    }
    
    func popoverDidClose(_ notification: Notification) {
        let closeReason = notification.userInfo![NSPopover.closeReasonUserInfoKey] as! String
        if (closeReason == NSPopover.CloseReason.standard.rawValue) {
            disableHideButton()
        }
    }
    
    // MARK: - Notifications Handling
    
    @objc func detachedWindowWillClose(notification: NSNotification) {
        disableHideButton()
    }
    
    // MARK: - Helpers
    
    private var popoverVisible: Bool {
        get { return popover.isShown }
    }
    
    private var customDetachedWindowVisible : Bool {
        get { return detachedWindowControllerLoaded && detachedWindowController.window!.isVisible }
    }
    
    private func enableHideButton() {
        hideButton.isEnabled = true
    }
    
    private func disableHideButton() {
        hideButton.isEnabled = false
    }
    
    private func appearanceForSelectedRadioButton(radioButton: Int) -> NSAppearance {
        switch radioButton {
        case 0: return NSAppearance(named: NSAppearance.Name.aqua)!
        case 1: return NSAppearance(named: NSAppearance.Name.vibrantDark)!
        case 2: return NSAppearance(named: NSAppearance.Name.vibrantLight)!
        default: fatalError("Unsupported appearence selected")
        }
    }
    
    private func preferredEdgeForSelectedRadioButton(radioButton: Int) -> NSRectEdge {
        switch radioButton {
        case 0: return .maxX
        case 1: return .maxY
        case 2: return .minX
        case 3: return .minY
        default: fatalError("Unsupported preferred edge selected")
        }
    }
    
    // MARK: - Deinitialization
    
    deinit {
        if (detachedWindowControllerLoaded) {
            NotificationCenter.default.removeObserver(self)
        }
    }
    
}
