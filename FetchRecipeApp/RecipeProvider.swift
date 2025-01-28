//
//  RecipeProvider.swift
//  FetchRecipeApp
//
//  Created by Juan Reyes on 1/27/25.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case requestFailed(Error)
    case decodingFailed(Error)
    case noData
    case unexpectedStatusCode(Int)
}

protocol RecipeProvider: ObservableObject {
    var recipes: [OrderedRecipes] { get }
    
    func fetchRecipes() async throws
    func fetchRecipes(with stringURL: String?) async throws
}

class RecipeService: RecipeProvider {
    @Published var recipes: [OrderedRecipes] = []
    
    private let apiURL: String = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
    
    private let urlSession: URLSession = .shared
    
    init() {
        URLCache.shared.memoryCapacity = 100_000_000
    }
    
    @MainActor
    func fetchRecipes() async throws {
        try await fetchRecipes(with: nil)
    }
    
    @MainActor
    func fetchRecipes(with stringURL: String? = nil) async throws {
        guard let url = URL(string: stringURL ?? apiURL) else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let (data, response) = try await urlSession.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse, !(200...399).contains(httpResponse.statusCode) {
                throw APIError.unexpectedStatusCode(httpResponse.statusCode)
            }
            
            guard !data.isEmpty else {
                throw APIError.noData
            }
            
            try decodeRecipes(data)
        } catch {
            if error is APIError {
                throw error
            }
            
            throw APIError.requestFailed(error)
        }
    }
    
    private func decodeRecipes(_ data: Data) throws {
        let decoder = JSONDecoder()
        
        do {
            var items: [OrderedRecipes] = []
            
            let decoded = try decoder.decode(Recipes.self, from: data)
            
            guard !decoded.recipes.isEmpty else {
                throw APIError.noData
            }
            
            decoded.recipes.forEach { recipe in
                if let index = items.firstIndex(where: { $0.cuisine == recipe.cuisine }) {
                    items[index].recipes.append(recipe)
                } else {
                    items.append(OrderedRecipes(cuisine: recipe.cuisine,
                                                recipes: [recipe]))
                }
            }
            
            self.recipes = items.sorted { $0.cuisine < $1.cuisine }
        } catch {
            if error is APIError {
                throw error
            }
            
            throw APIError.decodingFailed(error)
        }
    }
}

final class MockRecipeService: RecipeProvider {
    @Published var recipes: [OrderedRecipes] = []
    
    @MainActor
    func fetchRecipes() async throws {
        try await fetchRecipes(with: nil)
    }
    
    @MainActor
    func fetchRecipes(with stringURL: String?) async throws {
        try await Task.sleep(for: .seconds(3))
        
        var items: [OrderedRecipes] = []
        
        Recipe.samples.forEach { recipe in
            if let index = items.firstIndex(where: { $0.cuisine == recipe.cuisine }) {
                items[index].recipes.append(recipe)
            } else {
                items.append(OrderedRecipes(cuisine: recipe.cuisine,
                                            recipes: [recipe]))
            }
        }
        
        self.recipes = items
    }
}
