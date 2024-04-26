//
//  PostViewModel.swift
//  ListApp
//
//  Created by PujaRaj on 26/04/24.
//

import Foundation

class PostViewModel {
    var posts: [Post] = []
    var currentPage = 1
    let itemsPerPage = 10 
    var onDataUpdated: (() -> Void)?
    
    func fetchData(completion: @escaping (Bool) -> Void) {
            guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts?_page=\(currentPage)&_limit=\(itemsPerPage)") else {
                completion(false)
                return
            }
            
            URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                guard let self = self, let data = data, error == nil else {
                    completion(false)
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let newPosts = try decoder.decode([Post].self, from: data)
                    self.posts.append(contentsOf: newPosts)
                    completion(true)
                    self.onDataUpdated?() // Notify view controller
                } catch {
                    print("Error decoding JSON: \(error)")
                    completion(false)
                }
            }.resume()
        }
    
    func loadMoreDataIfNeeded(for indexPath: IndexPath) {
            let threshold = 5
            let nextPageThreshold = currentPage * itemsPerPage - threshold
            if indexPath.row >= nextPageThreshold {
                currentPage += 1
                fetchData { _ in  }
            }
        }
    
    
    func computeAdditionalDetails(for post: Post) -> String {
        // Simulate heavy computation using a delay
            DispatchQueue.global().async {
                // Start time
                let startTime = DispatchTime.now()
                
                // Simulate heavy computation by adding a delay
                Thread.sleep(forTimeInterval: 2.0) // Simulating 2 seconds of heavy computation
                
                // End time
                let endTime = DispatchTime.now()
                
                // Calculate the time taken for computation
                let nanoseconds = endTime.uptimeNanoseconds - startTime.uptimeNanoseconds
                let milliseconds = Double(nanoseconds) / 1_000_000
                
                // Log time taken for computation
                print("Time taken for computation: \(milliseconds) milliseconds")
            }
            
           
        return "Additional details id  \(post.id)"
    }
}
