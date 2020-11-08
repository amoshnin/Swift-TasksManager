
import Foundation
import Disk

import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseFunctions

import Combine
import Resolver

class BaseTaskRepository {
    @Published var tasks = [Task]()
}

protocol TaskRepository: BaseTaskRepository {
    func addTask(_ task: Task)
    func removeTask(_ task: Task)
    func updateTask(_ task: Task)
}


class FirestoreTaskRepository: BaseTaskRepository, TaskRepository, ObservableObject {
    @Injected var db: Firestore
    @Injected var authenticationService: AuthenticationService
    @LazyInjected var functions: Functions
    
    var tasksPath: String = "tasks"
    var userId: String = "unknown"
    
    private var listenerRegistration: ListenerRegistration?
    private var cancellables = Set<AnyCancellable>()
    
    override init() {
        super.init()
        
        authenticationService.$user
            .compactMap { user in
                user?.uid
            }
            .assign(to: \.userId, on: self)
            .store(in: &cancellables)
        
        // (re)load data if user changes
        authenticationService.$user
            .receive(on: DispatchQueue.main)
            .sink { [weak self] user in
                self?.loadData()
            }
            .store(in: &cancellables)
    }
    
    private func loadData() {
        if listenerRegistration != nil {
            listenerRegistration?.remove()
        }
        
        db.collection(tasksPath)
            .order(by: "createdAt")
            .whereField("userId", isEqualTo: self.userId)
            .addSnapshotListener { querySnapshot, error in
                if let querySnapshot = querySnapshot {
                    self.tasks = querySnapshot.documents.compactMap { document -> Task? in
                        try? document.data(as: Task.self)
                    }
                }
            }
    }
    
    func addTask(_ task: Task) {
        do {
            var userTask = task
            userTask.userId = self.userId
            let _ = try db.collection(tasksPath).addDocument(from: userTask)
        }
        catch {
            fatalError("Unable to encode task: \(error.localizedDescription).")
        }
    }
    
    func removeTask(_ task: Task) {
        if let taskID = task.id {
            db.collection(tasksPath).document(taskID).delete { (error) in
                if let error = error {
                    print("Unable to remove document: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func updateTask(_ task: Task) {
        if let taskID = task.id {
            do {
                try db.collection(tasksPath).document(taskID).setData(from: task)
            }
            catch {
                fatalError("Unable to encode task: \(error.localizedDescription).")
            }
        }
    }
    
    func migrateTasks(fromUserId: String) {
        let data = ["previousUserId": fromUserId]
        functions.httpsCallable("migrateTasks").call(data) { (result, error) in
            if let error = error as NSError? {
                print("Error: \(error.localizedDescription)")
            }
            print("Function result: \(result?.data ?? "(empty)")")
        }
    }
}
