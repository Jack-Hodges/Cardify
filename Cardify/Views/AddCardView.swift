import SwiftUI
import PencilKit

// ImagePicker to handle image selection
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.presentationMode) private var presentationMode

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

struct AddCardView: View {
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @State var card: Card
    @State var subject: Subject
    @State private var canvasView: CanvasViewModel
    @State private var backCanvasView: CanvasViewModel
    @State private var isEditing = false
    @State private var flipped = false
    @State private var showingAlert = false
    @State private var showingImagePicker = false
    var appColor: Color
    var textColor: Color

    init(card: Card, subject: Subject, appColor: Color, textColor: Color) {
        self.card = card
        self.subject = subject
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
                            if let image = card.backImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 350, height: 530)
                                    .clipped()
                            } else {
                                PencilKitCanvas(canvasView: $backCanvasView.canvasView, isEditable: isEditing)
                                    .frame(width: 350, height: 530)
                            }
                            Spacer()
                            Button(action: {
                                showingImagePicker.toggle()
                            }) {
                                Text("Upload Photo")
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                            .sheet(isPresented: $showingImagePicker) {
                                ImagePicker(image: $card.backImage)
                            }
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
                Text("Add Card")
                    .font(.largeTitle)
                    .bold()
                    .foregroundStyle(textColor)
            }
        })
        .alert("Save card?", isPresented: $showingAlert) {
            Button("Don't Save", role: .destructive) {
                        presentationMode.wrappedValue.dismiss()
                    }
            Button("Save", role: .none) {
                        subject.cards.append(card)
                        canvasView.saveDrawing()
                        backCanvasView.saveDrawing()
                        if let backImage = card.backImage {
                            card.saveImage(backImage)
                        }
                        presentationMode.wrappedValue.dismiss()
                    }
                } message: {
                    Text("Do you want to save your card?")
                }
    }
    
    private func rowButtons() -> some View {
        HStack {
            Button(action: {
                self.flipped.toggle()
                self.isEditing = false
            }) {
                Image(systemName: "rectangle.portrait.rotate")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
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
                    .resizable()
                    .aspectRatio(contentMode: .fit)
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
                subject.cards.append(card)
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
struct AddCardView_Previews: PreviewProvider {
    static var previews: some View {
        let appColor = Color(red: 123/255, green: 182/255, blue: 216/255)
        AddCardView(card: Card(), subject: Subject.samples[0], appColor: appColor, textColor: .blue)
    }
}
