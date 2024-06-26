import SwiftUI
import PencilKit

// Card view incorporating PencilKit
struct CardView: View {
    @State var card: Card
    @State private var canvasView: CanvasViewModel
    @State private var backCanvasView: CanvasViewModel
    @State private var flipped = false
    @State private var isEditing = false
    
    init(card: Card) {
            self.card = card
            _canvasView = State(initialValue: card.frontCanvas)
            _backCanvasView = State(initialValue: card.backCanvas)
    }
    
    var body: some View {
        ZStack {
            
            Rectangle()
                .fill(.white)
                
            if (!flipped) {
                VStack {
                    Spacer()
                    PencilKitCanvas(canvasView: $canvasView.canvasView, isEditable: isEditing)
                        .frame(width: 350, height: 560)
                }
            } else {
                VStack {
                    Spacer()
                    PencilKitCanvas(canvasView: $backCanvasView.canvasView, isEditable: isEditing)
                        .frame(width: 350, height: 560)
                }
            }
            
        }
        .frame(width: 350, height: 550)
        .cornerRadius(30)
        .shadow(radius: 10)
        .onTapGesture {
            flipped.toggle()
        }
    }
}

// Preview
struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: Card())
    }
}
