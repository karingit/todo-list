import SwiftUI

struct AddTodoView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    let initialGroup: PriorityGroup
    @State private var title: String = ""
    @State private var selectedGroup: PriorityGroup
    
    init(initialGroup: PriorityGroup = .whenPossible) {
        self.initialGroup = initialGroup
        _selectedGroup = State(initialValue: initialGroup)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("Todo Details") {
                    HStack {
                        TextField("Todo Title", text: $title)
                        
                        Picker("Priority", selection: $selectedGroup) {
                            ForEach(PriorityGroup.allCases, id: \.self) { group in
                                HStack {
                                    Circle()
                                        .fill(group.color)
                                        .frame(width: 8, height: 8)
                                    Text(group.title)
                                }
                                .tag(group)
                            }
                        }
                        .frame(width: 150)
                        .fixedSize()
                    }
                }
            }
            .navigationTitle("New Todo")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        addTodo()
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }
    
    private func addTodo() {
        let newTodo = TodoItem(context: viewContext)
        newTodo.title = title
        newTodo.isCompleted = false
        newTodo.createdAt = Date()
        newTodo.id = UUID()
        newTodo.priorityGroup = selectedGroup.rawValue
        
        do {
            try viewContext.save()
            dismiss()
        } catch {
            print("Error saving new todo: \(error)")
        }
    }
}

#Preview {
    AddTodoView(initialGroup: .today)
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
} 