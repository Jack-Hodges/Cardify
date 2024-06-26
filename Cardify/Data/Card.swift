//
//  Card.swift
//  Cardify
//
//  Created by Jack Hodges on 1/5/2024.
//

import PencilKit
import SwiftUI

class CanvasViewModel: ObservableObject {
    @Published var canvasView: PKCanvasView
    var fileName: String
    
    init(fileName: String) {
        self.canvasView = PKCanvasView()
        self.fileName = fileName
        canvasView.tool = PKInkingTool(.pen, color: .black, width: 5)
        canvasView.drawingPolicy = .anyInput
        loadDrawing()  // Load drawing on initialization if exists
    }

    func saveDrawing() {
        let drawingData = canvasView.drawing.dataRepresentation()
        let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(fileName)
        do {
            try drawingData.write(to: fileURL)
        } catch {
            print("Unable to save drawing to file: \(error.localizedDescription)")
        }
    }

    func loadDrawing() {
        let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(fileName)
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                let drawingData = try Data(contentsOf: fileURL)
                if let drawing = try? PKDrawing(data: drawingData) {
                    canvasView.drawing = drawing
                }
            } catch {
                print("Unable to load drawing from file: \(error.localizedDescription)")
            }
        }
    }
}

class Card: ObservableObject, Identifiable, Equatable {
    var id: UUID
    @Published var dragOffset: CGSize = .zero
    var frontCanvas: CanvasViewModel
    var backCanvas: CanvasViewModel
    @Published var backImage: UIImage?
    
    init() {
        self.id = UUID()
        self.frontCanvas = CanvasViewModel(fileName: "card_\(id.uuidString)_front.pk")
        self.backCanvas = CanvasViewModel(fileName: "card_\(id.uuidString)_back.pk")
        self.loadImage()
    }

    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.id == rhs.id
            && lhs.frontCanvas === rhs.frontCanvas
            && lhs.backCanvas === rhs.backCanvas
            && lhs.backImage == rhs.backImage
    }
    
    func saveImage(_ image: UIImage) {
        let imageData = image.jpegData(compressionQuality: 1.0)
        let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("card_\(id.uuidString)_back.jpg")
        do {
            try imageData?.write(to: fileURL)
        } catch {
            print("Unable to save image to file: \(error.localizedDescription)")
        }
    }
    
    func loadImage() {
        let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("card_\(id.uuidString)_back.jpg")
        if FileManager.default.fileExists(atPath: fileURL.path) {
            if let imageData = try? Data(contentsOf: fileURL), let image = UIImage(data: imageData) {
                self.backImage = image
            }
        }
    }
}
