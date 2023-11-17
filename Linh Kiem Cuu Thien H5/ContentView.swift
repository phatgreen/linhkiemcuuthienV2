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

        // Thêm CSS bằng cách sử dụng phương thức evaluateJavaScript
        let css = "* { -webkit-transform: translateZ(0); transform: translateZ(0); }"
        let js = "var style = document.createElement('style'); style.innerHTML = '\(css)'; document.head.appendChild(style);"
        self.webView.evaluateJavaScript(js, completionHandler: nil)
    }

    var body: some View {
        VStack(spacing: 0) {
            UIViewWrapper(view: webView)
        }
    }
}

