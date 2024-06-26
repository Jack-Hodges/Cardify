import SwiftUI

struct LessonView: View {
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    let appPrimary = Color.white
    @State private var progressValue: Double = 0.8
    @ObservedObject var subject: Subject
    var appColor: Color
    var textColor: Color
    @State private var correct = 0
    @State private var incorrect = 0
    @State private var cardCount: Int

    init(subject: Subject, appColor: Color, textColor: Color) {
        self._subject = ObservedObject(wrappedValue: subject)
        self._cardCount = State(initialValue: subject.cards.count)
        self.appColor = appColor
        self.textColor = textColor
    }

    var body: some View {
        ZStack {
            if subject.cards.count > 0 {
                ZStack {
                    Rectangle()
                        .fill(appColor)
                        .ignoresSafeArea()
                    
                    VStack {
                        progressIndicator(totalCards: cardCount)
                        
                        Spacer()

                        cardStack
                        
                        Spacer()
                    }
                    
                    visualDragFeedback
                }
            } else {
                ZStack {
                    Rectangle()
                        .fill(appColor)
                        .ignoresSafeArea()
                    
                    VStack {
                        Spacer()
                        
                        let total = Double(correct + incorrect)
                        let percentage = total == 0 ? 0 : Double(correct) / total * 100
                        
                        Text("\(percentage, specifier: "%.0f")% correct")
                            .font(.system(size: 45))
                            .bold()
                            .foregroundStyle(textColor)
                        
                        Text(emojiForPercentage(percentage))
                            .font(.system(size: 180))
                            .foregroundStyle(textColor)
                        
                        Spacer()
                        
                        HStack(spacing: 30) {
                            Button(action: {
                                // Add action for review
                            }) {
                                BottomButton(str: "Review")
                            }
                            
                            Button(action: {
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                BottomButton(str: "Finish")
                            }
                        }
                    }
                    .padding(.bottom, 30)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title)
                        .bold()
                        .foregroundStyle(textColor)
                }
            }
            ToolbarItem(placement: .principal) {
                Text(subject.name)
                    .font(.largeTitle)
                    .bold()
                    .foregroundStyle(textColor)
            }
        }
    }
    
    private func emojiForPercentage(_ percentage: Double) -> String {
        switch percentage {
        case 90...:
            return "🤩"
        case 70..<90:
            return "😀"
        case 50..<70:
            return "🙂"
        case 30..<50:
            return "😯"
        default:
            return "💤"
        }
    }
    
    private func BottomButton(str: String) -> some View {
        ZStack {
            Rectangle()
                .frame(width: 150, height: 50)
                .foregroundColor(textColor)
                .cornerRadius(25)
            Text(str)
                .font(.title)
                .bold()
                .foregroundStyle(.white)
        }
    }
    
    private func scaleForCard(at index: Int) -> CGFloat {
        let baseScale: CGFloat = 1.05
        let scaleDecrement: CGFloat = 0.05 * CGFloat(subject.cards.count - index)
        return baseScale - scaleDecrement
    }
    
    private var cardStack: some View {
        ZStack {
            if subject.cards.isEmpty {
                Text("No more")
            } else {
                ForEach(Array(subject.cards.enumerated()), id: \.element.id) { index, card in
                    ZStack {
                        CardView(card: card)
                            .offset(card.dragOffset)
                            .rotationEffect(.degrees(Double(card.dragOffset.width / 30)))
                            .scaleEffect(scaleForCard(at: index))
                            .zIndex(-Double(index))
                            .animation(.spring(response: 0.3, dampingFraction: 0.6, blendDuration: 0), value: card.dragOffset)
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        if subject.cards.indices.contains(index) {
                                            subject.cards[index].dragOffset = value.translation
                                        }
                                    }
                                    .onEnded { value in
                                        if subject.cards.indices.contains(index) {
                                            if value.translation.width > 100 {
                                                withAnimation {
                                                    correct += 1
                                                    subject.cards.remove(at: index)
                                                }
                                            } else if value.translation.width < -100 {
                                                withAnimation {
                                                    incorrect += 1
                                                    subject.cards.remove(at: index)
                                                }
                                            } else {
                                                withAnimation {
                                                    subject.cards[index].dragOffset = .zero
                                                }
                                            }
                                        }
                                    }
                            )
                    }
                }
            }
        }
    }

    private func progressIndicator(totalCards: Int) -> some View {
        let currentCardIndex = totalCards - subject.cards.filter { $0 != subject.cards.last }.count
        let progressText = "\(currentCardIndex)/\(totalCards)"
        let completedPercentage = Double(currentCardIndex) / Double(totalCards)
        
        return VStack {
            HStack {
                Spacer()
            }
            .padding(.trailing, 45)
            
            ColouredProgressBar(progress: .constant(completedPercentage), colour: appColor, backgroundCol: textColor)
                .frame(width: 300, height: 5)
                .padding(.trailing, 10)
                
            HStack {
                Text(progressText)
                    .foregroundStyle(textColor)
                    .bold()
                    .font(.title3)
                Spacer()
                Text("\(Int(completedPercentage * 100))% completed")
                    .foregroundStyle(textColor)
                    .bold()
                    .font(.title3)
            }
            .padding(.top, 10)
            .padding(.trailing, 45)
            .padding(.leading, 45)
        }
    }
    
    private var visualDragFeedback: some View {
        VStack {
            Spacer()
            if let lastCard = subject.cards.last, lastCard.dragOffset.width < -80 {
                ZStack {
                    Circle()
                        .fill(textColor)
                        .frame(width: 75, height: 75)
                        .scaleEffect(lastCard.dragOffset.width < -80 ? 1 : 0)
                        .opacity(lastCard.dragOffset.width < -80 ? 1 : 0)
                        .animation(.easeInOut(duration: 0.2), value: lastCard.dragOffset.width)
                    Image(systemName: "x.circle")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .bold()
                }
                .shadow(radius: 10)
            }
            
            if let lastCard = subject.cards.last, lastCard.dragOffset.width > 80 {
                ZStack {
                    Circle()
                        .fill(textColor)
                        .frame(width: 75, height: 75)
                        .scaleEffect(lastCard.dragOffset.width > 80 ? 1 : 0)
                        .opacity(lastCard.dragOffset.width > 80 ? 1 : 0)
                        .animation(.easeInOut(duration: 0.2), value: lastCard.dragOffset.width)
                    Image(systemName: "checkmark")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .bold()
                }
                .shadow(radius: 10)
            }
        }
        .padding(.bottom, 30)
    }
}

#Preview {
    LessonView(subject: Subject.samples[0], appColor: .blue, textColor: .red)
}
