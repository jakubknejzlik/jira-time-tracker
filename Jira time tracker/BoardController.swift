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
  
  var shortTaskInfo: JiraCurrentTaskInfoView!
  var logPanel: LogPanel!
  var tasksTableView = NSTableView()
  let tasksScrollView = NSScrollView()
  var jiraClient: JIRAClient?
  
  fileprivate var tasks: [JiraTask]?
  
  override func loadView() {
    shortTaskInfo = JiraCurrentTaskInfoView(task: JiraTask.mockedTask(), delegate: self)
    logPanel = LogPanel(task: JiraTask.mockedTask(), delegate: self)
    setupViews()
    refresh()
  }
  
  func refresh() {
    self.tasks = [JiraTask]()
    self.tasksTableView.reloadData()
    jiraClient?.getAllMyTasks(completion: { (tasks, error) in
      if error != nil {
        return
      }
      self.tasks = tasks
      self.tasksTableView.reloadData()
    })
  }
  
  func setupViews() {
    view = CustomPopoverBackground()
//    view.wantsLayer = true
//    view.layer?.backgroundColor = CGColor.white
    view.snp.makeConstraints { make in
      make.width.equalTo(600)
      make.height.equalTo(400)
    }
    view.addSubview(shortTaskInfo)
    view.addSubview(logPanel)
    view.addSubview(tasksScrollView)
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
    column.title = "All your opened tasks"
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
    shortTaskInfo.update(with: task)
    logPanel.update(with: task)
    return true
  }
  
}


extension BoardController: LogPanelDelegate {
  
  func logDidStart(panel: LogPanel) {
    
  }
  
  func logDidEnd(panel: LogPanel) {
    let task = panel.task!
    jiraClient?.logWork(task.currentSessionLoggedTime!, task: task) {
      task.currentSessionLoggedTime = 0
      let appDelegate = NSApp.delegate as! AppDelegate
      appDelegate.updateTitle(with: task)
    }
  }
  
}
