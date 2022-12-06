import SwiftUI

struct CreateTodoView: View {
    var userId: String
    @State var description: String = ""
    @State var isLoading: Bool = false
    @State var disabled: Bool = false
    @State private var showErrorAlert: Bool = false
    
    @FocusState private var focused: Bool
    
    @Environment(\.presentationMode) var presentationMode
    
    func onSubmit() {
        isLoading = true
        let todo = CreateTodoModel(description: description, userId: userId)
        TodoService.createTodo(todo: todo) { success in
            if success {
                presentationMode.wrappedValue.dismiss()
            } else {
                showErrorAlert = true
            }
            isLoading = false
        }
    }
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .leading, vertical: .bottom)) {
            Color("BackgroundColor").ignoresSafeArea()
            
            VStack(alignment: .leading) {
                Text("New ToDo")
                    .font(.system(size: 32))
                    .foregroundColor(Color("PrimaryColor"))
                    .bold()
                
                TextEditor(text: $description)
                    .focused($focused)
                    .accentColor(Color("PrimaryColor"))
                    .background(Color("BackgroundColor"))
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(
                        focused ? Color("PrimaryColor") : .black))
                    .cornerRadius(10)
                    .padding()
                    .frame(width: .none, height: 400)
                    
                Spacer()
                
                PrimaryButton(label: "Create", isLoading: isLoading, disabled: disabled)
                {
                    self.onSubmit()
                }
                    .padding()
            }
            .padding(20)
        }
        .onAppear {
            focused = true
        }
        .alert(
            "Error!",
            isPresented: $showErrorAlert,
            actions: {
                Button("Ok", role: nil, action: {})
            },
            message: {
                Text("Error while creating your ToDo")
            }
        )
        
    }
}
