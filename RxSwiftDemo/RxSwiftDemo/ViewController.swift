//
//  ViewController.swift
//  RxSwiftDemo
//
//  Created by Hiram Castro on 19/12/21.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var filterButton: UIButton!
    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.filterButton.isHidden = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let navC = segue.destination as? UINavigationController,
              let photosController = navC.viewControllers.first as? PhotosCollectionVC
        else {
            return
        }
        
        _ = photosController.selectedPhoto.subscribe(onNext: { [weak self] photo in
            
            DispatchQueue.main.async {
                self?.updateUI(with: photo)
            }
            
        }).disposed(by: disposeBag)
        
    }
    
    private func updateUI(with image: UIImage) {
        self.photoImage.image = image
        self.filterButton.isHidden = false
    }
    
    
    @IBAction func applyFilterButtonPressed(_ sender: Any) {
        guard let sourceImage = self.photoImage.image else { return }
        
        FilterService().applyFilter(to: sourceImage)
            .subscribe(onNext: { [weak self] filteredImage in
                guard self != nil else { return }
                DispatchQueue.main.async {
                    self?.photoImage.image = filteredImage
                }
            }).disposed(by: disposeBag)
        
//        FilterService().applyFilter(to: sourceImage) { [weak self] filteredImage in
//            guard self != nil else { return }
//            DispatchQueue.main.async {
//                self?.photoImage.image = filteredImage
//            }
//        }
    }
    

}

