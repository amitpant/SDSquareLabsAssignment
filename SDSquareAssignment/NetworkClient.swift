//
//  NetworkClient.swift
//  SDSquareAssignment
//
//  Created by Amit Pant on 03/07/17.
//  Copyright © 2017 Amit Pant. All rights reserved.
//

import UIKit
public final class NetworkClient {
    
    // MARK: - Instance Properties
    internal let baseURL: String
    internal let session = URLSession.shared
    
    // MARK: - Class Constructors
    public static let shared: NetworkClient = {
        let file = Bundle.main.path(forResource: "ServerEnvironments", ofType: "plist")!
        let dictionary = NSDictionary(contentsOfFile: file)!
        let urlString = dictionary["service_url"] as! String
        return NetworkClient(baseURL: urlString)
    }()
    
    // MARK: - Object Lifecycle
    private init(baseURL: String){
        self.baseURL = baseURL
    }
    
    public func getUsers(offset: Int,
                         limit: Int,
                         success _success: @escaping ([User])-> Void,
                         failure _failure:@escaping (NetworkError)->Void) {
        
        let success: ([User])-> Void = { users in
            DispatchQueue.main.async {
                _success(users)
            }
        }
        
        let failure: (NetworkError) -> Void = { error in
            DispatchQueue.main.async {
                _failure(error)
            }
        }
        
        let path = baseURL.appending("users?offset=\(offset)&limit=\(limit)")
        guard let url = URL(string: path) else{return}
        
        let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
            guard let data = data,
                let jsonObject = try? JSONSerialization.jsonObject(with: data),
                let json = jsonObject as? [String: Any] else {
                    if let error = error {
                        failure(NetworkError(error: error))
                    }
                    return
            }
            
            let users = User.array(jsonObject: json)
            success(users)
        })
        task.resume()
    }
    
    public func getItemImage(urlString: String,
                             success _success: @escaping (UIImage)-> Void,
                             failure _failure:@escaping (NetworkError)->Void) {
        
        let success: (UIImage)-> Void = { image in
            DispatchQueue.main.async {
                _success(image)
            }
        }
        
        let failure: (NetworkError) -> Void = { error in
            DispatchQueue.main.async {
                _failure(error)
            }
        }
        
        
        guard let url = URL(string: urlString) else{return}
        
        let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
            guard let data = data,
                let image =  UIImage(data: data) else {
                    if let error = error {
                        failure(NetworkError(error: error))
                    }
                    return
            }
            success(image)
        })
        task.resume()
    }
}
