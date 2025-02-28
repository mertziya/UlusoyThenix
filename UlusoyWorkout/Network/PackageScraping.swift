//
//  PackagesScrapingService.swift
//  UlusoyWorkout
//
//  Created by Mert Ziya on 22.02.2025.
//

import Foundation
import Alamofire
import SwiftSoup

enum PackageScrapingErrors : Error{
    case parseError(reason : String)
    case divError(reason : String)
    case selectError(reason : String)
}
struct ReadyPackage : Decodable{
    var imageURL : String?
    var packageDescription : String?
    var price : String?
    var decisions: [String]?
    var url : String?
}


class PackageScraping{
    
    // MARK: - Fetches the Packages from the Sercan Ulusoy Website:
    static func scrapePackages(completion: @escaping (Result<[ReadyPackage],Error>) -> () ){
        let url = URLEndpoints.hazirPaketler
        
        AF.request(url).responseString { response in
            switch response.result{
            case .success(let html):
                let packages = extractPackagesData(html: html) { error in
                    if let error = error{
                        completion(.failure(error))
                        return
                    }
                }
                completion(.success(packages))
                
            case .failure(let error):
                completion(.failure(error))
                return
            }
        }
    }
    
   
    // MARK: - Package Scraping Logic:
    private static func extractPackagesData(html : String , completion : @escaping (Error?) -> ()) -> [ReadyPackage]{
        var packages : [ReadyPackage] = []

        do{
            guard let document = try? SwiftSoup.parse(html) else{
                completion(PackageScrapingErrors.parseError(reason: "error while parsing html"))
                return []
            }
            

            if let divContent = try document.select("div[data-aid='MENU_ITEM_GRID_0']").first() {
                
                guard let gridCells = try? divContent.select("div[data-ux='GridCell']") else{
                    completion(PackageScrapingErrors.selectError(reason: "cannot select 'div[data-ux='GridCell']'"))
                    return []
                }
                
                for gridCell in gridCells {
                    var package = ReadyPackage()
                    
                    // Get the image url of the package:
                    if let imageElement = try gridCell.select("img[data-ux='Image']").first(), let imageURL = try? imageElement.attr("src") {
                        let correctImageURL = String(describing: imageURL.dropFirst(2))
                        package.imageURL = correctImageURL
                    } else{ completion(PackageScrapingErrors.selectError(reason: "'img[data-ux='Image']' NOT FOUND")) ; return []}
                    
                    // Get the shopier URL of the Package:
                    if let urlElement = try gridCell.select("a[data-ux='Element']").first() , let shopierURL = try? urlElement.attr("href"){
                        package.url = String(describing: shopierURL)
                    } else{ completion(PackageScrapingErrors.selectError(reason: "'a[data-ux='Element']' NOT FOUND")) ; return []}
                    
                    // get the desctiption of the package:
                    if let descriptionElement = try gridCell.select("h4[role='heading']").first() {
                        let description = try descriptionElement.text() // Get the visible text
                        package.packageDescription = description
                    } else{ completion(PackageScrapingErrors.selectError(reason: "'h4[role='heading']' NOT FOUND")) ; return []}
                    // get the price of package:
                    if let priceElement = try gridCell.select("div[data-ux='Price']").first() {
                        let price = try priceElement.text() // Get the visible text
                        package.price = price
                    } else{ completion(PackageScrapingErrors.selectError(reason: "'div[data-ux='Price']' NOT FOUND")) ; return []}
                    // get the descisions of the package:
                    if let decisionElement = try gridCell.select("ul").first(){
                        var decisionItems : [String] = []
                        let listItems = try decisionElement.select("li")
                        for listItem in listItems{
                            decisionItems.append(String(describing: listItem))
                        }
                        package.decisions = decisionItems
                    } else{ completion(PackageScrapingErrors.selectError(reason: "'ul' NOT FOUND")) ; return []}
                    
                    
                    packages.append(package)
                }
    
            } else {
                completion(PackageScrapingErrors.divError(reason: "no div with 'div[data-aid='MENU_ITEM_GRID_0']'  is found"))
            }
            
        }catch{
            print("SwiftSoup Error: \(error.localizedDescription)")
        }
        
        return packages
    }
    
}
