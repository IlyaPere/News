//
//  NewsTableViewCell.swift
//  NewsApiTask
//
//  Created by Илья Петров on 31.10.2021.
//

import UIKit

class NewsTableViewCellViewModel {
    

    let title: String
    let subTitle: String
    let imageURL: URL?
    var imageData: Data? = nil
    
    init(title: String, subTitle: String, imageURL: URL?) {
        self.title = title
        self.subTitle = subTitle
        self.imageURL = imageURL
    }
}

class NewsTableViewCell: UITableViewCell {
    
    static let identifaer = "NewsTableViewCell"
    
    static let height: CGFloat = 140
    
    var newsImageView: UIImageView!

    
    var newsTitleLable: UILabel!
    
    var newsSubTitle: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        makeNewsTitleLable()
        makeNewsSubTitle()
        makeImageViewFoto()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        newsTitleLable.frame = CGRect(x: 10, y: 0, width: contentView.frame.size.width - 120, height: contentView.frame.size.height / 2)
        newsSubTitle.frame = CGRect(x: 10, y: newsTitleLable.frame.size.height + 5, width: contentView.frame.size.width - 120, height: contentView.frame.size.height / 2)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        newsSubTitle.text = nil
        newsSubTitle.text = nil
        newsImageView.image = nil

    }
    
    
    
    func makeNewsTitleLable() {
        
        let rect = CGRect.init(x: 30, y: 30, width: 100, height: 30)
        newsTitleLable = UILabel.init(frame: rect)
        newsTitleLable.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        newsTitleLable.numberOfLines = 0
        self.contentView.addSubview(newsTitleLable)
    }
    
    func makeNewsSubTitle() {
        
        let rect = CGRect.init(x: 30, y: 60, width: 100, height: 30)
        newsSubTitle = UILabel.init(frame: rect)
        newsSubTitle.font = UIFont.systemFont(ofSize: 17, weight: .light)
        
        newsSubTitle.numberOfLines = 0
        self.contentView.addSubview(newsSubTitle)
    }
    
    func makeImageViewFoto() {
        let size = CGSize.init(width: 120, height: 120)
        let rect = CGRect.init(origin: .zero, size: size)
        newsImageView = UIImageView.init(frame: rect)
        newsImageView.backgroundColor = .blue
        newsImageView.frame.origin.x = 310
        newsImageView.layer.cornerRadius = 7
        newsImageView.center.y = NewsTableViewCell.height / 2
        self.contentView.addSubview(newsImageView)
    }
    
    func configere(with viewModel: NewsTableViewCellViewModel) {
        newsTitleLable.text = viewModel.title
        newsSubTitle.text = viewModel.subTitle
        
        if let data = viewModel.imageData {
             newsImageView.image = UIImage.init(data: data)
        }
        else if let url = viewModel.imageURL {
            
            //fetch
            URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                guard let data = data, error == nil else {
                     return
                }
                viewModel.imageData = data
                DispatchQueue.main.async {
                    self?.newsImageView.image = UIImage.init(data: data)
                }
                
            }.resume()
            
        }
    }
}
