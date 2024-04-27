//
//  ListDetailViewController.swift
//  ListApp
//
//  Created by PujaRaj on 26/04/24.
//

import Foundation
import UIKit
import SnapKit

class ListDetailViewController: UIViewController {
    let detailLabel = UILabel()
    
    var selectedPost: Post?
    let viewModel = PostViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                view.backgroundColor = .white
                setupDetailLabel()
                
                if let selectedPost = selectedPost {
                    computeAdditionalDetails(for: selectedPost)
                } else {
                    print("Error: Post is nil")
                }
    }
    
    func setupDetailLabel() {
        view.addSubview(detailLabel)
        detailLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    func computeAdditionalDetails(for post: Post) {
            let additionalDetails = viewModel.computeAdditionalDetails(for: post)
            detailLabel.text = additionalDetails
        }
}
