//
//  PreferenceKeys.swift
//  PopTip
//
//  Created by Joshua Homann on 8/1/20.
//

import SwiftUI

protocol DictionaryPreferenceKey: PreferenceKey where Value == [Key : DictionaryValue] {
  associatedtype Key: Hashable
  associatedtype DictionaryValue
}

extension DictionaryPreferenceKey {
  static var defaultValue: Value { [:] }
  static func reduce(value: inout Value, nextValue: () -> Value) {
    nextValue().forEach { value[$0] = $1 }
  }
}
