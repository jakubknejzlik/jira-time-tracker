//
//  Worklog.swift
//  Jira time tracker
//
//  Created by Denis Kudinov on 20.01.17.
//  Copyright © 2017 Denis Kudinov. All rights reserved.
//

import Cocoa

protocol WorklogDelegate {
  func tick()
  func worklogDidEnd()
}

class Worklog {

  static var shared = Worklog()
  
  var currentActiveTask: JiraTask?
  var timer: Timer?
  var delegate: WorklogDelegate!
  var counter = 0
  
  func isAnyTaskInProgress() -> Bool {
    return currentActiveTask != nil
  }
  
  
  /// Indicate that timer is now ticking.
  func isTimerValid() -> Bool {
    let valid = timer?.isValid
    return (timer != nil) ? valid! : false
  }
  
  func startWorklog() {
    if timer != nil {
      print("Previous worklog was not completed. Probably this is an error. Setting timer to nil")
      invalidateTimer()
    }
    timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(tick), userInfo: nil, repeats: true)
    timer?.fire()
  }
  
  func pauseWorklog() {
    invalidateTimer()
  }
  
  func stopWorklog() {
    if let loggedTime = currentActiveTask?.currentSessionLoggedTime, loggedTime < 60.0 {
      NSAlert(error: NSError(domain: "com.ac.error", code: 1, userInfo: [NSLocalizedDescriptionKey: "Logged time cannot be less than minute"])).runModal()
      return
    }
    invalidateTimer()
    delegate.worklogDidEnd()
  }

  @objc func tick() {
    delegate.tick()
    let appDelegate = NSApp.delegate as! AppDelegate
    appDelegate.updateStatus(with: currentActiveTask!)
  }
  
  func invalidateTimer() {
    timer?.invalidate()
    timer = nil
    counter = 0
  }
}
