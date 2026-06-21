//
//  FlowLayout.swift
//  HaraPeko
//
//  Created by 이재혁 on 6/21/26.
//
//  子要素を横に並べて幅を超えたら次の行へ折り返すレイアウト
//  チップ（ジャンル・予算など）の表示に使う

import SwiftUI

struct FlowLayout: Layout {
    var spacing: CGFloat = 8
    
    // "이 자식들을 이 너비에 배치하면 전체 크기가 얼마인가?"를 계산해 부모에게 보고 (여기서 줄바꿈을 가정해 높이를 누적).
    // "この子たちをこの幅に配置したら全体のサイズはどれくらいになるか？"を計算して親に報告し（ここで改行を仮定して高さを累積）
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let maxWidth = proposal.width ?? .infinity
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0
        var maxRowWidth: CGFloat = 0
        
        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            
            // 行幅を超えたら改行
            if x > 0, x + size.width > maxWidth {
                maxRowWidth = max(maxRowWidth, x - spacing)
                x = 0
                y += rowHeight + spacing
                rowHeight = 0
            }
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
        maxRowWidth = max(maxRowWidth, x - spacing)
        
        let width = (proposal.width == nil) ? maxRowWidth : maxWidth
        return CGSize(width: width, height: y + rowHeight)
    }
    
    // 실제로 각 자식을 어디에 놓을지 좌표를 지정 (가로로 놓다가 폭 초과 시 다음 줄로).
    // 実際に各子をどこに置くか座標を指定（横に置いて幅が超えた場合は次の行に）
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var x = bounds.minX
        var y = bounds.minY
        var rowHeight: CGFloat = 0
        
        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x > bounds.minX, x + size.width > bounds.maxX {
                x = bounds.minX
                y += rowHeight + spacing
                rowHeight = 0
            }
            subview.place(at: CGPoint(x: x, y: y),
                          anchor: .topLeading,
                          proposal: ProposedViewSize(size))
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
    }
}

