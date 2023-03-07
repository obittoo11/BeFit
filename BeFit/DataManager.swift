//
//  DataManager.swift
//  BeFit
//
//  Created by Sahib Anand on 20/02/23.
//

import SwiftUI
import Firebase
import FirebaseCore


struct BMI {
    static let shared = DataManager() // Singleton instance
    
    // Calculate the BMI based on the weight and height
    func calculateBMI(weight: Binding<String>, height: Binding<String>) {
        let weight = Double(weight.wrappedValue) ?? 0.0
        let height = (Double(height.wrappedValue) ?? 0.0) / 100.0
        globalBMI = weight / (height * height)
    }
}

    
    
class DataManager: ObservableObject {
    
    @Published var list = [User]()

    static let shared = DataManager()
    
    let db = Firestore.firestore()
    
    func createAccount(email: String, password: String, bmi: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let uid = authResult?.user.uid else {
                completion(.failure(NSError(domain: "com.yourdomain.app", code: 500, userInfo: [NSLocalizedDescriptionKey: "Failed to retrieve user ID"])))
                return
            }
            let userRef = self.db.collection("users").document(uid)
            userRef.setData([
                "email": email,
                "password": password,
                "bmi": bmi
            ]) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        }
    }
}


    

