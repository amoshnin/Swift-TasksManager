import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

enum TaskPriority: Int, Codable {
  case high
  case medium
  case low
}

struct Task: Codable, Identifiable {
  @DocumentID var id: String?
  var title: String
  var priority: TaskPriority
  var completed: Bool
  @ServerTimestamp var createdAt: Timestamp?
  var userId: String?
}
 
