//
//  SearchViewController.swift
//  SearchingBookApp
//
//  Created by 장은새 on 7/28/25.
//

import UIKit
import SnapKit

struct BooksDataResponse: Codable {
    let documents: [BooksData]
}

struct BooksData: Codable {
    let title: String?
    let contents: String?
    let salePrice: Int?
    let authors: [String]?
    let thumbnail: String?
    
    enum CodingKeys: String, CodingKey {
        case title
        case contents
        case salePrice = "sale_price"
        case authors
        case thumbnail
    }
}

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    let searchTableView =  UITableView()
    let searchBar = UISearchBar()

    var recentBookImages: [UIImage] = ["person.circle", "person.circle.fill"]
        .compactMap { UIImage(systemName: $0) }
    
    var searchResultArray: [BooksData] = []
    var savedBooks: [BooksData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        searchBar.delegate = self
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
        savedBooks.count :
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchBookCell", for: indexPath) as! SearchBookCell
            let book = savedBooks[indexPath.row]
            cell.bookTitleLabel.text = book.title ?? ""
            cell.bookAuthorLabel.text = book.authors?.joined(separator: ", ") ?? ""
            if let price = book.salePrice {
                let formatter = NumberFormatter()
                formatter.numberStyle = .decimal
                cell.bookPriceLabel.text = "\(formatter.string(from: NSNumber(value: price)) ?? "")원"
            } else {
                cell.bookPriceLabel.text = ""
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchBookCell", for: indexPath) as! SearchBookCell
            let book = searchResultArray[indexPath.row]
            cell.bookTitleLabel.text = book.title ?? ""
            cell.bookAuthorLabel.text = book.authors?.joined(separator: ", ") ?? ""
            if let price = book.salePrice {
                let formatter = NumberFormatter()
                formatter.numberStyle = .decimal
                cell.bookPriceLabel.text = "\(formatter.string(from: NSNumber(value: price)) ?? "")원"
            } else {
                cell.bookPriceLabel.text = ""
            }
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            handleSearchResultSelection(at: indexPath)
        } else if indexPath.section == 0 {
            handleSavedBookSelection(at: indexPath)
        }
    }
    
    private func handleSearchResultSelection(at indexPath: IndexPath) {
        let selectedBook = searchResultArray[indexPath.row]
        savedBooks.append(selectedBook)
        searchResultArray = []
        searchTableView.reloadData()
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    private func handleSavedBookSelection(at indexPath: IndexPath) {
        let selectedBook = savedBooks[indexPath.row]
        let modalViewController = BookDetailViewController()
        modalViewController.book = selectedBook
        modalViewController.modalPresentationStyle = .fullScreen
        present(modalViewController, animated: true, completion: nil)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            searchResultArray = []
            searchTableView.reloadData()
            return
        }
        fetchBooks(with: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let keyword = searchBar.text else { return }
        fetchBooks(with: keyword)
        searchBar.resignFirstResponder()
    }
    
    func fetchBooks(with keyword: String) {
        let query = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let urlString = "https://dapi.kakao.com/v3/search/book?query=\(query ?? "")&target=title"
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("KakaoAK 1053399f69b04ae09fb1272ae4cab4b3", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self, let data = data, error == nil else { return }
            do {
                let decoded = try JSONDecoder().decode(BooksDataResponse.self, from: data)
                DispatchQueue.main.async {
                    self.searchResultArray = decoded.documents
                    self.searchTableView.reloadData()
                }
            } catch {
                print("디코딩 실패:", error)
            }
        }.resume()
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
