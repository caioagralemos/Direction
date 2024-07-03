//
//  ContentView.swift
//  Direction
//
//  Created by Caio on 01/07/24.
//

import CoreML
import SwiftUI

struct DirBtn: ViewModifier {
    func body(content: Content) -> some View {
            return content.font(.headline.bold()).foregroundStyle(.secondary).padding().background(.background).clipShape(.rect(cornerRadius: 5)).padding(.horizontal)
        }
}

extension View {
    func dirbtn() -> some View {
        self.modifier(DirBtn())
    }
}

struct ContentView: View {
    @State private var direction = 0
    @State private var comment = ""
    @FocusState private var isFocused: Bool
    var body: some View {
        ZStack {
            LinearGradient(stops: [
                .init(color: .red.opacity(0.5), location: 0.45),
                //.init(color: .white, location: 0.5),
                .init(color: .blue.opacity(0.5), location: 0.55)
            ], startPoint: .leading, endPoint: .trailing).ignoresSafeArea().onTapGesture {
                isFocused = false
            }
            VStack {
                Text("Direction").font(.largeTitle.bold()).foregroundStyle(.secondary)
                VStack {
                    Text("Insert a comment or a opinion").bold().foregroundStyle(.secondary)
                    TextEditor(text: $comment).onChange(of: comment) {
                        askOracle()
                    }.frame(width: 300, height: 200).background(.thickMaterial).clipShape(.rect(cornerRadius: 10)).focused($isFocused)
                    
                    HStack {
                        Button("Delete") {
                            comment = ""
                        }.dirbtn()
                        Button("Paste") {
                            if let clipboardContent = UIPasteboard.general.string {
                                                comment += clipboardContent
                            }
                        }.dirbtn()

                    }
                }.padding(25).background(.thinMaterial).clipShape(.rect(cornerRadius: 20))
                
                Image(systemName: "arrowshape.up.fill").resizable().frame(width: 100, height: 120).foregroundStyle(.secondary).rotationEffect(.degrees(Double(direction))).padding(.top).animation(.easeInOut(duration: 1), value: direction)
            }
            
        }
    }
    
    func askOracle() {
        do {
            let config = MLModelConfiguration()
            let model = try iOracle(configuration: config)
            if comment == "" {
                direction = 0
            } else {
                let result = try model.prediction(text: comment)
                if result.label == "esquerda" {
                    direction = -90
                } else {
                    direction = 90
                }
            }
        } catch {
            print("Algo deu errado")
        }
    }
}

#Preview {
    ContentView()
}
