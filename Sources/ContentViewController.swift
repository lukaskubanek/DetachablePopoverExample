//
//  ContentViewController.swift
//  DetachablePopover
//
//  Created by Lukas Kubanek on 25.10.2014.
//  Copyright (c) 2014 Lukas Kubanek. All rights reserved.
//

import AppKit

class ContentViewController: NSViewController {
    
    // MARK: - Initialization

    override init!(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience override init() {
        self.init(nibName: "ContentViewController", bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
