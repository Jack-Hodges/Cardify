//
//  ContentView.swift
//  Cardify
//
//  Created by Jack Hodges on 29/3/2024.
//

import SwiftUI

struct ContentView: View {
    
    let appColor = Color(red: 203/255, green: 239/255, blue: 247/255)
    let appTextColor = Color(red: 87/255, green: 170/255, blue: 189/255)
    var subjects: [Subject]
    
    var body: some View {
        NavigationStack {
            ZStack {
                appColor
                    .ignoresSafeArea(edges: .all)
                
                VStack {
                    
                    topIcons
                        .padding(.horizontal, 20)
                    
                    Spacer()
                    
                    VStack {
                        HStack {
                            Text("Your subjects")
                            
                            Spacer()
                            
                            Button(action: {
                                
                            }) {
                                HStack {
                                    Text("View all")
                                    Image(systemName: "arrow.right")
                                }
                                .foregroundStyle(appTextColor)
                                
                            }
                        }
                        .padding(.horizontal, 20)
                        .bold()
                        .font(.title3)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 20) {
                                ForEach(Array(subjects.enumerated()), id: \.element.id) { index, subject in
                                    
                                    NavigationLink(destination: SubjectView(subject: subject, appColor: appColor, textColor: appTextColor)) {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 20)
                                                .fill(.white)
                                                .shadow(radius: 5)
                                            VStack {
                                                Spacer()
                                                HStack() {
                                                    Text(subject.name)
                                                        .font(.title)
                                                        .foregroundStyle(appTextColor)
                                                    Spacer()
                                                }
                                                .padding()
                                            }
                                        }
                                        .frame(width: 200, height: 250)
                                        // add conditional padding
                                        .padding(.leading, index == 0 ? 20 : 0)
                                        .padding(.trailing, index == subjects.count - 1 ? 20 : 0)
                                    .padding(.vertical, 10)
                                    }
                                }
                            }
                        }
                    }
                    
                    Spacer()
                    
                }
            }
            
        }
    }
    
    private var topIcons: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Hello Jack!")
                    .font(.largeTitle)
                    .bold()
                Text("15 🔥")
                    .font(.title3)
            }
            Spacer()
            
            Button(action: {
                
            }) {
                ZStack {
                    Circle()
                        .foregroundStyle(.black)
                    Text("🤩")
                        .font(.largeTitle)
                }
                .frame(width: 65, height: 65)
            }
        }
    }
}


#Preview {
    ContentView(subjects: Subject.samples)
        .modelContainer(for: Item.self, inMemory: true)
}
