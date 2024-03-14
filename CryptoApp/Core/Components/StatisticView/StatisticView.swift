//
//  StatisticView.swift
//  CryptoApp
//
//  Created by Şuayip Emre on 15.03.2024.
//

import SwiftUI

struct StatisticView: View {
    let stat : StatisticModel
    var body: some View {
        VStack(alignment: .leading, spacing: 4){
            Text(stat.title)
                .font(.caption)
                .foregroundStyle(Color.theme.secondaryText)
            Text(stat.value)
                .font(.headline)
                .foregroundStyle(Color.theme.accent)
            HStack(spacing:4) {
                Image(systemName: "triangle.fill")
                    .font(.caption2)
                    .rotationEffect(
                        Angle(degrees: (stat.percantageChange ?? 0) >= 0  ? 0 : 180 )
                    )
                Text(stat.percantageChange?.asPercentString() ?? "")
                    .font(.caption)
                    .bold()
            }
            .foregroundStyle(
                (stat.percantageChange ?? 0) >= 0 ? Color.theme.green : Color.theme.red
            )
            .opacity(stat.percantageChange == nil ? 0.0 : 10)
        }
    }
}

#Preview {
    StatisticView(stat: DeveloperPreview.instance.stat1)
}
