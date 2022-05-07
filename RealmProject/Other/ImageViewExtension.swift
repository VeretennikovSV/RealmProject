//
//  ImageViewExtension.swift
//  RealmProject
//
//  Created by Сергей Веретенников on 07/05/2022.
//

import Foundation
import UIKit

extension UIImage {
    
    static func createImageWith(name: String, width: Int, height: Int) -> UIImage {
        let image = UIImage(named: name)
        
        let size = CGSize(width: width, height: height)
        
        let renderer = UIGraphicsImageRenderer(size: size)
        
        let resizedImage = renderer.image { _ in
            image?.draw(in: CGRect(origin: .zero, size: size))
        }
        
        return resizedImage
    }
    
}
