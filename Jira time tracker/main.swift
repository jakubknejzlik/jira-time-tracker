//
//  main.swift
//  Jira time tracker
//
//  Created by Denis Kudinov on 16/11/2016.
//  Copyright © 2016 Denis Kudinov. All rights reserved.
//

import Foundation
import AppKit


NSApplication.shared()
NSApp.setActivationPolicy(.regular)
let controller = AppDelegate()
NSApp.delegate = controller
NSApp.run()

