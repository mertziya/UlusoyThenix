//
//  CoachingScraping.swift
//  UlusoyWorkout
//
//  Created by Mert Ziya on 23.02.2025.
//

import Foundation
import Alamofire


struct Coaching : Decodable{
    var id : Int?
    var imageURL : String?
    var shopierURL : String?
    var month : String?
    var price : String?
    var discountPrice : String?
    var details : [String]?
    var color : String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case imageURL = "Görsel Linki"
        case shopierURL = "Ürün Linki"
        case month = "Ay"
        case price = "Ücret"
        case details = "Detaylar"
        case discountPrice = "İndirimli Ücret"
        case color = "Renk"
        
    }
}

struct CoachingContainer : Decodable{
    var records : [CoachingSubContainer]?
}
struct CoachingSubContainer : Decodable{
    var id : String?
    var createdTime : String?
    var fields : Coaching?
    
}


class CoachingService{
    
    static func getCoachingData(completion: @escaping (Result<[Coaching],Error>) -> () ){
        
        let url = URLEndpoints.coaching
        let token = GetToken.token
        let headers : HTTPHeaders = [
            "Authorization" : "Bearer \(token)"
        ]
        let parameters : [String : Any] = [
            "sort[0][field]" : "id", // Sorts depending on the month
            "sort[0][direction]" : "asc"
        ]
        
        AF.request(url, method: .get , parameters: parameters ,headers: headers)
        .validate()
        .response { res in
            switch res.result{
            case .success(let data):
                if let data = data{
                    do{
                        let coachingContainer = try JSONDecoder().decode(CoachingContainer.self, from: data)
                        if let coachingSubcontainer = coachingContainer.records{
                            var coachingData : [Coaching] = []
                            for record in coachingSubcontainer{
                                coachingData.append(record.fields ?? Coaching())
                            }
                            completion(.success(coachingData))

                        }else{
                            completion(.failure(CoachingServiceError.dataError(reason: "Error while fetching coaching subcontainer")))
                        }
                        
                    }catch{
                        
                    }
                }else{
                    completion(.failure(CoachingServiceError.dataError(reason: "couldn't get the data for coaching")))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
        
    }
    
}


enum CoachingServiceError : Error{
    case dataError(reason : String)
}
