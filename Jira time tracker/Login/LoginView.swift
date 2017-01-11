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
  
  weak var delegate: LoginViewController?
  
  init(frame frameRect: NSRect, delegate: LoginViewController) {
    super.init(frame: frameRect)
    self.delegate = delegate
    addSubview(serverURLField)
    addSubview(usernameField)
    addSubview(passwordField)
    addSubview(loginButton)
    adjustServerURLField()
    adjustUsernameField()
    adjustPasswordField()
    adjustLoginButton()
  }
  
  func adjustServerURLField() {
    serverURLField.placeholderString = "Server URL (eg https://jira.company.com)"
    serverURLField.snp.makeConstraints { make in
      make.top.equalTo(snp.top).offset(20)
      make.left.equalTo(snp.left)
      make.right.equalTo(snp.right)
      make.height.equalTo(20)
    }
  }
  
  func adjustUsernameField() {
    usernameField.placeholderString = "Username"
    usernameField.snp.makeConstraints { make in
      make.top.equalTo(serverURLField.snp.bottom).offset(20)
      make.left.equalTo(snp.left)
      make.right.equalTo(snp.right)
      make.height.equalTo(20)
    }
  }
  
  func adjustPasswordField() {
    passwordField.placeholderString = "Password"
    passwordField.backgroundColor = .clear
    passwordField.target = self
    passwordField.action = #selector(loginButtonTapped)
    passwordField.snp.makeConstraints { make in
      make.top.equalTo(usernameField.snp.bottom).offset(20)
      make.left.equalTo(snp.left)
      make.right.equalTo(snp.right)
      make.height.equalTo(20)
    }
  }
  
  func adjustLoginButton() {
    loginButton.title = "Login"
    loginButton.target = self
    loginButton.action = #selector(loginButtonTapped)
    loginButton.snp.makeConstraints { make in
      make.top.equalTo(passwordField.snp.bottom).offset(20)
      make.left.equalTo(snp.left)
      make.right.equalTo(snp.right)
      make.height.equalTo(20)
    }
  }
  
  func loginButtonTapped() {
    let server = serverURLField.stringValue
    let username = usernameField.stringValue
    let password = passwordField.stringValue
    delegate?.loginButtonTapped(server: server, username: username, password: password)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
