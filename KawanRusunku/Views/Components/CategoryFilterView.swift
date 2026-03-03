//
//  CategoryFilterView.swift
//  KawanRusunku
//
//  Created by SlabPixel Designer on 03/03/26.
//
import SwiftUI

struct CategoryFilterView: View {
    @Binding var selectedCategory: String
    let categories: [CategoryInfo] = CategoryInfo.filterCategories

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(categories, id: \.name) { category in
                    CategoryPillView(
                        category: category,
                        isSelected: selectedCategory == category.name,
                        action: {
                            selectedCategory = category.name
                        }
                    )
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

#Preview {
    @Previewable @State var selected = "All"
    return CategoryFilterView(selectedCategory: $selected)
}

