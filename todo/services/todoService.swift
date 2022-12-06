import Foundation
import Firebase

struct CreateTodoModel {
    var description: String
    var userId: String
    
    init(description: String, userId: String) {
        self.description = description
        self.userId = userId
    }
}

struct Todo {
    var id: String
    var description: String
    var userId: String
    var completed: Bool
    
    init(id: String, description: String, userId: String, completed: Bool) {
        self.id = id
        self.description = description
        self.userId = userId
        self.completed = completed
    }
    
    static func fromJSON(id: String, json: [String : Any]) -> Todo {
        return Todo(
            id: id,
            description: json["description"] as! String,
            userId: json["userId"] as! String,
            completed: json["completed"] as! Bool
        )
    }
}

struct TodoService {
    static func getUserTodos(userId: String, completion: @escaping ([Todo]?) -> Void) {
        Firestore.firestore().collection("todos").whereField("userId", isEqualTo: userId)
            .getDocuments() {
                (querySnapshot, error) in
                if error != nil {
                    completion(nil)
                }
                let docs = querySnapshot!.documents
                var todos: [Todo] = []
                docs.forEach { doc in
                    let data = doc.data()
                    todos.append(Todo.fromJSON(id: doc.documentID, json: data))
                }
                completion(todos)
            }
    }
    
    static func createTodo(todo: CreateTodoModel, completion: @escaping (Bool) -> Void) {
        let doc = Firestore.firestore().collection("todos").addDocument(
            data: [
                "description": todo.description,
                "userId": todo.userId,
                "completed": false
            ]
        ) { err in
            if err != nil {
                completion(false)
            }
        }
        doc.getDocument { (ref, err) in
            if err != nil {
                completion(false)
            } else {
                completion(true)
            }
        }
        
    }
    
    static func completeTodo(todo: Todo, completion: @escaping (Bool) -> Void) {
        Firestore.firestore().collection("todos").document(todo.id)
            .updateData(
                ["completed": true]
            ) { err in
                if err != nil {
                    completion(false)
                } else {
                    completion(true)
                }
            }
        
    }
}
