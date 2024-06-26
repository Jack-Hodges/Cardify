//
//  PencilKitCanvasView.swift
//  Cardify
//
//  Created by Jack Hodges on 7/5/2024.
//

import SwiftUI
import PencilKit

struct PencilKitCanvasView: UIViewRepresentable {
    @Binding var canvasView: PKCanvasView
    var isEditable: Bool

    func makeUIView(context: Context) -> PKCanvasView {
        return canvasView
    }

    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        uiView.isUserInteractionEnabled = isEditable
    }
}
