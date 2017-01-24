//
//  JIRAClient.swift
//  Jira time tracker
//
//  Created by Denis Kudinov on 03/01/2017.
//  Copyright © 2017 Denis Kudinov. All rights reserved.
//

import Cocoa
import Foundation

class JIRAClient {
  
  var baseURL: URL!
  var session: URLSession!
  var credentialsStorage: CredentialsStorage!
  var apiURL: URL!
  
  init(credentialsStorage: CredentialsStorage) {
    session = URLSession(configuration: URLSessionConfiguration.default)
  }
  
  func configure(with credentialsStorage: CredentialsStorage) {
    if credentialsStorage.getServerURL() == nil || credentialsStorage.getCurrentCredentials() == nil
      || credentialsStorage.getServerURL() == "" || credentialsStorage.getCurrentCredentials() == "" {
      let appDelegate = NSApp.delegate as? AppDelegate
      appDelegate?.logout()
      print("cannot configure JIRA client with: \(credentialsStorage.getServerURL()), \(credentialsStorage.getServerURL())")
      return
    }
    self.baseURL = URL(string: credentialsStorage.getServerURL()!)!
    self.apiURL = self.baseURL.appendingPathComponent("/rest/api/2/")
    self.credentialsStorage = credentialsStorage
  }
  
  func authorize(request: inout URLRequest) {
    request.setValue("Basic \(credentialsStorage.getCurrentCredentials()!)", forHTTPHeaderField: "Authorization")
  }
  
  func printResponce(response: Data) {
    print(String(data: response, encoding: .utf8)!)
  }
  
  /// MARK - requests
  
  func getAllMyTasks(completion: @escaping ([JiraTask]?, Error?) -> Void) {
    if (credentialsStorage.isInDemoEnvironment()) {
      completion(JiraTask.mockedTasks(), nil)
      return
    }
    let searchURL = apiURL.appendingPathComponent("search")
    var urlComponents = URLComponents(string: searchURL.absoluteString)
    urlComponents?.queryItems = [URLQueryItem(name: "jql", value: "assignee = currentUser() AND resolution = Unresolved ORDER BY updatedDate DESC")]
    var urlRequest = URLRequest(url: (urlComponents?.url)!)
    urlRequest.httpMethod = "GET"
    authorize(request: &urlRequest)
    session.dataTask(with: urlRequest) { (data, response, error) in
      if let error = error {
        print("error occured: \(error)")
        DispatchQueue.main.async {
          NSAlert(error: error).runModal()
          completion(nil, error)
        }
        return
      }
      guard let data = data else {
        print("No data is received during GET [All my tasks]")
        DispatchQueue.main.async {
          let err = NSError(domain: "com", code: 4, userInfo: [NSLocalizedDescriptionKey: "`GET` failed"])
          NSAlert(error: err).runModal()
          completion(nil, err)
        }
        return
      }
      self.printResponce(response: data)
      let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as! Dictionary<String, Any>
      if json == nil {
        print("Invalid json")
        DispatchQueue.main.async {
          let err = NSError(domain: "com", code: 5, userInfo: [NSLocalizedDescriptionKey: "Invalid json"])
          NSAlert(error: err).runModal()
          completion(nil, err)
        }
        return
      }
      DispatchQueue.main.async {
        completion(JiraTask.tasks(with: json?["issues"] as! [Dictionary<String, AnyObject>], baseURL: self.baseURL), nil)
      }
      }.resume()
  }
  
  func logWork(_ time: TimeInterval, task: JiraTask, completion: @escaping () -> Void) {
    if (credentialsStorage.isInDemoEnvironment()) {
      completion()
      return
    }
    let worklogURL = apiURL.appendingPathComponent("issue/\(task.shortID!)/worklog")
    var urlRequest = URLRequest(url: worklogURL)
    urlRequest.httpMethod = "POST"
    urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
    let body =  try? JSONSerialization.data(withJSONObject: ["timeSpentSeconds": Int(time),
                                                             "comment": "Logged with Jira Tool preview"], options: [])
    urlRequest.httpBody = body
    authorize(request: &urlRequest)
    session.dataTask(with: urlRequest) { data, response, error in
      if let error = error {
        NSAlert(error: error).runModal()
        print("error occured: \(error)")
        return
      }
      self.printResponce(response: data!)
      DispatchQueue.main.async {
        completion()
      }
    }.resume()
  }
  
}
