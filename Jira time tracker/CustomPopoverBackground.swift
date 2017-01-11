//
//  CustomPopoverBackground.swift
//  Jira time tracker
//
//  Created by Denis Kudinov on 10/01/2017.
//  Copyright © 2017 Denis Kudinov. All rights reserved.
//

import Cocoa

class CustomPopoverBackground: NSView {
  
  override func viewDidMoveToWindow() {
    guard let window = window else {
      return
    }
    let frameView = window.contentView?.superview
    let bgView = ExactBackgroundView(frame: (frameView?.bounds)!)
    bgView.autoresizingMask = [.viewWidthSizable, .viewHeightSizable]
    frameView?.addSubview(bgView, positioned: .below, relativeTo: frameView)
    super.viewDidMoveToWindow()
  }
  
}

class ExactBackgroundView: NSView {
  
  override func draw(_ dirtyRect: NSRect) {
    Colors.lightBlueColor().set()
    NSRectFill(bounds)
  }
  

  
}

 
