//
//  ShopDetailView.swift
//  HaraPeko
//
//  Created by 이재혁 on 6/21/26.
//
//  ③店舗詳細画面
//  写真・基本情報・地図・予約導線を表示
//

import SwiftUI
import MapKit
import CoreLocation

struct ShopDetailView: View {
    let shop: Shop
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) private var openURL
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                heroImage
                
                VStack(alignment: .leading, spacing: 0) {
                    nameSection
                    actionRow.padding(.top, 18)
                    infoCard.padding(.top, 20)
                    mapSection.padding(.top, 18)
                    
                    HotPepperCredit()
                        .padding(.top, 22)
                }
                .padding(.horizontal, 18)
                .padding(.bottom, 24)
                .background(Color.hpBackground)
                .padding(.top, -24)         // ヒーロー画像と少し重ねるため
            }
        }
        .scrollIndicators(.hidden)
        .background(Color.hpBackground.ignoresSafeArea())
        .ignoresSafeArea(edges: .top)
        .safeAreaInset(edge: .bottom) { ctaBar }
        .toolbar(.hidden, for: .navigationBar)
        .navigationBarBackButtonHidden(true)
    }
    
    // MARK: - ヒーロー画像
    private var heroImage: some View {
        AsyncImage(url: URL(string: shop.photo.mobile.l)) { image in
            image.resizable().scaledToFill()
        } placeholder: {
            Color.hpLine
        }
        .frame(height: 280)
        .frame(maxWidth: .infinity)
        .clipped()
        .overlay(alignment: .topLeading) {
            Button { dismiss() } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 38, height: 38)
                    .background(.ultraThinMaterial, in: Circle())
            }
            .padding(.leading, 16)
            .padding(.top, 56)
        }
        .overlay(alignment: .bottom) {
            LinearGradient(
                colors: [.clear, .hpBackground],
                           startPoint: .center,
                           endPoint: .bottom
            )
            .frame(height: 120)
            .allowsHitTesting(false)
        }
    }
    
    // MARK: - 店名・ジャンル
    private var nameSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(shop.genre.name)
                .font(.pretendard(.semiBold, size: 11))
                .foregroundStyle(.hpEmber)
                .padding(.horizontal, 11)
                .padding(.vertical, 4)
                .background(
                    Capsule()
                        .fill(Color.hpEmberDim)
                        .stroke(Color.hpEmber, lineWidth: 1)
                )
            
            Text(shop.name)
                .font(.pretendard(.extraBold, size: 24))
                .foregroundStyle(.hpText)
            
            if let catchCopy = shop.genre.catchCopy, !catchCopy.isEmpty {
                Text(catchCopy)
                    .font(.pretendard(.regular, size: 13))
                    .foregroundStyle(.hpSubText)
            }
        }
    }
    
    // MARK: - アクションrow（地図・共有）
    private var actionRow: some View {
        HStack(spacing: 8) {
            Button { openInMaps() } label: {
                actionLabel(icon: "map", title: "地図")
            }
            .buttonStyle(.plain)
            
            shareButton
        }
    }
    
    private func actionLabel(icon: String, title: String) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 20))
            
            Text(title)
                .font(.pretendard(.regular, size: 10))
        }
        .foregroundStyle(.hpText)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 13)
                .fill(Color.hpSurface)
                .stroke(Color.hpLine, lineWidth: 1)
        )
    }
    
    @ViewBuilder
    private var shareButton: some View {
        if let urlString = shop.urls?.pc, let url = URL(string: urlString) {
            ShareLink(item: url) {
                actionLabel(icon: "square.and.arrow.up", title: "共有")
            }
        } else {
            ShareLink(item: shop.name) {
                actionLabel(icon: "square.and.arrow.up", title: "共有")
            }
        }
    }
    
    // MARK: - 基本情報
    /// 表示する情報行（値があるものだけ）
    private var infoItems: [(icon: String, label: String, value: String)] {
        var items: [(String, String, String)] = [
            ("mappin.and.ellipse", "住所", shop.address)
        ]
        
        if let open = shop.open, !open.isEmpty { items.append(("clock", "営業時間", open)) }
        
        if let close = shop.close, !close.isEmpty { items.append(("calendar", "定休日", close)) }
        
        if !shop.access.isEmpty { items.append(("figure.walk", "アクセス", shop.access)) }
        
        if let budget = shop.budget?.name, !budget.isEmpty {
            items.append(("yensign", "予算", budget))
        }
        
        return items
    }
    
    private var infoCard: some View {
        VStack(spacing: 0) {
            ForEach(Array(infoItems.enumerated()), id: \.offset) { index, item in
                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: item.icon)
                        .font(.system(size: 16))
                        .foregroundStyle(.hpSubText)
                        .frame(width: 18)
                    
                    VStack(alignment: .leading, spacing: 3) {
                        Text(item.label)
                            .font(.pretendard(.regular, size: 10))
                            .foregroundStyle(.hpSubText)
                        
                        Text(item.value)
                            .font(.pretendard(.medium, size: 13))
                            .foregroundStyle(.hpText)
                    }
                    
                    Spacer(minLength: 0)
                }
                .padding(14)
                
                if index < infoItems.count - 1 {
                    Rectangle()
                        .fill(Color.hpLine)
                        .frame(height: 1)
                }
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.hpSurface)
                .stroke(Color.hpLine, lineWidth: 1)
        )
    }
    
    // MARK: - 地図
    private var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: shop.lat, longitude: shop.lng)
    }
    
    private var mapSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("地図")
                .font(.pretendard(.bold, size: 13))
                .foregroundStyle(.hpText)
            
            Button { openInMaps() } label: {
                Map(initialPosition: .region(
                    MKCoordinateRegion(
                        center: coordinate,
                        latitudinalMeters: 400,
                        longitudinalMeters: 400
                    )
                ), interactionModes: []) {
                    Marker(shop.name, coordinate: coordinate)
                        .tint(.hpEmber)
                }
                .frame(height: 150)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.hpLine, lineWidth: 1)
                )
            }
            .buttonStyle(.plain)
        }
    }
    
    // MARK: - 地図アプリ連携
    private func openInMaps() {
        let query = shop.name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        if let url = URL(string: "http://maps.apple.com/?ll=\(shop.lat),\(shop.lng)&q=\(query)") {
            openURL(url)
        }
    }
    
    // MARK: - 予約CTA
    private var ctaBar: some View {
        Button {
            if let urlString = shop.urls?.pc, let url = URL(string: urlString) {
                openURL(url)
            }
        } label: {
            Text("ホットペッパーで予約")
                .font(.pretendard(.bold, size: 15))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.hpEmber, in: RoundedRectangle(cornerRadius: 16))
                .shadow(color: .hpEmber.opacity(0.4), radius: 14, y: 10)
        }
        .padding(.horizontal, 18)
        .padding(.top, 14)
        .padding(.bottom, 12)
        .background(
            LinearGradient(
                colors: [.hpBackground.opacity(0), .hpBackground],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
}

//#Preview {
//    ShopDetailView()
//}
