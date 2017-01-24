//
//  LogPanel.swift
//  Jira time tracker
//
//  Created by Denis Kudinov on 16/11/2016.
//  Copyright © 2016 Denis Kudinov. All rights reserved.
//

import Cocoa

protocol LogPanelDelegate: class {
  
  func logDidStart(panel: LogPanel)
  func logDidEnd(panel: LogPanel)
  
}


enum LogPanelState {
  case inProgress
  case paused
  case initial
}

class LogPanel: NSView {
  
  var task: JiraTask!
  
  var toggleButton: NSButton!
  var doneButton: NSButton!
  var loggedTimeLabel = NSTextField()
  
  var counter: Int = 0 {
    didSet {
      self.task.currentSessionLoggedTime = TimeInterval(self.counter)
      let stringLogged = convertToHumanReadable(time: TimeInterval(self.task.loggedTime! + self.task.currentSessionLoggedTime!))
      self.loggedTimeLabel.stringValue = stringLogged
    }
  }
  var timer: Timer?
  var state: LogPanelState
  
  weak var delegate: LogPanelDelegate?
  
  init(task: JiraTask, delegate: LogPanelDelegate) {
    self.state = .initial
    super.init(frame: NSZeroRect)
    self.delegate = delegate
    Worklog.shared.delegate = self
    
    toggleButton = NSButton()
    toggleButton.title = "Start/Pause"
    toggleButton.target = self
    toggleButton.action = #selector(togglePressed)
    toggleButton.bezelStyle = .regularSquare
    //
    doneButton = NSButton()
    doneButton.title = "Log Work"
    doneButton.target = self
    doneButton.action = #selector(donePressed)
    doneButton.bezelStyle = .regularSquare
    //
    addSubview(toggleButton)
    addSubview(doneButton)
    addSubview(loggedTimeLabel)
    //
    customizeToggleButton()
    customizeDoneButton()
    customizeCounter()
    //
    update(with: task)
  }
  
  override func draw(_ dirtyRect: NSRect) {
    Colors.darkBlueColor().setFill()
    NSRectFill(dirtyRect)
    super.draw(dirtyRect)
  }
  
  func update(with task: JiraTask) {
    self.task = task
    state = .initial
    counter = Int(task.currentSessionLoggedTime!)
  }
  
  func customizeToggleButton() {
    toggleButton.snp.makeConstraints { make in
      make.right.equalTo(loggedTimeLabel.snp.left).inset(-20)
      make.centerY.equalTo(snp.centerY)
      make.width.equalTo(150)
    }
  }
  
  func customizeDoneButton() {
    doneButton.snp.makeConstraints { make in
      make.left.equalTo(loggedTimeLabel.snp.right).offset(20)
      make.centerY.equalTo(snp.centerY)
      make.width.equalTo(150)
    }
  }
  
  func customizeCounter() {
    loggedTimeLabel.snp.makeConstraints { make in
      make.center.equalTo(snp.center)
      make.height.equalTo(20)
      make.width.equalTo(75)
    }
    loggedTimeLabel.alignment = .center
    loggedTimeLabel.isEditable = false
  }
  
  /// MARK: Actions
  
  func togglePressed() {
    switch state {
    case .inProgress:
      Worklog.shared.currentActiveTask = task
      Worklog.shared.pauseWorklog()
      state = .paused
    case .initial:
      fallthrough
    case .paused:
      Worklog.shared.currentActiveTask = task
      Worklog.shared.startWorklog()
      state = .inProgress
    }
  }
  
  func donePressed() {
    Worklog.shared.currentActiveTask = task
    Worklog.shared.stopWorklog()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

extension LogPanel: WorklogDelegate {
  
  func tick() {
    counter += 1
    task.currentSessionLoggedTime = TimeInterval(counter)
  }
  
  func worklogDidEnd() {
    delegate?.logDidEnd(panel: self)
    state = .initial
  }
  
}
