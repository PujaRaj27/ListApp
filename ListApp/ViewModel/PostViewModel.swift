//
//  PostViewModel.swift
//  ListApp
//
//  Created by PujaRaj on 26/04/24.
//

import Foundation

class PostViewModel {
    var posts: [Post] = []
    var onDataUpdated: (() -> Void)?
    var initialData: [Post] = []
    var isFetchingData = false
    
    func fetchData() {
        guard !isFetchingData else { return }
        isFetchingData = true
        
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self, let data = data, error == nil else {
                self?.isFetchingData = false
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let newPosts = try decoder.decode([Post].self, from: data)
                self.posts = newPosts
                DispatchQueue.main.async {
                    self.isFetchingData = false
                    self.onDataUpdated?()
                }
            } catch {
                print("Error decoding JSON: \(error)")
                self.isFetchingData = false
            }
        }.resume()
    }
    
    func fetchMoreData() {
        print("Call after initial data")
        guard !isFetchingData else { return }
        isFetchingData = true
        
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self, let data = data, error == nil else {
                self?.isFetchingData = false
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let newPosts = try decoder.decode([Post].self, from: data)
                self.posts.append(contentsOf: newPosts)
                DispatchQueue.main.async {
                    self.isFetchingData = false
                    self.onDataUpdated?()
                    print("Call after initial data")
                }
            } catch {
                print("Error decoding JSON: \(error)")
                self.isFetchingData = false
            }
        }.resume()
    }
    
    
    
    
    func computeAdditionalDetails(for post: Post) -> String {
        // Simulate heavy computation using a delay
        DispatchQueue.global().async {
            // Start time
            let startTime = DispatchTime.now()
            
            // Simulate heavy computation by adding a 2 seconds of  delay
            Thread.sleep(forTimeInterval: 2.0)
            
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
