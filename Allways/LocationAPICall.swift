//
//  LocationAPICall.swift
//  Allways
//
//  Created by Jairo Batista on 10/18/16.
//  Copyright © 2016 AllWays. All rights reserved.
//

import Foundation

class LocationAPICall: APICall {
    private let _accountID: String!
    private let _serverID: String!
    private let _loadID: String!
    private let _latitude: Double!
    private let _longitude: Double!
    private let _head: Double!
    private let _speed: Double!
    private let _addrStreet: String!
    private let _addrCity: String!
    private let _addrZip: String!
    private let _addrState: String!
    private let _addrCountry: String!
    
    init(phone: String, lat: Double, lng: Double, head: Double, speed: Double,
         street: String, city: String, zip: String, state: String, country: String, accountID: String, serverID: String, loadID: String) {
        
        _latitude = lat
        _longitude = lng
        _head = head
        _speed = speed
        _addrStreet = street
        _addrCity = city
        _addrZip = zip
        _addrState = state
        _addrCountry = country
        _accountID = accountID
        _serverID = serverID
        _loadID = loadID
        
        // Instantiate Base Class Attributes
        super.init(phone: phone)
    }
    
    
    // MARK: - Discreet Data Revealing
    
    func loadID() -> String {
        return _loadID
    }
    
    func serverID() -> String{
        return _serverID
    }
    
    func accountID() -> String {
        return _accountID
    }
    
    func latitude() -> String {
        return String(_latitude)
    }
    
    func longitude() -> String {
        return String(_longitude)
    }
    
    func head() -> String {
        return String(_head)
    }
    
    func speed() -> String {
        return String(_speed)
    }
    
    func street() -> String {
        return _addrStreet
    }
    
    func city() -> String {
        return _addrCity
    }
    
    func zip() -> String {
        return _addrZip
    }
    
    func state() -> String {
        return _addrState
    }
    
    func country() -> String {
        return _addrCountry
    }
    
    // Convert -> JSON
    func position() -> String {
        return "{\"lat\":\"\(self.latitude())\",\"lng\":\"\(self.longitude())\",\"head\":\"\(self.head())\",\"speed\":\"\(self.speed())\"}"
    }
    
    func address() -> String {
        return "{\"street\":\"\(self.street())\",\"city\":\"\(self.city())\",\"state\":\"\(self.state())\",\"country\":\"\(self.country())\",\"zip\":\"\(self.zip())\"}"
    }
    
    // TODO: Server Does Not Respond When Given Load_ID
    override func toJSON() -> Dictionary<String, String> {
        return [
            "data": "{\"process\":\"\(self.process())\",\"phone\":\"\(self.phone())\",\"load_id\":\"\(self.loadID())\",\"server_id\":\"\(self.serverID())\",\"account_id\":\"\(self.accountID())\",\"position\":\(self.position()),\"address\":\(self.address())}"
        ]
    }
}
