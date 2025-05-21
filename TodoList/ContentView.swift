//
//  ContentView.swift
//  TodoList
//
//  Created by Karin Almström on 2025-05-21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var showingAddTodo = false
    @State private var selectedGroup: PriorityGroup? = .today
    
    @FetchRequest(
        sortDescriptors: [
            NSSortDescriptor(keyPath: \TodoItem.priorityGroup, ascending: true),
            NSSortDescriptor(keyPath: \TodoItem.isCompleted, ascending: true),
            NSSortDescriptor(keyPath: \TodoItem.createdAt, ascending: true)
        ],
        animation: .default)
    private var todos: FetchedResults<TodoItem>
    
    private var groupedTodos: [PriorityGroup: [TodoItem]] {
        Dictionary(grouping: todos) { todo in
            PriorityGroup(rawValue: todo.priorityGroup ?? "whenPossible") ?? .whenPossible
        }
    }
    
    private func sortedTodos(for group: PriorityGroup) -> [TodoItem] {
        let todosInGroup = groupedTodos[group] ?? []
        return todosInGroup.sorted { todo1, todo2 in
            if todo1.isCompleted != todo2.isCompleted {
                return !todo1.isCompleted
            }
            return (todo1.createdAt ?? Date()) < (todo2.createdAt ?? Date())
        }
    }
    
    var body: some View {
        NavigationSplitView {
            List(PriorityGroup.allCases, id: \.self, selection: $selectedGroup) { group in
                NavigationLink(value: group) {
                    HStack {
                        Circle()
                            .fill(group.color)
                            .frame(width: 10, height: 10)
                        Text(group.title)
                        Spacer()
                        let count = groupedTodos[group]?.filter { !$0.isCompleted }.count ?? 0
                        if count > 0 {
                            Text("\(count)")
                                .foregroundColor(.white)
                                .font(.caption)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(group.color)
                                .clipShape(Capsule())
                        }
                    }
                }
            }
            .navigationTitle("Priority Groups")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { showingAddTodo = true }) {
                        Label("Add Todo", systemImage: "plus")
                    }
                }
            }
        } detail: {
            if let selectedGroup = selectedGroup {
                List {
                    let todosInGroup = sortedTodos(for: selectedGroup)
                    if todosInGroup.isEmpty {
                        ContentUnavailableView("No Tasks", systemImage: "checklist", description: Text("Add some tasks to get started"))
                    } else {
                        ForEach(todosInGroup) { todo in
                            TodoItemView(todo: todo)
                                .listRowBackground(todo.isCompleted ? Color.gray.opacity(0.1) : selectedGroup.lightColor)
                        }
                    }
                }
                .navigationTitle(selectedGroup.title)
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Button(action: { showingAddTodo = true }) {
                            Label("Add Todo", systemImage: "plus")
                        }
                    }
                }
            } else {
                ContentUnavailableView("No Group Selected", systemImage: "sidebar.left", description: Text("Select a priority group"))
            }
        }
        .sheet(isPresented: $showingAddTodo) {
            AddTodoView(initialGroup: selectedGroup ?? .whenPossible)
        }
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
