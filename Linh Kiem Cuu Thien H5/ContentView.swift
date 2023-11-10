//
//  ContentView.swift
//  Linh Kiem Cuu Thien H5
//
//  Created by Vũ Tấn Phát on 02/11/2023.
//

import SwiftUI
import WebKit

struct ContentView: View {
    
    let webView: WKWebView
    
    init(homeUrl: URL) {
        
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = prefs
        
        self.webView = WKWebView(frame: .zero, configuration: config)
        
        let request = URLRequest(url: homeUrl)
        self.webView.load(request)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            UIViewWrapper(view: webView)
        }
    }
}
