//
//  ContentView.swift
//  Linh Kiem Cuu Thien H5
//
//  Created by Vũ Tấn Phát on 02/11/2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            SwiftUIWebView(url: URL ( string: "http://linhkiem.fun/" ) )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
