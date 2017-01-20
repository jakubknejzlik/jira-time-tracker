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


class LogPanel: NSView {
  
  var task: JiraTask!
  
  var toggleButton: NSButton!
  var doneButton: NSButton!
  var loggedTimeLabel = NSTextView()
  
  var counter: Int = 0 {
    didSet {
      self.task.currentSessionLoggedTime = TimeInterval(self.counter)
      let stringLogged = convertToHumanReadable(time: TimeInterval(self.task.loggedTime! + self.task.currentSessionLoggedTime!))
      self.loggedTimeLabel.string = stringLogged
    }
  }
  var timer: Timer?
  
  weak var delegate: LogPanelDelegate?
  
  init(task: JiraTask, delegate: LogPanelDelegate) {
    super.init(frame: NSZeroRect)
    self.delegate = delegate

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
    counter = 0
    timer?.invalidate()
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
  }
  
  /// MARK: Actions
  
  func togglePressed() {
    if timer == nil {
      timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { timer in
        self.counter += 1
        let appDelegate = NSApp.delegate as! AppDelegate
        appDelegate.updateStatus(with: self.task)
      })
      timer?.fire()
    } else {
      timer?.invalidate()
      timer = nil
    }
  }
  
  func donePressed() {
    if let loggedTime = task.currentSessionLoggedTime, loggedTime < 60.0 {
      NSAlert(error: NSError(domain: "com.ac.error", code: 1, userInfo: [NSLocalizedDescriptionKey: "Logged time cannot be less than minute"])).runModal()
      return
    }
    timer?.invalidate()
    timer = nil
    delegate?.logDidEnd(panel: self)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
