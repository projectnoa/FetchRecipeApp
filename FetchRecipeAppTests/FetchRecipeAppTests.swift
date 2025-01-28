//
//  FetchRecipeAppTests.swift
//  FetchRecipeAppTests
//
//  Created by Juan Reyes on 1/27/25.
//

import Testing
@testable import FetchRecipeApp
import SwiftUICore

struct FetchRecipeAppTests {
    
    @Suite("Provider Tests")
    struct ProviderTests {
        
        @Suite("Success")
        struct Success {
            let provider: any RecipeProvider = RecipeService()
            
            init() async {
                try? await provider.fetchRecipes()
            }
            
            @Test("Fetches recipe data") func fetchesData() async throws {
                #expect(provider.recipes.isEmpty == false)
            }
            
            @Test("Sorts recipe data") func sortsData() async throws {
                let orderedRecipes = provider.recipes
                
                #expect(zip(orderedRecipes, orderedRecipes.dropFirst()).allSatisfy { $0.cuisine <= $1.cuisine })
            }
        }
        
        @Suite("Failure")
        struct Failure {
            let provider: any RecipeProvider = RecipeService()
            
            @Test("Handles invalid URL") func handlesInvalidURL() async throws {
                await #expect(performing: {
                    try await provider.fetchRecipes(with: "")
                }, throws: { error in
                    switch error as? APIError {
                    case .invalidURL:
                        return true
                    default:
                        return false
                    }
                })
            }
            
            @Test("Handles no data returned") func handlesNoDataReturned() async throws {
                await #expect(performing: {
                    try await provider.fetchRecipes(with: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json")
                }, throws: { error in
                    switch error as? APIError {
                    case .noData:
                        return true
                    default:
                        return false
                    }
                })
            }
            
            @Test("Handles bad data returned") func handlesBadDataReturned() async throws {
                await #expect(performing: {
                    try await provider.fetchRecipes(with: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json")
                }, throws: { error in
                    switch error as? APIError {
                    case .decodingFailed(_):
                        return true
                    default:
                        return false
                    }
                })
            }
            
            @Test("Handles general error") func handlesGeneralError() async throws {
                await #expect(performing: {
                    try await provider.fetchRecipes(with: "badurl")
                }, throws: { error in
                    switch error as? APIError {
                    case .requestFailed(_):
                        return true
                    default:
                        return false
                    }
                })
            }
        }
    }
    
    @Suite("Cache Tests")
    struct CacheTests {
        @Suite("Success")
        struct Success {
            let cacheManager: CacheManager = .shared
            
            @Test("Caches image") func cachesImage() async throws {
                let imageName = "star"
                let image = Image(systemName: imageName)
                
                await cacheManager.saveImage(image, for: imageName)
                
                #expect(try cacheManager.getImage(for: imageName) != nil)
            }
        }
        
        @Suite("Failure")
        struct Failure {
            let cacheManager: CacheManager = .shared
            
            @Test func handlesInvalidImage() async throws {
                #expect(try cacheManager.getImage(for: "noimage") == nil)
            }
        }
    }
}
