//
//  FavoritesView.swift
//  iDine
//
//  Created by Zhuo on 2025/4/20.
//

import SwiftUI

struct FavoritesView: View {
    
    @EnvironmentObject var favoritesManager: FavoritesManager
    
    let menu = Bundle.main.decode([MenuSection].self, from: "menu.json")
    
//    获取所有收藏的菜品
    var favoritedItems:[MenuItem]{
        let allItems = menu.flatMap{$0.items}
        return allItems.filter{favoritesManager.isFavoried(item:$0)}
    }
    
    var body: some View {
            NavigationStack {
                if favoritedItems.isEmpty {
                    VStack {
                        Image(systemName: "heart.slash")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                            .padding()
                        
                        Text("您还没有收藏任何菜品")
                            .font(.title2)
                            .foregroundColor(.gray)
                        
                        Text("浏览菜单并点击❤️来添加收藏")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .padding()
                    }
                    .navigationTitle("收藏")
                } else {
                    List {
                        ForEach(favoritedItems) { item in
                            NavigationLink(value: item) {
                                ItemRow(item: item)
                            }
                        }
                    }
                    .navigationDestination(for: MenuItem.self) { item in
                        ItemDetail(item: item)
                    }
                    .navigationTitle("收藏")
                    .listStyle(.insetGrouped)
                }
            }
        }
}

#Preview {
    FavoritesView()
        .environmentObject(FavoritesManager())
}
