//
//  KawanRusunkuApp.swift
//  KawanRusunku
//
//  Created by SlabPixel Designer on 03/03/26.
//

import SwiftUI
import SwiftData

@main
struct KawanRusunkuApp: App {
    let modelContainer: ModelContainer

    var body: some Scene {
        WindowGroup {
            HomeView()
        }
        .modelContainer(modelContainer)
    }

    init() {
        do {
            modelContainer = try ModelContainer(for: Expense.self)
        } catch {
            fatalError("Could not initialize ModelContainer: \(error)")
        }
    }
}
