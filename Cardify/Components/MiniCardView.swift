import SwiftUI
import PencilKit

// Card view incorporating PencilKit
struct MiniCardView: View {
    @State var drawingSize: CGSize = CGSize(width: 350, height: 530)
    @State private var image: UIImage = UIImage() // Default empty image
    
    var card: Card
    
    // Function to update the image based on the card's drawing
    func updateImage() {
        let imgRect = CGRect(origin: .zero, size: drawingSize)
        image = card.frontCanvas.canvasView.drawing.image(from: imgRect, scale: 1.0)
    }
    
    var body: some View {
        VStack {
            Image(uiImage: image)
                .resizable()
                .frame(width: 165, height: 265)
                .aspectRatio(drawingSize, contentMode: .fit)
                
        }
        .frame(width: 165, height: 265)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 5)
        .scaledToFit()
        .onAppear {
            updateImage()  // Update the image when the view appears
        }
    }
}

// Preview
struct MiniCardView_Previews: PreviewProvider {
    static var previews: some View {
        MiniCardView(card: Card())
    }
}
