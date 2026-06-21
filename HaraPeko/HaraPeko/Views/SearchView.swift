//
//  SearchView.swift
//  HaraPeko
//
//  Created by 이재혁 on 6/20/26.
//
// ① 検索条件入力画面。現在地と検索半径などを指定して飲食店を検索する。
// この段階では、全体レイアウト（ヘッダー・スクロール領域・固定CTA）の骨組みのみ

import SwiftUI
import CoreLocation
import UIKit        // 設定アプリを開くため

struct SearchView: View {
    @State private var viewModel = SearchViewModel()
    @State private var showResults = false
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                // 画面全体の背景
                Color.hpBackground.ignoresSafeArea()
                
                // スクロールする検索条件エリア
                ScrollView {
                    VStack(alignment: .leading, spacing: 22) {
                        brandHeader
                        
                        Text("検索条件を入力")
                            .font(.pretendard(.bold, size: 18))
                            .foregroundStyle(.hpText)
                        
                        locationCard
                        
                        radiusSection
                        
                        // TODO: ／ジャンル／キーワード／予算
                        
                        if let error = viewModel.errorMessage {
                            Text(error)
                                .font(.pretendard(.medium, size: 12))
                                .foregroundStyle(.red)
                        }
                        
                        HotPepperCredit(showsImageCredit: false)
                            .padding(.top, 8)
                    }
                    .padding(.horizontal, 18)
                    .padding(.top, 8)
                    .padding(.bottom, 120) // 固定CTAに隠れないよう余白を確保
                }
                
                searchButton
            }
            .toolbar(.hidden, for: .navigationBar)
            .onAppear { viewModel.onAppear() }
            .onChange(of: viewModel.coordinate?.latitude) {
                viewModel.reverseGeocode()
            }
            .navigationDestination(isPresented: $showResults) {
                ResultListView(viewModel: viewModel)        // データの代わりにviewModel
            }
        }
    }
    
    // MARK: - ブランドヘッダー
    
    private var brandHeader: some View {
        HStack(spacing: 11) {
            // ロゴマーク（暫定：SF Symbols。後で専用アイコンに差し替え可能）
            ZStack {
                Circle().fill(Color.hpEmberDim)
                Image(systemName: "pawprint.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(.hpEmber)
            }
            .frame(width: 40, height: 40)
            
            VStack(alignment: .leading, spacing: 2) {
                Text("腹ペコフェンリル")
                    .font(.pretendard(.extraBold, size: 19))
                    .foregroundStyle(.hpText)
                Text("HUNT FOR YOUR MEAL")
                    .font(.pretendard(.semiBold, size: 9))
                    .tracking(1.5)
                    .foregroundStyle(.hpEmber)
            }
            
            Spacer()
            
            // 設定ボタン（暫定）
            Image(systemName: "gearshape")
                .font(.system(size: 20))
                .foregroundStyle(.hpText)
                .frame(width: 38, height: 38)
                .background(
                    RoundedRectangle(cornerRadius: 11)
                        .fill(Color.hpSurface)
                        .stroke(Color.hpLine, lineWidth: 1)
                )
        }
    }
    
    // MARK: - 現在地カード
    
    private var locationCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 12) {
                // アイコン
                ZStack {
                    RoundedRectangle(cornerRadius: 12).fill(Color.hpEmberDim)
                    Image(systemName: "location.fill")
                        .font(.system(size: 18))
                        .foregroundStyle(.hpEmber)
                }
                .frame(width: 40, height: 40)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("現在地")
                        .font(.pretendard(.regular, size: 10))
                        .foregroundStyle(.hpSubText)
                    Text(locationPrimaryText)
                        .font(.pretendard(.semiBold, size: 15))
                        .foregroundStyle(.hpText)
                        .lineLimit(1)
                }
                
                Spacer()
                
                gpsBadge
            }
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.hpSurface)
                    .stroke(Color.hpLine, lineWidth: 1)
            )
            
            statusLine
        }
    }
    
    private var gpsBadge: some View {
        let isOn = (viewModel.coordinate != nil)
        return HStack(spacing: 5) {
            Image(systemName: "scope")
                .font(.system(size: 11))
            Text(isOn ? "GPS ON" : "GPS OFF")
                .font(.pretendard(.semiBold, size: 10))
        }
        .foregroundStyle(isOn ? Color.hpEmber : .hpSubText)
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .overlay(
            Capsule()
                .stroke(isOn ? Color.hpEmber : Color.hpLine, lineWidth: 1)
        )
    }
    
    /// カード中央に出す主テキスト（状態の出し分け）
    private var locationPrimaryText: String {
        switch viewModel.authorizationStatus {
        case .denied, .restricted:
            "位置情報が許可されていません"
        default:
            if let name = viewModel.locationName {
                name
            } else if let c = viewModel.coordinate {
                String(format: "緯度 %.4f, 軽度 %.4f", c.latitude, c.longitude)
            } else {
                "現在地を取得中..."
            }
        }
    }
    
    /// カード下の状態行（状態で出し分け）
    @ViewBuilder
    private var statusLine: some View {
        switch viewModel.authorizationStatus {
        case .denied, .restricted:
            HStack(spacing: 6) {
                Text("設定アプリから位置情報を許可してください")
                Button("設定を開く") {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                }
                .font(.pretendard(.semiBold, size: 10))
                .foregroundStyle(.hpEmber)
            }
            .font(.pretendard(.regular, size: 10))
            .foregroundStyle(.hpSubText)
            .padding(.horizontal, 2)
            
        default:
            HStack(spacing: 6) {
                if viewModel.coordinate != nil {
                    Circle().fill(.green).frame(width: 6, height: 6)
                    Text("現在地を取得しました")
                } else {
                    ProgressView()
                        .scaleEffect(0.6)
                        .tint(.hpSubText)
                    Text("現在地を取得中...")
                }
            }
            .font(.pretendard(.regular, size: 10))
            .foregroundStyle(.hpSubText)
            .padding(.horizontal, 2)
        }
    }
    
    // MARK: - 検索半径セクション
    
    private var radiusSection: some View {
        VStack(alignment: .leading, spacing: 11) {
            HStack(spacing: 8) {
                Text("検索半径")
                    .font(.pretendard(.bold, size: 13))
                    .foregroundStyle(.hpText)
                
                Text("必須")
                    .font(.pretendard(.semiBold, size: 9))
                    .foregroundStyle(.hpEmber)
                    .padding(.horizontal, 7)
                    .padding(.vertical, 2)
                    .overlay(Capsule().stroke(Color.hpEmber, lineWidth: 1))
                
                Spacer()
                
                Text("API range 1-5")
                    .font(.system(size: 9, design: .monospaced))
                    .foregroundStyle(.hpSubText)
            }
            
            HStack(spacing: 6) {
                ForEach(SearchRange.allCases) { range in
                    radiusItem(range)
                }
            }
        }
    }
    
    private func radiusItem(_ range: SearchRange) -> some View {
        let isSelected = (viewModel.selectedRange == range)
        return Button {
            viewModel.selectedRange = range
        } label: {
            VStack(spacing: 1) {
                Text(range.title)
                    .font(.pretendard(isSelected ? .bold : .semiBold, size: 14))
                Text(range.unit)
                    .font(.pretendard(.medium, size: 9))
                    .opacity(0.75)
            }
            .foregroundStyle(isSelected ? Color.white : .hpSubText)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 13)
            .background(
                RoundedRectangle(cornerRadius: 13)
                    .fill(isSelected ? Color.hpEmber : Color.hpSurface)
                    .stroke(isSelected ? Color.hpEmber : Color.hpLine, lineWidth: 1)
            )
            .shadow(color: isSelected ? .hpEmber.opacity(0.3) : .clear, radius: 8, y: 6)
        }
        .buttonStyle(.plain)
    }
    
    // MARK: - 検索ボタン（固定CTA）
    
    private var searchButton: some View {
        Button {
            Task {
                await viewModel.search()
                if viewModel.errorMessage == nil {
                    showResults = true
                }
            }
        } label: {
            HStack(spacing: 10) {
                if viewModel.isLoading {
                    ProgressView()
                        .tint(.white)
                } else {
                    Image(systemName: "pawprint.fill")
                        .font(.system(size: 20))
                    Text("獲物を探す")
                        .font(.pretendard(.bold, size: 16))
                }
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 17)
            .background(Color.hpEmber, in: RoundedRectangle(cornerRadius: 16))
            .shadow(color: .hpEmber.opacity(0.4), radius: 14, y: 10)
        }
        .padding(.horizontal, 18)
        .padding(.bottom, 30)
    }
}

#Preview {
    SearchView()
}
