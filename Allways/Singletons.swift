//
//  Singletons.swift
//  Allways
//
//  Created by Jairo Batista on 9/29/16.
//  Copyright © 2016 AllWays. All rights reserved.
//

import Foundation


// MARK: - Interval

class IntervalManager {
    
    // Variable
    var _interval: Int?
    
    // Interval Can Only Be Instantiated -> SharedInstance
    static let sharedInstance = IntervalManager()
    private init() {}
    
    // Set Interval
    func set(interval: Int) {
        _interval = interval
    }
    
    // Return Interval
    func get() -> Int {
        if let status = _interval {
            return status
        } else {
            // Recover Saved Interval from User Defaults
            if let recoveredInterval = UserDefaults.standard.value(forKey: "interval") as? Int {
                self.set(interval: recoveredInterval)
                return self.get()
            } else {
                print("Not able to recover interval from UserDefaults")
                self.set(interval: 0)
                return self.get()
            }
        }
    }
    
    // Save Interval
    func save() {
        UserDefaults.standard.setValue(self.get(), forKey: "interval")
        UserDefaults.standard.synchronize()
    }
}


// MARK: - Phone Number

class PhoneManager {
    var _number: String?
    static let sharedInstance = PhoneManager()
    private init() {}
    
    func set(number: String) {
        _number = String(number)
    }
    
    func get() -> String? {
        if let number = _number {
            return number
        } else {
            // Recover Saved Number from User Defaults
            if let recoveredNumber = UserDefaults.standard.value(forKey: "phone") as? String {
                self.set(number: recoveredNumber)
                return self.get()
            } else {
                print("ERROR: attempting to recover phoneNumber w/o it being set initally.")
                return "0"
            }
        }
    }
    
    func save() {
        UserDefaults.standard.setValue(self.get(), forKey: "phone")
        UserDefaults.standard.synchronize()
    }
}


// MARK: - Server ID

class ServerIDManager {
    var _serverID: String?
    static let sharedInstance = ServerIDManager()
    private init() {}
    
    func set(serverID: String) {
        _serverID = serverID
    }
    
    func get() -> String? {
        if let value = _serverID {
            return String(value)
        } else {
            // Recover <- UserDefaults
            if let recoveredID = UserDefaults.standard.value(forKey: "serverID") as? String {
                self.set(serverID: recoveredID)
                return self.get()
            } else {
                print("ERROR: No server ID saved.")
                return nil
            }
        }
    }
    
    func save() {
        UserDefaults.standard.setValue(self.get(), forKey: "serverID")
        UserDefaults.standard.synchronize()
    }
}


// MARK: - Load ID

class LoadIDManager {
    var _loadID: String?
    static let sharedInstance = LoadIDManager()
    private init() {}
    
    func set(loadID: String) {
        _loadID = loadID
    }
    
    func get() -> String? {
        if let loadID = _loadID {
            return loadID
        } else {
            // Recover <- User Defaults
            if let recoveredID = UserDefaults.standard.value(forKey: "loadID") as? String {
                self.set(loadID: recoveredID)
                return self.get()
            } else {
                print("ERROR: Attempting to recover load ID but none has been assigned.")
                return nil
            }
        }
    }
    
    func save() {
        UserDefaults.standard.setValue(self.get(), forKey: "loadID")
        UserDefaults.standard.synchronize()
    }
}


// MARK: - Work Order

class WorkOrderManager {
    var _workOrder: String?
    static let sharedInstance = WorkOrderManager()
    private init() {}
    
    func set(wo: String) {
        _workOrder = wo
    }
    
    func get() -> String? {
        if let workOrder = _workOrder {
            return workOrder
        } else {
            if let recoveredValue = UserDefaults.standard.value(forKey: "workOrder") as? String {
                self.set(wo: recoveredValue)
                return self.get()
            } else {
                print("ERROR: Attempting to recover Work Order but none set.")
                return nil
            }
        }
    }
    
    func save() {
        UserDefaults.standard.setValue(self.get(), forKey: "workOrder")
        UserDefaults.standard.synchronize()
    }
}


// MARK: - Account ID

class AccountIDManager {
    var _accountID: String?
    static let sharedInstance = AccountIDManager()
    private init() {}
    
    func set(accountID: String) {
        _accountID = accountID
    }
    
    func get() -> String? {
        if let accountID = _accountID {
            return accountID
        } else {
            if let recoveredValue = UserDefaults.standard.value(forKey: "accountID") as? String {
                self.set(accountID: recoveredValue)
                return self.get()
            } else {
                print("ERROR: Attempting to recover Account ID but none set.")
                return nil
            }
        }
    }
    
    func save() {
        UserDefaults.standard.setValue(self.get(), forKey: "accountID")
        UserDefaults.standard.synchronize()
    }
}
