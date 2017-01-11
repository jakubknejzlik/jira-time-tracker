//
//  TimeConverter.swift
//  Jira time tracker
//
//  Created by Denis Kudinov on 08/01/2017.
//  Copyright © 2017 Denis Kudinov. All rights reserved.
//

import Foundation

func convertToHumanReadable(time interval: TimeInterval) -> String {
  var seconds = interval
  let hours = Int(seconds / 60.0 / 60.0)
  let minutes = Int((seconds - TimeInterval(hours * 60 * 60)) / 60.0)
  seconds = seconds - TimeInterval(hours * 60 * 60) - TimeInterval(minutes * 60)
  
  let hoursString = hours < 10 ? "0\(hours)" : "\(hours)"
  let minutesString = minutes < 10 ? "0\(minutes)" : "\(minutes)"
  let secondsString = Int(seconds) < 10 ? "0\(Int(seconds))" : "\(Int(seconds))"
  
  return "\(hoursString):\(minutesString):\(secondsString)"
}
