import SwiftUI

struct TodoList: View {
    var list: [Todo]
    var onTodoSelected: (Todo) -> Void
    
    var body: some View {
        ScrollView {
            ForEach(list, id: \.id) { todo in
                HStack {
                    Text(todo.description)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.leading)
                        .padding()
                    
                    Button(action: {
                        onTodoSelected(todo)
                    }) {
                        Image(systemName: todo.completed ? "checkmark.square.fill" : "checkmark.square")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 32, height: 32)
                            
                    }
                    .tint(Color("PrimaryColor").opacity(todo.completed ? 1 : 0.4))
                    .padding()
                    
                }
                .shadow(color: .gray, radius: 6)
                .background(.black.opacity(0.1))
                .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color("PrimaryColor").opacity(0.4)))
                .padding()
            }
        }
    }
}
