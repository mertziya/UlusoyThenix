//
//  PackagesScrapingService.swift
//  UlusoyWorkout
//
//  Created by Mert Ziya on 22.02.2025.
//

import Foundation
import Alamofire

struct ReadyPackage : Decodable{
    var id : Int?
    var imageURL : String?
    var productURL : String?
    var name : String?
    var price : String?
    var discountPrice : String?
    var description : String?
    
    enum CodingKeys : String , CodingKey {
        case id = "id"
        case imageURL = "Görsel Linki"
        case productURL = "Ürün Linki"
        case name = "İsim"
        case price = "Ücret"
        case discountPrice = "İndirimli Ücret"
        case description = "Açıklama"
    }
}
struct packageContainer : Decodable{
    var records : [packagesSubContainer]?
}
struct packagesSubContainer : Decodable{
    var id : String?
    var createdTime : String?
    var fields : ReadyPackage?
}


class PackageService{
    
    static func fetchPackages(completion : @escaping (Result<[ReadyPackage] , Error>) -> () ){
        let url = URLEndpoints.hazirPaketler
        let token = GetToken.token
        let headers : HTTPHeaders = [
            "Authorization" : "Bearer \(token)"
        ]
        let parameters : [String : Any] = [
            "sort[0][field]" : "id",
            "sort[0][direction]" : "asc"
        ]
        
        AF.request(url, method: .get, parameters: parameters, headers: headers).response { response in
            switch response.result{
            case .success(let data):
                if let data = data{
                    do{
                        let dataContainer = try JSONDecoder().decode(packageContainer.self, from: data)
                        
                        if let records = dataContainer.records{
                            var allPackages : [ReadyPackage] = []
                            for record in records{
                                allPackages.append(record.fields ?? ReadyPackage())
                            }
                            completion(.success(allPackages))
                        }else{
                            completion(.failure(PackageServiceErrors.serviceError(reason: "Error while unwrapping records at package serivice")))
                        }
                        
                    }catch{
                        completion(.failure(error))
                    }
                }else{
                    completion(.failure(PackageServiceErrors.serviceError(reason: "Error while unwrapping the data ")))
                }
                
            case .failure(let error):
                completion(.failure(error))
                return
            }
        }
    }
    
}


enum PackageServiceErrors : Error{
    case serviceError(reason : String)
}
