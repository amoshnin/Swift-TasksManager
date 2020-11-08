import Foundation
import Combine
import Resolver
import Firebase

class SettingsViewModel: ObservableObject {
  @Published var user: User?
  @Published var email: String = ""
  @Published var displayName: String = ""
  
  @Published private var authenticationService: AuthenticationService = Resolver.resolve()
  
  private var cancellables = Set<AnyCancellable>()
  
  init() {
    authenticationService.$user.compactMap { user in
      user?.email
    }
    .assign(to: \.email, on: self)
    .store(in: &cancellables)
    
    authenticationService.$user.compactMap { user in
      user?.displayName
    }
    .assign(to: \.displayName, on: self)
    .store(in: &cancellables)

  }
  
  func logout() {
    self.authenticationService.signOut()
  }
  
}

