//
//  ListView.swift
//  BeFit
//
//  Created by Sahib Anand on 20/02/23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import FirebaseFirestoreSwift

struct ListView: View {
    @EnvironmentObject var dataManager : DataManager
    @State var bmi: Double = 0
    
    
    private var workoutList: [WorkoutItem] {
        if bmi != 0 {
            
            if bmi >= 35 {
                return [WorkoutItem(
                    workoutItem: Image("flame"),
                    name: "Warm-up",
                    description: "Start with a 5-10 minute light cardio exercise such as marching in place, step-ups, or stationary bike."
                ),
                WorkoutItem(
                    workoutItem: Image("walk"),
                    name: "Low-impact Aerobic Exercise",
                    description: "Perform low-impact exercises for 30-60 minutes such as walking, swimming, or cycling. You can also use a stationary bike or elliptical if preferred."
                ),
                WorkoutItem(
                    workoutItem: Image("house"),
                    name: "Bodyweight Circuit",
                    description: "Perform the following circuit for 3 sets:\n- 10 squats (use a chair for support if needed)\n- 10 push-ups (modified if needed)\n- 10 lunges (each leg)\n- 10 sit-ups (use a stability ball for support if needed)"
                ),
                WorkoutItem(
                    workoutItem: Image("flame"),
                    name: "Plank",
                    description: "Lie on your stomach, and lift your body up with your elbows and toes, keeping your body in a straight line. Hold for 30-60 seconds."
                ),
                WorkoutItem(
                    workoutItem: Image("scale"),
                    name: "Resistance Training",
                    description: "Use resistance bands or weights to perform the following exercises for 3 sets of 8-10 reps:\n- Bicep curls\n- Tricep extensions\n- Shoulder presses\n- Chest presses\n- Rows\n- Squats (with weights)"
                ),
                WorkoutItem(
                    workoutItem: Image("flame"),
                    name: "Cool-down",
                    description: "Finish with a 5-10 minute stretch to help your muscles recover."
                )]
            }
            
            if bmi >= 30 && bmi <= 34.9 {
                return [WorkoutItem(
                    workoutItem: Image("flame"),
                    name: "Warm-up",
                    description: "Start with a 5-10 minute light cardio exercise such as jogging, cycling, or jumping jacks."
                ),
                WorkoutItem(
                    workoutItem: Image("walk"),
                    name: "Brisk Walking",
                    description: "Walk at a brisk pace for 20-30 minutes. You can also use a treadmill, elliptical, or stationary bike if preferred."
                ),
                WorkoutItem(
                    workoutItem: Image("house"),
                    name: "Bodyweight Circuit",
                    description: "Perform the following circuit for 3 sets:\n- 10 squats\n- 10 push-ups (modified if needed)\n- 10 lunges (each leg)\n- 10 sit-ups"
                ),
                WorkoutItem(
                    workoutItem: Image("flame"),
                    name: "Plank",
                    description: "Lie on your stomach, and lift your body up with your elbows and toes, keeping your body in a straight line. Hold for 30-60 seconds."
                ),
                WorkoutItem(
                    workoutItem: Image("scale"),
                    name: "Resistance Training",
                    description: "Use resistance bands or weights to perform the following exercises for 3 sets of 8-10 reps:\n- Bicep curls\n- Tricep extensions\n- Shoulder presses\n- Chest presses\n- Rows\n- Squats (with weights)"
                ),
                WorkoutItem(
                    workoutItem: Image("flame"),
                    name: "Cool-down",
                    description: "Finish with a 5-10 minute stretch to help your muscles recover."
                )]
            }
            if bmi >= 25.0 && bmi <= 29.9 {
                return [WorkoutItem(
                    workoutItem: Image("inclinepress"),
                    name: "Incline Dumbell Press",
                    description: "Repeat 15 Times for 3 Sets"),
                  WorkoutItem(
                    workoutItem: Image("white"),
                    name: "Rest",
                    description: "Rest for 30-60 Seconds"),
                  WorkoutItem(
                    workoutItem: Image("flatpress"),
                    name: "Flat Benchpress",
                    description: "Repeat 15 Times for 3 Sets"),
                  WorkoutItem(
                    workoutItem: Image("white"),
                    name: "Rest",
                    description: "Rest for 30-60 Seconds"),
                  WorkoutItem(
                    workoutItem: Image("flys"),
                    name: "Machine Chest Flys",
                    description: "Repeat 15 Times for 3 Sets")]
            }
            if bmi >= 18.5 && bmi <= 24.9 {
                return [WorkoutItem(
                    workoutItem: Image("flame"),
                    name: "Warm-up",
                    description: "Start with a 5-10 minute light cardio exercise such as jogging, cycling, or jumping jacks."
                ),

                WorkoutItem(
                    workoutItem: Image("squat"),
                    name: "Squats",
                    description: "Stand with your feet hip-width apart, and lower your body by bending your knees, keeping your back straight. Repeat for 3 sets of 10 reps."
                ),

                WorkoutItem(
                    workoutItem: Image("pushup"),
                    name: "Push-ups",
                    description: "Lie on your stomach with your hands shoulder-width apart, and push your body up, keeping your back straight. Repeat for 3 sets of 10 reps."
                ),

                WorkoutItem(
                    workoutItem: Image("walk"),
                    name: "Lunges",
                    description: "Stand with your feet shoulder-width apart, take a step forward with one foot, and lower your body until your knee is bent at a 90-degree angle. Repeat for 3 sets of 10 reps on each leg."
                ),

                WorkoutItem(
                    workoutItem: Image("flame"),
                    name: "Plank",
                    description: "Lie on your stomach, and lift your body up with your elbows and toes, keeping your body in a straight line. Hold for 30 seconds to 1 minute."
                ),

                WorkoutItem(
                    workoutItem: Image("flame"),
                    name: "Cool-down",
                    description: "Finish with a 5-10 minute stretch to help your muscles recover."
                )]
            }
            if bmi <= 18.5 {
                return [WorkoutItem(
                    workoutItem: Image("flame"),
                    name: "Warm-up",
                    description: "Start with a 5-10 minute light cardio exercise such as jogging, cycling, or jumping jacks."
                ),
                WorkoutItem(
                    workoutItem: Image("squat"),
                    name: "Bodyweight squats",
                    description: "Stand with your feet hip-width apart, and lower your body by bending your knees, keeping your back straight. Repeat for 3 sets of 8-10 reps."
                ),
                WorkoutItem(
                    workoutItem: Image("pushup"),
                    name: "Modified push-ups",
                    description: "Kneel on the ground and place your hands shoulder-width apart, keeping your back straight. Lower your body towards the ground, and then push back up. Repeat for 3 sets of 8-10 reps."
                ),
                WorkoutItem(
                    workoutItem: Image("lunge"),
                    name: "Lunges",
                    description: "Stand with your feet shoulder-width apart, take a step forward with one foot, and lower your body until your knee is bent at a 90-degree angle. Repeat for 3 sets of 8-10 reps on each leg."
                ),
                WorkoutItem(
                    workoutItem: Image("flame"),
                    name: "Plank",
                    description: "Lie on your stomach, and lift your body up with your elbows and toes, keeping your body in a straight line. Hold for 15-30 seconds."
                ),
                WorkoutItem(
                    workoutItem: Image("flame"),
                    name: "Cool-down",
                    description: "Finish with a 5-10 minute stretch to help your muscles recover."
                )]
            }
        }
        return [WorkoutItem(workoutItem: Image("cancel"), name: "No BMI Selected", description: "Looks like there was an error getting your BMI or you didn't input one.")]
    }
    
    
    
    
    var body: some View {
        NavigationView {
            List(workoutList) { item in
                HStack(spacing: 20){
                    ZStack(){
                        Text(item.workoutItem)
                            .frame(width: 65, height: 65)


                    }
                    
                    VStack{
//                        Button {
//                            setBMI()
//                        } label: {
//                            Text("test")
//                        }

                        Text(item.name)
                            .font(.headline)
                            .fontWeight(.semibold)
                        Text(item.description)
                            .fontWeight(.regular)
                        
                    }
                }
                
                .padding(.vertical, 15)
            }
            .onAppear{
                setBMI()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Personlized Workout")
                        .font(.largeTitle.bold())
                        .accessibilityAddTraits(.isHeader)
                }
            }
            .fontWeight(.bold)
        }
        
    }
    
    func setBMI() {
        guard let user = Auth.auth().currentUser else {
            print("Error: no authenticated user found")
            return
        }
        
        let db = Firestore.firestore()
        let bmiRef = db.collection("listBMI").document(user.uid)
        
        bmiRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
                
                let bmiData = document.data() as? [String: Double]
                
                print(bmiData!["bmi"])
                bmi = bmiData!["bmi"]!
                print("BMI variable data is \(bmi)")
                
//                if let bmi = dataDescription["bmi"] {
//                    print("The value of the \"bmi\" key is \(bmi)")
//                } else {
//                    print("There is no value for the \"bmi\" key.")
//                }
            } else {
                print("Document does not exist")
            }
        }
    }
    
}

struct WorkoutItem : Identifiable {
    let id = UUID()
    let workoutItem : Image
    let name : String
    let description : String
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}
