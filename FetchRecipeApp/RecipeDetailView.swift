//
//  RecipeDetailView.swift
//  FetchRecipeApp
//
//  Created by Juan Reyes on 1/27/25.
//

import SwiftUI
import WebKit

struct RecipeDetailView: View {
    var recipe: Recipe
    
    var body: some View {
        if let source_url = recipe.source_url,
           let url = URL(string: source_url) {
            RecipeDetailInfoView(recipe: recipe)
            
            WebView(url: url)
                .ignoresSafeArea()
        } else {
            if let imageURL = recipe.photo_url_large,
                let url = URL(string: imageURL) {
                AsyncImage(url: url,
                           transaction: .init(animation: .easeInOut)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .transition(.blurReplace)
                    case .failure:
                        ImagePlaceholderView()
                    @unknown default:
                        ImagePlaceholderView()
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding(.horizontal)
            }
            
            RecipeDetailInfoView(recipe: recipe)
        }
    }
}



#Preview {
    NavigationStack {
        RecipeDetailView(recipe: .sample)
//            .toolbar {
//                ToolbarItem(placement: .navigation) {
//                    Button("< Recipes") {
//                        
//                    }
//                }
//            }
    }
}
