//
//  UIViewWrapper.swift
//  Linh Kiem Cuu Thien H5
//
//  Created by Vũ Tấn Phát on 09/11/2023.
//  Copyright © 2023 com.thousandkg. All rights reserved.
//

import SwiftUI
import WebKit

struct UIViewWrapper: UIViewRepresentable {
    
    let view: WKWebView
    
    func makeUIView(context: Context) -> UIView  {
        view.uiDelegate = context.coordinator
        view.navigationDelegate = context.coordinator

        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
    
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
