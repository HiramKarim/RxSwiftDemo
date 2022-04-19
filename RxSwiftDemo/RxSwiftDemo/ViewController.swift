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
    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let navC = segue.destination as? UINavigationController,
              let photosController = navC.viewControllers.first as? PhotosCollectionVC
        else {
            return
        }
        
        _ = photosController.selectedPhoto.subscribe(onNext: { [weak self] photo in
            
            DispatchQueue.main.async {
                self?.photoImage.image = photo
            }
            
        }).disposed(by: disposeBag)
        
    }


}

