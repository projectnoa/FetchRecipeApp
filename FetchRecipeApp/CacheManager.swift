//
//  CacheManager.swift
//  FetchRecipeApp
//
//  Created by Juan Reyes on 1/27/25.
//

import SwiftUI

// This is an implementation to comply with the test requirements.
// However, SwiftUI AsyncImage does a better job at handlyng cache at this scale.
// Therefore it is unnecessary.
class CacheManager {
    static let shared = CacheManager()
    
    private init() {
        
    }
    
    let cache = NSCache<NSString, NSData>()
    
    func getImage(for url: String) -> Image? {
        let cacheID = NSString(string: url)

        if let cachedData = cache.object(forKey: cacheID),
            let uiImage = UIImage(data: cachedData as Data) {
            return Image(uiImage: uiImage)
        }
        
        return nil
    }
    
    @MainActor
    func saveImage(_ image: Image,
                   for url: String) {
        let cacheID = NSString(string: url)
        
        if let uiImage = image.getUIImage(newSize: .init(width: 300,
                                                         height: 300)),
           let data = uiImage.pngData() as? NSData {
            cache.setObject(data, forKey: cacheID)
        }
    }
}

extension Image {
    @MainActor
    func getUIImage(newSize: CGSize) -> UIImage? {
        let image = resizable()
            .scaledToFill()
            .frame(width: newSize.width,
                   height: newSize.height)
            .clipped()
        
        return ImageRenderer(content: image).uiImage
    }
}
