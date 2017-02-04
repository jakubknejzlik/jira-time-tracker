//
//  AppDelegate.swift
//  Jira time tracker
//
//  Created by Denis Kudinov on 16/11/2016.
//  Copyright © 2016 Denis Kudinov. All rights reserved.
//

import Cocoa
import Fabric
import Crashlytics


enum AppState {
  case active
  case inactive
}

class AppDelegate: NSObject, NSApplicationDelegate {
  
  var credentialsStorage: CredentialsStorage?
  var jiraClient: JIRAClient?
  var statusItem = NSStatusBar.system().statusItem(withLength: 200)
  var currentTask: JiraTask?
  var window: NSWindow?
  
  func applicationDidFinishLaunching(_ aNotification: Notification) {
    print("APP STATUS: applicationDidFinishLaunching(_ aNotification: Notification)")
    UserDefaults.standard.register(defaults: ["NSApplicationCrashOnExceptions": true])
    Fabric.with([Crashlytics.self])
    
    NSApp.activate(ignoringOtherApps: true)
    credentialsStorage = CredentialsStorage()
    jiraClient = JIRAClient(credentialsStorage: credentialsStorage!)
    if (credentialsStorage!.isLoggedIn()) {
      try? jiraClient?.configure(with: credentialsStorage!)
    }
    addStatusBarItem()
    openFullApp()
  }
  
  func addStatusBarItem() {
    statusItem.button?.image = NSImage(named: "AppIcon")
    statusItem.button?.imageScaling = .scaleProportionallyDown
    statusItem.button?.imagePosition = .imageLeft
    statusItem.button?.title = "[No Active Tasks]"
    statusItem.button?.target = self
    statusItem.button?.action = #selector(showMenu)
  }
  
  func openFullApp() {
    if window == nil {
      window = NSWindow(contentRect: NSRect(x: 500, y: 500, width: 200, height: 200), styleMask: [NSWindowStyleMask.titled, NSWindowStyleMask.closable], backing: NSBackingStoreType.buffered, defer: true)
      window?.isReleasedWhenClosed = false
    }
    var rootController: NSViewController? = nil
    if credentialsStorage!.isLoggedIn() {
      let boardController = BoardController()
      boardController.jiraClient = jiraClient
      rootController = boardController
    } else {
      rootController = LoginViewController()
    }
    if let contentController = window?.contentViewController {
      if contentController.className != rootController?.className {
        window?.contentViewController = rootController
      }
    } else {
      window?.contentViewController = rootController
    }
    window?.setIsVisible(true)
    window?.makeKeyAndOrderFront(self)
    
  }
  
  func updateStatus(with task: JiraTask) {
    statusItem.button?.title = "\(convertToHumanReadable(time: task.currentSessionLoggedTime!)) [\(task.shortID!)]"
  }
  
  func showMenu() {
    let mainMenu = NSMenu(title: "Jira Time Tracker")
    let showMainWindowItem = NSMenuItem(title: "Show app", action: #selector(openFullApp), keyEquivalent: "")
    let resumePauseItem = NSMenuItem(title: "Resume / Pause", action: #selector(onResumePauseClicked), keyEquivalent: "")
    let endItem = NSMenuItem(title: "Log work", action: #selector(onEndWorklogClicked), keyEquivalent: "")
    mainMenu.addItem(showMainWindowItem)
    mainMenu.addItem(resumePauseItem)
    mainMenu.addItem(endItem)
    statusItem.popUpMenu(mainMenu)
  }
  
/// MARK: Resume / pause from menu logic
  
  func onResumePauseClicked() {
    guard let _ = Worklog.shared.currentActiveTask else {
      return
    }
    if (Worklog.shared.isTimerValid()) {
      Worklog.shared.pauseWorklog()
    } else {
      Worklog.shared.startWorklog()
    }
  }
  
  func onEndWorklogClicked() {
    guard let _ = Worklog.shared.currentActiveTask else {
      return
    }
    Worklog.shared.stopWorklog()
  }
  
/// MARK: login
  
  func logout() {
    credentialsStorage?.removeCredentials()
    credentialsStorage?.clearServerURL()
    UserDefaults.resetStandardUserDefaults()
    window?.contentViewController = LoginViewController()
    statusItem.button?.title = "[No Active Tasks]"
  }
  
  func login(server: String, username: String, password: String) {
    credentialsStorage?.setServerURL(serverURL: server)
    let credentials = "\(username):\(password)".data(using: .utf8)?.base64EncodedString()
    credentialsStorage?.setCredentials(base64Encoded: credentials!)
    //
    do {
      try jiraClient?.configure(with: credentialsStorage!)
    } catch  {
      let appDelegate = NSApp.delegate as? AppDelegate
      appDelegate?.logout()
      return
    }
    //
    let boardController = BoardController()
    boardController.jiraClient = jiraClient
    window?.contentViewController = boardController
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
  }
  
  func applicationWillResignActive(_ notification: Notification) {
    print("APP STATUS: applicationWillResignActive(_ notification: Notification)")
  }
  
  func applicationDidResignActive(_ notification: Notification) {
    print("APP STATUS: applicationDidResignActive(_ notification: Notification)")
  }
  
  func applicationWillTerminate(_ notification: Notification) {
    print("APP STATUS: applicationWillTerminate(_ notification: Notification)")
  }
  
  func applicationDidChangeScreenParameters(_ notification: Notification) {
    print("APP STATUS: applicationDidChangeScreenParameters(_ notification: Notification)")
  }
  
}

