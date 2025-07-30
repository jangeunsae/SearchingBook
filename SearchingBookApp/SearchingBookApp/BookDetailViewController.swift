//
//  BookDetailViewController.swift
//  SearchingBookApp
//
//  Created by 장은새 on 7/30/25.
//

import UIKit
import SnapKit

class BookDetailViewController: UIViewController /*UITableViewDataSource, UITableViewDelegate*/ {

    let bookDetailTableView = UITableView()
    let detailTitleLabel = UILabel()
    let datailAuthorLabel = UILabel()
    let imageView = UIImageView()
    let detailPriceLabel = UILabel()
    let detailContentLabel = UILabel()
    let escapeButton = UIButton()
    let cartButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(bookDetailTableView)
        bookDetailTableView.register(SearchBookCell.self, forCellReuseIdentifier: "SearchBookCell")
        bookDetailTableView.register(RecentBookImageCell.self, forCellReuseIdentifier: "RecentBookImageCell")
//        bookDetailTableView.dataSource = self
//        bookDetailTableView.delegate = self
        bookDetailTableView.snp.makeConstraints { make in
        }
        view.addSubview(detailTitleLabel)
        view.addSubview(datailAuthorLabel)
        view.addSubview(imageView)
        view.addSubview(detailPriceLabel)
        view.addSubview(detailContentLabel)
        view.addSubview(escapeButton)
        escapeButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(20)
            make.leading.equalToSuperview().inset(20)
            escapeButton.setTitle("나가기", for: .normal)
            escapeButton.setTitleColor(.white, for: .normal)
            escapeButton.backgroundColor = .systemGray
            escapeButton.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .bold)
            escapeButton.layer.cornerRadius = 10
        }
        view.addSubview(cartButton)

    }
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        <#code#>
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        <#code#>
//    }
//    
//    
}
