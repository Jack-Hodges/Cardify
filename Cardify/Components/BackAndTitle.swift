//
//  BackAndTitle.swift
//  Cardify
//
//  Created by Jack Hodges on 3/5/2024.
//

import SwiftUI

// Subject title and back chevron
func BackAndTitle(color: Color, title: String) -> some View {
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
    }
    .padding(.top)
    .padding(.trailing, 35)
    .padding(.leading, 10)
}
