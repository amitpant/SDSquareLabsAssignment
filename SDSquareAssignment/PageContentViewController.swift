//
//  PageContentViewController.swift
//  SDSquareAssignment
//
//  Created by Amit Pant on 03/07/17.
//  Copyright © 2017 Amit Pant. All rights reserved.
//

import UIKit

class PageContentViewController: UIViewController {
    
    // MARK: - Injections
    internal var networkClient = NetworkClient.shared
    
    // MARK: - Instance Properties
    var index:Int = 0
    var user:User?
    var images = [UIImage]()
    
    // MARK: - Outlets
    @IBOutlet weak var userImageView: UIImageView!{
        didSet{
            userImageView.layer.cornerRadius = self.userImageView.bounds.width/2
            userImageView.layer.borderColor = UIColor.black.cgColor
            userImageView.layer.borderWidth = 1
            userImageView.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureContentView()
    }
    
    
    // MARK: Private functions
   private func configureContentView()  {
        guard let user = user else {return}
        self.userNameLabel.text = user.name
       
        self.loadProfileImage()
        self.loadItemImages()
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
   private func loadItemImages()  {
        guard let items = self.user?.items else {
            return
        }
        for item in items {
            networkClient.getItemImage(urlString: item,
                                       success: {
                                        [weak self] image in
                                        guard let strongSelf = self else {return}
                                        strongSelf.images.append(image)
                                        strongSelf.collectionView.reloadData() },
                                       failure: {error in
                                        print("Product download failed: \(error)")})
        }
    }
    
    private func loadProfileImage()  {
        guard let imageurl = self.user?.image else {
            return
        }
        networkClient.getItemImage(urlString: imageurl,
                                   success: {
                                    [weak self] image in
                                    guard let strongSelf = self else {return}
                                    strongSelf.userImageView.image = image  },
                                   failure: {error in
                                    print("Product download failed: \(error)")})
    }
}


extension PageContentViewController:UICollectionViewDataSource,UICollectionViewDelegate{
  
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let items = self.user?.items else {
            return 0
        }
        return items.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
        if self.images.count > indexPath.row {
            cell.imageView.image = self.images[indexPath.row]
        }
        return cell
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}

extension PageContentViewController:UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let squareCellWidth = collectionView.bounds.size.width/2 - 3
        let size = CGSize(width: squareCellWidth, height: squareCellWidth)
        
        guard let items = self.user?.items else {
            return size
        }
        if items.count % 2 > 0 && indexPath.item == 0 {
            let newSize = CGSize(width: (squareCellWidth + 2) * 2 , height: (squareCellWidth + 2) * 2 )
            return newSize
        }
        return size
    }
}
