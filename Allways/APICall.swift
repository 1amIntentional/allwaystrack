//
//  APICall.swift
//  Allways
//
//  Created by Jairo Batista on 10/17/16.
//  Copyright © 2016 AllWays. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

// Base Class for API Calls //
class APICall {
    private let _phone: String!
    private let _process: String! = "mobileGps"
    
    init(phone: String) {
        _phone = phone
    }
    
    // Discreet Data Revealing
    func process() -> String {
        return _process
    }
    
    func phone() -> String {
        return String(_phone)
    }
    
    // Format Data -> JSON
    func toJSON() -> Dictionary<String, String>{
        return [
            "data": "{\"process\":\"\(self.process())\",\"phone\":\"\(self.phone())\"}"
        ]
    }
    
    // Send Request -> Server
    func post() {
        print(self.toJSON())
        Alamofire.request("http://104.130.126.143/webapp/zTest/gpsAppAC.php", method: .post, parameters: self.toJSON(), encoding: URLEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            switch(response.result) {
            case .success(_):
                if let serverResponse = response.result.value{
                    let json = JSON(serverResponse)
                    // Send Response -> Middleware
                    let middleware = MiddlewareManager.sharedInstance
                    middleware.parseAPIResponse(json: json)
                    print(json)
                }
                break
                
            case .failure(_):
                print(response.result.error ?? "ERROR: Server POST request failed.")
                // Error handle error w/ server
                break
            }
        }
    }
}
