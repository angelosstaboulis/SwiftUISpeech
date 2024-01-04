//
//  ContentView.swift
//  SwiftUISpeech
//
//  Created by Angelos Staboulis on 3/1/24.
//

import SwiftUI
struct ContentView: View {
    @State var editor:String
    var speech = SpeechHelper()
    var body: some View {
        VStack {
            Text("Phrase below").frame(width:300,height:45,alignment: .leading)
            Text(editor).frame(width:300,height:45)
            .background {
                Color.blue
            }
            Button {
                speech.speak{value in
                    editor = value
                }
            } label: {
                Text("Listen(speak in Greek Language)")
            }

        }
        .padding()
        .onAppear(perform: {
            speech.checkPermissions()
        })
    }

   
}

#Preview {
    ContentView(editor: "")
}
