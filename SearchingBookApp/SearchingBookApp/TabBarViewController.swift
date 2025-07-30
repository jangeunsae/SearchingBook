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
        
        setViewControllers([searchViewController, cartViewController], animated: false)
        print(0)
        if let items = tabBar.items {
            print(1)
            
            items[0].title = "검색 탭"
            
            items[0].image = UIImage(systemName: "magnifyingglass")
            
            print(2)
            items[1].title = "담은 책 리스트 탭"
            items[1].image = UIImage(systemName: "cart")
        }

    }

}
