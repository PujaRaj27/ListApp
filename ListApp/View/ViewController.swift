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
                }
            }
        }
    
    func fetchData() {
        viewModel.fetchData { success in
            if success {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } else {
                print("Error while loading data")
            }
        }
    }
    
    // Table view data source and delegate methods...
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return viewModel.posts.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath)
            let post = viewModel.posts[indexPath.row]
            cell.textLabel?.text = "\(post.id): \(post.title)"
            viewModel.loadMoreDataIfNeeded(for: indexPath)
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let selectedPost = viewModel.posts[indexPath.row]
            let detailViewController = ListDetailViewController()
            detailViewController.selectedPost = selectedPost
            detailViewController.detailLabel.text = selectedPost.title
            navigationController?.pushViewController(detailViewController, animated: true)
        }
}

