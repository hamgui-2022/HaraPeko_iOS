//
//  ResultListView.swift
//  HaraPeko
//
//  Created by 이재혁 on 6/20/26.
//
//  ②検索結果画面
//  検索条件と件数のヘッダー+店舗カードの一覧（ページング対応）
//

import SwiftUI
import CoreLocation

struct ResultListView: View {
    let viewModel: SearchViewModel
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            Color.hpBackground.ignoresSafeArea()
            
            if viewModel.shops.isEmpty {
                emptyState
            } else {
                ScrollView {
                    LazyVStack(spacing: 11) {
                        ForEach(viewModel.shops) { shop in
                            NavigationLink {
                                ShopDetailView(shop: shop)
                            } label: {
                                ShopRow(shop: shop, distance: distanceText(for: shop))
                            }
                            .buttonStyle(.plain)
                        }
                        
                        loadMoreFooter
                        
                        HotPepperCredit()
                            .padding(.top, 4)
                            .padding(.bottom, 16)
                    }
                    .padding(.horizontal, 18)
                    .padding(.vertical, 14)
                }
            }
        }
        .safeAreaInset(edge: .top) { header }
        .toolbar(.hidden, for: .navigationBar)
    }
    
    // MARK: - ヘッダー
    private var header: some View {
        VStack(spacing: 13) {
            HStack(spacing: 12) {
                Button { dismiss() } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(.hpText)
                        .frame(width: 34, height: 34)
                        .background(
                            RoundedRectangle(cornerRadius: 11)
                                .fill(Color.hpSurface)
                                .stroke(Color.hpLine, lineWidth: 1)
                        )
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("検索結果")
                        .font(.pretendard(.bold, size: 18))
                        .foregroundStyle(.hpText)
                    
                    countText
                }
                
                Spacer()
            }
            
            conditionTags
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 18)
        .padding(.top, 8)
        .padding(.bottom, 12)
        .background(Color.hpBackground)
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(Color.hpLine)
                .frame(height: 1)
        }
    }
    
    private var countText: Text {
        var count = AttributedString("\(viewModel.resultsAvailable)")
        count.font = .pretendard(.bold, size: 11)
        count.foregroundColor = .hpMoon

        var rest = AttributedString(" 件の獲物が見つかりました")
        rest.font = .pretendard(.regular, size: 11)
        rest.foregroundColor = .hpSubText

        return Text(count + rest)
    }
    
    private var conditionTags: some View {
        HStack(spacing: 7) {
            if let locationName = viewModel.locationName {
                tag(icon: "mappin.and.ellipse", text: locationName, highlighted: true)
            }
            tag(icon: "scope", text: viewModel.selectedRange.label, highlighted: false)
            
            if let genre = viewModel.selectedGenre {        // 選択された時のみ
                tag(icon: "fork.knife", text: genre.name, highlighted: false)
            }
            if let budget = viewModel.selectedBudget {        // 選択された時のみ
                tag(icon: "yensign", text: budget.name, highlighted: false)
            }
        }
    }
    
    private func tag(icon: String, text: String, highlighted: Bool) -> some View {
        HStack(spacing: 5) {
            Image(systemName: icon)
                .font(.system(size: 11))
            
            Text(text)
                .font(.pretendard(.semiBold, size: 11))
        }
        .foregroundStyle(highlighted ? Color.hpEmber : .hpText)
        .padding(.horizontal, 11)
        .padding(.vertical, 6)
        .background(
            Capsule()
                .fill(highlighted ? Color.hpEmberDim : Color.hpSurface)
                .stroke(highlighted ? Color.hpEmber : Color.hpLine, lineWidth: 1)
        )
    }
    
    // MARK: - 空状態
    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "fork.knife.circle")
                .font(.system(size: 44))
                .foregroundStyle(.hpSubText)
            
            Text("条件に合うお店が見つかりませんでした")
                .font(.pretendard(.medium, size: 14))
                .foregroundStyle(.hpSubText)
        }
    }
    
    // MARK: - 距離計算
    
    /// 現在地から店舗までの距離を文字列に（300m / 1.2km）
    private func distanceText(for shop: Shop) -> String? {
        guard let userCoordinate = viewModel.coordinate else { return nil }
        let user = CLLocation(latitude: userCoordinate.latitude, longitude: userCoordinate.longitude)
        let shopLocation = CLLocation(latitude: shop.lat, longitude: shop.lng)
        let meters = user.distance(from: shopLocation)
        
        return meters < 1000
        ? "\(Int(meters))m"
        : String(format: "%.1fkm", meters / 1000)
    }
    
    // MARK: - もっと見る
    
    @ViewBuilder
    private var loadMoreFooter: some View {
        if viewModel.canLoadMore {
            Button {
                Task { await viewModel.loadMore() }
            } label: {
                HStack(spacing: 8) {
                    if viewModel.isLoadingMore {
                        ProgressView()
                            .tint(.hpText)
                    } else {
                        Text("もっと見る")
                            .font(.pretendard(.semiBold, size: 14))
                        
                        Image(systemName: "chevron.down")
                            .font(.system(size: 14))
                    }
                }
                .foregroundStyle(.hpText)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 13)
                        .fill(Color.hpSurface)
                        .stroke(Color.hpLine, lineWidth: 1)
                )
            }
            .buttonStyle(.plain)
            .disabled(viewModel.isLoadingMore)
            .padding(.top, 7)
        }
    }
}
