//
//  ShopVC.swift
//  UlusoyWorkout
//
//  Created by Mert Ziya on 22.02.2025.
//

import UIKit
import WebKit

class ProgramsVC: UIViewController{
    // MARK: - UI Elements:
    let scrollView = UIScrollView()
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var coachingLabel: UILabel!
    @IBOutlet weak var coachingCollectionView: UICollectionView!
    
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
    let dummyImagesURL = [
        "https://img1.wsimg.com/isteam/ip/3d69d790-2bbf-4204-ba9a-7ec36a7897af/1-d0d5308.png/:/cr=t:0%25,l:0%25,w:100%25,h:100%25/rs=w:720,h:720,cg:true",
        "https://img1.wsimg.com/isteam/ip/3d69d790-2bbf-4204-ba9a-7ec36a7897af/3-e960d2d.png/:/cr=t:0%25,l:0%25,w:100%25,h:100%25/rs=w:720,h:720,cg:true",
        "https://img1.wsimg.com/isteam/ip/3d69d790-2bbf-4204-ba9a-7ec36a7897af/6-7b6f1bf.png/:/cr=t:0%25,l:0%25,w:100%25,h:100%25/rs=w:720,h:720,cg:true",
        "https://img1.wsimg.com/isteam/ip/3d69d790-2bbf-4204-ba9a-7ec36a7897af/12-d19d980.png/:/cr=t:0%25,l:0%25,w:100%25,h:100%25/rs=w:720,h:720,cg:true"
    ]
    
    
    // For scraping the Reviews:
    var webView: WKWebView!
    var renderedHTMLforReviews = ""
    var completionHandler: ((String?) -> Void)? // Store the completion handler


    // MARK: - Lifecylces:
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScrollView()
        setupCollectionViews()
        
        fetchAll()
        setupBinding()
    }
    
    
    deinit {
        webView?.navigationDelegate = nil
        webView?.uiDelegate = nil
        webView = nil
        completionHandler = nil
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
        coachingCollectionView.backgroundColor = .clear
        
        spacingToCenterCell = (view.bounds.width - CoachingCell.cellWidth) / 2
        coachingCollectionView.contentInset = UIEdgeInsets(top: 0, left: spacingToCenterCell, bottom: 0, right: spacingToCenterCell)
        
        coachingCollectionView.decelerationRate = UIScrollView.DecelerationRate(rawValue: 0.0) // No deceleration
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleCoachingCollectionViewScrolled(_:)))
        panGesture.delegate = self
        coachingCollectionView.addGestureRecognizer(panGesture)
    }
    
}


// MARK: - Collection View Configuartions:
extension ProgramsVC : UICollectionViewDelegate , UICollectionViewDataSource , UIGestureRecognizerDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView{
        case coachingCollectionView:
            return self.coachings.count
            
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView{
            
        case coachingCollectionView:
            guard let cell = coachingCollectionView.dequeueReusableCell(withReuseIdentifier: CoachingCell.identifier, for: indexPath) as? CoachingCell else{
                return UICollectionViewCell()
            }
            cell.configureCell(with: self.coachings[indexPath.row] , color: self.coachingColors[indexPath.row] , imageURL: dummyImagesURL[indexPath.row])
            
            return cell
            
        default:
            print("Collection View Cell Error")
            return UICollectionViewCell()
            
        }
    }
    
    @objc private func handleCoachingCollectionViewScrolled(_ gesture : UIPanGestureRecognizer){
        switch gesture.state{
        case .ended, .cancelled, .failed:
            navigateToNearestCell(scrollView: coachingCollectionView , gesture : gesture)
        default:
            break
        }
    }
    
    // 🔹 Ensure the collection view can still scroll naturally
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    

    
    func navigateToNearestCell(scrollView: UIScrollView, gesture: UIPanGestureRecognizer) {
        guard let collectionView = scrollView as? UICollectionView else { return }
        
        // Determine the center point of the visible area
        let centerPoint = CGPoint(
            x: collectionView.contentOffset.x + collectionView.bounds.width / 2,
            y: collectionView.bounds.height / 2
        )
        
        // Get the indexPath for the cell currently near the center
        guard let currentIndexPath = collectionView.indexPathForItem(at: centerPoint) else { return }
        
        // Get the horizontal velocity of the pan gesture
        let velocityX = gesture.velocity(in: scrollView).x
        var targetIndexPath = currentIndexPath

        // Determine the target cell based on velocity threshold (e.g., 1000 points/sec)
        if velocityX > 1000 {
            // Swiping to the right: go to the previous cell if available
            let previousItem = currentIndexPath.item - 1
            if previousItem >= 0 {
                targetIndexPath = IndexPath(item: previousItem, section: currentIndexPath.section)
            }
        } else if velocityX < -1000 {
            // Swiping to the left: go to the next cell if available
            let nextItem = currentIndexPath.item + 1
            if nextItem < collectionView.numberOfItems(inSection: currentIndexPath.section) {
                targetIndexPath = IndexPath(item: nextItem, section: currentIndexPath.section)
            }
        }
        
        
        // Delay setting alpha to ensure scrolling animation completes
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak collectionView] in
            guard let cell = collectionView?.cellForItem(at: targetIndexPath) else { return }
            
            // Reset all cells' alpha to default first (optional, for better visual effect)
            for visibleCell in collectionView?.visibleCells ?? [] {
                visibleCell.alpha = 0.3
            }
            // Highlight the selected cell by changing its alpha
            cell.alpha = 1.0 // Change this value as needed
        
        }
        
        // Scroll to the determined target cell
        collectionView.scrollToItem(at: targetIndexPath, at: .centeredHorizontally, animated: true)
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
