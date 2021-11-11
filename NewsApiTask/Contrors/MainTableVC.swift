//
//  MainTableVC.swift
//  NewsApiTask
//
//  Created by Илья Петров on 31.10.2021.
//

import UIKit
import SafariServices

class MainTableVC: UITableViewController, UISearchBarDelegate {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setTitle()
       
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: "NewsTableViewCell")
        crateSerchBar()
        
        
     
       
        APICaller.shared.setTopStroires { [weak self] result in
            switch result {
            case .success(let articles):
                self?.articles = articles
                self?.viewModels = articles.compactMap({
                    NewsTableViewCellViewModel(title: $0.title, subTitle: $0.description, imageURL: URL.init(string: $0.urlToImage))
                    
                    
                })
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    self?.searcVC.dismiss(animated: true, completion: nil )
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    
    private var articles = [Articele]()
    
    private var viewModels = [NewsTableViewCellViewModel]()
    
    
    private let searcVC = UISearchController(searchResultsController: nil)

    
    override func viewDidLayoutSubviews() {
        
    }
    
    private func crateSerchBar() {
        navigationItem.searchController = searcVC
        searcVC.searchBar.delegate = self
        
      
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
       
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifaer, for: indexPath) as? NewsTableViewCell else {
            fatalError()
        }
        
        cell.configere(with: viewModels[indexPath.row])
        

        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let article = articles[indexPath.row]
        
        guard let url = URL(string: article.url ?? "") else {
            return
        }
        
        let vc = SFSafariViewController.init(url: url)
        present(vc, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return NewsTableViewCell.height
    }
    
    
}


//MARK: -Set Navigation Bar-

extension MainTableVC {
    
    func setTitle() {
        navigationItem.title = "News"
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else {
            return
        }
        APICaller.shared.search(with: text) { [weak self] result in
            switch result {
            case .success(let articles):
                self?.articles = articles
                self?.viewModels = articles.compactMap({
                    NewsTableViewCellViewModel(title: $0.title, subTitle: $0.description, imageURL: URL.init(string: $0.urlToImage))
                    
                    
                })
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
       
    }
}






