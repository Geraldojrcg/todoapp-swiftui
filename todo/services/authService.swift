import Foundation
import Firebase

struct RegisterModel {
    var name: String
    var email: String
    var password: String
    
    init(name: String, email: String, password: String) {
        self.name = name
        self.email = email
        self.password = password
    }
}

struct User {
    var id: String
    var name: String
    var email: String
    
    init(id: String, name: String, email: String) {
        self.id = id
        self.name = name
        self.email = email
    }
}

struct AuthService {
    
    static func isLoggedIn() -> Bool {
        return Auth.auth().currentUser != nil
    }
    
    static func getUser(completion: @escaping (User?) -> Void) {
        let authUser = Auth.auth().currentUser
        if authUser == nil  {
            completion(nil)
        } else {
            Firestore.firestore().collection("users").whereField("email", isEqualTo: authUser?.email ?? "")
                .getDocuments(completion: { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                        completion(nil)
                    } else {
                        let document = querySnapshot!.documents.first
                        let data = document?.data()
                        let user = User(
                            id: document!.documentID,
                            name: data?["name"] as! String,
                            email: data?["email"] as! String
                        )
                        completion(user)
                    }
                })
        }
    }
    
    static func login(email: String, password: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    static func logout(completion: @escaping (Bool) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(true)
        } catch {
            completion(false)
        }
    }
    
    static func register(model: RegisterModel, completion: @escaping (Bool) -> Void) {
        Auth.auth().createUser(withEmail: model.email, password: model.password) { (result, error) in
            if error != nil {
                completion(false)
            } else {
                Firestore.firestore().collection("users").addDocument(data: ["name": model.name, "email": model.email]) { (error) in
                    if error != nil {
                        completion(false)
                    } else {
                        completion(true)
                    }
                }
            }
        }
    }
}
