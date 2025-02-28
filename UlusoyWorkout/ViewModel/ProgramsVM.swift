//
//  ProgramsVM.swift
//  UlusoyWorkout
//
//  Created by Mert Ziya on 22.02.2025.
//

import Foundation

protocol ProgramsVMDelegate : AnyObject{
    func isLoadingPackages(value: Bool)
    func didReturnErrorForPackages(with error: Error)
    func didLoadPackages(with packages: [ReadyPackage])
    
    func isLoadingCoachings(value : Bool)
    func didReturnErrorForCoaching(with error : Error)
    func didLoadCoachings(with coachings : [Coaching])
    
    func isLoadingReviews(value : Bool)
    func didReturnErrorForReview(with error : Error)
    func didLoadReviews(with reviews : [Review])
    
    func isLoadingPictures(value : Bool)
    func didReturnErrorForPictures(with error : Error)
    func didLoadPictures(with pictures : [Picture])
}

class ProgramsVM{
    weak var delegate : ProgramsVMDelegate?
    
    func fetchPackages(){
        delegate?.isLoadingPackages(value: true) // Start loading packages
        DispatchQueue.global().async {
            PackageScraping.scrapePackages { res in
                switch res{
                case .failure(let error):
                    self.delegate?.didReturnErrorForPackages(with: error)
                    
                case .success(let packages):
                    self.delegate?.didLoadPackages(with: packages)
                }
                self.delegate?.isLoadingPackages(value: false) // end loading packages
            }
        }
    }
    
    func fetchCoaching(){
        delegate?.isLoadingCoachings(value: true)
        DispatchQueue.global().async {
            CoachingScraping.scrapeCoachings { res in
                switch res{
                case .success(let coachings):
                    self.delegate?.didLoadCoachings(with: coachings)
                case .failure(let error):
                    self.delegate?.didReturnErrorForCoaching(with: error)
                }
            }
            self.delegate?.isLoadingCoachings(value: false)
        }
    }
    
    func fetchReviews(){
        delegate?.isLoadingReviews(value: true)

        let programsVC = ProgramsVC()
        
        programsVC.setupWebView(withURL: URLEndpoints.hazirPaketler) { html in
            guard let html = html else{return}
            DispatchQueue.global().async {
                ReviewsScraping.scrapeReviews(renderedHTML: html) { res in
                    switch res{
                    case .success(let reviews):
                        self.delegate?.didLoadReviews(with: reviews)
                    case .failure(let error):
                        self.delegate?.didReturnErrorForPackages(with: error)
                    }
                }
                self.delegate?.isLoadingReviews(value: false)
            }
        }
    }
    
    func fetchPictures(){
        delegate?.isLoadingPictures(value: true)
        
        DispatchQueue.global().async {
            PicturesScraping.scrapePictures { res in
                switch res{
                case .success(let pictures):
                    self.delegate?.didLoadPictures(with: pictures)
                    
                case .failure(let error):
                    self.delegate?.didReturnErrorForPictures(with: error)
                }
            }
            self.delegate?.isLoadingPictures(value: false)
        }
    }
    
}
