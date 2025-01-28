//
//  RecipeListView.swift
//  FetchRecipeApp
//
//  Created by Juan Reyes on 1/27/25.
//

import SwiftUI

struct RecipeListView<T: RecipeProvider>: View {
    @ObservedObject var recipeProvider: T
    
    @State private var displayError: Bool = false
    @State private var isLoading: Bool = false
    
    private let gridColumns = Array(repeating: GridItem(.flexible(minimum: 200)), count: 2)
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    ScrollView(.vertical) {
                        ZStack {
                            LazyVGrid(columns: gridColumns,
                                      pinnedViews: [.sectionHeaders]) {
                                ForEach(recipeProvider.recipes) { item in
                                    Section {
                                        ForEach(item.recipes) { recipe in
                                            NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                                                RecipeItemView(recipe: recipe)
                                                    .tint(.primary)
                                            }
                                        }
                                    } header: {
                                        Rectangle()
                                            .fill(.white)
                                            .background(.ultraThinMaterial)
                                            .frame(height: 25)
                                            .opacity(0.75)
                                            .overlay(alignment: .leading) {
                                                Text(item.cuisine)
                                                    .font(.headline.bold())
                                                    .padding(.horizontal)
                                            }
                                    }
                                }
                            }
                        }
                    }
                    
                    if displayError {
                        NoDataView()
                            .padding(.horizontal, 40)
                    }
                    
                    if isLoading {
                        Rectangle()
                            .fill(.gray)
                            .opacity(0.4)
                            .ignoresSafeArea()
                        
                        ProgressView()
                            .scaleEffect(2.0, anchor: .center)
                            .tint(.gray)
                            .frame(maxWidth: .infinity,
                                   alignment: .center)
                            .padding()
                    }
                }
            }
            .navigationTitle("Recipes")
        }
        .onAppear(perform: handleOnAppear)
    }
}

extension RecipeListView {
    private func handleOnAppear() {
        Task { @MainActor in
            do {
                isLoading = true
                
                try await recipeProvider.fetchRecipes()
                
                displayError = false
            } catch {
                displayError = true
            }
            
            isLoading = false
        }
    }
}

#Preview {
    RecipeListView(recipeProvider: MockRecipeService())
}
