//
//  ContentView.swift
//  Fun_math_game
//
//  Created by Thushini Abeysuriya on 2024-10-14.
//

import SwiftUI

import SwiftUI

enum MathOperation: String, CaseIterable {
    case addition = "+"
    case subtraction = "-"
    case multiplication = "*"
    case division = "/"
    
    static func randomOperation() -> MathOperation {
        return MathOperation.allCases.randomElement()!
    }
}

struct ContentView: View {
    @AppStorage("points") var points: Int = 0
    @AppStorage("fontSizeDouble") var fontSizeDouble: Double = 16.0 // Store as Double
    @AppStorage("systemColorString") var systemColorString: String = "blue" // Store color as String
    @State private var fontSize: CGFloat = 16.0 // Use CGFloat in UI
    @State private var systemColor: Color = .blue // Default color
    @State private var operand1: Int = 0
    @State private var operand2: Int = 0
    @State private var operation: MathOperation = .addition
    @State private var guessedAnswer: String = ""
    @State private var correctAnswer: Int = 0
    @State private var resultMessage: String = ""
    @State private var showAlert = false
    @State private var questionSubmitted = false
    
    var body: some View {
        TabView {
            VStack {
                Text("Guess the answer!")
                    .foregroundColor(.cyan)
                    .fontWeight(.bold)
                    .font(.title)
                    .padding(.top, 20)
                
                
                Text("What is \(operand1) \(operation.rawValue) \(operand2) = ?")
                    .fontWeight(.bold)
                    .font(.system(size: 22)) // Set font size to 30 or any desired value
                    .foregroundColor(systemColor)
                    .padding()
                
                HStack {
                    TextField("Enter your answer", text: $guessedAnswer)
                        .keyboardType(.asciiCapable)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .disabled(questionSubmitted)
                    
                    Button("Submit") {
                        submitAnswer()
                    }
                    .disabled(questionSubmitted || guessedAnswer.isEmpty)
                    .padding(.all,8)
                    .background(.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding() // Padding inside the border
                .overlay(
                    RoundedRectangle(cornerRadius: 1)
                        .stroke(Color.gray, lineWidth: 2) // The border color and width
                )
                .padding(.horizontal) // Padding outside the border

                
                
                Text("\(points)")
                    .fontWeight(.bold)
                    .font(.system(size: 100))
                    .font(.title)
                    .padding(.top, 2)
                    .padding(.bottom,10)
                
                Text(resultMessage)
                    .font(.system(size: fontSize))
                    .padding()
                
                
                VStack {
                    // Center the title
                    Text("Instructions")
                        .font(.title) // Larger title font
                        .padding(.top, 5)
                        .padding(.bottom,1)
                        .multilineTextAlignment(.center) // Center-align title
                    
                    // Description
                    Text("Submit the correct answer and gain 1 point.Submit a wrong answer or press on 'NEXT' and you will lose 1 point.")
                        .font(.system(size: 15)) // Smaller description font
                        .padding(.top, 10) // Padding between title and description
                        .lineLimit(nil) // Allows text to wrap to the next line
                        .multilineTextAlignment(.center) // Justify-like effect by aligning leading
                        .fixedSize(horizontal: false, vertical: true) // Ensure text grows vertically
                }
                .padding(.horizontal)



               
                
                Button("Next") {
                    generateNewQuestion()
                }
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
                
                Spacer()
            }
            .onAppear(perform: generateNewQuestion)
            .tabItem {
                Label("Game", systemImage: "gamecontroller")
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Invalid Input"), message: Text("Please enter a numeric answer."), dismissButton: .default(Text("OK")))
            }
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
       .accentColor(systemColor)
    }
    
    // Function to submit and check the user's answer
    func submitAnswer() {
        guard let userAnswer = Int(guessedAnswer) else {
            showAlert = true
            return
        }
        
        questionSubmitted = true
        if userAnswer == correctAnswer {
            points += 1
            resultMessage = "Congratulations! Correct answer."
        } else {
            if points > 0 { points -= 1 }
            resultMessage = "Incorrect. The correct answer is \(correctAnswer)."
        }
    }
    
    // Function to generate a new math question
    func generateNewQuestion() {
        operand1 = Int.random(in: 0...9)
        operand2 = Int.random(in: 1...9) // Avoid division by zero
        operation = MathOperation.randomOperation()
        
        switch operation {
        case .addition:
            correctAnswer = operand1 + operand2
        case .subtraction:
            correctAnswer = operand1 - operand2
        case .multiplication:
            correctAnswer = operand1 * operand2
        case .division:
            correctAnswer = operand1 / operand2
        }
        
        // Reset for the next question
        guessedAnswer = ""
        resultMessage = ""
        questionSubmitted = false
    }
}






#Preview {
    ContentView()
}
