//
//  FollowerListVC.swift
//  GHFollowers
//
//  Created by Maks Vogtman on 23/04/2024.
//

import UIKit

class FollowerListVC: UIViewController {
    enum Section {
        case main
    }
    
    var username: String!
    var followers = [Follower]()
    var page = 1
    var hasMoreFollowers = true
    
    var collectionView: UICollectionView!
    
// DataSource is what tells the collection view what to show.
    
// Diffable data source really shines when your collection/table view needs to be dynamic.
    
// In DiffableDataSource I'm no longer keeping track of indexPath. The data source has hash values for my sections, and each of my items. What it does - it takes the snapshot of my data and UI before I make any changes, and when I make changes, it takes another snapshot of that, and does the magical diffing behind the scenes to basically implement those changes, and animate them smoothly.
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!
    
// It's good to have nice and neat viewDidLoad(), as a list of commands, without any logic. (Ofc there are exceptions)
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureCollectionView()
        getFollowers(username: username, page: page)
        configureDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
// I had to initialize the collectionView first, couse otherwise while adding to subview it would be nil.
        view.addSubview(collectionView)
// I'm telling my delegate what to listen to. It needs to listen to self.
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID)
    }
    
    func getFollowers(username: String, page: Int) {
        showLoadingView()
        NetworkManager.shared.getFollowers(for: username, page: page) { [weak self] result in
            guard let self else { return }
            self.dismissLoadingView()
            
            switch result {
            case .success(let followers):
                if followers.count < 100 { self.hasMoreFollowers = false }
//                self.followers = followers
// Previously it was like the above, but I've changed it, so I can add two arrays to each other. Previously whe, it hit 100 followers, another 100 was added, but I wasn't able to see the first 100 anymore. Now it's 100 + 100.
                self.followers.append(contentsOf: followers)
                self.updateData()
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Bad stuff happened", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, follower) -> UICollectionViewCell in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseID, 
                                                          for: indexPath) as! FollowerCell
// For every follower, I send that follower information to the FollowerCell, through the set function, and this function is going to set usernameLabel.text to follower.login
            cell.set(follower: follower)
            return cell
        })
    }
    
// Now's where the data comes in. That's where I kind of feed the follower array. It's going to be called every time I take a snapshot and want to adjust the collection view.
    func updateData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        DispatchQueue.main.async { self.dataSource.apply(snapshot, animatingDifferences: true) }
    }
}

// Delegates are just waiting to be called, and then they act. It sits and waits to be told to do something.
extension FollowerListVC: UICollectionViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            guard hasMoreFollowers else { return }
            page += 1
            getFollowers(username: username, page: page)
        }
    }
}
