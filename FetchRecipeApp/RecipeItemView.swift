//
//  RecipeItemView.swift
//  FetchRecipeApp
//
//  Created by Juan Reyes on 1/27/25.
//

import SwiftUI

struct RecipeItemView: View {
    var recipe: Recipe
    
    private let cornerRadii: CGFloat = 20
    
    private let cacheManager: CacheManager = .shared
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.gray)
                .opacity(0.4)
            
            if let imageURL = recipe.photo_url_small,
                let url = URL(string: imageURL) {
                
                if let image = cacheManager.getImage(for: url.absoluteString) {
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(maxHeight: 150)
                        .transition(.blurReplace)
                } else {
                    AsyncImage(url: url,
                               transaction: .init(animation: .easeInOut)) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(maxHeight: 150)
                                .transition(.blurReplace)
                                .task {
                                    // Store image in disk cache
                                    cacheManager.saveImage(image,
                                                           for: url.absoluteString)
                                }
                        case .failure:
                            ImagePlaceholderView()
                        @unknown default:
                            ImagePlaceholderView()
                        }
                    }
                }
            } else {
                ImagePlaceholderView()
            }
            
            VStack {
                Spacer()
                
                ZStack {
                    Rectangle()
                        .fill(.white)
                        .background(.ultraThinMaterial)
                        .opacity(0.5)
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text(recipe.name)
                                .font(.headline.bold())
                                .lineLimit(2)
                                .minimumScaleFactor(0.8)
                                .multilineTextAlignment(.leading)
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                }
                .frame(height: 50)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: cornerRadii))
        .frame(height: 150)
    }
}

#Preview {
    RecipeItemView(recipe: .sample)
        .padding()
}
