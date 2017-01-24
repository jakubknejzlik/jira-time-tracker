//
//  CredentialsStorage.swift
//  Jira time tracker
//
//  Created by Denis Kudinov on 09/01/2017.
//  Copyright © 2017 Denis Kudinov. All rights reserved.
//

import Foundation
import Security


class CredentialsStorage : UserDefaults {
  
  let privateKey = "MIIBOgIBAAJBAKnklsz0e7lHNwKDv5sq/EbyXgM2L75Z37hoPn675wVLKHLzEJDLBDJD67M8pCJwNImRwrwdSd7YE7QVrfPCGK8CAwEAAQJAA5pzkFlHHoDiK817jOD2hNKzJ8JIdPMXCaQ8XxfBKJ2Mi+SuCDNknsRm3MgT/TWhvfg+kf1ZBCUIZkCBHia8kQIhAO2/+tWv1tYAzjv74Eld+M0I0xBD3Suxo4W8UT2Tv5YNAiEAtu8nBgsNE6SQRoUXs00xPlJV/NUWrY5wfqEKLBxC1qsCICpOdUY9Kg+eyRQnd/vWOwXRQi2sxdiWnbCYmCRK/FapAiAZkYOazKCfRjkEIkYVwYxIcamjFQV+bJI8oLWTRL/y0QIhAN/ba7r3tPDJMizHWYxWO0XY/hp/pAKzaXUxm+3oB6wD"
  let publicKey = "MFwwDQYJKoZIhvcNAQEBBQADSwAwSAJBAKnklsz0e7lHNwKDv5sq/EbyXgM2L75Z37hoPn675wVLKHLzEJDLBDJD67M8pCJwNImRwrwdSd7YE7QVrfPCGK8CAwEAAQ=="
  
  let kCurrentCredentialsKey = "kCurrentCredentialsKey"
  let kServerURLKey = "kServerURLKey"
  
  func isInDemoEnvironment() -> Bool {
    return getCurrentCredentials() == "ZGVtbzpkZW1v" && getServerURL() == "https://demo.jira.com"
  }
  
  /// MARK: Credentials
  
  /// Getting current user credentials
  ///
  /// - Returns: base64 string username:password
  func getCurrentCredentials() -> String? {
    guard let credentialsEncrypted = UserDefaults.standard.data(forKey: kCurrentCredentialsKey) else {
      return nil
    }
    let data = NSData(data: credentialsEncrypted)
    return decrypt(data: data)
  }
  
  func setCredentials(base64Encoded credentials: String) {
    let data = encrypt(string: credentials)
    UserDefaults.standard.set(data, forKey: kCurrentCredentialsKey)
  }
  
  func removeCredentials() {
    UserDefaults.standard.removeObject(forKey: kCurrentCredentialsKey)
  }
  
  func isLoggedIn() -> Bool {
    return getCurrentCredentials() != nil
  }
  
  /// MARK: Server URL
  
  func setServerURL(serverURL: String) {
    UserDefaults.standard.setValue(serverURL, forKeyPath: kServerURLKey)
  }
  
  func getServerURL() -> String? {
    return UserDefaults.standard.string(forKey: kServerURLKey)
  }
  
  func clearServerURL() {
    UserDefaults.standard.removeObject(forKey: kServerURLKey)
  }
  
  /// MARK: Helpers /// TODO: move to another file
  
  func encrypt(data: NSData, key: String) -> NSData {
    var error: Unmanaged<CFError>? = nil
    //
    let parameters: [NSString: NSString] = [
      kSecAttrKeyType: kSecAttrKeyTypeRSA,
      kSecAttrKeyClass: kSecAttrKeyClassPublic
    ]
    let keyData = Data(base64Encoded: key, options: .ignoreUnknownCharacters)!
    let cryptoKey = SecKeyCreateFromData(parameters as CFDictionary, keyData as CFData , &error)!
    //
    let encrypt = SecEncryptTransformCreate(cryptoKey, &error)
    SecTransformSetAttribute(encrypt, kSecTransformInputAttributeName, data, &error)
    let encryptedData = SecTransformExecute(encrypt, &error)
    //
    return encryptedData as! NSData
  }
  
  func decrypt(data: NSData, key: String) -> NSData {
    var error: Unmanaged<CFError>? = nil
    //
    let parameters: [NSString: NSString] = [
      kSecAttrKeyType: kSecAttrKeyTypeRSA,
      kSecAttrKeyClass: kSecAttrKeyClassPrivate
    ]
    let keyData = Data(base64Encoded: key, options: .ignoreUnknownCharacters)!
    let cryptoKey = SecKeyCreateFromData(parameters as CFDictionary, keyData as CFData , &error)!
    //
    let decrypt = SecDecryptTransformCreate(cryptoKey, &error)
    SecTransformSetAttribute(decrypt, kSecTransformInputAttributeName, data, &error)
    let decryptedData = SecTransformExecute(decrypt, &error)
    //
    return decryptedData as! NSData
  }
  
  func encrypt(string: String) -> NSData? {
    let output = encrypt(data: string.data(using: .utf8)! as NSData, key: publicKey)
    return output
  }
  
  func decrypt(data: NSData) -> String? {
    let output = decrypt(data: data, key: privateKey)
    return String(data: output as Data, encoding: .utf8)
  }
  
}
