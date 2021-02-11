//
//  ContentView.swift
//  ToDoApp
//
//  Created by Jovial Software on 20/11/20.
//

import SwiftUI

struct ContentView: View {
    @State private var newTodo = ""
    @State private var allTodos:[TodoItem] = []
    private let  todoskey  = "tododskey"
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Add ToDo ...",text:$newTodo)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button(action:{
                        guard !self.newTodo.isEmpty else{return}
                        self.allTodos.append(TodoItem(todo: self.newTodo))
                        self.newTodo = ""
                        self.saveTodos()
                    }){
                        Image(systemName: "plus")
                    }.padding(.leading,5)
                }.padding()
                List {
                    ForEach(allTodos) {todoitem in
                        Text(todoitem.todo)
                    }.onDelete(perform: deleteTodos)
                }
            }
            .navigationBarTitle("ToDos")
        }.onAppear(perform:loadTodos)
    }
    private func deleteTodos(at offset:IndexSet){
        self.allTodos.remove(atOffsets: offset)
        saveTodos()
    }
    private func loadTodos(){
        if let todosData = UserDefaults.standard.value(forKey: todoskey) as? Data{
            if let todosList = try?PropertyListDecoder().decode(Array<TodoItem>.self, from: todosData){
                self.allTodos = todosList
            }
        }
    }
    private func saveTodos(){
        UserDefaults.standard.set(try?PropertyListEncoder().encode(self.allTodos), forKey: todoskey)
    }
}

struct TodoItem:Codable, Identifiable{
    let id = UUID()
    let todo:String
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
