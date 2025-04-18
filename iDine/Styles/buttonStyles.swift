//
//  styles.swift
//  iDine
//
//  Created by Zhuo on 2025/4/18.
//

import SwiftUI

struct ShadowButtonStyle: ButtonStyle {
    let radius: CGFloat

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .foregroundColor(configuration.isPressed ? .gray : .white)
            .background(
                Capsule()
                    .fill(
                        .shadow(
                            configuration.isPressed ?
                                .inner(radius: radius) :
                                .drop(radius: radius)
                        )
                    )
                    .foregroundStyle(
                        .linearGradient(
                            colors: configuration.isPressed ? [.blue, .purple] : [.orange, .red],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            )
            .animation(.default, value: configuration.isPressed)
    }
}

extension ShadowButtonStyle{
    static func shadow(radius: CGFloat) -> ShadowButtonStyle{
        ShadowButtonStyle(radius: radius)
    }
}
