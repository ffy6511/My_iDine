//
//  HeartParticleEffect.swift
//  iDine
//
//  Created by Zhuo on 2025/4/18.
//

import SwiftUI

struct HeartParticle: Identifiable {
    let id = UUID()
    var position: CGPoint
    var scale: CGFloat
    var opacity: Double
    var rotation: Double
    var color: Color
}

struct HeartParticleEffect: View {
    @State private var particles: [HeartParticle] = []
    @Binding var isActive: Bool

    // 添加固定大小
    let size: CGSize = CGSize(width: 40, height: 40)

    func generateParticles() {
        // 清空现有粒子
        particles = []

        // 生成新粒子
        for _ in 0..<15 {
            let randomAngle = Double.random(in: 0..<2*Double.pi)
            let randomDistance = CGFloat.random(in: 10...50)
            let position = CGPoint(
                x: randomDistance * CGFloat(cos(randomAngle)),
                y: randomDistance * CGFloat(sin(randomAngle))
            )

            let particle = HeartParticle(
                position: position,
                scale: CGFloat.random(in: 0.2...0.5),
                opacity: 1.0,
                rotation: Double.random(in: 0...360),
                color: [.red, .pink, .orange].randomElement()!
            )

            particles.append(particle)
        }
    }

    var body: some View {
        ZStack {
            // 空视图作为占位符，确保ZStack大小固定
            Color.clear
                .frame(width: size.width, height: size.height)

            ForEach(particles) { particle in
                Image(systemName: "heart.fill")
                    .foregroundColor(particle.color)
                    .scaleEffect(particle.scale)
                    .opacity(particle.opacity)
                    .rotationEffect(.degrees(particle.rotation))
                    .position(
                        x: size.width/2 + particle.position.x,
                        y: size.height/2 + particle.position.y
                    )
            }
        }
        // 使用overlay而不是直接放在ZStack中，这样不会影响父视图布局
        .allowsHitTesting(false) // 禁止粒子接收点击事件
        .onChange(of: isActive) { newValue in
            if newValue {
                generateParticles()

                // 为每个粒子添加动画
                for index in particles.indices {
                    withAnimation(.easeOut(duration: 1.0)) {
                        particles[index].position.x *= 2
                        particles[index].position.y *= 2
                        particles[index].opacity = 0
                        particles[index].scale *= 0.5
                    }
                }

                // 重置触发器
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isActive = false
                }
            }
        }
    }
}

struct FavoriteButton: View {
    @ObservedObject var favoritesManager: FavoritesManager
    @State private var triggerEffect = false
    let item: MenuItem

    var body: some View {
        Button(action: {
            let wasFavorited = favoritesManager.isFavorited(item: item)
            favoritesManager.toggleFavorite(for: item)

            // 只有在添加收藏时触发效果，取消收藏时不触发
            if !wasFavorited {
                triggerEffect = true
            }
        }) {
            Image(systemName: favoritesManager.isFavorited(item: item) ? "heart.fill" : "heart")
                .foregroundColor(.red)
                .font(.system(size: 22))
                .padding(8)
                .background(Circle().fill(Color.white.opacity(0.8)))
        }
        .overlay(
            // 添加粒子效果作为按钮的覆盖层，不影响按钮布局
            HeartParticleEffect(isActive: $triggerEffect)
        )
    }
}
