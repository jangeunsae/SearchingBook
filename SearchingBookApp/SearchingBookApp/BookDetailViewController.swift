//
//  BookDetailViewController.swift
//  SearchingBookApp
//
//  Created by 장은새 on 7/30/25.
//

import UIKit

class BookDetailViewController: UIViewController {
    
    let bookDetailTableView = UITableView()
    let detailTitleLabel = UILabel()
    let datailAuthorLabel = UILabel()
    let imageView = UIImageView()
    let detailPriceLabel = UILabel()
    let detailContentLabel = UILabel()
    let escapeButton = UIButton()
    let cartButton = UIButton()

    override func viewDidLoad() {
        view.backgroundColor = .green
        super.viewDidLoad()
        view.addSubview(bookDetailTableView)
        view.addSubview(detailTitleLabel)
        view.addSubview(datailAuthorLabel)
        view.addSubview(imageView)
        view.addSubview(detailPriceLabel)
        view.addSubview(detailContentLabel)
        view.addSubview(escapeButton)
        view.addSubview(cartButton)

    }

}
