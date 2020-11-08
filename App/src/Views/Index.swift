import SwiftUI
import Firebase

struct Index: View {
    @ObservedObject var authenticationService = AuthenticationService()
    
    
    var body: some View {
        VStack {
            if authenticationService.isAuth {
                TaskListView()
            } else {
                AuthView()
            }
        }
    }
}

struct Index_Previews: PreviewProvider {
    static var previews: some View {
        Index()
    }
}
