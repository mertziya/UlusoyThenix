//
//  CoachingScraping.swift
//  UlusoyWorkout
//
//  Created by Mert Ziya on 23.02.2025.
//

import Foundation
import Alamofire
import SwiftSoup


enum CoachingScrapingError : Error{
    case parseError(reason : String)
    case divError(reason : String)
    case selectError(reason : String)
}
struct Coaching : Decodable{
    var imageURL : String?
    var shopierURL : String?
    var month : String?
    var price : String?
    var details : [String]?
}


class CoachingScraping{
    
    // MARK: - Return all the coaching data:
    static func scrapeCoachings(completion : @escaping (Result<[Coaching],Error>) -> ()){
        AF.request(URLEndpoints.coaching).responseString { responseString in
            switch responseString.result{
            case .success(let html):
                let coachingData = extractCoachingData(html: html) { error in
                    if let error = error{
                        completion(.failure(error))
                        return
                    }
                }
                completion(.success(coachingData))
            case .failure(let afError):
                completion(.failure(afError))
                return
            }
        }
    }
    
    
    // MARK: - Web scraping logic for getting the coaching data:
    private static func extractCoachingData(html : String , completion: @escaping (Error?) -> ()) -> [Coaching]{
        var allCoachingData : [Coaching] = []
        
        do{
            let document = try SwiftSoup.parse(html)
            guard let divContent = try document.select("div[data-aid='MENU_ITEM_GRID_0'").first() else{
                completion(CoachingScrapingError.divError(reason: "Cannot get MENU_ITEM_GRID_0 "))
                return []
            }
            let gridCells = try divContent.select("div[data-ux='GridCell']")
            
            for coachingCell in gridCells{
                var coaching = Coaching()
                
                let imageElement = try coachingCell.select("a[data-ux='Element']").first()
                let shopierURL = try imageElement?.attr("href") ?? URLEndpoints.coaching // Error case URL
                
                let imageURLHolder = try imageElement?.select("img").first()
                let imageURL = try imageURLHolder?.attr("src") ?? URLEndpoints.coaching // Error case URL
                let trueImageURL = String(describing: imageURL.dropFirst(2)) // true URL
                
                let headingElement = try coachingCell.select("h4[role='heading']").first()
                let monthText = try headingElement?.text() ?? "0 Month" // Error case text
                
                let priceElement = try coachingCell.select("div[data-ux='Price']").first()
                let priceText = try priceElement?.text() ?? "Uygun Değil" // Error case price text
                
                guard let listElement = try coachingCell.select("ul").first() else{
                    completion(CoachingScrapingError.selectError(reason: "Couldn't select the coaching list items."))
                    return []
                }
                let listItems = try listElement.select("li")
                
                var details : [String] = []
                for item in listItems{
                    let itemText = try item.text()
                    details.append(itemText)
                }
                
                
                coaching.shopierURL = shopierURL
                coaching.imageURL = trueImageURL
                coaching.month = monthText
                coaching.price = priceText
                coaching.details = details
                
                allCoachingData.append(coaching)
            }
                
        }catch{
            completion(error)
        }
        
        return allCoachingData
    }
}
