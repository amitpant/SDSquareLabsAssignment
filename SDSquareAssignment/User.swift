//
//  User.swift
//  SDSquareAssignment
//
//  Created by Amit Pant on 03/07/17.
//  Copyright © 2017 Amit Pant. All rights reserved.
//

import Foundation
import UIKit

public final class User {
    
    // MARK: - Instance Properties
    public let name : String?
    public let image: String?
    public let items:[String]?
    
    internal struct Keys {
        static let name = "name"
        static let image = "image"
        static let items = "items"
        static let data = "data"
        static let users = "users"
    }
    
    init(name: String, image: String, items:[String]) {
        self.name = name
        self.image = image
        self.items = items
    }
    
    // MARK: - Object Lifecycle
    public init?(json: [String: Any]) {
        guard let name = json[Keys.name] as? String,
            let image = json[Keys.image] as? String,
            let items = json[Keys.items] as? [String] else {
                return nil
        }
        self.name = name
        self.image = image
        self.items = items
    }
    
    // MARK: - Class Constructors
    public class func array(jsonObject: [String: Any]) -> [User] {
        var array: [User] = []
        guard let jsonData = jsonObject[Keys.data] as? [String: Any],
        let jsonArray = jsonData[Keys.users] as? [[String:Any]] else {
            return array
        }
        for json in jsonArray {
            guard let user = User(json: json) else { continue }
            array.append(user)
        }
        return array
    }
}
