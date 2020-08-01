//
//  EnvirontmentKeys.swift
//  PopTip
//
//  Created by Joshua Homann on 8/1/20.
//

import SwiftUI

struct PopTipStyleKey: EnvironmentKey {
  static let defaultValue: PopTipStyle = PopTipStyle()
}

extension EnvironmentValues {
  var popTipStlye: PopTipStyle {
    get { self[PopTipStyleKey.self] }
    set { self[PopTipStyleKey.self] = newValue }
  }
}
