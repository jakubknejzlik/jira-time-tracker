//
//  Colors.swift
//  Jira time tracker
//
//  Created by Denis Kudinov on 10/01/2017.
//  Copyright © 2017 Denis Kudinov. All rights reserved.
//

import Cocoa

class Colors {
  
  class func lightBlueColor() -> NSColor {
    return UIColorFromRGB(rgbValue: 0xEDF1F7)
  }

  class func darkBlueColor() -> NSColor {
    return UIColorFromRGB(rgbValue: 0x011B43)
  }
  
  class func brightBlueColor() -> NSColor {
    return UIColorFromRGB(rgbValue: 0xA2D9FD)
  }
  
  class func grayColor() -> NSColor {
    return UIColorFromRGB(rgbValue: 0x7F7F7F)
  }
  
  class func greenColor() -> NSColor {
    return UIColorFromRGB(rgbValue: 0x91BE11)
  }
  
  class func UIColorFromRGB(rgbValue: UInt) -> NSColor {
    return NSColor(
      red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
      green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
      blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
      alpha: CGFloat(1.0)
    )
  }
  
}
