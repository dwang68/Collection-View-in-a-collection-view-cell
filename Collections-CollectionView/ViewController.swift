//
//  ViewController.swift
//  Collections-CollectionView
//
//  Created by Irfan Lone on 4/8/16.
//  Copyright © 2016 Ilone Labs. All rights reserved.
//

import UIKit

let reuseMainCollectionViewCellIdentifier = "MainCollectionViewCellIdentifier"
let reuseChildCollectionViewCellIdentifier = "ChildCollectionViewCellIdentifier"


class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    let data = generateRandomData()
    var dataProvider : MainCollectionViewDataSource!
    var storedOffsets = [Int: CGFloat]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataProvider = MainCollectionViewDataSource()
        dataProvider.data = data
        collectionView.dataSource = dataProvider
    }
    
}


extension ViewController : UICollectionViewDelegate {
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        guard let collectionViewCell = cell as? MainCollectionViewCell else { return }
        
        collectionViewCell.delegate = self
        
        let dataProvider = ChildCollectionViewDataSource()
        dataProvider.data = data[indexPath.row] as NSArray
        
        let delegate = ChildCollectionViewDelegate()
        
        collectionViewCell.initializeCollectionViewWithDataSource(dataProvider, delegate: delegate, forRow: indexPath.row)
        
        collectionViewCell.collectionViewOffset = storedOffsets[indexPath.row] ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        guard let collectionViewCell = cell as? MainCollectionViewCell else { return }
        storedOffsets[indexPath.row] = collectionViewCell.collectionViewOffset
    }
    
}


extension ViewController : UICollectionViewDelegateFlowLayout {
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(self.view.frame.size.width, 140)
    }
}


extension ViewController : CollectionViewSelectedProtocol {
    
    // MARK: - CollectionViewSelectedProtocol
    
    func collectionViewSelected(collectionViewItem: Int) {
        
        let dataProvider = ChildCollectionViewDataSource() // You can choose to create a new data source and feed it the same data
        dataProvider.data = data[collectionViewItem] as NSArray
        
        let delegate = ChildCollectionViewDelegate() // You can choose to create a new CollectionViewDelegate for detailViewController
        
        let detailVC = UIStoryboard(name: "DetailView", bundle: nil).instantiateViewControllerWithIdentifier("DetailView") as! DetailViewController
        detailVC.dataSource = dataProvider
        detailVC.delegate = delegate
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
}

