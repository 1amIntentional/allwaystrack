//
//  Notification.swift
//  Allways
//
//  Created by Jairo Batista on 1/8/17.
//  Copyright © 2017 AllWays. All rights reserved.
//

import Foundation
import UserNotifications

class NotificationManager {
    
    static let sharedInstance = NotificationManager()
    private init() {}
    
    // CREATE NOTIFICATION
    func scheduleNotification(title: String, body: String, inSeconds: TimeInterval, completion: @escaping (_ Success: Bool) -> ()) {
        
        // Create our notification content
        let notif = UNMutableNotificationContent()
        
        notif.title = title
        notif.body = body
        
        let test = UNTimeIntervalNotificationTrigger(timeInterval: inSeconds, repeats: false)
        
        let request = UNNotificationRequest(identifier: "myNotification", content: notif, trigger: test)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
            if error != nil {
                print(error ?? "ERROR")
                completion(false)
            } else {
                completion(true)
            }
        })
    }
}
