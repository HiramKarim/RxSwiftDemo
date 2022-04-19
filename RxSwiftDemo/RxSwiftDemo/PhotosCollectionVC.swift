//
//  PhotosCollectionVC.swift
//  RxSwiftDemo
//
//  Created by Hiram Castro on 15/04/22.
//

import UIKit
import Photos
import RxCocoa
import RxSwift

class PhotosCollectionVC: UICollectionViewController {
    
    private var imagesArray = [PHAsset]()
    
    private let selectedPhotoSubject = PublishSubject<UIImage>()
    
    var selectedPhoto: Observable<UIImage> {
        return selectedPhotoSubject.asObservable()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        populatePhotos()
    }
    
    private func populatePhotos() {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] status in
            if status == .authorized {
                
                let assets = PHAsset.fetchAssets(with: .image, options: nil)
                
                assets.enumerateObjects { [weak self] obj, count, stop in
                    self?.imagesArray.append(obj)
                }
                
                self?.imagesArray.reverse()
                
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
                
            }
        }
    }
    
}

extension PhotosCollectionVC {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imagesArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? PhotoCell
        else { return UICollectionViewCell () }
        
        let asset = self.imagesArray[indexPath.row]
        
        let manager = PHImageManager.default()
        manager.requestImage(for: asset, targetSize: CGSize(width: 100,height: 100), contentMode: .aspectFit, options: nil) { image, _ in
            DispatchQueue.main.async {
                cell.photoImage.image = image
            }
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let asset = self.imagesArray[indexPath.row]
        
        let manager = PHImageManager.default()
        manager.requestImage(for: asset, targetSize: CGSize(width: 100,height: 100), contentMode: .aspectFit, options: nil) { image, info in
            DispatchQueue.main.async {
                guard let info = info else { return }
                let isDegradedImage = info["PHImageResultIsDegradedKey"] as! Bool
                if !isDegradedImage {
                    if let image = image {
                        self.selectedPhotoSubject.onNext(image)
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
}
