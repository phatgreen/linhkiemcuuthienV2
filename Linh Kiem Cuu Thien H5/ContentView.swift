//
//  ContentView.swift
//  Linh Kiem Cuu Thien H5
//
//  Created by Vũ Tấn Phát on 02/11/2023.
//

import SwiftUI
import Combine
import WebKit
import WebArchiver

struct ContentView: View {
    
    class ToolbarState: NSObject, ObservableObject {
        @Published var loading = true
        
        override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
            loading = change![.newKey] as! Bool // quick and dirty
        }
    }
    
    enum Popup: Identifiable {
        case archiveCreated
        case achivingFailed(error: Error)
        case noArchive
        
        var id: String { return self.message } // hack
        
        var message: String {
            switch self {
            case .archiveCreated:
                return "Web page stored offline."
            case .achivingFailed(let error):
                return "Error: " + error.localizedDescription
            case .noArchive:
                return "Nothing archived yet!"
            }
        }
    }
    
    let archiveURL: URL
    let webView: WKWebView
    let spinner: UIActivityIndicatorView
    
    @ObservedObject var toolbar = ToolbarState()
    @State var popup: Popup? = nil
    
    init(homeUrl: URL) {
        
        self.archiveURL = try! FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("cached").appendingPathExtension("webarchive")
        
        self.spinner = UIActivityIndicatorView(style: .medium)
        self.spinner.startAnimating()
        
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = prefs
        
        self.webView = WKWebView(frame: .zero, configuration: config)
        self.webView.addObserver(toolbar, forKeyPath: #keyPath(WKWebView.isLoading), options: .new, context: nil)
        
        let request = URLRequest(url: homeUrl)
        self.webView.load(request)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            UIViewWrapper(view: webView)
        }.alert(item: $popup) { p in
            Alert(title: Text(p.message))
        }
    }
    
    func back() {
        webView.goBack()
    }
    
    func archive() {
        guard let url = webView.url else {
            return
        }
        
        toolbar.loading = true
        
        webView.configuration.websiteDataStore.httpCookieStore.getAllCookies { cookies in
            
            WebArchiver.archive(url: url, cookies: cookies) { result in
                
                if let data = result.plistData {
                    do {
                        try data.write(to: self.archiveURL)
                        self.popup = .archiveCreated
                    } catch {
                        self.popup = .achivingFailed(error: error)
                    }
                } else if let firstError = result.errors.first {
                    self.popup = .achivingFailed(error: firstError)
                }
                
                self.toolbar.loading = false
            }
        }
    }
    
    func unarchive() {
        if FileManager.default.fileExists(atPath: archiveURL.path) {
            webView.loadFileURL(archiveURL, allowingReadAccessTo: archiveURL)
        } else {
            self.popup = .noArchive
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(homeUrl: URL(string: "http://linhkiem.fun")!)
    }
}
