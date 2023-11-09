//
//  UIViewWrapper.swift
//  Linh Kiem Cuu Thien H5
//
//  Created by Vũ Tấn Phát on 09/11/2023.
//  Copyright © 2023 com.thousandkg. All rights reserved.
//

import SwiftUI
  
struct UIViewWrapper: UIViewRepresentable {
    
    let view: UIView
    
    func makeUIView(context: Context) -> UIView  {
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}
