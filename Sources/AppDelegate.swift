//
//  AppDelegate.swift
//  DetachablePopover
//
//  Created by Lukas Kubanek on 25.10.2014.
//  Copyright (c) 2014 Lukas Kubanek. All rights reserved.
//

import AppKit

@NSApplicationMain class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationShouldTerminateAfterLastWindowClosed(sender: NSApplication) -> Bool {
        return true
    }
    
}
