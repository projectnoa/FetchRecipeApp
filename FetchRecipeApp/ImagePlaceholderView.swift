//
//  ImagePlaceholderView.swift
//  FetchRecipeApp
//
//  Created by Juan Reyes on 1/27/25.
//

import SwiftUI

struct ImagePlaceholderView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.white)
                .border(.gray)
            
            Image(systemName: "photo.artframe")
                .resizable()
                .frame(width: 50,
                       height: 50)
        }
        .frame(maxHeight: 300)
    }
}

#Preview {
    ImagePlaceholderView()
        .padding()
}
