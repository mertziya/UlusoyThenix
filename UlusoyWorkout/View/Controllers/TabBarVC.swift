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

        // Do any additional setup after loading the view.
    }
    
    
    private func setupTabs(){
        
        // Tabbar elements:
        let homeVC = UINavigationController(rootViewController: HomeVC())
        homeVC.tabBarItem = UITabBarItem(title: NSLocalizedString("Home", comment: ""), image: UIImage(systemName: "house"), tag: 0)
        homeVC.tabBarItem.selectedImage = UIImage(systemName: "house.fill")
        
        let profileVC = UINavigationController(rootViewController: ProfileVC())
        profileVC.tabBarItem = UITabBarItem(title: NSLocalizedString("Profile", comment: ""), image: UIImage(systemName: "person"), tag: 1)
        profileVC.tabBarItem.selectedImage = UIImage(systemName: "person.fill")
        
        
        // Set the view controllers of the tabbar:
        self.viewControllers = [homeVC, profileVC]

       
        // Color of the selected & unselected items:
        self.tabBar.tintColor = .appGreen
        self.tabBar.unselectedItemTintColor = .appLightGray
        self.tabBar.backgroundColor = .appBlack.withAlphaComponent(0.9)
        
        // Configure the appearance of the tab bar
//        let appearance = UITabBarAppearance()
//        appearance.backgroundColor = .black
//        self.tabBar.standardAppearance = appearance
    }

}
