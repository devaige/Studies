//
//  ContentView.swift
//  TheUltimate70HoursIOSDevelopmentBootcamp
//
//  Created by Aige on 2024/06/18.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: []) private var budgetCategoryResults: FetchedResults<BudgetCategory>
    @State private var isPresented: Bool = false
    var total: Double {
        budgetCategoryResults.reduce(0) { result, budgetCategory in
            result + budgetCategory.total
        }
    }

    private func deleteBudgetCategory(budgetCategory: BudgetCategory) {
        viewContext.delete(budgetCategory)
        do {
            try viewContext.save()
        } catch {
            print(error)
        }
    }

    var body: some View {
        NavigationStack {
            VStack {
                Text(total as NSNumber, formatter: NumberFormatter.currency).fontWeight(.bold)
                BudgetListView(budgetCategoryResult: budgetCategoryResults, onDeleteBudgetCategory: deleteBudgetCategory)
            }
            .sheet(isPresented: $isPresented, content: {
                AddBudgetCategoryView()
            })
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add Category") {
                        isPresented = true
                    }
                }
            }).padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, CoreDataManager.shared.viewContext)
    }
}
