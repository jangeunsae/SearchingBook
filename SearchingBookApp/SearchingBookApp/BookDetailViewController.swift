//
//  BookDetailViewController.swift
//  SearchingBookApp
//
//  Created by 장은새 on 7/30/25.
//

import UIKit
import SnapKit
import CoreData

class BookDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let bookDetailTableView = UITableView()
    let detailTitleLabel = UILabel()
    let datailAuthorLabel = UILabel()
    let thumbnailImageView = UIImageView()
    let detailPriceLabel = UILabel()
    let detailContentLabel = UILabel()
    let escapeButton = UIButton()
    let cartButton = UIButton()
    var book: BooksData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(bookDetailTableView)
        
        bookDetailTableView.dataSource = self
        bookDetailTableView.delegate = self
        bookDetailTableView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(80)
        }
        escapeButton.setTitle("나가기", for: .normal)
        escapeButton.backgroundColor = .systemGray
        escapeButton.layer.cornerRadius = 10
        escapeButton.titleLabel?.font = .systemFont(ofSize: 20)
        escapeButton.addTarget(self, action: #selector(dismissModal), for: .touchUpInside)
        
        cartButton.setTitle("담기", for: .normal)
        cartButton.backgroundColor = .systemBlue
        cartButton.layer.cornerRadius = 10
        cartButton.titleLabel?.font = .systemFont(ofSize: 20)
        cartButton.addTarget(self, action: #selector(addToCart), for: .touchUpInside)
        
        
        let buttonStackView = UIStackView(arrangedSubviews: [escapeButton, cartButton])
        view.addSubview(buttonStackView)
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 20
        buttonStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        
        guard let searchedBook = book else { return cell }
        
        switch indexPath.row {
        case 0:
            detailTitleLabel.text = searchedBook.title
            detailTitleLabel.font = .boldSystemFont(ofSize: 20)
            detailTitleLabel.textAlignment = .center
            cell.contentView.addSubview(detailTitleLabel)
            detailTitleLabel.snp.makeConstraints { make in make.edges.equalToSuperview().inset(16) }
        case 1:
            datailAuthorLabel.text = searchedBook.authors?.joined(separator: ", ") ?? ""
            datailAuthorLabel.textColor = .gray
            datailAuthorLabel.textAlignment = .center
            cell.contentView.addSubview(datailAuthorLabel)
            datailAuthorLabel.snp.makeConstraints { make in make.edges.equalToSuperview().inset(16) }
        case 2:
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            cell.contentView.addSubview(imageView)
            imageView.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(16)
                make.height.equalTo(180)
            }
            
            if let url = URL(string: searchedBook.thumbnail ?? "") {
                URLSession.shared.dataTask(with: url) { data, response, error in
                    guard let data = data, let image = UIImage(data: data) else { return }
                    DispatchQueue.main.async {
                        imageView.image = image
                    }
                }.resume()
            }
        case 3:
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            let formattedPrice = numberFormatter.string(from: NSNumber(value: searchedBook.salePrice ?? 0)) ?? "0"
            detailPriceLabel.text = "\(formattedPrice)원"
            detailPriceLabel.font = .boldSystemFont(ofSize: 17)
            detailPriceLabel.textAlignment = .center
            cell.contentView.addSubview(detailPriceLabel)
            detailPriceLabel.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(16)
            }
        case 4:
            detailContentLabel.text = searchedBook.contents
            detailContentLabel.numberOfLines = 0
            detailContentLabel.font = .systemFont(ofSize: 14)
            cell.contentView.addSubview(detailContentLabel)
            detailContentLabel.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(16)
            }
        default:
            break
        }
        return cell
    }
    
    @objc func dismissModal() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func addToCart() {
        guard let searchedBook = book else { return }
        if checkCartTitleExists(searchedBook.title) {
            showAlert()
        } else {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let bookToSave = Book(context: context)
            bookToSave.title = searchedBook.title
            bookToSave.author = searchedBook.authors?.joined(separator: ", ") ?? ""
            bookToSave.salePrice = Int64(searchedBook.salePrice ?? 0 )
            bookToSave.thumbnail = searchedBook.thumbnail
            bookToSave.contents = searchedBook.contents
            do {
                try context.save()
                dismissModal()
                print("저장 성공")
            } catch {
                print("저장 실패: \(error)")
            }
        }
    }
    func checkCartTitleExists(_ title: String?) -> Bool {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName:"Book")
        var cartAddArray: [[String: Any]] = []
        do {
            let books = try context.fetch(fetchRequest)
            cartAddArray = books.map { book in
                var dict: [String: Any] = [:]
                dict["title"] = book.value(forKey: "title") as? String ?? ""
                dict["author"] = book.value(forKey: "author") as? String ?? ""
                dict["price"] = book.value(forKey: "salePrice") as? Int ?? 0
                return dict
            }
            for cartAddedBook in cartAddArray {
                if cartAddedBook["title"] as? String == title {
                    return true
                }
            }
            return false
        } catch {
            print("데이터 로딩 실패: \(error)")
        }
        return false
    }
    
    func showAlert() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "오류 메세지", message: "이미 동일한 책이 존재합니다.", preferredStyle: .alert)
            let sucess = UIAlertAction(title: "확인", style: .default)
            alert.addAction(sucess)
            self.present(alert, animated: true)
        }
    }
}
