//
//  PicturesScraping.swift
//  UlusoyWorkout
//
//  Created by Mert Ziya on 26.02.2025.
//

import Foundation
import Alamofire

struct Picture : Decodable{
    var id : Int?
    var description : String?
    var imageURL : String?
    
    enum CodingKeys : String , CodingKey{
        case id = "id"
        case description = "Açıklama"
        case imageURL = "Fotoğraf Linki"
    }
}

struct PictureSubContainer : Decodable{
    var id : String?
    var createdTime : String?
    var fields : Picture?
}
struct PictureContainer : Decodable{
    var records : [PictureSubContainer]?
}

class PicturesService{

    static func fetchPictures(completion : @escaping (Result<[Picture],Error>) -> () ){
        let url = URLEndpoints.pictures
        let token = GetToken.token
        let headers : HTTPHeaders = [
            "Authorization" : "Bearer \(token)"
        ]
        let parameters : [String : Any] = [
            "sort[0][field]" : "id",
            "sort[0][direction]" : "asc"
        ]
        
        AF.request(url, method: .get , parameters: parameters , headers: headers).response { response in
            switch response.result{
            case .success(let data):
                if let data = data{
                    do{
                        let dataContainer = try JSONDecoder().decode(PictureContainer.self, from: data)
                        if let records = dataContainer.records{
                            var allPicture : [Picture] = []
                            for record in records{
                                allPicture.append(record.fields ?? Picture())
                            }
                            completion(.success(allPicture))
                        }else{
                            completion(.failure(PictureServiceError.error(reason: "error while unwrapping records of pictures!")))
                        }
                        
                    }catch{
                        completion(.failure(error))
                    }
                }else{
                    completion(.failure(PictureServiceError.error(reason: "data unwrapping error while fetching Pictures")))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

enum PictureServiceError : Error{
    case error(reason : String)
}

