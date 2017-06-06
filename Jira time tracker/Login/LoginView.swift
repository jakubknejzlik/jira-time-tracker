//
//  LoginView.swift
//  Jira time tracker
//
//  Created by Denis Kudinov on 10/01/2017.
//  Copyright © 2017 Denis Kudinov. All rights reserved.
//

import Cocoa

class LoginView: NSView {
  
  let serverURLField = NSTextField()
  let usernameField = NSTextField()
  let passwordField = NSSecureTextField()
  let loginButton = NSButton()
  let askQuestionButton = NSButton()
  
  weak var delegate: LoginViewController?
  
  init(frame frameRect: NSRect, delegate: LoginViewController) {
    super.init(frame: frameRect)
    self.wantsLayer = true
    self.layer?.backgroundColor = Colors.lightBlueColor().cgColor
    self.delegate = delegate
    addSubview(serverURLField)
    addSubview(usernameField)
    addSubview(passwordField)
    addSubview(loginButton)
    addSubview(askQuestionButton)
    adjustServerURLField()
    adjustUsernameField()
    adjustPasswordField()
    adjustLoginButton()
    adjustAskQuestionButton()
  }
  
  func adjustServerURLField() {
    serverURLField.placeholderString = "Server URL (eg https://jira.company.com)"
    serverURLField.bezelStyle = .roundedBezel
    serverURLField.snp.makeConstraints { make in
      make.top.equalTo(snp.top).offset(20)
      make.left.equalTo(snp.left).inset(20)
      make.right.equalTo(snp.right).inset(20)
      make.height.equalTo(20)
    }
  }
  
  func adjustUsernameField() {
    usernameField.placeholderString = "Username"
    usernameField.bezelStyle = .roundedBezel
    usernameField.snp.makeConstraints { make in
      make.top.equalTo(serverURLField.snp.bottom).offset(20)
      make.left.equalTo(snp.left).inset(20)
      make.right.equalTo(snp.right).inset(20)
      make.height.equalTo(20)
    }
  }
  
  func adjustPasswordField() {
    passwordField.placeholderString = "Password"
    passwordField.backgroundColor = .clear
    passwordField.bezelStyle = .roundedBezel
    passwordField.target = self
    passwordField.action = #selector(loginButtonTapped)
    passwordField.snp.makeConstraints { make in
      make.top.equalTo(usernameField.snp.bottom).offset(20)
      make.left.equalTo(snp.left).inset(20)
      make.right.equalTo(snp.right).inset(20)
      make.height.equalTo(20)
    }
  }
  
  func adjustLoginButton() {
    loginButton.title = "Login"
    loginButton.target = self
    loginButton.action = #selector(loginButtonTapped)
    loginButton.bezelStyle = .regularSquare
    loginButton.snp.makeConstraints { make in
      make.top.equalTo(passwordField.snp.bottom).offset(20)
      make.left.equalTo(snp.left).inset(20)
      make.width.equalTo(askQuestionButton.snp.width)
      make.height.equalTo(20)
    }
  }
  
  func adjustAskQuestionButton() {
    askQuestionButton.title = "Help"
    askQuestionButton.target = self
    askQuestionButton.action = #selector(askAQuestion)
    askQuestionButton.bezelStyle = .regularSquare
    askQuestionButton.snp.makeConstraints { make in
      make.top.equalTo(passwordField.snp.bottom).offset(20)
      make.left.equalTo(loginButton.snp.right).offset(20)
      make.right.equalTo(snp.right).inset(20)
      make.height.equalTo(20)
    }
  }
  
  func loginButtonTapped() {
    let server = serverURLField.stringValue
    let username = usernameField.stringValue
    let password = passwordField.stringValue
    if server == "" || username == "" || password == "" {
      NSAlert(error: NSError(domain: "com.ac.error", code: 2, userInfo: [NSLocalizedDescriptionKey: "All fields must be filled"])).runModal()
      return
    }
    delegate?.loginButtonTapped(server: server, username: username, password: password)
  }
  
  func askAQuestion() {
    Helper.askAQuestion()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
