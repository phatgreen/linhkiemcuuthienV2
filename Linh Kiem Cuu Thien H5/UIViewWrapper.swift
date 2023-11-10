//
//  UIViewWrapper.swift
//  Linh Kiem Cuu Thien H5
//
//  Created by Vũ Tấn Phát on 09/11/2023.
//  Copyright © 2023 com.thousandkg. All rights reserved.
//

import SwiftUI
import WebKit

extension WKPreferences {
    @objc func _setOfflineApplicationCacheIsEnabled(_ isEnabled: Bool) {
        // Kiểm tra xem có thể truy cập WKWebsiteDataStore không
        if #available(iOS 14.0, *) {
            // Sử dụng WKWebsiteDataStore để thiết lập cache khi offline
            let dataStore = WKWebsiteDataStore.default()
            let websiteDataTypes = Set([WKWebsiteDataTypeOfflineWebApplicationCache])

            // Thiết lập cache khi offline
            dataStore.removeData(ofTypes: websiteDataTypes, modifiedSince: Date.distantPast) {
                // Xử lý khi hoàn tất việc xóa cache
                print("Offline application cache is enabled: \(isEnabled)")
            }
        } else {
            // iOS 13 và phiên bản thấp hơn không hỗ trợ WKWebsiteDataStore
            // Thực hiện các bước thích hợp cho các phiên bản iOS thấp hơn
            print("Unsupported on iOS versions prior to 14.0")
        }
    }
}

struct UIViewWrapper: UIViewRepresentable {
    
    let view: WKWebView
    
    func makeUIView(context: Context) -> UIView  {
        view.uiDelegate = context.coordinator
        view.navigationDelegate = context.coordinator
        
        // Gọi phương thức để thiết lập cache khi offline
        let preferences = view.configuration.preferences
        preferences._setOfflineApplicationCacheIsEnabled(true)

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
