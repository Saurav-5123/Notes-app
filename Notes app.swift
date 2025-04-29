//import SwiftUI
//
//struct ContentView: View {
//    @State private var notes: [Note] = []
//    @State private var reminders: [Reminder] = []
//    @State private var lists: [ListModel] = []
//    @State private var selectedTab: FilterOption = .all
//    @State private var showingNoteSheet = false
//    @State private var showingReminderSheet = false
//    @State private var showingListSheet = false
//    @State private var editingNote: Note? = nil
//    @State private var editingReminder: Reminder? = nil
//    @State private var editingList: ListModel? = nil
//    @State private var newNoteText: String = ""
//    @State private var newListName: String = ""
//    @State private var newItemText: String = ""
//
//    var body: some View {
//        NavigationView {
//            VStack {
//                // Segmented Control for filtering
//                Picker("Filter", selection: $selectedTab) {
//                    Text("All").tag(FilterOption.all)
//                    Text("Notes").tag(FilterOption.notes)
//                    Text("Reminders").tag(FilterOption.reminders)
//                    Text("Lists").tag(FilterOption.lists)
//                }
//                .pickerStyle(SegmentedPickerStyle())
//                .padding()
//
//                // Conditional Views based on selectedTab
//                List {
//                    if selectedTab == .all || selectedTab == .notes {
//                        Section(header: Text("Notes")) {
//                            ForEach(notes) { note in
//                                Button(action: {
//                                    editingNote = note
//                                    showingNoteSheet = true
//                                }) {
//                                    Text(note.title)
//                                }
//                            }
//                            .onDelete { indexSet in
//                                notes.remove(atOffsets: indexSet)
//                            }
//                        }
//                    }
//
//                    if selectedTab == .all || selectedTab == .reminders {
//                        Section(header: Text("Reminders")) {
//                            ForEach(reminders) { reminder in
//                                Button(action: {
//                                    editingReminder = reminder
//                                    showingReminderSheet = true
//                                }) {
//                                    Text(reminder.title)
//                                }
//                            }
//                            .onDelete { indexSet in
//                                reminders.remove(atOffsets: indexSet)
//                            }
//                        }
//                    }
//
//                    if selectedTab == .all || selectedTab == .lists {
//                        Section(header: Text("Lists")) {
//                            ForEach(lists) { list in
//                                VStack(alignment: .leading) {
//                                    Text(list.name)
//                                        .font(.headline)
//                                        .padding(.bottom, 5)
//
//                                    ForEach(list.items) { item in
//                                        HStack {
//                                            Text("• \(item.text)") // Bullet-point formatting
//                                                .padding(.leading, 10)
//                                            Spacer()
//                                        }
//                                    }
//                                    .padding(.bottom, 5)
//                                }
//                                .padding(.vertical, 5)
//                            }
//                            .onDelete { indexSet in
//                                lists.remove(atOffsets: indexSet)
//                            }
//                        }
//                    }
//                }
//                .listStyle(GroupedListStyle())
//                .navigationTitle("Notes")
//                .toolbar {
//                    ToolbarItemGroup(placement: .navigationBarTrailing) {
//                        Button(action: {
//                            editingNote = nil
//                            showingNoteSheet = true
//                        }) {
//                            Label("Add Note", systemImage: "square.and.pencil")
//                        }
//                        Button(action: {
//                            editingReminder = nil
//                            showingReminderSheet = true
//                        }) {
//                            Label("Add Reminder", systemImage: "bell")
//                        }
//                        Button(action: {
//                            editingList = nil
//                            showingListSheet = true
//                        }) {
//                            Label("Add List", systemImage: "list.bullet")
//                        }
//                    }
//                }
//                .sheet(isPresented: $showingNoteSheet) {
//                    EditItemView(
//                        title: editingNote?.title ?? "",
//                        onSave: { title in
//                            if let note = editingNote {
//                                if let index = notes.firstIndex(where: { $0.id == note.id }) {
//                                    notes[index].title = title
//                                }
//                            } else {
//                                notes.append(Note(title: title))
//                            }
//                        }
//                    )
//                }
//                .sheet(isPresented: $showingReminderSheet) {
//                    EditItemView(
//                        title: editingReminder?.title ?? "",
//                        onSave: { title in
//                            if let reminder = editingReminder {
//                                if let index = reminders.firstIndex(where: { $0.id == reminder.id }) {
//                                    reminders[index].title = title
//                                }
//                            } else {
//                                reminders.append(Reminder(title: title))
//                            }
//                        }
//                    )
//                }
//                .sheet(isPresented: $showingListSheet) {
//                    EditListView(
//                        listName: editingList?.name ?? "",
//                        listItems: editingList?.items ?? [],
//                        onSave: { name, items in
//                            if let list = editingList {
//                                if let index = lists.firstIndex(where: { $0.id == list.id }) {
//                                    lists[index].name = name
//                                    lists[index].items = items
//                                }
//                            } else {
//                                lists.append(ListModel(name: name, items: items))
//                            }
//                        }
//                    )
//                }
//            }
//        }
//    }
//}
//
//// MARK: - Models
//
//struct Note: Identifiable, Equatable {
//    var id = UUID()
//    var title: String
//}
//
//struct Reminder: Identifiable, Equatable {
//    var id = UUID()
//    var title: String
//}
//
//struct ListItem: Identifiable, Equatable {
//    var id = UUID()
//    var text: String
//}
//
//struct ListModel: Identifiable, Equatable {
//    var id = UUID()
//    var name: String
//    var items: [ListItem]
//}
//
//// Enum to define the filtering options
//enum FilterOption {
//    case all, notes, reminders, lists
//}
//
//// MARK: - Reusable Edit View for Notes, Reminders, and Lists
//
//struct EditItemView: View {
//    @Environment(\.dismiss) var dismiss
//    @State var title: String
//    var onSave: (String) -> Void
//
//    var body: some View {
//        NavigationView {
//            Form {
//                TextField("Title", text: $title)
//            }
//            .navigationTitle("Editor")
//            .toolbar {
//                ToolbarItem(placement: .confirmationAction) {
//                    Button("Save") {
//                        if !title.isEmpty {
//                            onSave(title)
//                            dismiss()
//                        }
//                    }
//                }
//                ToolbarItem(placement: .cancellationAction) {
//                    Button("Cancel", role: .cancel) {
//                        dismiss()
//                    }
//                }
//            }
//        }
//    }
//}
//
//struct EditListView: View {
//    @Environment(\.dismiss) var dismiss
//    @State var listName: String
//    @State var listItems: [ListItem]
//    @State private var newItemText: String = ""
//
//    var onSave: (String, [ListItem]) -> Void
//
//    var body: some View {
//        NavigationView {
//            Form {
//                TextField("List Name", text: $listName)
//
//                Section(header: Text("Items")) {
//                    ForEach(listItems) { item in
//                        HStack {
//                            Text("• \(item.text)") // Bullet-point formatting
//                            Spacer()
//                        }
//                    }
//                    .onDelete { indexSet in
//                        listItems.remove(atOffsets: indexSet)
//                    }
//
//                    HStack {
//                        TextField("New item", text: $newItemText)
//                            .textFieldStyle(RoundedBorderTextFieldStyle())
//                        Button(action: {
//                            if !newItemText.isEmpty {
//                                listItems.append(ListItem(text: newItemText))
//                                newItemText = ""
//                            }
//                        }) {
//                            Text("Add")
//                        }
//                    }
//                }
//            }
//            .navigationTitle("List")
//            .toolbar {
//                ToolbarItem(placement: .confirmationAction) {
//                    Button("Save") {
//                        if !listName.isEmpty {
//                            onSave(listName, listItems)
//                            dismiss()
//                        }
//                    }
//                }
//                ToolbarItem(placement: .cancellationAction) {
//                    Button("Cancel", role: .cancel) {
//                        dismiss()
//                    }
//                }
//            }
//        }
//    }
//}



// import SwiftUI

// struct ContentView: View {
//     @State private var notes: [Note] = []
//     @State private var reminders: [Reminder] = []
//     @State private var lists: [ListModel] = []
//     @State private var selectedTab: FilterOption = .all
//     @State private var showingNoteSheet = false
//     @State private var showingReminderSheet = false
//     @State private var showingListSheet = false
//     @State private var editingNote: Note? = nil
//     @State private var editingReminder: Reminder? = nil
//     @State private var editingList: ListModel? = nil
//     @State private var newNoteText: String = ""
//     @State private var newListName: String = ""
//     @State private var newItemText: String = ""

//     var body: some View {
//         NavigationView {
//             VStack {
//                 Picker("Filter", selection: $selectedTab) {
//                     Text("All").tag(FilterOption.all)
//                     Text("Notes").tag(FilterOption.notes)
//                     Text("Reminders").tag(FilterOption.reminders)
//                     Text("Lists").tag(FilterOption.lists)
//                 }
//                 .pickerStyle(SegmentedPickerStyle())
//                 .padding()

//                 List {
//                     if selectedTab == .all || selectedTab == .notes {
//                         Section(header: Text("Notes")) {
//                             ForEach(notes) { note in
//                                 Button(action: {
//                                     editingNote = note
//                                     showingNoteSheet = true
//                                 }) {
//                                     Text(note.name)  
//                                 }
//                             }
//                             .onDelete { indexSet in
//                                 notes.remove(atOffsets: indexSet)
//                             }
//                         }
//                     }

//                     if selectedTab == .all || selectedTab == .reminders {
//                         Section(header: Text("Reminders")) {
//                             ForEach(reminders) { reminder in
//                                 Button(action: {
//                                     editingReminder = reminder
//                                     showingReminderSheet = true
//                                 }) {
//                                     Text(reminder.title)
//                                 }
//                             }
//                             .onDelete { indexSet in
//                                 reminders.remove(atOffsets: indexSet)
//                             }
//                         }
//                     }

//                     if selectedTab == .all || selectedTab == .lists {
//                         Section(header: Text("Lists")) {
//                             ForEach(lists) { list in
//                                 VStack(alignment: .leading) {
//                                     Text(list.name)
//                                         .font(.headline)
//                                         .padding(.bottom, 5)

//                                     ForEach(list.items) { item in
//                                         HStack {
//                                             Text("• \(item.text)") 
//                                                 .padding(.leading, 10)
//                                             Spacer()
//                                         }
//                                     }
//                                     .padding(.bottom, 5)
//                                 }
//                                 .padding(.vertical, 5)
//                             }
//                             .onDelete { indexSet in
//                                 lists.remove(atOffsets: indexSet)
//                             }
//                         }
//                     }
//                 }
//                 .listStyle(GroupedListStyle())
//                 .navigationTitle("Notes")
//                 .toolbar {
//                     ToolbarItemGroup(placement: .navigationBarTrailing) {
//                         Button(action: {
//                             editingNote = nil
//                             showingNoteSheet = true
//                         }) {
//                             Label("Add Note", systemImage: "square.and.pencil")
//                         }
//                         Button(action: {
//                             editingReminder = nil
//                             showingReminderSheet = true
//                         }) {
//                             Label("Add Reminder", systemImage: "bell")
//                         }
//                         Button(action: {
//                             editingList = nil
//                             showingListSheet = true
//                         }) {
//                             Label("Add List", systemImage: "list.bullet")
//                         }
//                     }
//                 }
//                 .sheet(isPresented: $showingNoteSheet) {
//                     EditItemView(
//                         noteName: editingNote?.name ?? "",
//                         noteTitle: editingNote?.title ?? "",
//                         onSave: { name, title in
//                             if let note = editingNote {
//                                 if let index = notes.firstIndex(where: { $0.id == note.id }) {
//                                     notes[index].name = name
//                                     notes[index].title = title
//                                 }
//                             } else {
//                                 notes.append(Note(name: name, title: title))
//                             }
//                         }
//                     )
//                 }
//                 .sheet(isPresented: $showingReminderSheet) {
//                     EditItemView(
//                         title: editingReminder?.title ?? "",
//                         onSave: { title in
//                             if let reminder = editingReminder {
//                                 if let index = reminders.firstIndex(where: { $0.id == reminder.id }) {
//                                     reminders[index].title = title
//                                 }
//                             } else {
//                                 reminders.append(Reminder(title: title))
//                             }
//                         }
//                     )
//                 }
//                 .sheet(isPresented: $showingListSheet) {
//                     EditListView(
//                         listName: editingList?.name ?? "",
//                         listItems: editingList?.items ?? [],
//                         onSave: { name, items in
//                             if let list = editingList {
//                                 if let index = lists.firstIndex(where: { $0.id == list.id }) {
//                                     lists[index].name = name
//                                     lists[index].items = items
//                                 }
//                             } else {
//                                 lists.append(ListModel(name: name, items: items))
//                             }
//                         }
//                     )
//                 }
//             }
//         }
//     }
// }


// struct Note: Identifiable, Equatable {
//     var id = UUID()
//     var name: String  
//     var title: String
// }

// struct Reminder: Identifiable, Equatable {
//     var id = UUID()
//     var title: String
// }

// struct ListItem: Identifiable, Equatable {
//     var id = UUID()
//     var text: String
// }

// struct ListModel: Identifiable, Equatable {
//     var id = UUID()
//     var name: String
//     var items: [ListItem]
// }

// enum FilterOption {
//     case all, notes, reminders, lists
// }


// struct EditItemView: View {
//     @Environment(\.dismiss) var dismiss
//     @State var noteName: String
//     @State var noteTitle: String
//     var onSave: (String, String) -> Void

//     var body: some View {
//         NavigationView {
//             Form {
//                 TextField("Note Name", text: $noteName) 
//                 TextField("Note Title", text: $noteTitle) 
//             }
//             .navigationTitle("Editor")
//             .toolbar {
//                 ToolbarItem(placement: .confirmationAction) {
//                     Button("Save") {
//                         if !noteName.isEmpty && !noteTitle.isEmpty {
//                             onSave(noteName, noteTitle)
//                             dismiss()
//                         }
//                     }
//                 }
//                 ToolbarItem(placement: .cancellationAction) {
//                     Button("Cancel", role: .cancel) {
//                         dismiss()
//                     }
//                 }
//             }
//         }
//     }
// }

// struct EditListView: View {
//     @Environment(\.dismiss) var dismiss
//     @State var listName: String
//     @State var listItems: [ListItem]
//     @State private var newItemText: String = ""

//     var onSave: (String, [ListItem]) -> Void

//     var body: some View {
//         NavigationView {
//             Form {
//                 TextField("List Name", text: $listName)

//                 Section(header: Text("Items")) {
//                     ForEach(listItems) { item in
//                         HStack {
//                             Text("• \(item.text)") 
//                             Spacer()
//                         }
//                     }
//                     .onDelete { indexSet in
//                         listItems.remove(atOffsets: indexSet)
//                     }

//                     HStack {
//                         TextField("New item", text: $newItemText)
//                             .textFieldStyle(RoundedBorderTextFieldStyle())
//                         Button(action: {
//                             if !newItemText.isEmpty {
//                                 listItems.append(ListItem(text: newItemText))
//                                 newItemText = ""
//                             }
//                         }) {
//                             Text("Add")
//                         }
//                     }
//                 }
//             }
//             .navigationTitle("List")
//             .toolbar {
//                 ToolbarItem(placement: .confirmationAction) {
//                     Button("Save") {
//                         if !listName.isEmpty {
//                             onSave(listName, listItems)
//                             dismiss()
//                         }
//                     }
//                 }
//                 ToolbarItem(placement: .cancellationAction) {
//                     Button("Cancel", role: .cancel) {
//                         dismiss()
//                     }
//                 }
//             }
//         }
//     }
// }




struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isLoggedIn: Bool = false
    @State private var showingAlert = false
    @State private var alertMessage = ""

    var body: some View {
        VStack {
            TextField("Username", text: $username)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            SecureField("Password", text: $password)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button("Login") {
                authenticateUser()
            }
            .padding()
            .buttonStyle(.borderedProminent)

            if showingAlert {
                Text(alertMessage)
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .padding()
        .navigationTitle("Login")
    }
    
    func authenticateUser() {
        // Replace with your authentication logic
        if username == "user" && password == "password" {
            isLoggedIn = true
        } else {
            alertMessage = "Invalid credentials, please try again."
            showingAlert = true
        }
    }
}
