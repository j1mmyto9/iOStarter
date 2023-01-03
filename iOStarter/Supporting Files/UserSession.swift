//
//  UserSession.swift
//  iOStarter
//
//  Created by Macintosh on 07/04/22.
//  
//
//  This file was generated by Project Xcode Templates
//  Created by Wahyu Ady Prasetyo,
//  Source: https://github.com/dypme/iOStarter
//

import Foundation
import UIKit
import MMKV
import SwiftyJSON

class UserSession: ObservableObject {
    static let shared = UserSession()
    
    private var profileKey = "profileKey"
    private var regidKey = "regidKey"
    
    private var userStandard = MMKV.default()
    
    /// Getting stored token registration id for push notification
    @Published var regid: String = "" {
        didSet {
            userStandard?.set(regid, forKey: regidKey)
        }
    }

    /// Getting stored profile data
    @Published var profile: User? {
        didSet {
            setObject(profile, forKey: profileKey)
        }
    }
    
    init() {
        regid = userStandard?.string(forKey: regidKey) ?? ""
        profile = getObject(forKey: profileKey)
    }
    
    // TODO: Example usage to save logged in user session
    /// Check user logged in
    var isUserLoggedIn: Bool {
        profile != nil
    }
    
    func clearData() {
        profile = nil
        regid = ""
        userStandard?.clearAll()
    }
    
    private func setObject(_ object: BaseModel?, forKey key: String) {
        guard let object = object else {
            userStandard?.removeValue(forKey: key)
            return
        }
        guard let jsonStr = object.toJson()?.rawString() else { fatalError("Converting JSON to raw string failed") }
        guard let chiperStr = jsonStr.encrypt else { fatalError("Failed to encrypt string") }
        userStandard?.set(chiperStr, forKey: key)
    }
    
    private func getObject<T: BaseModel>(forKey key: String) -> T? {
        if let chiperStr = userStandard?.string(forKey: key) {
            guard let plainStr = chiperStr.decrypt else { return nil }
            guard let jsonData = plainStr.data(using: .utf8), let json = try? JSON(data: jsonData) else { return nil }
            return plainStr.isEmpty ? nil : T(fromJson: json)
        }
        return nil
    }
}
