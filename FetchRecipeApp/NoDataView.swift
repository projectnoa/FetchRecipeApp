//
//  NoDataView.swift
//  FetchRecipeApp
//
//  Created by Juan Reyes on 1/27/25.
//

import SwiftUI

struct NoDataView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            Image(systemName: "wifi.exclamationmark")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 100)
                .opacity(0.5)

            Text("Uh oh!")
                .font(.largeTitle.bold())
            
            Text("There was a problem fetching data. Please try again in a bit.")
                .font(.callout)
                .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    NoDataView()
        .padding()
}
