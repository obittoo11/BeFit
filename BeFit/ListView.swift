//
//  ListView.swift
//  BeFit
//
//  Created by Sahib Anand on 20/02/23.
//

import SwiftUI

struct ListView: View {
    @EnvironmentObject var dataManager : DataManager
    
    
    private let workoutList: [WorkoutItem] = [
        WorkoutItem(
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
          description: "Repeat 15 Times for 3 Sets")
      ]
    
    var body: some View {
        NavigationView {
            List(workoutList) { item in
                HStack(spacing: 20){
                    ZStack(){
                        Text(item.workoutItem)
                            .frame(width: 65, height: 65)


                    }
                    
                    VStack{
                        Text(item.name)
                            .font(.headline)
                            .fontWeight(.semibold)
                        Text(item.description)
                            .fontWeight(.regular)
                        
                    }
                }
                
                .padding(.vertical, 15)
            }
            
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Chest Workout")
                        .font(.largeTitle.bold())
                        .accessibilityAddTraits(.isHeader)
                }
            }
            .fontWeight(.bold)
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
