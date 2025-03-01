//
//  GetToken.swift
//  UlusoyWorkout
//
//  Created by Mert Ziya on 1.03.2025.
//

import Foundation

class GetToken{

    static let token :String = {
        if let path = Bundle.main.path(forResource: "Privacy", ofType: "plist"),
           let keys = NSDictionary(contentsOfFile: path),
           let apiKey = keys["API_TOKEN"] as? String{
            return apiKey
        }
        return "ERROR API"
    }()
    
}
