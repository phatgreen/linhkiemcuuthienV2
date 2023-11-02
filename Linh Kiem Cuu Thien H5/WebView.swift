//
//  WebView.swift
//  Linh Kiem Cuu Thien H5
//
//  Created by Vũ Tấn Phát on 03/11/2023.
//

import SwiftUI
import WebKit

struct SwiftUIWebView: UIViewRepresentable {
    let url: URL?
    var shouldReload: Bool = false // Thêm biến này

    func makeUIView(context: Context) -> WKWebView {
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = prefs

        let webView = WKWebView(frame: .zero, configuration: config)
        webView.uiDelegate = context.coordinator
        webView.navigationDelegate = context.coordinator

        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard let myURL = url else {
            return
        }
        let request = URLRequest(url: myURL)

        if shouldReload {
            // Tắt tự động làm mới trang
            uiView.load(request)
        } else {
            // Sử dụng URLCache để cấu hình cache cho request
            let urlCache = URLCache.shared
            let cachedResponse = urlCache.cachedResponse(for: request)
            if let cachedResponse = cachedResponse {
                uiView.load(cachedResponse.data, mimeType: cachedResponse.response.mimeType ?? "", characterEncodingName: "UTF-8", baseURL: myURL)
            } else {
                uiView.load(request)
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }

    class Coordinator: NSObject, WKUIDelegate, WKNavigationDelegate {
        // Triển khai các phương thức UI delegate và navigation delegate ở đây
        func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
            let alertController = UIAlertController(title: "Thông Báo", message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                completionHandler()
            })

            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                if let topViewController = windowScene.windows.first?.rootViewController {
                    topViewController.present(alertController, animated: true, completion: nil)
                }
            }
        }

        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if navigationAction.navigationType == .reload {
                decisionHandler(.cancel)
            } else {
                decisionHandler(.allow)
            }
        }
    }
}

