//
//  AppDelegate.swift
//  Jira time tracker
//
//  Created by Denis Kudinov on 16/11/2016.
//  Copyright © 2016 Denis Kudinov. All rights reserved.
//

import Cocoa


enum AppState {
  case active
  case inactive
}

class AppDelegate: NSObject, NSApplicationDelegate {
  
  var appState: AppState?
  var previousState: AppState?
  var credentialsStorage: CredentialsStorage?
  var jiraClient: JIRAClient?
  var statusItem = NSStatusBar.system().statusItem(withLength: 200)
  var popover = NSPopover()

  func applicationDidFinishLaunching(_ aNotification: Notification) {
    credentialsStorage = CredentialsStorage()
    jiraClient = JIRAClient(credentialsStorage: credentialsStorage!)
    print("APP STATUS: applicationDidFinishLaunching(_ aNotification: Notification)")
    addStatusBarItem()
  }
  
  func addStatusBarItem() {
    statusItem.button?.title = "[No Active Tasks]"
    statusItem.button?.target = self
    statusItem.button?.action = #selector(showPopover)
    
    var rootController: NSViewController? = nil
    if credentialsStorage!.isLoggedIn() {
      let boardController = BoardController()
      boardController.jiraClient = jiraClient
      rootController = boardController
    } else {
      rootController = LoginViewController()
    }
    popover.contentViewController = rootController
  }
  
  func updateTitle(with task: JiraTask) {
    statusItem.button?.title = "\(convertToHumanReadable(time: task.currentSessionLoggedTime!)) [\(task.shortID!)]"
  }
  
  func showPopover() {
//    if previousState == .inactive && appState == .active {
//      return
//    }
    if popover.isShown {
      popover.performClose(nil)
    } else {
      popover.show(relativeTo: (statusItem.button?.bounds)!, of: statusItem.button!, preferredEdge: .minY)
    }
  }
  
/// MARK: login
  
  func logout() {
    credentialsStorage?.removeCredentials()
    credentialsStorage?.clearServerURL()
    popover.contentViewController = LoginViewController()
    statusItem.button?.title = "[No Active Tasks]"
  }
  
  func login(server: String, username: String, password: String) {
    credentialsStorage?.setServerURL(serverURL: server)
    let credentials = "\(username):\(password)".data(using: .utf8)?.base64EncodedString()
    credentialsStorage?.setCredentials(base64Encoded: credentials!)
    //
    let boardController = BoardController()
    boardController.jiraClient = jiraClient
    popover.contentViewController = boardController
  }
  
  /// MARK: 

  func applicationWillFinishLaunching(_ notification: Notification) {
    print("APP STATUS: applicationWillFinishLaunching(_ notification: Notification)")
  }
  
  func applicationWillHide(_ notification: Notification) {
    print("APP STATUS: applicationWillHide(_ notification: Notification)")
  }
  
  func applicationDidHide(_ notification: Notification) {
    print("APP STATUS: applicationDidHide(_ notification: Notification)")
  }
  
  func applicationWillUnhide(_ notification: Notification) {
    print("APP STATUS: applicationWillUnhide(_ notification: Notification)")
  }
  
  func applicationDidUnhide(_ notification: Notification) {
    print("APP STATUS: applicationDidUnhide(_ notification: Notification)")
  }
  
  func applicationWillBecomeActive(_ notification: Notification) {
    print("APP STATUS: applicationWillBecomeActive(_ notification: Notification)")
  }
  
  func applicationDidBecomeActive(_ notification: Notification) {
    print("APP STATUS: applicationDidBecomeActive(_ notification: Notification)")
    previousState = appState
    appState = .active
  }
  
  func applicationWillResignActive(_ notification: Notification) {
    print("APP STATUS: applicationWillResignActive(_ notification: Notification)")
  }
  
  func applicationDidResignActive(_ notification: Notification) {
    print("APP STATUS: applicationDidResignActive(_ notification: Notification)")
    previousState = appState
    appState = .inactive
  }
  
  func applicationWillUpdate(_ notification: Notification) {
//    print("APP STATUS: applicationWillUpdate(_ notification: Notification)")
  }
  
  func applicationDidUpdate(_ notification: Notification) {
//    print("APP STATUS: applicationDidUpdate(_ notification: Notification)")
  }
  
  func applicationWillTerminate(_ notification: Notification) {
    print("APP STATUS: applicationWillTerminate(_ notification: Notification)")
  }
  
  func applicationDidChangeScreenParameters(_ notification: Notification) {
    print("APP STATUS: applicationDidChangeScreenParameters(_ notification: Notification)")
  }
  
}

