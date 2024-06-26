import SwiftUI
import PencilKit

struct EditCardView: View {
    
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    @State var card: Card
    @State private var canvasView: CanvasViewModel
    @State private var backCanvasView: CanvasViewModel
    @State private var isEditing = false
    @State private var flipped = false
    @State private var showingAlert = false
    var appColor: Color
    var textColor: Color
    
    init(card: Card, appColor: Color, textColor: Color) {
        self.card = card
        _canvasView = State(initialValue: card.frontCanvas)
        _backCanvasView = State(initialValue: card.backCanvas)
        self.appColor = appColor
        self.textColor = textColor
    }
    
    var body: some View {
            ZStack {
                appColor
                    .ignoresSafeArea(.all)

                VStack {
                    
                    ZStack {
                        Rectangle()
                            .fill(.white)
                            
                        if (!flipped) {
                            VStack {
                                Spacer()
                                PencilKitCanvas(canvasView: $canvasView.canvasView, isEditable: isEditing)
                                    .frame(width: 350, height: 530)
                            }
                        } else {
                            VStack {
                                Spacer()
                                PencilKitCanvas(canvasView: $backCanvasView.canvasView, isEditable: isEditing)
                                    .frame(width: 350, height: 530)
                            }
                        }
                    }
                    .frame(width: 350, height: 520)
                    .cornerRadius(30)
                    .shadow(radius: 10)
                    
                    rowButtons()
                        .padding(.top, -10)
                }
                .padding(.top, 20)
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        showingAlert.toggle()
                    }, label: {
                        Image(systemName: "chevron.left")
                            .font(.title)
                            .bold()
                            .foregroundStyle(textColor)
                    })
                }
                ToolbarItem(placement: .principal) {
                    Text("Edit Card")
                        .font(.largeTitle)
                        .bold()
                        .foregroundStyle(textColor)
                }
            })
            .alert("Save changes?", isPresented: $showingAlert) {
                Button("Don't Save", role: .destructive) {
                            print("Didn't save")
                            presentationMode.wrappedValue.dismiss()
                        }
                Button("Save", role: .none) {
                            canvasView.saveDrawing()
                            backCanvasView.saveDrawing()
                            presentationMode.wrappedValue.dismiss()
                        }
                    } message: {
                        Text("Do you want to save your changes?")
                    }
    }
    
    private func rowButtons() -> some View {
        HStack {
            
            Button(action: {
                self.flipped.toggle()
                self.isEditing = false
            }) {
                Image(systemName: "rectangle.portrait.rotate")
                        .resizable()  // Makes the image resizable
                        .aspectRatio(contentMode: .fit)  // Keeps the aspect ratio of the image
                        .frame(width: 70, height: 70)
                        .foregroundStyle(textColor)
            }
            .padding()
            
            Spacer()
            
            Text(flipped ? "Back" : "Front")
                .font(.title)
                .bold()
                .foregroundStyle(textColor)
            
            Spacer()
            
            Button(action: {
                isEditing.toggle()
            }) {
                Image(systemName: isEditing ? "pencil.circle.fill" : "pencil.circle")
                        .resizable()  // Makes the image resizable
                        .aspectRatio(contentMode: .fit)  // Keeps the aspect ratio of the image
                        .frame(width: 60, height: 60)
                        .foregroundStyle(textColor)
                        
            }
            .padding(.trailing, 20)
        }
        .padding(.bottom, 40)
    }
    
    func SaveTitle(color: Color, title: String) -> some View {
        HStack {
            Image(systemName: "chevron.left")
                .foregroundStyle(color)
                .bold()
                .font(.largeTitle)
            
            Spacer()
                
            Text("Science")
                .foregroundStyle(color)
                .bold()
                .font(.largeTitle)
            
            Spacer()
            
            Button("Save") {
                canvasView.saveDrawing()
                backCanvasView.saveDrawing()
            }
        }
        .padding(.top)
        .padding(.trailing, 35)
        .padding(.leading, 10)
    }
}

// Preview
struct EditCardView_Previews: PreviewProvider {
    static var previews: some View {
        let appColor = Color(red: 123/255, green: 182/255, blue: 216/255)
        EditCardView(card: Card(), appColor: appColor, textColor: .blue)
    }
}
