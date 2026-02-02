import Foundation
import UIKit

// Sample Swift file with various code smells and issues for testing the AI Code Assistant

class UserManager: NSObject {
    var users: [User] = []
    var currentUser: User!
    
    // Long method with deep nesting
    func processUserData(userId: String, firstName: String, lastName: String, email: String, age: Int, address: String, city: String, country: String, zipCode: String) {
        if userId != "" {
            if firstName != "" {
                if lastName != "" {
                    if email.contains("@") {
                        if age > 18 {
                            if address != "" {
                                if city != "" {
                                    if country != "" {
                                        if zipCode != "" {
                                            let user = User(
                                                id: userId,
                                                firstName: firstName,
                                                lastName: lastName,
                                                email: email,
                                                age: age,
                                                address: address,
                                                city: city,
                                                country: country,
                                                zipCode: zipCode
                                            )
                                            self.users.append(user)
                                            print("User added successfully")
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    // Method with force unwrapping
    func getUserById(id: String) -> User {
        let user = users.first { $0.id == id }
        return user!  // Force unwrap - dangerous!
    }
    
    // Magic numbers
    func calculateDiscount(totalAmount: Double) -> Double {
        if totalAmount > 100 {
            return totalAmount * 0.15  // Magic number
        } else if totalAmount > 50 {
            return totalAmount * 0.10  // Magic number
        }
        return 0
    }
    
    // String concatenation in loop - performance issue
    func generateUserReport() -> String {
        var report = ""
        for user in users {
            report += "User: \(user.firstName) \(user.lastName)\n"  // Inefficient
            report += "Email: \(user.email)\n"
            report += "Age: \(user.age)\n"
            report += "---\n"
        }
        return report
    }
    
    // Unnecessary self usage
    func addUser(_ user: User) {
        self.users.append(user)
        self.printUserCount()
    }
    
    func printUserCount() {
        print("Total users: \(self.users.count)")
    }
    
    // Using count instead of isEmpty
    func hasUsers() -> Bool {
        return users.count > 0  // Should use isEmpty
    }
    
    // Potential retain cycle - no [weak self]
    func fetchUserDataFromAPI(completion: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.users = [User]()  // Retain cycle potential
            completion()
        }
    }
    
    // Long method that should be refactored
    func validateAndSaveUser(firstName: String, lastName: String, email: String, password: String, confirmPassword: String, age: Int, agreedToTerms: Bool) -> Bool {
        // Validation logic
        if firstName.isEmpty {
            print("First name is required")
            return false
        }
        
        if lastName.isEmpty {
            print("Last name is required")
            return false
        }
        
        if email.isEmpty {
            print("Email is required")
            return false
        }
        
        if !email.contains("@") || !email.contains(".") {
            print("Invalid email format")
            return false
        }
        
        if password.isEmpty {
            print("Password is required")
            return false
        }
        
        if password.count < 8 {
            print("Password must be at least 8 characters")
            return false
        }
        
        if password != confirmPassword {
            print("Passwords do not match")
            return false
        }
        
        if age < 18 {
            print("Must be 18 or older")
            return false
        }
        
        if !agreedToTerms {
            print("Must agree to terms and conditions")
            return false
        }
        
        // Save user
        let newUser = User(
            id: UUID().uuidString,
            firstName: firstName,
            lastName: lastName,
            email: email,
            age: age,
            address: "",
            city: "",
            country: "",
            zipCode: ""
        )
        
        users.append(newUser)
        
        // Send welcome email
        print("Sending welcome email to \(email)")
        
        // Log activity
        print("User registered: \(firstName) \(lastName)")
        
        return true
    }
    
    // Duplicate code
    func getActiveUsers() -> [User] {
        var activeUsers: [User] = []
        for user in users {
            if user.isActive {
                activeUsers.append(user)
            }
        }
        return activeUsers
    }
    
    // More duplicate code
    func getPremiumUsers() -> [User] {
        var premiumUsers: [User] = []
        for user in users {
            if user.isPremium {
                premiumUsers.append(user)
            }
        }
        return premiumUsers
    }
}

// Simple User struct
struct User {
    let id: String
    let firstName: String
    let lastName: String
    let email: String
    let age: Int
    let address: String
    let city: String
    let country: String
    let zipCode: String
    var isActive: Bool = true
    var isPremium: Bool = false
}

// Enum without CaseIterable
enum UserRole {
    case admin
    case moderator
    case user
    case guest
}

// God object - doing too many things
class AppManager {
    var users: [User] = []
    var settings: [String: Any] = [:]
    var networkManager: NetworkManager?
    var databaseManager: DatabaseManager?
    
    func handleEverything() {
        // This class does too many things
    }
}

class NetworkManager {
    // Network code
}

class DatabaseManager {
    // Database code
}
