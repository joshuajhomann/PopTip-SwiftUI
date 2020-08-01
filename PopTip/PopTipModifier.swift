//
//  PopTipModifier.swift
//  PopTip
//
//  Created by Joshua Homann on 8/1/20.
//

import SwiftUI

fileprivate enum Constant {
  static let triangleLength:CGFloat = 8
  static let triangleHieght:CGFloat = sqrt(64+16)
}

struct PopTipStyle {
  var foregroundColor: Color = Color(.systemBackground)
  var backgroundColor: Color = .accentColor
  var margin: CGFloat = 20
  var cornerRadius: CGFloat = 10
  var maxWidth: CGFloat = 200
}

extension PopTipStyle {
  static let `default` = PopTipStyle()
  static let error = PopTipStyle(
    foregroundColor: Color(.systemBackground),
    backgroundColor: Color(.systemRed),
    margin: 20,
    cornerRadius: 4,
    maxWidth: 250
  )
}

struct PopTipModifier<Label: View>: ViewModifier {

  @State private var popTipFrame: CGRect = .zero
  @State private var contentFrame: CGRect = .zero
  @Environment(\.popTipStlye) private var style

  private struct PopTipSizePreferenceKey: DictionaryPreferenceKey {
    typealias Key = UUID
    typealias DictionaryValue = CGRect
  }

  private let label: () -> Label
  private let popTipId: UUID
  private let contentId: UUID
  private var scale: CGFloat

  init(isHiddden: Bool, @ViewBuilder label: @escaping () -> Label) {
    self.label = label
    popTipId = UUID()
    contentId = UUID()
    scale = isHiddden ? 0 :  1
  }

  func body(content: Content) -> some View {
    content
      .measureFrame(
        storeIn: PopTipSizePreferenceKey.self,
        setPreference: { [self.contentId: $0 ] }
      )
      .overlay(
        ZStack {
          Path { path in
            path.addRoundedRect(in: popTipFrame, cornerSize: .init(width: style.cornerRadius, height: style.cornerRadius))
            path.move(to: .init(x: popTipFrame.midX - Constant.triangleLength, y: popTipFrame.maxY))
            path.addLine(to: .init(x: popTipFrame.midX, y: popTipFrame.maxY + Constant.triangleHieght))
            path.addLine(to: .init(x: popTipFrame.midX + Constant.triangleLength, y: popTipFrame.maxY))
            path.closeSubpath()
          }
          .foregroundColor(style.backgroundColor)
          .shadow(color: Color.gray, radius: 2, x: 1, y: 1)
          label()
            .foregroundColor(style.foregroundColor)
            .measureFrame(
              storeIn: PopTipSizePreferenceKey.self,
              setPreference: { [self.popTipId: $0 ] }
            )
            .frame(maxWidth: style.maxWidth)
        }
        .offset(.init(width: 0, height: -0.5 * (popTipFrame.height + contentFrame.height + Constant.triangleHieght*2)))
        .frame(width: popTipFrame.width, height: popTipFrame.height)
        .scaleEffect(.init(width: scale, height: scale), anchor: .center)
      )
      .onPreferenceChange(PopTipSizePreferenceKey.self) { key in
        popTipFrame = (key[popTipId] ?? .zero)
          .insetBy(dx: -style.margin, dy: -style.margin)
          .applying(.init(translationX: style.margin, y: style.margin))
        contentFrame = (key[contentId] ?? .zero)
      }
  }
}

extension View {
  func popTip<Label: View>(isHidden: Bool = false, @ViewBuilder label: @escaping () -> Label) -> some View {
    modifier(PopTipModifier(isHiddden: isHidden, label: label))
  }

  func popTip(text: String, isHidden: Bool = false) -> some View {
    popTip(isHidden: isHidden) { Text(text) }
  }
}
