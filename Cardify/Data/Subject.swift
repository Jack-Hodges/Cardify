import SwiftUI
//import Combine

class Subject: ObservableObject, Identifiable {
    var id: UUID
    @Published var name: String
    var subjectColor: Color
    @Published var cards: [Card]

    init(id: UUID = UUID(), name: String, subjectColor: Color, cards: [Card]) {
        self.id = id
        self.name = name
        self.subjectColor = subjectColor
        self.cards = cards
    }
}

// Define sample data for the subjects
struct SampleData {
    static let subjects: [Subject] = [
        Subject(
            name: "Mathematics",
            subjectColor: Color.purple,
            cards: [
                Card(),
                Card(),
                Card()
            ]
        ),
        Subject(
            name: "Physics",
            subjectColor: Color.orange,
            cards: [
                Card(),
                Card()
            ]
        ),
        Subject(
            name: "Chemistry",
            subjectColor: Color.purple,
            cards: [
                Card(),
                Card(),
                Card(),
                Card()
            ]
        ),
        Subject(
            name: "Literature",
            subjectColor: Color.green,
            cards: [
                Card(),
                Card()
            ]
        )
    ]
}

// Extend the `Subject` class to include this sample data
extension Subject {
    static var samples: [Subject] {
        return SampleData.subjects
    }
}
