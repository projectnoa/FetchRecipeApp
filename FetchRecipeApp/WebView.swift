//
//  WebView.swift
//  FetchRecipeApp
//
//  Created by Juan Reyes on 1/27/25.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    private let url: URL
    let webView: WKWebView
    
    init(url: URL) {
        self.url = url
        self.webView = WKWebView(frame: .zero)
    }

    func makeUIView(context: Context) -> WKWebView {
        return webView
    }

    func updateUIView(_ uiView: WKWebView,
                      context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
