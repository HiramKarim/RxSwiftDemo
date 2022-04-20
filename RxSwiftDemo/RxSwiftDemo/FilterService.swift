//
//  FilterService.swift
//  RxSwiftDemo
//
//  Created by Hiram Castro on 19/04/22.
//

import UIKit
import CoreImage
import RxSwift

class FilterService {
    
    private var context:CIContext
    
    init() {
        self.context = CIContext()
    }
    
    func applyFilter(to inputImage: UIImage) -> Observable<UIImage> {
        return Observable<UIImage>.create { observer in
            
            self.applyFilter(to: inputImage) { image in
                observer.onNext(image)
            }
            
            return Disposables.create()
        }
    }
    
    func applyFilter(to inputImage:UIImage, completion: @escaping ((UIImage) -> ()) ) {
        let filter = CIFilter(name: "CICMYKHalftone")
        filter?.setValue(5.0, forKey: kCIInputWidthKey)
        
        if let sourceImage = CIImage(image: inputImage) {
            filter?.setValue(sourceImage, forKey: kCIInputImageKey)
            
            if let cgimg = self.context.createCGImage((filter?.outputImage)!, from: filter!.outputImage!.extent) {
                let processedImage = UIImage(cgImage: cgimg, scale: inputImage.scale, orientation: inputImage.imageOrientation)
                completion(processedImage)
            }
            
        }
    }
    
}

