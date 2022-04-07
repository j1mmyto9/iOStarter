//
//  NotificationHelper.swift
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
import UserNotifications
// TODO: Adjust this when not use firebase
import FirebaseMessaging
import SwiftyJSON
import AVKit

class NotificationHelper {
    static var shared = NotificationHelper()
    
    private var player: AVAudioPlayer?
    
    /// Setup all need for notification first
    func setupNotif(delegate: AppDelegate, application: UIApplication) {
        UNUserNotificationCenter.current().delegate = delegate
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: options, completionHandler: { (_, _) in })
        application.registerForRemoteNotifications()
        
        Messaging.messaging().delegate = delegate
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshFcmToken), name: NSNotification.Name.MessagingRegistrationTokenRefreshed, object: nil)
    }
    
    /// Save registration id token
    ///
    /// - Parameter deviceToken: Reg id to send notification in this device
    func register(deviceToken: Data) {
        // TODO: Adjust this when not use firebase
        Messaging.messaging().apnsToken = deviceToken
        #if DEBUG
            Messaging.messaging().setAPNSToken(deviceToken, type: .sandbox)
        #else
            Messaging.messaging().setAPNSToken(deviceToken, type: .prod)
        #endif
        
        refreshFcmToken()
    }
    
    /// Update registration id token
    ///
    /// - Parameter notification: Notification sender when token refresh
    @objc func refreshFcmToken() {
        // TODO: Adjust this when not use firebase
        Messaging.messaging().token { (token, error) in
            if let token = token {
                print("Messaging token: \(token)")
                UserSession.shared.setRegid(string: token)
            }
        }
        if let token = Messaging.messaging().fcmToken {
            print("Fcm token \(token)")
            UserSession.shared.setRegid(string: token)
        }
    }
    
    /// Custom sound of notification in foreground
    private func playCustomSound() {
//        guard let url = Bundle.main.url(forResource: "notification", withExtension: "mp3") else { return }
//        do {
//            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
//            try AVAudioSession.sharedInstance().setActive(true)
//
//            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
//
//            guard let player = player else { return }
//
//            player.play()
//
//        } catch let error {
//            print(error.localizedDescription)
//        }
    }
    
    /// Trigger action when notification appear
    func notificationWillAppear(data: [AnyHashable : Any]) {
        print("Notification will present")
        exampleAction()
    }
    
    /// Trigger action when user tap on notification
    func notificationDidReceive(data: [AnyHashable : Any]) {
        let json = JSON(data)
        _ = json["title"].stringValue
        _ = json["content"].stringValue
        _ = json["action"].stringValue
        
        print("Hey you did receive notification \(json)")
        self.example2Action()
    }
    
    /// Example action of notification
    func exampleAction() {
        print("Oh, hey you trigger action when notification will present")
    }
    
    func example2Action() {
        print("Oh, hey you tap the notification")
    }
    
}

extension AppDelegate : UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        NotificationHelper.shared.notificationWillAppear(data: userInfo)
        
        if #available(iOS 14.0, *) {
            completionHandler([.banner, .badge, .sound])
        } else {
            completionHandler([.alert, .badge, .sound])
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        NotificationHelper.shared.notificationDidReceive(data: userInfo)
        
        completionHandler()
    }
}

// TODO: Adjust this when not use firebase
extension AppDelegate : MessagingDelegate {
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        print("Firebase refresh registration token:", fcmToken)
        NotificationHelper.shared.refreshFcmToken()
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase receive registration token:", fcmToken ?? "")
        NotificationHelper.shared.refreshFcmToken()
    }
}
