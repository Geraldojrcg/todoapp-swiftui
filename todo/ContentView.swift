import SwiftUI

struct ContentView: View {
    @State var isLogged: Bool = false
    
    var body: some View {
        NavigationView {
            if isLogged == true {
                HomeView()
            } else {
                LoginView()
            }
        }
        .onAppear{
            isLogged = AuthService.isLoggedIn()
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("goToHome"))) { output in
            isLogged = true
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("goToLogin"))) { output in
            isLogged = false
        }
    }
}

