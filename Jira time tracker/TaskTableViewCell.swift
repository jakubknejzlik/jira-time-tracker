//
//  TaskTableViewCell.swift
//  Jira time tracker
//
//  Created by Denis Kudinov on 21/11/2016.
//  Copyright © 2016 Denis Kudinov. All rights reserved.
//

import Cocoa

class TaskTableViewCell: NSTableRowView {
  
  private var task: JiraTask?
  
  lazy var titleView: NSTextField = {
    var textField = NSTextField()
    textField.isEditable = false
    textField.isBezeled = false
    textField.backgroundColor = .clear
    textField.refusesFirstResponder = true
    textField.textColor = .black
    return textField
  }()
  var shortIDView: NSTextField = {
    var textField = NSTextField()
    textField.isEditable = false
    textField.isBezeled = false
    textField.backgroundColor = .clear
    textField.refusesFirstResponder = true
    textField.textColor = .black
    return textField
  }()
  var estimatedTime: NSTextField = {
    var textField = NSTextField()
    textField.isEditable = false
    textField.isBezeled = false
    textField.backgroundColor = .clear
    textField.refusesFirstResponder = true
    textField.textColor = .black
    return textField
  }()
  var loggedTime: NSTextField = {
    var textField = NSTextField()
    textField.isEditable = false
    textField.isBezeled = false
    textField.backgroundColor = .clear
    textField.refusesFirstResponder = true
    textField.textColor = .black
    return textField
  }()
  
  init(with task: JiraTask) {
    super.init(frame: .zero)
    self.task = task
    backgroundColor = Colors.lightBlueColor()
    //
    addShortIDView()
    addTitleView()
    addEstimatedTime()
    addLoggedTime()
    //
    shortIDView.stringValue = task.shortID!
    titleView.stringValue = task.title!
    estimatedTime.stringValue = "\(task.estimatedTime)"
    loggedTime.stringValue = "\(task.loggedTime)"
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  func addShortIDView() {
    addSubview(shortIDView)
    shortIDView.snp.makeConstraints { make in
      make.top.equalTo(snp.top)
      make.left.equalTo(snp.left).inset(10)
      make.width.equalTo(75)
      make.height.equalTo(snp.height).dividedBy(3)
    }
  }
  
  func addTitleView() {
    addSubview(titleView)
    titleView.refusesFirstResponder = true
    titleView.snp.makeConstraints { make in
      make.top.equalTo(shortIDView.snp.bottom)
      make.left.equalTo(snp.left).inset(10)
      make.bottom.equalTo(snp.bottom)
      make.width.equalTo(snp.width).multipliedBy(0.75)
    }
  }
  
  func addEstimatedTime() {
    
  }
  
  func addLoggedTime() {
    
  }
  
}
