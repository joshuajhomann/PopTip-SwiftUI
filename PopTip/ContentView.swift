//
//  ContentView.swift
//  PopTip
//
//  Created by Joshua Homann on 8/1/20.
//

import SwiftUI

struct ContentView: View {
  @State private var showPopTip: Bool = false
  var body: some View {
    VStack(spacing: 40) {
      Text("Hello, World!")
        .popTip(isHidden: showPopTip) {
          Label("very bad 💩 happened!", systemImage: "exclamationmark.circle.fill")
            .font(.title)
        }
        .popTipStyle(.error)
      Text("Hello, World!")
      Text("Hello, World!") 
        .popTip(text: "The quick brown fox jumped over the lazy dog", isHidden: showPopTip)
      Text("Hello, World!")
      Text("Hello, World!")
      Button("toggle") {
        withAnimation(Animation.spring(dampingFraction: 0.5).speed(2)) {
          showPopTip.toggle()
        }
      }
    }
  }
}


struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
