//
//  MeasureModifier.swift
//  PopTip
//
//  Created by Joshua Homann on 8/1/20.
//

import SwiftUI

struct MeasureFrameModifier<Preference: PreferenceKey>: ViewModifier {
  private let setPreference: (CGRect) -> Preference.Value
  init(storeIn: Preference.Type, setPreference: @escaping (CGRect) -> Preference.Value) {
    self.setPreference = setPreference
  }
  func body(content: Content) -> some View {
    content
      .overlay(GeometryReader { geometry in
        Rectangle()
          .hidden()
          .preference(key: Preference.self, value: self.setPreference(geometry.frame(in: .local)))
      })
  }
}

extension View {
  func measureFrame<Preference: PreferenceKey>(
    storeIn: Preference.Type,
    setPreference: @escaping (CGRect) -> Preference.Value
  ) -> some View {
    modifier(MeasureFrameModifier(storeIn: storeIn, setPreference: setPreference))
  }
}

extension View {
  func popTipStyle(_ style: PopTipStyle) -> some View {
    environment(\.popTipStlye, style)
  }
}
