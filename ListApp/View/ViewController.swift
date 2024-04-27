//
//  ViewController.swift
//  ListApp
//
//  Created by PujaRaj on 26/04/24.
//

import UIKit
import SnapKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let tableView = UITableView()
    let viewModel = PostViewModel()
    var isFetchingData = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupViewModel()
        fetchData()
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "PostCell")
        
        // Apply SnapKit constraints
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    func setupViewModel() {
        viewModel.onDataUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.isFetchingData = false
            }
        }
    }
    
    func fetchData() {
        guard !isFetchingData else { return }
        isFetchingData = true
        viewModel.fetchData()
    }
    
    func fetchMoreDataIfNeeded() {
        let contentOffsetY = tableView.contentOffset.y
        let contentHeight = tableView.contentSize.height
        let screenHeight = tableView.frame.height
        let scrollPosition = contentOffsetY + screenHeight
        
        if scrollPosition > contentHeight - screenHeight { // Scrolled to the bottom
            viewModel.fetchMoreData()
        }
    }
  
    
    // Table view data source and delegate methods...
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.posts.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath)
        let post = viewModel.posts[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = "\(post.id): \(post.title)"
        return cell
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        fetchMoreDataIfNeeded()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPost = viewModel.posts[indexPath.row]
        let detailViewController = ListDetailViewController()
        detailViewController.selectedPost = selectedPost
        detailViewController.detailLabel.text = selectedPost.title
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

