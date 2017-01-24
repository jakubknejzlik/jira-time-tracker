//
//  UIHelpers.swift
//  Jira time tracker
//
//  Created by Denis Kudinov on 21.01.17.
//  Copyright © 2017 Denis Kudinov. All rights reserved.
//

import Cocoa


// Return true in case when OK clicked, else return false
//
func showCancelOKAlert(withTitle title: String) -> Bool {
  let alert = NSAlert()
  alert.messageText = title
  alert.addButton(withTitle: "Cancel")
  alert.addButton(withTitle: "OK")
  let result = alert.runModal()
  if (result == NSAlertFirstButtonReturn) {
    return false
  } else {
    return true
  }
}

// Alert with `OK` only button
//
func showOKAlert(withTitle title: String) {
  let alert = NSAlert()
  alert.messageText = title
  alert.addButton(withTitle: "OK")
  alert.runModal()
}


