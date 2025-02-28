//
//  TabBarVC.swift
//  UlusoyWorkout
//
//  Created by Mert Ziya on 22.02.2025.
//

import UIKit

class TabBarVC: UITabBarController {


    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabs()
        setupFloatingButton()

        // Do any additional setup after loading the view.
    }
    
    
    private func setupTabs(){
    
        // Tabbar elements:
        let homeNavVC = UINavigationController(rootViewController: HomeVC())
        homeNavVC.tabBarItem = UITabBarItem(title: NSLocalizedString("Home", comment: ""), image: UIImage(systemName: "house"), tag: 0)
        homeNavVC.tabBarItem.selectedImage = UIImage(systemName: "house.fill")
        
        let parksNavVC = UINavigationController(rootViewController: ParksVC())
        parksNavVC.tabBarItem = UITabBarItem(title: NSLocalizedString("Parks", comment: ""), image: UIImage(systemName: "map"), tag: 1)
        parksNavVC.tabBarItem.selectedImage = UIImage(systemName: "map.fill")
        
        let addParksNavVC = UINavigationController(rootViewController: AddParksVC()) // Dummy tabbaritem for aligning tabbaritems.
        addParksNavVC.tabBarItem = UITabBarItem(title: "", image: UIImage(), tag: 2)
        
        let shopNavVC = UINavigationController(rootViewController: ProgramsVC())
        shopNavVC.tabBarItem = UITabBarItem(title: NSLocalizedString("Packages", comment: ""), image: UIImage(systemName: "cart"), tag: 3)
        shopNavVC.tabBarItem.selectedImage = UIImage(systemName: "cart.fill")
        shopNavVC.isNavigationBarHidden = true
        
        let profileNavVC = UINavigationController(rootViewController: ProfileVC())
        profileNavVC.tabBarItem = UITabBarItem(title: NSLocalizedString("Profile", comment: ""), image: UIImage(systemName: "person"), tag: 4)
        profileNavVC.tabBarItem.selectedImage = UIImage(systemName: "person.fill")
    
        
        // Set the view controllers of the tabbar:
        self.viewControllers = [homeNavVC , parksNavVC, addParksNavVC , shopNavVC , profileNavVC]

       
        // Color of the selected & unselected items:
        self.tabBar.tintColor = .selectedIcon
        self.tabBar.unselectedItemTintColor = .unselectedIcon
        self.tabBar.backgroundColor = .tabbar
        
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = .tabbar
        appearance.stackedLayoutAppearance.normal.iconColor = .unselectedIcon  // Set unselected icon color
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.unselectedIcon] // Set unselected text color
        appearance.stackedLayoutAppearance.selected.iconColor = .selectedIcon // Set selected icon color
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.selectedIcon] // Set selected text color

        // Apply appearance
        self.tabBar.standardAppearance = appearance

    }
    
    // MARK: - Floating Tab bar item Configurations:
    private let floatingButton: UIButton = {
        let button = UIButton(type: .custom)
        let configuration = UIImage.SymbolConfiguration(pointSize: 26.0 , weight: .light)
        button.setImage(UIImage(systemName: "plus" , withConfiguration: configuration), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .appGreen
        button.layer.cornerRadius = 64 / 2 // Makes it circular
        
        button.layer.shadowOffset = CGSize(width: 0, height: 0)
        button.layer.shadowColor = UIColor.appBlack.cgColor
        button.layer.shadowOpacity = 0.4
        button.layer.shadowRadius = 2
     
        return button
    }()
    
    private func setupFloatingButton() {
        floatingButton.addTarget(self, action: #selector(floatingButtonTapped), for: .touchUpInside)
        view.addSubview(floatingButton)

        // Positioning the button
        floatingButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            floatingButton.centerXAnchor.constraint(equalTo: tabBar.centerXAnchor),
            floatingButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -4),
            floatingButton.widthAnchor.constraint(equalToConstant: 64),
            floatingButton.heightAnchor.constraint(equalToConstant: 64)
        ])
    }

    @objc private func floatingButtonTapped() {
        let addParksVC = AddParksVC()
        let navVC = UINavigationController(rootViewController: addParksVC)
        present(navVC, animated: true)
    }

}
