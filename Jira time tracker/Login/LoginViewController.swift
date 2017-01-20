//
//  LoginViewController.swift
//  Jira time tracker
//
//  Created by Denis Kudinov on 10/01/2017.
//  Copyright © 2017 Denis Kudinov. All rights reserved.
//

import Cocoa
import Foundation

class LoginViewController: NSViewController {
  
  override func loadView() {
    setupViews()
  }
  
  func setupViews() {
    view = LoginView(frame: .zero, delegate: self)
    view.snp.makeConstraints { make in
      make.width.equalTo(270)
      make.height.equalTo(170)
    }
  }
  
  func loginButtonTapped(server: String, username: String, password: String) {
    let appDelegate = NSApp.delegate as! AppDelegate
    appDelegate.login(server: server, username: username, password: password)
  }
  
}
