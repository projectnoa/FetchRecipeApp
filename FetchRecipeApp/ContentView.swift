//
//  ContentView.swift
//  FetchRecipeApp
//
//  Created by Juan Reyes on 1/27/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        RecipeListView(recipeProvider: RecipeService())
    }
}

#Preview {
    ContentView()
}
