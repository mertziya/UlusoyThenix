//
//  ReviesScraping.swift
//  UlusoyWorkout
//
//  Created by Mert Ziya on 23.02.2025.
//

import Foundation
import Alamofire

struct Review : Decodable{
    var id : Int?
    var name : String?
    var instagram : String?
    var imageURL : String?
    var comment : String?
    
    enum CodingKeys : String , CodingKey{
        case id = "id"
        case name = "İsim"
        case instagram = "instagram"
        case imageURL = "Görsel Linki"
        case comment = "Yorum"
    }
}

struct reviewContainer : Decodable{
    var records : [reviewSubContainer]?
}

struct reviewSubContainer : Decodable{
    var id : String?
    var createdTime : String?
    var fields : Review?
    
}

class ReviewService {
    
    static func fetchReviews(completion : @escaping (Result<[Review],Error>) -> () ){
        let url = URLEndpoints.reviews
        let token = GetToken.token
        let headers : HTTPHeaders = [
            "Authorization" : "Bearer \(token)"
        ]
        let parameters : [String : Any] = [
            "sort[0][field]" : "id",
            "sort[0][direction]" : "asc"
        ]
        
        AF.request(url , method: .get ,parameters: parameters ,headers: headers).response { response in
            switch response.result{
            case .success(let data):
                if let data = data{
                    do{
                        let dataContainer = try JSONDecoder().decode(reviewContainer.self, from: data)
                        let records = dataContainer.records
                        if let records = records{
                            var allReviews : [Review] = []
                            for record in records{
                                allReviews.append(record.fields ?? Review())
                            }
                            completion(.success(allReviews))
                            
                        }else{
                            completion(.failure(ReviewServiceErrors.error(reason: "Couldn't unwrap records at reviews service!")))
                        }
                    }catch{
                        
                    }
                }else{
                    completion(.failure(ReviewServiceErrors.error(reason: "Couldn't unwrap the data at review service!")))
                    return
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}


enum ReviewServiceErrors : Error{
    case error(reason : String)
}
