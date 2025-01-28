//
//  Recipe.swift
//  FetchRecipeApp
//
//  Created by Juan Reyes on 1/27/25.
//

import Foundation

struct Recipe: Codable, Identifiable {
    var id: String { uuid }
    
    let name: String
    let cuisine: String
    let photo_url_large: String?
    let photo_url_small: String?
    let uuid: String
    let source_url: String?
    let youtube_url: String?
}

struct Recipes: Codable {
    let recipes: [Recipe]
}

struct OrderedRecipes: Identifiable {
    var id: String { cuisine }
    
    var cuisine: String
    var recipes: [Recipe] = []
}

extension Recipe {
    static let sample: Recipe = .init(
        name: "Apam Balik",
        cuisine: "Malaysian",
        photo_url_large: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg",
        photo_url_small: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg",
        uuid: "0c6ca6e7-e32a-4053-b824-1dbf749910d8",
        source_url: "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ",
        youtube_url: "https://www.youtube.com/watch?v=6R8ffRRJcrg"
    )
    
    static let emptySample: Recipe = .init(
        name: "",
        cuisine: "",
        photo_url_large: nil,
        photo_url_small: nil,
        uuid: "",
        source_url: nil,
        youtube_url: nil
    )
    
    static let samples: [Recipe] = Array(repeating: .sample,
                                         count: 10)
}
