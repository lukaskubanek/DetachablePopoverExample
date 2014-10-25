//
//  CustomizablePopoverSegue.swift
//  DetachablePopover
//
//  Created by Lukas Kubanek on 25.10.2014.
//  Copyright (c) 2014 Lukas Kubanek. All rights reserved.
//

import AppKit

class CustomizablePopoverSegue: NSStoryboardSegue {

    var positioningView: NSView!
    var positioningRect: NSRect = NSZeroRect
    var preferredEdge: NSRectEdge = NSMinXEdge
    
    let popover = NSPopover()
    
    override func perform() {
        assert(positioningView != nil, "The positioning view has to be set in prepareForSegue()")
        
        popover.contentViewController = self.destinationController as? NSViewController
        popover.showRelativeToRect(positioningRect, ofView: positioningView!, preferredEdge: preferredEdge)
    }
    
}
