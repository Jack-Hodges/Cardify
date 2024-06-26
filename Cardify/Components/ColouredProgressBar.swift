//
//  ColouredProgressBar.swift
//  Cardify
//
//  Created by Jack Hodges on 29/4/2024.
//

import SwiftUI

struct ColouredProgressBar: View {
    @Binding var progress: Double
    @State var colour: Color
    @State var backgroundCol: Color
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundColor(backgroundCol)
                    .frame(width: geometry.size.width + 10, height: geometry.size.height + 10)
                    .cornerRadius(100)
                
                Rectangle()
                    .foregroundColor(colour)
                    .frame(width: min(CGFloat(self.progress) * geometry.size.width, geometry.size.width),
                           height: geometry.size.height)
                    .cornerRadius(geometry.size.height / 2)
                    .padding(.leading, 5)
                    .animation(.easeInOut(duration: 0.5), value: progress)
            }
        }
    }
}
