//
//  PencilKitCanvas.swift
//  Cardify
//
//  Created by Jack Hodges on 3/5/2024.
//

import SwiftUI
import PencilKit

struct PencilKitCanvas: UIViewRepresentable {
    @Binding var canvasView: PKCanvasView
    var isEditable: Bool
    
    func makeUIView(context: Context) -> PKCanvasView {
        // Setup the canvas view with the initial state
        canvasView.tool = PKInkingTool(.pen, color: .black, width: 5)
        canvasView.drawingPolicy = .anyInput
        
        // Setup the tool picker and add it to the canvas
        let toolPicker = PKToolPicker()
        toolPicker.addObserver(canvasView)
        toolPicker.setVisible(false, forFirstResponder: canvasView)
        canvasView.becomeFirstResponder()
        toolPicker.selectedTool = canvasView.tool
        
        return canvasView
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        uiView.drawingPolicy = isEditable ? .anyInput : .pencilOnly
         
        if let window = uiView.window, let toolPicker = PKToolPicker.shared(for: window) {
            toolPicker.setVisible(isEditable, forFirstResponder: uiView)
            if isEditable {
                uiView.becomeFirstResponder()
                toolPicker.addObserver(uiView)
            } else {
                toolPicker.removeObserver(uiView)
                uiView.resignFirstResponder()
            }
        }
    }
}
