import SwiftUI

struct ContentView: View {
    @State private var inputText: String = ""
    @State private var results: String = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Analizador de Ansiedad y Depresión")
                    .font(.headline)
                    .padding()

                TextEditor(text: $inputText)
                    .frame(height: 150)
                    .border(Color.gray, width: 1)
                    .cornerRadius(8)
                    .padding()

                Button(action: analyzeText) {
                    Text("Analizar")
                        .font(.title2)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()

                Text("Resultados:")
                    .font(.headline)
                    .padding(.top)

                ScrollView {
                    Text(results)
                        .padding()
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Keyword Analyzer")
        }
    }
    
    func analyzeText() {
        let anxietyKeywordsWithWeights: [String: Double] = [
            "ansiedad": 1.5, "preocupado": 1.2, "nervioso": 1.3,
            "estresado": 1.4, "inquieto": 1.1, "temor": 1.7, "pánico": 2.0
        ]
        let depressionKeywordsWithWeights: [String: Double] = [
            "depresión": 2.0, "triste": 1.0, "abatido": 1.8,
            "desesperanza": 2.5, "fatiga": 1.6, "soledad": 1.8, "inútil": 2.2
        ]
        
        let cleanText = inputText.lowercased()
        let anxietyScore = weightedCountKeywords(in: cleanText, keywordsWithWeights: anxietyKeywordsWithWeights)
        let depressionScore = weightedCountKeywords(in: cleanText, keywordsWithWeights: depressionKeywordsWithWeights)
        
        let anxietyLikert = calculateLikertScale(weightedScore: anxietyScore, type: "Ansiedad")
        let depressionLikert = calculateLikertScale(weightedScore: depressionScore, type: "Depresión")
        
        results = """
        Ansiedad Escala Likert: \(String(format: "%.2f", anxietyLikert))
        Depresión Escala Likert: \(String(format: "%.2f", depressionLikert))
        """
    }
    
    func weightedCountKeywords(in text: String, keywordsWithWeights: [String: Double]) -> Double {
        var totalWeight = 0.0

        for (keyword, weight) in keywordsWithWeights {
            let occurrences = text.components(separatedBy: keyword).count - 1
            totalWeight += Double(occurrences) * weight
        }

        return totalWeight
    }
    
    func calculateLikertScale(weightedScore: Double, type: String) -> Double {
        switch weightedScore {
        case 0..<1.5:
            return 1.00
        case 1.5..<3.0:
            return 3.00
        case 3.0..<5.0:
            return 5.00
        case 5.0...:
            return 7.00
        default:
            return 1.00
        }
    }
}
