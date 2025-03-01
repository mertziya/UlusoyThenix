//
//  ImageLoader.swift
//  UlusoyWorkout
//
//  Created by Mert Ziya on 27.02.2025.
//

import Foundation
import UIKit

class ImageLoader{
    
    static func getImage(from urlString: String?, completion: @escaping (UIImage?) -> Void) {
        guard var formattedURLString = urlString else{return}
        
        // Ensure the URL has "https://" prefix if missing
        if !formattedURLString.lowercased().hasPrefix("http") {
            formattedURLString = "https://" + formattedURLString
        }
                
        guard let url = URL(string: formattedURLString) else {
            print("Invalid URL: \(formattedURLString)")
            completion(nil)
            return
        }
        
        let session = URLSession.shared
        session.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Image Fetch Error: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            if let data = data, let image = UIImage(data: data) {
                completion(image)
            } else {
                print("Invalid image data")
                completion(nil)
            }
        }.resume()
    }
    
}
