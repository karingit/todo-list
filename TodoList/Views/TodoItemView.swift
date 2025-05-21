import SwiftUI

struct TodoItemView: View {
    @ObservedObject var todo: TodoItem
    @Environment(\.managedObjectContext) private var viewContext
    @State private var showingPriorityPicker = false
    
    private var priorityGroup: PriorityGroup {
        PriorityGroup(rawValue: todo.priorityGroup ?? "whenPossible") ?? .whenPossible
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Button(action: toggleCompletion) {
                Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(todo.isCompleted ? .gray : priorityGroup.color)
            }
            .buttonStyle(.plain)
            .frame(width: 20)
            
            Text(todo.title ?? "")
                .strikethrough(todo.isCompleted)
                .foregroundColor(todo.isCompleted ? .gray : .primary)
            
            Spacer()
            
            Menu {
                ForEach(PriorityGroup.allCases, id: \.self) { group in
                    Button {
                        changePriority(to: group)
                    } label: {
                        HStack {
                            Circle()
                                .fill(group.color)
                                .frame(width: 8, height: 8)
                            Text(group.title)
                        }
                    }
                }
                
                Divider()
                
                Button(role: .destructive, action: deleteTodo) {
                    Label("Delete", systemImage: "trash")
                }
            } label: {
                Image(systemName: "ellipsis.circle")
                    .foregroundColor(todo.isCompleted ? .gray : priorityGroup.color)
            }
            .frame(width: 150)
        }
        .padding(.vertical, 4)
        .padding(.trailing, 8)
        .opacity(todo.isCompleted ? 0.8 : 1.0)
    }
    
    private func toggleCompletion() {
        todo.isCompleted.toggle()
        saveContext()
    }
    
    private func changePriority(to group: PriorityGroup) {
        todo.priorityGroup = group.rawValue
        saveContext()
    }
    
    private func deleteTodo() {
        viewContext.delete(todo)
        saveContext()
    }
    
    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let newTodo = TodoItem(context: context)
    newTodo.title = "Sample Todo"
    newTodo.isCompleted = false
    newTodo.createdAt = Date()
    newTodo.priorityGroup = PriorityGroup.today.rawValue
    
    return TodoItemView(todo: newTodo)
        .environment(\.managedObjectContext, context)
} 
