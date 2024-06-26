//
//  SubjectView.swift
//  Cardify
//
//  Created by Jack Hodges on 3/5/2024.
//

import SwiftUI

struct SubjectView: View {
    
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    @ObservedObject var subject: Subject
    var appColor: Color
    var textColor: Color
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    
    @State private var editingMode = false
    @State private var showingRemovalAlert = false
    @State private var cardToRemove: Card?

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    NavigationLink(destination: LessonView(subject: subject, appColor: appColor, textColor: textColor), label: {
                        Image(systemName: "play.circle.fill")
                            .foregroundStyle(textColor)
                            .font(.system(size: 100))
                            .padding(.leading, -10)
                    })
                    
                    Spacer()
                    
                    Button(action: {
                        editingMode.toggle()
                    }, label: {
                        Text(editingMode ? "Done" : "Edit")
                            .bold()
                            .foregroundStyle(textColor)
                    })
                }
                .padding(.top, 20)
                .padding(.horizontal, 20)
                .padding(.bottom, -10)
                    
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(subject.cards) { card in
                            NavigationLink(destination: EditCardView(card: card, appColor: appColor, textColor: textColor)) {
                                MiniCardView(card: card)
                                    .overlay(
                                        Button(action: {
                                            cardToRemove = card
                                            showingRemovalAlert = true
                                        }) {
                                            Image(systemName: "minus.circle.fill")
                                                .foregroundColor(.red)
                                                .font(.system(size: 40))
                                                .padding(.leading, -15)
                                                .padding(.top, -10)
                                        }
                                        .opacity(editingMode ? 1 : 0),
                                        alignment: .topLeading
                                    )
                            }
                        }
                    }
                    .padding()
                }
            }
            .background(appColor)
            .alert("Remove Card", isPresented: $showingRemovalAlert) {
                Button("Remove", role: .destructive) {
                    if let card = cardToRemove, let index = subject.cards.firstIndex(where: { $0.id == card.id }) {
                        subject.cards.remove(at: index)
                    }
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Are you sure you want to remove this card?")
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(content: {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "chevron.left")
                        .font(.title)
                        .bold()
                        .foregroundStyle(textColor)
                })
            }
            ToolbarItem(placement: .principal) {
                Text(subject.name)
                    .font(.largeTitle)
                    .bold()
                    .foregroundStyle(textColor)
            }
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink(destination: AddCardView(card: Card(), subject: subject, appColor: appColor, textColor: textColor)) {
                    Image(systemName: "plus")
                        .font(.title)
                        .bold()
                        .foregroundStyle(textColor)
                }
            }
        })
    }
}

#Preview {
    SubjectView(subject: Subject.samples[0], appColor: Color.blue, textColor: Color.white)
}
