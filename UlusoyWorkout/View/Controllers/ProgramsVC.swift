//
//  ShopVC.swift
//  UlusoyWorkout
//
//  Created by Mert Ziya on 22.02.2025.
//

import UIKit
import WebKit
import FSPagerView

class ProgramsVC: UIViewController{
    // MARK: - UI Elements:
    let scrollView = UIScrollView()
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var coachingLabel: UILabel!
    @IBOutlet weak var coachingCollectionView: FSPagerView!
    
    @IBOutlet weak var packagesLabel: UILabel!
    @IBOutlet weak var packagesCollectionView: UICollectionView!
    
    @IBOutlet weak var resultsLabel: UILabel!
    @IBOutlet weak var resultPicturesCollectionView: UICollectionView!
    @IBOutlet weak var resultReviewsCollectionView: UICollectionView!
    
    @IBOutlet weak var SSSLabel: UILabel!
    @IBOutlet weak var SSSCollectionView: UICollectionView!
    
    @IBOutlet weak var redeemPolicyLabel: UILabel!
    @IBOutlet weak var redeemPolicyContent: UILabel!
    
    
    // MARK: - Properties:
    private var programsVM = ProgramsVM()
    private var coachings : [Coaching] = [] {
        didSet{
            DispatchQueue.main.async {
                self.coachingCollectionView.reloadData()
            }
        }
    }
    private var coachingColors : [UIColor] = [.appBronze, .appSilver , .appGolden, .appDiamond]
    var spacingToCenterCell : CGFloat = 0.0
    
   


    // MARK: - Lifecylces:
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScrollView()
        setupCollectionViews()
        
        fetchAll()
        setupBinding()
    }
    
    
  
}


//MARK: - UI Configurations:
extension ProgramsVC{
    
    private func setupScrollView(){
        loadContentView()

        view.backgroundColor = .appLightGray
        scrollView.backgroundColor = .appLightGray
        contentView.backgroundColor = .appLightGray

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor), // For the vertical scrolling.
            
           
        ])
        
        
        // Set content height to enable scrolling
        let contentHeight: CGFloat = 2000
        contentView.heightAnchor.constraint(equalToConstant: contentHeight).isActive = true
        scrollView.showsVerticalScrollIndicator = false
        
    }
    
    private func loadContentView() {
        let nib = UINib(nibName: "ProgramsContentView", bundle: nil)
        if let loadedView = nib.instantiate(withOwner: self, options: nil).first as? UIView {
            contentView = loadedView
            contentView.translatesAutoresizingMaskIntoConstraints = false
        } else {
            fatalError("Could not load ContentView from XIB")
        }
    }
    
    private func setupCollectionViews(){
        coachingCollectionView.delegate = self
        coachingCollectionView.dataSource = self
        coachingCollectionView.register(UINib(nibName: CoachingCell.nibName, bundle: nil), forCellWithReuseIdentifier: CoachingCell.identifier)
        
        // ✅ Configure layout
        coachingCollectionView.backgroundColor = .clear
        coachingCollectionView.itemSize = CGSize(width: 290, height: 448)  // Set item size
        coachingCollectionView.interitemSpacing = 10  // Space between items
        coachingCollectionView.transformer = FSPagerViewTransformer(type: .linear)  // Standard collection view style
        coachingCollectionView.isInfinite = true  // Enable infinite scrolling
        coachingCollectionView.layer.shadowOpacity = 0.0
        
        coachingCollectionView.decelerationDistance = 1
    }
    
    
    
}


// MARK: - Collection View Configuartions:
extension ProgramsVC : FSPagerViewDelegate , FSPagerViewDataSource {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        switch pagerView{
        case coachingCollectionView:
            return self.coachings.count
            
        default:
            return 0
        }
    }
    
  
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        switch pagerView{
            
        case coachingCollectionView:
            guard let cell = coachingCollectionView.dequeueReusableCell(withReuseIdentifier: CoachingCell.identifier, at: index) as? CoachingCell else{
                return FSPagerViewCell()
            }
            
            cell.configureCell(with: self.coachings[index] , color: self.coachingColors[index])
            
            return cell
            
        default:
            print("Collection View Cell Error")
            return FSPagerViewCell()
        }
        
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        let webVC = WebVC(webURL: self.coachings[index].shopierURL ?? "")
        webVC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(webVC, animated: true)
    }
    
}




// MARK: - UI Bindings:
extension ProgramsVC : ProgramsVMDelegate{
    
    private func setupBinding(){ programsVM.delegate = self }
    private func fetchAll(){
        programsVM.fetchCoaching()
        programsVM.fetchPackages()
        programsVM.fetchPictures()
        programsVM.fetchReviews()
    }
    
    // MARK: - Coaching Binding:
    func isLoadingCoachings(value: Bool) {
        print(value)
    }
    
    func didReturnErrorForCoaching(with error: any Error) {
        print(error.localizedDescription)
    }
    
    func didLoadCoachings(with coachings: [Coaching]) {
        self.coachings = coachings
    }
    
    
    // MARK: - Packages Binding:
    func isLoadingPackages(value: Bool) {
        print(value)
    }
    
    func didReturnErrorForPackages(with error: any Error) {
        print(error.localizedDescription)
    }
    
    func didLoadPackages(with packages: [ReadyPackage]) {
//        print(packages)
    }
    
    
    // MARK: - Reviews Binding:
    func isLoadingReviews(value: Bool) {
        print(value)
    }
    
    func didReturnErrorForReview(with error: any Error) {
        print(error.localizedDescription)
    }
    
    func didLoadReviews(with reviews: [Review]) {
//        print(reviews)
    }
    
    
    // MARK: - Pictures Binding:
    func isLoadingPictures(value: Bool) {
        print(value)
    }
    
    func didReturnErrorForPictures(with error: any Error) {
        print(error.localizedDescription)
    }
    
    func didLoadPictures(with pictures: [Picture]) {
//        print(pictures)
    }
}
