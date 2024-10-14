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

enum AppColor: String, CaseIterable {
    case blue, red, green, cyan, yellow, purple
    
    var color: Color {
        switch self {
        case .blue: return .blue
        case .red: return .red
        case .green: return .green
        case .cyan: return .cyan
        case .yellow: return .yellow
        case .purple: return .purple
        }
    }
}


struct ContentView: View {
    @AppStorage("points") var points: Int = 0
    @AppStorage("fontSizeDouble") var fontSizeDouble: Double = 16.0 // Store as Double
    @AppStorage("systemColor") var systemColor: String = AppColor.blue.rawValue // Store color as String
       
    
    @State private var fontSize: CGFloat = 16.0 // Use CGFloat in UI
    //@State private var systemColor: Color = .blue // Default color
    @State private var operand1: Int = 0
    @State private var operand2: Int = 0
    @State private var operation: MathOperation = .addition
    @State private var guessedAnswer: String = ""
    @State private var correctAnswer: Int = 0
    @State private var resultMessage: String = ""
    @State private var showAlert = false
    @State private var questionSubmitted = false
    @State private var resultImage: String = ""

    
    var body: some View {
        TabView {
            VStack {
                Text("Guess the answer!")
                    .foregroundColor(AppColor(rawValue: systemColor)?.color ?? .cyan) // Set color based on user selection
                    .fontWeight(.bold)
                    .font(.title)
                    .padding(.top, 20)
                
                
                Text("What is \(operand1) \(operation.rawValue) \(operand2) = ?")
                    .fontWeight(.bold)
                    .font(.system(size: 22)) // Set font size to 30 or any desired value
                    .foregroundColor(AppColor(rawValue: systemColor)?.color ?? .cyan) // Set color based on user selection
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
                
//                Text(resultMessage)
//                    .font(.system(size: fontSize))
//                    .padding()
                
                if questionSubmitted {
                    HStack {
                        Image(systemName: resultImage) // Display the corresponding system image
                            .foregroundColor(resultImage == "checkmark.circle.fill" ? .green : .red)
                            .font(.system(size: 24)) // Adjust the size of the image
                        
                        Text(resultMessage) // Display the result message
                            .font(.headline)
                            .foregroundColor(resultImage == "checkmark.circle.fill" ? .green : .red) // Change text color
                    }
                    .padding()
                }

                
                
                VStack {
                    // Center the title
                    Text("Instructions")
                        .font(.system(size: CGFloat(fontSize))) // Use the font size from settings
                        .font(.title) // Larger title font
                        .padding(.top, 5)
                        .padding(.bottom,1)
                        .multilineTextAlignment(.center) // Center-align title
                    
                    // Description
                    Text("Submit the correct answer and gain 1 point.Submit a wrong answer or press on 'NEXT' and you will lose 1 point.")
                        .font(.system(size: CGFloat(fontSize))) // Use the font size from settings
                        .padding(.top, 10) // Padding between title and description
                        .lineLimit(nil) // Allows text to wrap to the next line
                        .multilineTextAlignment(.center) // Justify-like effect by aligning leading
                        .fixedSize(horizontal: false, vertical: true) // Ensure text grows vertically
                }
                .padding(.horizontal)



               
                Button("Next") {
                    // Check if the question has been submitted
                    if questionSubmitted {
                        // Reset input and state for the next question
                        guessedAnswer = ""
                        questionSubmitted = false
                        resultMessage = ""
                        resultImage = ""

                        // Generate a new question
                        generateNewQuestion()
                    } else {
                        // If the question wasn't submitted, decrement the points
                      
                            points -= 1 // Decrease points by 1
                        
                        resultMessage = "You lose 1 point for skipping the question."
                        resultImage = "xmark.circle.fill"

                        // Reset for the next question
                        guessedAnswer = ""
                        questionSubmitted = false
                    }
                }
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)

                //.disabled(!questionSubmitted) // Disable until the current question is answered
                Spacer()
            }
            .onAppear(perform: generateNewQuestion)
            .tabItem {
                Label("Guess", systemImage: "checkmark.circle.badge.questionmark.fill")
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Invalid Input"), message: Text("Please enter a numeric answer."), dismissButton: .default(Text("OK")))
            }
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear.circle.fill")
                }
        }
        .accentColor(AppColor(rawValue: systemColor)?.color ?? .cyan) // Set color based on user selection
       //.accentColor(systemColor)
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
            resultImage = "checkmark.circle.fill"
        } else {
             points -= 1
            resultMessage = "Incorrect. The correct answer is \(correctAnswer)."
            resultImage = "xmark.circle.fill"
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
