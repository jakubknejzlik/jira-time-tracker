//
//  BoardController.swift
//  Jira time tracker
//
//  Created by Denis Kudinov on 16/11/2016.
//  Copyright © 2016 Denis Kudinov. All rights reserved.
//

import Cocoa
import SnapKit

class BoardController : NSViewController {
  
  static let kViewHeight = 400
  static let kViewWidth = 600
  
  var shortTaskInfo: JiraCurrentTaskInfoView!
  var logPanel: LogPanel!
  var tasksTableView = NSTableView()
  let tasksScrollView = NSScrollView()
  var jiraClient: JIRAClient?
  
  let progressIndicator: NSProgressIndicator = {
    var pi = NSProgressIndicator(frame: NSRect(x: 0, y: BoardController.kViewHeight - 20, width: 20, height: 20))
    pi.style = .spinningStyle
    pi.appearance = NSAppearance(named: NSAppearanceNameAqua)
    return pi
  }()
  
  fileprivate var tasks: [JiraTask]?
  
  override func loadView() {
    shortTaskInfo = JiraCurrentTaskInfoView(task: JiraTask.mockedTask(), delegate: self)
    logPanel = LogPanel(task: JiraTask.mockedTask(), delegate: self)
    setupViews()
    refresh()
  }
  
  func refresh() {
    progressIndicator.isHidden = false
    progressIndicator.startAnimation(self)
    tasks = [JiraTask]()
    tasksTableView.reloadData()
    jiraClient?.getAllMyTasks(completion: { (tasks, error) in
      self.progressIndicator.stopAnimation(self)
      self.progressIndicator.isHidden = true
      if error != nil {
        return
      }
      self.tasks = tasks
      self.tasksTableView.reloadData()
    })
  }
  
  func setupViews() {
    view = NSView()
    view.wantsLayer = true
    view.layer?.backgroundColor = Colors.lightBlueColor().cgColor
    view.snp.makeConstraints { make in
      make.width.equalTo(BoardController.kViewWidth)
      make.height.equalTo(BoardController.kViewHeight)
    }
    progressIndicator.isHidden = true
    view.addSubview(shortTaskInfo)
    view.addSubview(logPanel)
    view.addSubview(tasksScrollView)
    view.addSubview(progressIndicator)
    customizeShortTaskInfo()
    customizeLogPanel()
    customizeTasksScrollView()
  }
  
  func customizeShortTaskInfo() {
    shortTaskInfo.snp.makeConstraints { make in
      make.height.equalTo(100)
      make.width.equalTo(view.snp.width)
      make.top.equalTo(view.snp.top)
      make.centerX.equalTo(view.snp.centerX)
    }
  }
  
  func customizeLogPanel() {
    logPanel.snp.makeConstraints { make in
      make.height.equalTo(50)
      make.width.equalTo(view.snp.width)
      make.top.equalTo(shortTaskInfo.snp.bottom)
      make.centerX.equalTo(view.snp.centerX)
    }
  }
  
  func customizeTasksScrollView() {
    tasksScrollView.documentView = tasksTableView
//    tasksScrollView.hasVerticalScroller = true
    tasksScrollView.snp.makeConstraints { make in
      make.top.equalTo(logPanel.snp.bottom)
      make.centerX.equalTo(view.snp.centerX)
      make.width.equalTo(view.snp.width)
      make.bottom.equalTo(view.snp.bottom)
    }
    customizeTableView()

  }
  
  func customizeTableView() {
    tasksTableView.backgroundColor = Colors.darkBlueColor()
    let column = NSTableColumn(identifier: "Column1")
    column.headerCell.backgroundColor = Colors.darkBlueColor()
    column.headerCell.drawsBackground = true
    column.headerCell.textColor = Colors.whiteColor()
    let columnTitle = NSAttributedString(string: "All your opened tasks", attributes: [NSForegroundColorAttributeName: Colors.whiteColor()])
    column.headerCell.attributedStringValue = columnTitle
    tasksTableView.delegate = self
    tasksTableView.dataSource = self
    tasksTableView.addTableColumn(column)
  }

}

extension BoardController: NSTableViewDataSource, NSTableViewDelegate {
  
  func numberOfRows(in tableView: NSTableView) -> Int {
    return tasks?.count ?? 0
  }
  
  func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
    if let v = tableView.make(withIdentifier: (tableColumn?.identifier)!, owner: self) {
      // never was here
      return v
    }
    let v = TaskTableViewCell(with: (tasks?[row])!)
    return v
  }
  
  func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
    return 50
  }
  
  func tableView(_ tableView: NSTableView, isGroupRow row: Int) -> Bool {
    return false
  }
  
  func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
    let task = (tasks?[row])!
    if (Worklog.shared.isAnyTaskInProgress()) {
      print("Some task is already in progress. Selected new task.")
      if (!Helper.showCancelOKAlert(withTitle: "Some task is already in progress. Progress for current task will be cancelled")) {
        return false
      }
    }
    Worklog.shared.invalidateTimer()
    Worklog.shared.currentActiveTask = task
    shortTaskInfo.update(with: task)
    logPanel.update(with: task)
    let appDelegate = NSApp.delegate as! AppDelegate
    appDelegate.updateStatus(with: task)
    return true
  }
  
}


extension BoardController: LogPanelDelegate {
  
  func logDidStart(panel: LogPanel) {
    
  }
  
  func logDidEnd(panel: LogPanel) {
    let task = panel.task!
    jiraClient?.logWork(task.currentSessionLoggedTime!, task: task) {
      Helper.showOKAlert(withTitle: "Successfully logged")
      self.logPanel.counter = 0
      task.currentSessionLoggedTime = 0
      let appDelegate = NSApp.delegate as! AppDelegate
      appDelegate.updateStatus(with: task)
    }
  }
  
}
