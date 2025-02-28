//
//  PicturesScraping.swift
//  UlusoyWorkout
//
//  Created by Mert Ziya on 26.02.2025.
//

import Foundation
import Alamofire
import SwiftSoup


class PicturesScraping{
    
    static func scrapePictures(completion : @escaping (Result<[Picture],Error>) -> () ){
        AF.request(URLEndpoints.coaching).responseString { res in
            switch res.result{
            case .success(let html):
                let allPictures = extractPictures(html: html) { error in
                    if let error = error{
                        completion(.failure(error))
                        return
                    }
                }
                completion(.success(allPictures))
                
            case .failure(let error):
                completion(.failure(error))
                return
            }
        }
    }
    
    static private func extractPictures(html : String , completion: @escaping(Error?) -> () ) -> [Picture]{
        var pictures : [Picture] = []
        
        do{
            let document = try SwiftSoup.parse(html)
            guard let blockOfContent = try document.select("div[data-ux='Block']").first() else{
                completion(PictureScrapingError.selectError(reason: "error while selecting data-ux='Block' "))
                return []
            }
            
            // MARK: - Scraping the pictures of the achievemnt of the students:
            
            let picturesElement = try blockOfContent.select("div[class='widget widget-gallery widget-gallery-gallery-6']")
            for pictureElement in picturesElement {
                let containerFirstSection = try pictureElement.select("div[data-ux='Container']").first()
                
                let firstImageDescription = try containerFirstSection?.select("h2").first()
                let firstImagedescriptionText = try firstImageDescription?.text()
                
                let firstPictureElement = try containerFirstSection?.select("img[data-ux='Image']").first()
                let firstPictureURL = try firstPictureElement?.attr("data-srclazy").dropFirst(2)
                
                var firstPicture = Picture()
                firstPicture.imageSourceURL = String(describing: firstPictureURL ?? "")
                firstPicture.imageDescription = firstImagedescriptionText ?? ""
                pictures.append(firstPicture)
            }
            
            // MARK: - Scraping the rest of pictures (cody transformation pictures):
            
            let transformationPictures = try blockOfContent.select("div[class='widget widget-about widget-about-about-3']").first()
            guard let allTransformations = try transformationPictures?.select("div[data-ux='GridCell']") else{
                completion(PictureScrapingError.selectError(reason: "Couldn't select grid cell"))
                return []
            }
            for transformationPicture in allTransformations{
                let imageUrlContainer = try transformationPicture.select("img[data-ux='Image']").first()
                let imageURL = try imageUrlContainer?.attr("data-srclazy").dropFirst(2)
                                
                var transformationPictureContent = Picture()
                transformationPictureContent.imageDescription = "Transformation"
                transformationPictureContent.imageSourceURL = String(describing: imageURL ?? "")
                pictures.append(transformationPictureContent)
            }
        }catch{
            completion(error)
        }
        
        return pictures
    }
    
}

struct Picture : Hashable{
    var imageDescription : String?
    var imageSourceURL : String?
}


enum PictureScrapingError : Error{
    case parseError(reason : String)
    case divError(reason : String)
    case selectError(reason : String)
}
