//
//  ItemDetail.swift
//  iDine
//
//  Created by Paul Hudson on 08/02/2021.
//

import SwiftUI

struct ItemDetail: View {
    @EnvironmentObject var order: Order
    @EnvironmentObject var favoritesManager: FavoritesManager
    let item: MenuItem

    var body: some View {
        VStack {
            ZStack(alignment: .bottomTrailing) {
                Image(item.mainImage)
                    .resizable()
                    .scaledToFit()

                Text("Photo: \(item.photoCredit)")
                    .padding(4)
                    .background(Color.black)
                    .font(.caption)
                    .foregroundColor(.white)
                    .offset(x: -5, y: -5)
                

                
            }
            

            
//            HStack{
//                Spacer(minLength: 10)
//                
//                Text(item.description)
//                    .padding()
//                    .background(Color(.systemGray6))
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 10) // 10为圆角半径，可调整
//                            .stroke(Color.gray, lineWidth: 1) // 边框颜色和宽度
//                    )
//                    .clipShape(RoundedRectangle(cornerRadius: 10))
//                // 保证背景和边框都圆角
//                .frame(maxWidth: 400) // 最大宽度限制
//                
//                Spacer(minLength: 10)
//            }
            
            Text(item.description)
                .padding(.horizontal, 12) // 卡片内容内边距
                .padding(.vertical, 12)
                .background(Color(.systemGray6))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 1)
                )
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.horizontal, 10) // 整个卡片距离父视图左右20pt
                .padding(.vertical,20)

            
            
            
            
            HStack{
                Button("Order This") {
                    order.add(item: item)
                }
                .buttonStyle(ShadowButtonStyle(radius: 8))
                .buttonBorderShape(.roundedRectangle)
                .padding()
                
    //            添加收藏按钮
                Button(action:{
                    favoritesManager.toggleFavorite(for: item)
                }){
                    Image(systemName: favoritesManager.isFavoried(item: item) ? "heart.fill":"heart")
                        .foregroundColor(.red)
                        .padding(8)
                        .background(Circle().fill(Color.white.opacity(0.8)))
                }
                .padding()
            }
            
            Spacer()
        }
        .navigationTitle(item.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ItemDetail_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ItemDetail(item: MenuItem.example)
                .environmentObject(Order())
                .environmentObject(FavoritesManager())
        }
    }
}
