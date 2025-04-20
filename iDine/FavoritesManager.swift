//
//  FavoritesManager.swift
//  iDine
//
//  Created by Zhuo on 2025/4/20.
//

import Foundation
import Combine

class FavoritesManager: ObservableObject{
//    使用set存储收藏的菜品ID
    @Published private(set) var favoritedItemIDs = Set<UUID>()

    init(){
        loadFavorites()
    }

//    judge if the item is favorited yet
    func isFavorited(item: MenuItem) -> Bool{
        favoritedItemIDs.contains(item.id)
    }

    // 为了兼容性保留旧方法名
    func isFavoried(item: MenuItem) -> Bool{
        return isFavorited(item: item)
    }

//    toggle the states
    func toggleFavorite(for item: MenuItem){
        if isFavorited(item: item){
            favoritedItemIDs.remove(item.id)
        }else{
            favoritedItemIDs.insert(item.id)
        }
        saveFavorites()
    }

//    save data to userDefaults
    private func   saveFavorites(){
        let favoriteIDString = favoritedItemIDs.map{$0.uuidString}
        UserDefaults.standard.set(favoriteIDString, forKey: "favoritedItems")
    }

//    load data from userDefaults
    private func loadFavorites(){
        if let favoritedIDStrings = UserDefaults.standard.stringArray(forKey: "favoritedItems"){
            favoritedItemIDs = Set(favoritedIDStrings.compactMap{
                UUID(uuidString: $0)
            })
        }
    }
}
