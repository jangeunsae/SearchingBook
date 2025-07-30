//
//  TabBarViewController.swift
//  SearchingBookApp
//
//  Created by 장은새 on 7/28/25.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let searchViewController = SearchViewController()
        let cartViewController = CartViewController()
        
        searchViewController.tabBarItem.image = UIImage.init(systemName: "magnifyingglass")
        cartViewController.tabBarItem.image = UIImage.init(systemName: "cart")
        
        searchViewController.navigationItem.largeTitleDisplayMode = .always
        cartViewController.navigationItem.largeTitleDisplayMode = .always
        
        let navigationSearch = UINavigationController(rootViewController: searchViewController)
        let navigationCart = UINavigationController(rootViewController: cartViewController)
        
        navigationSearch.navigationBar.prefersLargeTitles = true
        navigationCart.navigationBar.prefersLargeTitles = true
        
        setViewControllers([navigationSearch, navigationCart], animated: false)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
