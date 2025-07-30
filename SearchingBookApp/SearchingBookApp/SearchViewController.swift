//
//  SearchViewController.swift
//  SearchingBookApp
//
//  Created by 장은새 on 7/28/25.
//

import UIKit
import SnapKit

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let searchTableView =  UITableView()
    let searchBar = UISearchBar()

    var recentBookImages: [UIImage] = ["person.circle", "person.circle.fill"]
        .compactMap { UIImage(systemName: $0) }
    
    var searchResultArray: [[String: Any]] = [
        ["title": "Swift 신", "author": "장은새", "price": 20000],
        ["title": "iOS 마스터", "author": "송명균", "price": 15000],
        ["title": "Xcode 왕초보", "author": "이돈혁", "price": 10000]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
//coredata이용 검색데이터값을 가져와야함 + 이미지 + 최근검색순 + 검색한 내용이 없으면 섹션이 나타나지않도록
        view.addSubview(searchBar)
        
        searchBar.placeholder = "이곳에 검색어를 입력하세요."
        searchBar.backgroundImage = UIImage()
        searchBar.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        view.addSubview(searchTableView)
        searchTableView.register(SearchBookCell.self, forCellReuseIdentifier: "SearchBookCell")
        searchTableView.register(RecentBookImageCell.self, forCellReuseIdentifier: "RecentBookImageCell")
        searchTableView.dataSource = self
        searchTableView.delegate = self
        
        searchTableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ?
        recentBookImages.count :
        searchResultArray.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "최근 본 책" : "검색 결과"
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }

        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        header.textLabel?.textColor = UIColor.black
        header.textLabel?.textAlignment = .left
        header.textLabel?.frame = CGRect(x: 20, y: 0, width: 200, height: 30)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecentBookImageCell", for: indexPath) as! RecentBookImageCell
            cell.configure(thumbnail: recentBookImages[indexPath.row])
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchBookCell", for: indexPath) as! SearchBookCell
            let book = searchResultArray[indexPath.row]
            cell.bookTitleLabel.text = book["title"] as? String
            cell.bookAuthorLabel.text = book["author"] as? String
            cell.bookPriceLabel.text = "\(book["price"] as? Int ?? 0)원"
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section == 1 else { return }
        
        let modalViewController = BookDetailViewController()
        modalViewController.modalPresentationStyle = .fullScreen
        present(modalViewController, animated: true, completion: nil)
    }
    
}

class SearchBookCell: UITableViewCell {
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
class RecentBookImageCell: UITableViewCell {
    let thumbnailImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        contentView.addSubview(thumbnailImageView)
        thumbnailImageView.contentMode = .scaleAspectFit
        thumbnailImageView.clipsToBounds = true
        thumbnailImageView.layer.cornerRadius = 25
        thumbnailImageView.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.top.bottom.equalToSuperview().inset(8)
            make.leading.equalToSuperview().offset(16)
        }
    }
    func configure(thumbnail: UIImage) {
        thumbnailImageView.image = thumbnail
    }
}
#Preview {
    SearchViewController()
}
