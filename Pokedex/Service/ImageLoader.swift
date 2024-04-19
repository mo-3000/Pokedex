//
//  ImageLoader.swift
//  Pokédex
//
//  Created by Mohammed Ali on 19/04/2024.
//

import Foundation
import UIKit

class ImageLoader {
    static let shared = ImageLoader()
    
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil, let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }
}
