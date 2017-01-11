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
  
  var baseURL: URL
  var session: URLSession
  var credentialsStorage: CredentialsStorage
  lazy var apiURL: URL = {
    return self.baseURL.appendingPathComponent("/rest/api/2/")
  }()
  
  init?(credentialsStorage: CredentialsStorage) {
    if credentialsStorage.getServerURL() == nil || credentialsStorage.getCurrentCredentials() == nil
    || credentialsStorage.getServerURL() == "" || credentialsStorage.getCurrentCredentials() == "" {
      let appDelegate = NSApp.delegate as? AppDelegate
      appDelegate?.logout()
      return nil
    }
    self.baseURL = URL(string: credentialsStorage.getServerURL()!)!
    self.credentialsStorage = credentialsStorage
    session = URLSession(configuration: URLSessionConfiguration.default)
  }
  
  func authorize(request: inout URLRequest) {
    request.setValue("Basic \(credentialsStorage.getCurrentCredentials()!)", forHTTPHeaderField: "Authorization")
  }
  
  func printResponce(response: Data) {
    print(String(data: response, encoding: .utf8)!)
  }
  
  /// MARK - requests
  
  func getAllMyTasks(completion: @escaping ([JiraTask]?, Error?) -> Void) {
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
          completion(nil, error)
        }
        return
      }
      self.printResponce(response: data!)
      let json = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! Dictionary<String, Any>
      DispatchQueue.main.async {
        completion(JiraTask.tasks(with: json?["issues"] as! [Dictionary<String, AnyObject>], baseURL: self.baseURL
        ), nil)
      }
      }.resume()
  }
  
  func logWork(_ time: TimeInterval, task: JiraTask, completion: () -> Void) {
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
        print("error occured: \(error)")
        return
      }
      self.printResponce(response: data!)
    }.resume()
  }
  
}
