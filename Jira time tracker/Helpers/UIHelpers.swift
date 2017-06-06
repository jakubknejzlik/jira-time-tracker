//
//  UIHelpers.swift
//  Jira time tracker
//
//  Created by Denis Kudinov on 21.01.17.
//  Copyright © 2017 Denis Kudinov. All rights reserved.
//

import Cocoa

class Helper {
  
  // Return true in case when OK clicked, else return false
  //
  class func showCancelOKAlert(withTitle title: String) -> Bool {
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
  class func showOKAlert(withTitle title: String) {
    let alert = NSAlert()
    alert.messageText = title
    alert.addButton(withTitle: "OK")
    alert.runModal()
  }
  
  
  // Open send email window
  //
  class func askAQuestion() {
    let emailBody           = "My question is: "
    let emailService        =  NSSharingService.init(named: NSSharingServiceNameComposeEmail)!
    emailService.recipients = ["kudinov-de@yandex.ru"]
    emailService.subject    = "App Support"
    
    if emailService.canPerform(withItems: [emailBody]) {
      emailService.perform(withItems: [emailBody])
    } else {
      showOKAlert(withTitle: "No mail client is configured. You can send an email manually to: kudinov-de@yandex.ru")
    }
  }
  
}


