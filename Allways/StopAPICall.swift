//
//  StopAPICall.swift
//  Allways
//
//  Created by Jairo Batista on 1/7/17.
//  Copyright © 2017 AllWays. All rights reserved.
//

import Foundation

class StopAPICall: APICall {
    
    private let _stopID: String!
    private var _status: String?
    private let _type: String!
    private let _accountID: String!
    private let _serverID: String!
    private let _loadID: String!
    private let _date: String!
    
    init(phone: String, accountID: String, serverID: String, loadID: String, stopID: String, type: String) {
        
        _stopID = stopID
        _type = type
        _accountID = accountID
        _serverID = serverID
        _loadID = loadID
        _date = String(describing: Date())
        
        super.init(phone: phone)
    }
    
    // Discreet Data Revealing
    func getType() -> String {
        return _type
    }
    
    func getDate() -> String {
        return String(_date)
    }
    
    func getStopID() -> String {
        return _stopID
    }
    
    func getStatus() -> String {
        if let statusAvailable = _status {
            return statusAvailable
        } else {
            return "NS"
        }
    }
    
    func loadID() -> String {
        return _loadID
    }
    
    func serverID() -> String{
        return _serverID
    }
    
    func accountID() -> String {
        return _accountID
    }
    
    func setStatus(status: String) {
        _status = status
    }
    
    func stopData() -> String {
        return "{\"type\":\"\(self.getType())\",\"date_time\":\"\(self.getDate())\",\"status\":\"\(self.getStatus())\",\"stop_id\":\"\(self.getStopID())\"}"
    }
    
    override func toJSON() -> Dictionary<String, String> {
        return [
            "data": "{\"process\":\"\(self.process())\",\"phone\":\"\(self.phone())\",\"load_id\":\"\(self.loadID())\",\"account_id\":\"\(self.accountID())\",\"server_id\":\"\(self.serverID())\",\"stops\":\(self.stopData())}"
        ]
    }
}
