//
//  ReviesScraping.swift
//  UlusoyWorkout
//
//  Created by Mert Ziya on 23.02.2025.
//

import Foundation
import SwiftSoup
import WebKit

struct Review : Hashable{
    var imgURL : String?
    var name : String?
    var instaComment : String?
    var reviewShortText : String?
}
enum ReviewErrors: Error{
    case emptyError
}

class ReviewsScraping {
   
    static func scrapeReviews(renderedHTML : String , completion: @escaping (Result<[Review],Error>) -> () ){
        let reviews = extractReviews(html: renderedHTML) { error in
            if let error = error{
                completion(.failure(error))
                return
            }
        }
        if let reviews = reviews{
            completion(.success(reviews))
            return
        }else{
            completion(.failure(ReviewErrors.emptyError))
            return
        }
        
    }
    
    
    private static func extractReviews(html: String , completion: @escaping (Error?) -> () ) -> [Review]?{
        var reviews : [Review] = []
        
        do{
            let document = try SwiftSoup.parse(html)

            guard let allReviews = try? document.select("div[data-ux='Card']") else{return []}
            
            for review in allReviews{
            
                var reviewToAdd = Review()
                            
                // Get the person's image URL of the review:
                let image = try review.select("img[data-ux='ImageThumbnail']").first()
                let imageURL = try image?.attr("src") ?? "http://img1.wsimg.com/isteam/ip/3d69d790-2bbf-4204-ba9a-7ec36a7897af/2c812287-167c-4bec-b979-a90ced732ac2.jpg/:/cr=t:20.93%25,l:21.67%25,w:56.66%25,h:58.14%25/rs=w:100,h:100,cg:true,m" // Default Image URL
                let correctURL = String(describing: imageURL.dropFirst(2))
                
                // Get the person's short review:
                let shortReviewElement = try review.select("span[data-aid='USER_REVIEW_RENDERED']").first()
                let shortReviewText = try shortReviewElement?.text()
                let shortReviewCleaned = String(describing: shortReviewText?.filter{$0 != "\""}.dropLast(3) ?? "")
          
                //Get the person's name:
                let nameElement = try review.select("h4[data-aid='REVIEW_TITLE_RENDERED']").first()
                let nameText = try nameElement?.text()
                
                //Get the person's insta:
                let instaElement = try review.select("p[data-aid='REVIEWER_INFO_RENDERED']").first()
                let instaText = try instaElement?.text()
    
             
                reviewToAdd.imgURL = correctURL
                reviewToAdd.reviewShortText = shortReviewCleaned
                reviewToAdd.name = nameText
                reviewToAdd.instaComment = instaText
                
                reviews.append(reviewToAdd)
            }
            
        }catch{
            completion(error)
            return []
        }
        
        reviews = Array(Set(reviews))
        
        return reviews
    }
}




extension ProgramsVC : WKNavigationDelegate{
        

    func setupWebView(withURL : String , completion: @escaping (String?) -> Void) {
        webView = WKWebView()
        webView.navigationDelegate = self
        
        let url = URL(string: withURL)!
        webView.load(URLRequest(url: url))

        // Wait for page to finish loading before extracting HTML
        webView.navigationDelegate = self // Ensure delegate is set
        self.webView.evaluateJavaScript("document.readyState") { result, error in
            if result as? String == "complete" {
                self.findJSHTML(completion: completion)
                
            }
        }
    }

    // WKNavigationDelegate method to know when the page is fully loaded
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        findJSHTML { renderedHTML in
            self.completionHandler?(renderedHTML)
        }
    }
    
    func findJSHTML(completion: @escaping (String?) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.webView.evaluateJavaScript("document.documentElement.outerHTML.toString()") { result, error in
                if let error = error {
                    print("JavaScript execution error: \(error.localizedDescription)")
                    completion(nil) // Return nil on error
                } else if let html = result as? String {
                    
                    // MARK: - Check if JS-rendered HTML is loaded
                    if html.localizedStandardContains("data-ux=\"Card\"") {
                        self.webView.removeFromSuperview()
                        completion(html) // Return the final HTML content
                    } else {
                        self.findJSHTML(completion: completion) // Retry if the HTML is not fully loaded
                    }
                }
            }
        }
    }


}
