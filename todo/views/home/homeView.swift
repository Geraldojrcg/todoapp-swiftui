import SwiftUI

struct HomeView: View {
    @State var user: User? = nil
    @State var isLoading: Bool = false
    @State var todoList: [Todo] = []
    
    func getData() {
        AuthService.getUser() { user in
            if user != nil {
                self.user = user
                TodoService.getUserTodos(userId: user!.id) { todos in
                    if todos != nil {
                        todoList = todos!.sorted(by: { (a,b) in
                            return !a.completed && b.completed
                        })
                    }
                    isLoading = false
                }
            } else {
                isLoading = false
            }
        }
    }
    
    func handleLogout() {
        AuthService.logout(){ success in
            if success {
                NotificationCenter.default.post(name: Notification.Name("goToLogin"), object: nil)
            }
        }
    }
    
    func handleCompleteTodo(todo: Todo) {
        TodoService.completeTodo(todo: todo) { success in
            if success {
                let index = todoList.firstIndex(where: { td in
                    return td.id == todo.id
                })
                if index != nil {
                    todoList[index!].completed = true
                }
            }
        }
    }
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .leading, vertical: .bottom)) {
            Color("BackgroundColor").ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading) {
                    if isLoading == true {
                        ProgressView().foregroundColor(.white)
                    }
                    if user != nil {
                        Button("Logout") {
                            self.handleLogout()
                        }
                        .foregroundColor(.white)
                        .padding(.bottom, 10)
                        
                        Text("Hello \(user?.name ?? "")")
                            .font(.system(size: 32))
                            .foregroundColor(Color("PrimaryColor"))
                            .bold()
                        
                        if todoList.isEmpty {
                            Text("You don't have ToDos! Add your first ToDo pressing + button.")
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .bold()
                                .padding(.top, 40)
                        }
                        
                        TodoList(list: todoList, onTodoSelected: self.handleCompleteTodo)
                        
                        Spacer()
                    }
                }
            }
            .padding(20)
            
            HStack {
                Spacer()
                
                NavigationLink(destination: {
                    if user != nil {
                        CreateTodoView(userId: user!.id)
                    }
                })
                {
                    Image(systemName: "plus")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 32, height: 32)
                        .padding(22)
                }
                .background(Color("PrimaryColor"))
                .foregroundColor(.white)
                .cornerRadius(.infinity)
                .padding()
            }
        }
        .onAppear {
            self.getData()
        }
    }
}
