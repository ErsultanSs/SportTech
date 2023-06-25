//
//  VisualEffectView.swift
//  SportTechTerricon
//
//  Created by Ерсултан Сабырханов on 24.06.2023.
//

import SwiftUI

import SwiftUI
import UIKit

struct VisualEffectView: UIViewRepresentable {
    var style: UIBlurEffect.Style = .systemMaterial

    func makeUIView(context: Context) -> UIVisualEffectView {
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: style))
        return visualEffectView
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}

