//
//  CartViewController.swift
//  SearchingBookApp
//
//  Created by 장은새 on 7/28/25.
//

import UIKit
import SnapKit
import CoreData

class CartViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let deleteAllButton = UIButton()
    let cartTitleLabel = UILabel()
    let addButton = UIButton()
    let cartTableview = UITableView()
    
    var cartAddArray: [[String: Any]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchBooksData()
    }
    
    func fetchBooksData() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName:"Book")
        do {
            let books = try context.fetch(fetchRequest)
            cartAddArray = books.map { book in
                var dict: [String: Any] = [:]
                dict["title"] = book.value(forKey: "title") as? String ?? ""
                dict["author"] = book.value(forKey: "author") as? String ?? ""
                dict["price"] = book.value(forKey: "salePrice") as? Int ?? 0
                return dict
            }
            cartTableview.reloadData()
        } catch {
            print("데이터 로딩 실패: \(error)")
        }
    }
    
    @objc func deleteAllBooks() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Book")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
            cartAddArray.removeAll()
            cartTableview.reloadData()
        } catch {
        }
    }
    @objc func addButtonTapped(_ sender: UIButton) {
        let moveViewController = TabBarViewController()
        moveViewController.modalPresentationStyle = .fullScreen
        present(moveViewController, animated: true, completion: nil)
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
        deleteAllButton.addTarget(self, action: #selector(deleteAllBooks), for: .touchUpInside)
        
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
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        
        view.addSubview(cartTableview)
        cartTableview.dataSource = self
        cartTableview.delegate = self
        cartTableview.register(cartAddCell.self, forCellReuseIdentifier: "cartAddCell")
        
        cartTableview.snp.makeConstraints { make in
            make.top.equalTo(cartTitleLabel.snp.bottom).offset(25)
            make.leading.trailing.bottom.equalToSuperview()
            make.bottom.equalToSuperview().inset(100)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartAddArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cartAddCell", for: indexPath) as! cartAddCell
        let addBook = cartAddArray[indexPath.row]
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let price = addBook["price"] as? Int ?? 0
        let formattedCartPrice = numberFormatter.string(from: NSNumber(value: price)) ?? "0"
        cell.bookTitleLabel.text = addBook["title"] as? String
        cell.bookAuthorLabel.text = addBook["author"] as? String
        cell.bookPriceLabel.text = "\(formattedCartPrice)원"
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
            make.leading.equalTo(contentView).inset(15)
            make.centerY.equalToSuperview()
        }
        bookTitleLabel.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 800), for: .horizontal)
        
        bookAuthorLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(15)
            make.leading.equalTo(bookTitleLabel.snp.trailing).offset(10)
            make.centerY.equalToSuperview()
        }
        bookAuthorLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 200), for: .horizontal)
        
        bookPriceLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(15)
            make.leading.equalTo(bookAuthorLabel.snp.trailing).offset(10)
            make.trailing.equalTo(contentView).inset(15)
            make.centerY.equalToSuperview()
        }
        bookPriceLabel.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 800), for: .horizontal)
    }
}
