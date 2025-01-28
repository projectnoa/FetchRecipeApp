//
//  RecipeDetailInfoView.swift
//  FetchRecipeApp
//
//  Created by Juan Reyes on 1/27/25.
//

import SwiftUI

struct RecipeDetailInfoView: View {
    var recipe: Recipe
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(recipe.name)
                    .font(.title.bold())
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
                    .multilineTextAlignment(.leading)
                
                Text("Cuisine: \(recipe.cuisine)")
            }
            
            Spacer()
            
            if let youtube_url = recipe.youtube_url,
               let url = URL(string: youtube_url) {
                Link("View Video", destination: url)
                    .font(.callout.bold())
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    RecipeDetailInfoView(recipe: .sample)
}
