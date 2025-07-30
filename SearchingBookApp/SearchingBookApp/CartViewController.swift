//
//  CartViewController.swift
//  SearchingBookApp
//
//  Created by 장은새 on 7/28/25.
//

import UIKit
import SnapKit

class CartViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let deleteAllButton = UIButton()
    let cartTitleLabel = UILabel()
    let addButton = UIButton()
    let cartTableview = UITableView()
    
    var cartAddArray: [[String: Any]] = [
        ["title": "Swift 신2", "author": "장은새", "price": 20000],
        ["title": "iOS 마스터2", "author": "송명균", "price": 15000],
        ["title": "Xcode 왕초보2", "author": "이돈혁", "price": 10000]
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        
        view.addSubview(deleteAllButton)
        deleteAllButton.setTitle("전체 삭제", for: .normal)
        deleteAllButton.setTitleColor(.gray, for: .normal)
        deleteAllButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        deleteAllButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(15)
            make.leading.equalToSuperview().offset(20)
        }
        
        view.addSubview(cartTitleLabel)
        cartTitleLabel.text = "담은 책"
        cartTitleLabel.font = .systemFont(ofSize: 25, weight: .bold)
        cartTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(15)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(addButton)
        addButton.setTitle("추가", for: .normal)
        addButton.setTitleColor(.green, for: .normal)
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        addButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(15)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        view.addSubview(cartTableview)
        cartTableview.dataSource = self
        cartTableview.delegate = self
        cartTableview.register(cartAddCell.self, forCellReuseIdentifier: "cartAddCell")
        
        cartTableview.snp.makeConstraints { make in
            make.top.equalTo(cartTitleLabel.snp.bottom).offset(25)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartAddArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cartAddCell", for: indexPath) as! cartAddCell
        let addBook = cartAddArray[indexPath.row]
        cell.bookTitleLabel.text = addBook["title"] as? String
        cell.bookAuthorLabel.text = addBook["author"] as? String
        cell.bookPriceLabel.text = "\(addBook["price"] as? Int ?? 0)원"
        return cell
    }
}
class cartAddCell: UITableViewCell {
    let bookTitleLabel = UILabel()
    let bookAuthorLabel = UILabel()
    let bookPriceLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        [bookTitleLabel, bookAuthorLabel, bookPriceLabel].forEach {
            contentView.addSubview($0)
            $0.font = .systemFont(ofSize: 15)
            $0.textColor = .black
        }
        
        bookTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(15)
            make.leading.trailing.equalTo(contentView).inset(16)
            make.centerX.equalToSuperview()
        }
        bookAuthorLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(15)
            make.leading.trailing.equalTo(bookTitleLabel).offset(150)
            make.centerX.equalToSuperview()
        }
        bookPriceLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(15)
            make.leading.trailing.equalTo(bookAuthorLabel).offset(150)
            make.centerX.equalToSuperview()
            
        }
    }
}

#Preview {
    CartViewController()
}
