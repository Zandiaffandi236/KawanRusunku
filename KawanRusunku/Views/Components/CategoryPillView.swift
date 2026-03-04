//
//  CategoryPillView.swift
//  KawanRusunku
//
//  Created by SlabPixel Designer on 03/03/26.
//
import SwiftUI

struct CategoryPillView: View {
    let category: CategoryInfo
    let isSelected: Bool
    var selectedColor: Color = .lime
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: category.icon)
                Text(category.name)
                    .font(.caption)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(isSelected ? selectedColor : Color.gray.opacity(0.2))
            .foregroundColor(isSelected ? .black : .primary)
            .cornerRadius(20)
        }
    }
}

#Preview {
    VStack(spacing: 12) {
        HStack(spacing: 8) {
            CategoryPillView(
                category: .foodDrink,
                isSelected: true,
                action: {}
            )

            CategoryPillView(
                category: .vehicle,
                isSelected: false,
                action: {}
            )
        }
    }
    .padding()
}



