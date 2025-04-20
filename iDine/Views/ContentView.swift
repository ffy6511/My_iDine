//
//  ContentView.swift
//  iDine
//
//  Created by Paul Hudson on 08/02/2021.
//

import SwiftUI

struct ContentView: View {
    let menu = Bundle.main.decode([MenuSection].self, from: "menu.json")
    @State private var searchText = ""

    // 保持原有的分类结构，但过滤菜品
    var filteredMenu: [MenuSection] {
        if searchText.isEmpty {
            return menu
        } else {
            return menu.compactMap { section in
                let matchedItems = section.items.filter { item in
                    item.name.lowercased().contains(searchText.lowercased()) ||
                    item.description.lowercased().contains(searchText.lowercased())
                }

                if matchedItems.isEmpty {
                    return nil
                } else {
                    return MenuSection(id: section.id, name: section.name, items: matchedItems)
                }
            }
        }
    }

    // 用于搜索建议的扁平菜品列表
    var filteredItems: [MenuItem] {
        if searchText.isEmpty {
            return []
        } else {
            return menu.flatMap { $0.items }.filter { item in
                item.name.lowercased().contains(searchText.lowercased()) ||
                item.description.lowercased().contains(searchText.lowercased())
            }
        }
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredMenu) { section in
                    Section(section.name) {
                        ForEach(section.items) { item in
                            NavigationLink(value: item) {
                                ItemRow(item: item)
                            }
                        }
                    }
                }
            }
            .navigationDestination(for: MenuItem.self) { item in
                ItemDetail(item: item)
            }
            .navigationTitle("Menu")
            .listStyle(.grouped)
            .searchable(text: $searchText, prompt: "Search Menu")
            // .searchSuggestions {
            //     if !searchText.isEmpty {
            //         ForEach(filteredItems) { item in
            //             Text(item.name).searchCompletion(item.name)
            //         }
            //     }
            // }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
