//
//  PhotosViewController.swift
//  FlickrViewer
//
//  Created by Eugene Belyakov on 03/07/2019.
//  Copyright © 2019 Ievgen Bieliakov. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController {

    var photoSearchService: PhotoSearchService? {
        didSet {
            if let photoSearchService = self.photoSearchService {
                self.photoDataSource = PhotoDataSource(photoService: photoSearchService)
                self.photoDataSource?.delegate = self
            } else {
                self.photoDataSource = nil
            }
        }
    }
    
    var photoDataSource: PhotoDataSource? {
        didSet {
            if self.isViewLoaded {
                self.collectionView.reloadData()
            }
        }
    }
    
    var photoDownloadService: PhotoDownloadService?
    
    var requests: [IndexPath: Cancellable] = [:]
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.isPrefetchingEnabled = false
    }
    
    override func viewWillLayoutSubviews() {
        let size: CGFloat = collectionView.bounds.width / 3.0
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize(width: size, height: size)
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0
        }
    }
}

extension PhotosViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photoDataSource?.photos.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.ReuseID, for: indexPath) as? PhotoCell else {
            fatalError("Incorrect cell dequeued")
        }
        
        cell.activityIndicator.isHidden = false
        cell.activityIndicator.startAnimating()
        
        self.downlaodPhotoForCellAtIndexPath(indexPath)
        
        return cell
    }
    
    private func downlaodPhotoForCellAtIndexPath(_ indexPath: IndexPath) {
        if let photo = self.photoDataSource?.photos[indexPath.row] {
            
            self.requests[indexPath] = self.photoDownloadService?.loadPhoto(photo, completion: { (image, error) in
                
                DispatchQueue.main.async {
                    self.requests[indexPath] = nil
                    if let cell = self.collectionView.cellForItem(at: indexPath) as? PhotoCell {
                        cell.activityIndicator.stopAnimating()
                        cell.activityIndicator.isHidden = true
                        if let image = image {
                            cell.imageView.image = image
                        }
                    }
                }
            })
        }
    }
}

extension PhotosViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let dataSource = self.photoDataSource {
            if indexPath.row >= dataSource.photos.count - 1 {
                self.photoDataSource?.loadMoreIfPresent()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? PhotoCell {
            cell.activityIndicator.stopAnimating()
            cell.imageView.image = nil //Freeing up memory
        }
        
        self.requests[indexPath]?.cancel()
        self.requests[indexPath] = nil
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.searchBar.isFirstResponder {
            self.searchBar.resignFirstResponder()
        }
    }
    
}

extension PhotosViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.photoDataSource?.searchTerm = searchText
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
    
}

extension PhotosViewController: PhotoDataSourceDelegate {
    func photoSourceDidUpdateBucket(_ source: PhotoDataSource) {
        self.collectionView.reloadData()
    }
    
    func photoSource(_ source: PhotoDataSource, didLoadMorePhotosInRange range: Range<Int>) {
        
        var indexes = [IndexPath]()
        for i in range {
            indexes.append(IndexPath(row: i, section: 0))
        }
        self.collectionView.insertItems(at: indexes)
    }
}
