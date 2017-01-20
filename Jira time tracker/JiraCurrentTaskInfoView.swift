//
//  JiraCurrentTaskInfoView.swift
//  Jira time tracker
//
//  Created by Denis Kudinov on 16/11/2016.
//  Copyright © 2016 Denis Kudinov. All rights reserved.
//

import Cocoa

class JiraCurrentTaskInfoView: NSView {
  
  var titleView = NSTextView()
  var shortIDView = NSTextView()
  var loggedTimeView = NSTextView()
  var estimatedTimeView = NSTextView()
  var signoutButton = NSButton()
  var openInWebButton = NSButton()
  var refreshButton = NSButton()
  var task: JiraTask?
  
  weak var delegate: BoardController?
  
  init(task: JiraTask, delegate: BoardController) {
    super.init(frame: NSZeroRect)
    self.delegate = delegate
    //
    addSubview(titleView)
    addSubview(shortIDView)
    addSubview(loggedTimeView)
    addSubview(estimatedTimeView)
    addSubview(signoutButton)
    addSubview(openInWebButton)
    addSubview(refreshButton)
    addTitleView()
    addShortIDView()
    addLoggedTime()
    addEstimatedTime()
    addSignoutButton()
    addOpenInWebButton()
    addRefreshButton()
    //
    update(with: task)
  }
  
  func update(with task: JiraTask) {
    self.task = task
    titleView.string = task.title
    shortIDView.string = task.shortID
    loggedTimeView.string = String(format: "Total logged: \(convertToHumanReadable(time: task.loggedTime!))")
    estimatedTimeView.string = String(format: "Estimated: \(convertToHumanReadable(time: task.estimatedTime!))")
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func addTitleView() {
    titleView.snp.makeConstraints { make in
      make.width.equalTo(snp.width).inset(10)
      make.top.equalTo(snp.top).inset(10)
      make.height.equalTo(snp.height).dividedBy(3)
      make.bottom.equalTo(shortIDView.snp.top)
      make.centerX.equalTo(snp.centerX)
    }
    titleView.isEditable = false
    titleView.font = NSFont.systemFont(ofSize: 14)
    titleView.backgroundColor = .clear
    titleView.alignment = .center
  }
  
  func addShortIDView() {
    shortIDView.snp.makeConstraints { make in
      make.width.equalTo(snp.width)
      make.top.equalTo(titleView.snp.bottom)
      make.height.equalTo(25)
      make.bottom.equalTo(loggedTimeView.snp.top)
      make.centerX.equalTo(snp.centerX)
    }
    shortIDView.isEditable = false
    shortIDView.font = NSFont.systemFont(ofSize: 13)
    shortIDView.backgroundColor = .clear
    shortIDView.alignment = .center
  }
  
  func addLoggedTime() {
    loggedTimeView.snp.makeConstraints { make in
      make.width.equalTo(snp.width).dividedBy(3)
      make.top.equalTo(shortIDView.snp.bottom)
      make.height.equalTo(estimatedTimeView.snp.height)
      make.bottom.equalTo(estimatedTimeView.snp.top)
      make.left.equalTo(snp.left)
    }
    loggedTimeView.isEditable = false
    loggedTimeView.font = NSFont.systemFont(ofSize: 10)
    loggedTimeView.backgroundColor = .clear
  }
  
  func addEstimatedTime() {
    estimatedTimeView.snp.makeConstraints { make in
      make.width.equalTo(snp.width).dividedBy(3)
      make.top.equalTo(loggedTimeView.snp.bottom)
      make.bottom.equalTo(snp.bottom)
      make.left.equalTo(snp.left)
    }
    estimatedTimeView.isEditable = false
    estimatedTimeView.font = NSFont.systemFont(ofSize: 10)
    estimatedTimeView.backgroundColor = .clear
  }
  
  func addSignoutButton() {
    signoutButton.target = self
    signoutButton.action = #selector(signoutButtonPressed)
    signoutButton.bezelStyle = .regularSquare
    let parargaphStyle = NSMutableParagraphStyle()
    parargaphStyle.alignment = .center
    let title = NSAttributedString(string: "Signout", attributes: [NSForegroundColorAttributeName: NSColor.black,
                                                                   NSParagraphStyleAttributeName: parargaphStyle])
    signoutButton.attributedTitle = title
    signoutButton.snp.makeConstraints { make in
      make.bottom.equalTo(snp.bottom).inset(10)
      make.right.equalTo(snp.right).inset(10)
      make.height.equalTo(20)
      make.width.equalTo(65)
    }
  }
  
  func addOpenInWebButton() {
    openInWebButton.target = self
    openInWebButton.action = #selector(openInWebButtonPressed)
    openInWebButton.bezelStyle = .regularSquare
    let parargaphStyle = NSMutableParagraphStyle()
    parargaphStyle.alignment = .center
    let title = NSAttributedString(string: "Open in Web", attributes: [NSForegroundColorAttributeName: NSColor.black,
                                                                   NSParagraphStyleAttributeName: parargaphStyle])
    openInWebButton.attributedTitle = title
    openInWebButton.snp.makeConstraints { make in
      make.bottom.equalTo(snp.bottom).inset(10)
      make.centerX.equalTo(snp.centerX)
      make.height.equalTo(20)
      make.width.equalTo(100)
    }
  }
  
  func addRefreshButton() {
    refreshButton.target = self
    refreshButton.action = #selector(refreshButtonPressed)
    refreshButton.bezelStyle = .regularSquare
    let parargaphStyle = NSMutableParagraphStyle()
    parargaphStyle.alignment = .center
    let title = NSAttributedString(string: "Refresh", attributes: [NSForegroundColorAttributeName: NSColor.black,
                                                                       NSParagraphStyleAttributeName: parargaphStyle])
    refreshButton.attributedTitle = title
    refreshButton.snp.makeConstraints { make in
      make.bottom.equalTo(signoutButton.snp.top).inset(-10)
      make.right.equalTo(snp.right).inset(10)
      make.height.equalTo(20)
      make.width.equalTo(65)
    }
    
  }
  
  func openInWebButtonPressed() {
    NSWorkspace.shared().open(task!.URL!)
  }
  
  func signoutButtonPressed() {
    let appDelegate = NSApp.delegate as! AppDelegate
    appDelegate.logout()
  }
  
  func refreshButtonPressed() {
    delegate?.refresh()
  }
  
}
