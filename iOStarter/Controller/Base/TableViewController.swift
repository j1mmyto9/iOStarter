//
//  TableViewController.swift
//  iOStarter
//
//  Created by Macintosh on 07/04/22.
//  
//
//  This file was generated by Project Xcode Templates
//  Created by Wahyu Ady Prasetyo,
//  Source: https://github.com/dypme/iOStarter
//

import UIKit

class TableViewController: ViewController {
    
    @IBOutlet weak private(set) var tableView: UITableView!
    
    private(set) var refreshControl = UIRefreshControl()
    
    override func setupMethod() {
        super.setupMethod()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        refreshControl.addTarget(self, action: #selector(fetch), for: .valueChanged)
    }
    
    override func setupView() {
        super.setupView()
        
        tableView.addSubview(refreshControl)
    }
    
    @objc override func fetch() {
        fetch(isLoadMore: false)
    }
    
    /// Fetch list data
    @objc func fetch(isLoadMore: Bool = false) {
        
    }
    
}

extension TableViewController {
    /// Indicate that list can load more
    @objc open var isAllowLoadMore: Bool {
        false
    }
    
    /// Distance from bottom to trigger load more
    @objc open var loadMoreDistance: CGFloat {
        40
    }
}

extension TableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fatalError("Number items method not defined")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        fatalError("Cell tableview not set")
    }
}

extension TableViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        let bounds = scrollView.bounds
        let size = scrollView.contentSize
        let inset = scrollView.contentInset
        let y = offset.y + bounds.size.height - inset.bottom
        let h = size.height
        if y > (h + loadMoreDistance) {
            if isAllowLoadMore {
                fetch(isLoadMore: true)
            }
        }
    }
}
