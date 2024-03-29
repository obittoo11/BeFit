//
//  ContentView.swift
//  BeFit
//
//  Created by Sahib Anand on 05/01/23.
//

import SwiftUI
import Firebase
import Combine


struct TabBar : View {
    
    @Binding var email : String
    @Binding var password : String
    
    let dataManager = DataManager()
    
    var body: some View {
        TabView {
            DetailView(firstName: .constant("Name"))
                .onAppear {
                    DataManager.shared.createAccount(email: email, password: password, bmi: globalBMI) { result in
                        switch result {
                        case .success:
                            // handle success
                            break
                        case .failure(let error):
                            // handle error
                            print(error.localizedDescription)
                            break
                        }
                    }
                }
                .tabItem(){
                    Image(systemName: "figure.run")
                    Text("Workout")
                }
            DietView()
                .tabItem(){
                    Image(systemName: "fork.knife")
                    Text("Diet")
                }
            profile()
                .tabItem(){
                    Image(systemName: "person.crop.circle")
                    Text("Profile")
                    
                    
                }
            
        }
    }
}

struct ContentView: View {
    
    @Binding var email : String
    @Binding var password : String
    let dataManager = DataManager()
    
    
    var body: some View {
        VStack {
            
            Home()
            
//            DetailView()
//                .onAppear {
//                    DataManager.shared.createAccount(email: email, password: password, bmi: globalBMI) { result in
//                        switch result {
//                        case .success:
//                            // handle success
//                            break
//                        case .failure(let error):
//                            // handle error
//                            print(error.localizedDescription)
//                            break
//                        }
//                    }
//                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(email: .constant("example@gmail.com"), password: .constant("password123"))
    }
}

struct Home : View {
    
    @State var show = false
    @State var status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
    
    var body: some View{
        
        NavigationView{
            
            VStack {
                if self.status{
                    
                    Homescreen()
                    
                    
                } else {
                    
                    ZStack{
                        
                        NavigationLink(destination: SignUp(show: self.$show), isActive: self.$show){
                            Text("")
                        }
                        .hidden()
                        
                        Login(show: self.$show)
                    }
                }
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            .onAppear{
                
                NotificationCenter.default.addObserver(forName: NSNotification.Name("status"), object: nil, queue: .main) { (_) in
                    
                    self.status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
                    
                }
            }
            
        }
    }
    
    
    struct Homescreen : View {
        
        var body: some View{
            
            VStack{
                
                Text("Logged In Successfully")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color.black.opacity(0.7))
                
                
                NavigationLink(destination: getBMI()) {
                    
                    Button(action: {}){
                        
                    }
                    
                    Text("Continue")
                        .foregroundColor(.white)
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width - 50)
                    
                    
                }
                
                
                .background(Color("Color"))
                .cornerRadius(10)
                .padding(.top, 25)
                
                
                Button(action: {
                    
                    try! Auth.auth().signOut()
                    UserDefaults.standard.set(false, forKey: "status")
                    NotificationCenter.default.post(name: NSNotification.Name("status"),
                                                    object: nil)
                    
                }) {
                    
                    Text("Log Out")
                        .foregroundColor(.white)
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width - 50)
                }
                
                
                
                .background(Color("Color"))
                .cornerRadius(10)
                .padding(.top, 25)
            }
        }
        
    }
    
    struct Login : View {
        
        @State var color = Color.black.opacity(0.7)
        @State var email = ""
        @State var pass = ""
        @State var visible = false
        @Binding var show : Bool
        @State var alert = false
        @State var error = ""
        
        var body: some View{
            
            ZStack{
                ZStack(alignment: .topTrailing) {
                    
                    GeometryReader {_ in
                        
                        VStack{
                            Image("logo")
                            
                            Text("Log In To Your Account")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(self.color)
                                .padding(.top, 35)
                            
                            TextField("Email", text: self.$email)
                                .autocapitalization(.none)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 4).stroke(self.email != "" ? Color("Color") : self.color, lineWidth: 2))
                                .padding(.top, 25)
                            
                            HStack(spacing: 15){
                                
                                VStack{
                                    if self.visible{
                                        TextField("Password", text: self.$pass)
                                            .autocapitalization(.none)
                                        
                                    }
                                    else {
                                        SecureField("Password", text: self.$pass)
                                            .autocapitalization(.none)
                                        
                                    }
                                }
                                
                                Button(action: {
                                    self.visible.toggle()
                                    
                                }) {
                                    Image(systemName: self.visible ? "eye.slash.fill" : "eye.fill")
                                        .foregroundColor(self.color)
                                }
                            }
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 4).stroke(self.pass != "" ? Color("Color") : self.color,
                                                                                 lineWidth: 2))
                            .padding(.top, 25)
                            
                            HStack{
                                
                                Spacer()
                                
                                Button(action: {
                                    self.reset()
                                }) {
                                    
                                    Text("Forget Password")
                                        .fontWeight(.bold)
                                        .foregroundColor(Color("Color"))
                                    
                                }
                            }
                            .padding(.top, 20)
                            
                            Button(action: {
                                self.verify()
                                
                            }) {
                                
                                Text("Log In")
                                    .foregroundColor(.white)
                                    .padding(.vertical)
                                    .frame(width: UIScreen.main.bounds.width - 50)
                            }
                            .background(Color("Color"))
                            .cornerRadius(10)
                            .padding(.top, 25)
                            
                            
                        }
                        .padding(.horizontal, 25)
                    }
                    
                    Button(action: {
                        
                        self.show.toggle()
                        
                    }) {
                        
                        Text("Register")
                            .fontWeight(.bold)
                            .foregroundColor(Color("Color"))
                        
                    }
                    
                    .padding()
                }
                
                if self.alert{
                    
                    ErrorView(alert: self.$alert, error: self.$error)
                }
            }
        }
        
        // MARK: Verify Email
        func verify(){
            
            if self.email != "" && self.pass != "" {
                
                Auth.auth().signIn(withEmail: self.email, password: self.pass) { (res,err) in
                    
                    if err != nil{
                        
                        self.error = err!.localizedDescription
                        self.alert.toggle()
                        return
                    }
                    
                    print("success")
                    UserDefaults.standard.set(true, forKey: "status")
                    NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                }
                
            } else {
                
                self.error = "Please Fill All The Contents Properly"
                self.alert.toggle()
            }
        }
        
        func reset(){
            
            if self.email != ""{
                
                Auth.auth().sendPasswordReset(withEmail: self.email) { (err) in
                    
                    if err != nil {
                        self.error = err!.localizedDescription
                        self.alert.toggle()
                        return
                    }
                    
                    self.error = "RESET"
                    self.alert.toggle()
                }
            }
            else{
                self.error = "Email ID is Empty"
                self.alert.toggle()
            }
        }
    }
    
    // MARK: Get BMI
    struct getBMI : View {
        
        @State var color = Color.black.opacity(0.7)
        @State var height: String = ""
        @State var weight: String = ""
        @State var value = ""
        @State public var userBMI: Double?
        @State var linkIsActive = false // New state variable
        
        let allowedChars = CharacterSet.decimalDigits
        
        
        var body: some View {
            GeometryReader {_ in
                VStack{
                    Text("Enter Your Height")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color.black.opacity(0.7))
                        .padding(.top, 35)
                    
                    TextField("Your Height (cm)", text: self.$height)
                        .autocapitalization(.none)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 4).stroke(self.height != "" ? Color("Color") : self.color, lineWidth: 2))
                        .padding(.top, 25)
                    
                    Text("Enter Your Weight")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color.black.opacity(0.7))
                        .padding(.top, 35)
                    
                    TextField("Your Weight (kg)", text: self.$weight)
                        .autocapitalization(.none)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 4).stroke(self.weight != "" ? Color("Color") : self.color, lineWidth: 2))
                        .padding(.top, 25)
                    
                    if let myBMI = userBMI {
                        Text("")
                            .font(.largeTitle)
                            .fontWeight(.black)
                            .padding(.top, 30)
                    } else {
                        Text("")
                            .font(.largeTitle)
                            .fontWeight(.black)
                            .padding(.top, 30)
                    }
                }
                .padding(.top, 125)
                .padding(.horizontal, 25)
            }
            NavigationLink(destination: TabBar(email: .constant("example@gmail.com"), password: .constant("password123")), isActive: self.$linkIsActive) {
                Button(action: {
                    if !self.height.isEmpty && !self.weight.isEmpty {
                        self.linkIsActive = true
                        let heightDouble = Double(self.height) ?? 0
                        let weightDouble = Double(self.weight) ?? 0
                        let bmi = calculateBMI(height: heightDouble, weight: weightDouble)
                        self.userBMI = bmi
                    }
                    
                    
                }){
                    Text("Continue")
                        .foregroundColor(.white)
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width - 50)
                }
                .background(Color("Color"))
                .cornerRadius(10)
                .padding(.top, 25)
            }
        }
    }
    
}

func calculateBMI(height: Double, weight: Double) -> Double {
    let heightMeters = height / 100
    let bmi = weight / (heightMeters * heightMeters)
    
    guard let user = Auth.auth().currentUser else {
        print("Error: no authenticated user found")
        return bmi
    }
    
    let db = Firestore.firestore()
    let bmiRef = db.collection("listBMI").document(user.uid)

    
    let data: [String: Double] = [
        "bmi": bmi
    ]
    
    bmiRef.setData(data) { error in
        if let error = error {
            print("Error saving BMI data: \(error.localizedDescription)")
        } else {
            print("BMI data saved successfully")
        }
    }
    
    return bmi
}


//
//Button(action: {
// Calculate BMI
//print("Change screen")
//                    print("User BMI Before: \(String(describing: userBMI))")
//let weightDouble = Double(self.$weight.wrappedValue) ?? 0.0
//let heightDouble = (Double(self.$height.wrappedValue) ?? 0.0) / 100.0
//userBMI = weightDouble / (heightDouble * heightDouble)
//print("User BMI After: \(String(describing: userBMI))")
//}){
//Text("Get BMI")
//  .foregroundColor(.white)
//.padding(.vertical)
//.frame(width: UIScreen.main.bounds.width - 50)
//}
//.background(Color("Color"))
//.cornerRadius(10)
//.padding(.top, 25)




//struct weight : View {
//
//    @State var height = ""
//    @State var color = Color.black.opacity(0.7)
//    @State var weight = ""
//    @State var value = ""
//
//    let allowedChars = CharacterSet.decimalDigits
//
//
//    var body: some View {
//        GeometryReader {_ in
//
//            VStack{
//                Image("logo")
//
//                Text("Enter Your Weight")
//                    .font(.title)
//                    .fontWeight(.bold)
//                    .foregroundColor(Color.black.opacity(0.7))
//                    .padding(.top, 35)
//
//                TextField("Your Weight (kg)", text: self.$weight)
//                    .autocapitalization(.none)
//                    .padding()
//                    .background(RoundedRectangle(cornerRadius: 4).stroke(self.weight != "" ? Color("Color") : self.color, lineWidth: 2))
//                    .padding(.top, 25)
//                    .onReceive(Just(weight)) { newValue in
//                        let filtered = newValue.filter { allowedChars.contains(Unicode.Scalar(String($0))!) }
//                        if filtered != newValue {
//                            self.weight = filtered
//                        }
//                    }
//
//            }
//            .padding(.horizontal, 25)
//        }
//
//
//        NavigationLink(destination: Test(bmi: <#Double#>)) {
//
//            Button(action: {
////                BMI.calculateBMI(weight: $weight, height: $globalHeight)
//            }){
//
//            }
//
//            Text("Continue")
//                .foregroundColor(.white)
//                .padding(.vertical)
//                .frame(width: UIScreen.main.bounds.width - 50)
//
//
//        }
//
//
//        .background(Color("Color"))
//        .cornerRadius(10)
//        .padding(.top, 25)
//
//    }
//
//}



struct SignUp : View {
    
    @State var color = Color.black.opacity(0.7)
    @State var email = ""
    @State var pass = ""
    @State var repass = ""
    @State var visible = false
    @State var revisible = false
    @Binding var show : Bool
    @State var alert = false
    @State var error = ""
    @State private var showBodyType = false
    
    var body: some View{
        
        ZStack{
            
            ZStack(alignment: .topLeading) {
                
                GeometryReader {_ in
                    
                    VStack{
                        Image("logo")
                        
                        Text("Log In To Your Account")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(self.color)
                            .padding(.top, 35)
                        
                        TextField("Email", text: self.$email)
                            .autocapitalization(.none)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 4).stroke(self.email != "" ? Color("Color") : self.color, lineWidth: 2))
                            .padding(.top, 25)
                        
                        HStack(spacing: 15){
                            
                            VStack{
                                if self.visible{
                                    TextField("Password", text: self.$pass)
                                        .autocapitalization(.none)
                                }
                                else {
                                    SecureField("Password", text: self.$pass)
                                        .autocapitalization(.none)
                                    
                                }
                            }
                            
                            Button(action: {
                                
                                self.visible.toggle()
                                
                            }) {
                                Image(systemName: self.visible ? "eye.slash.fill" : "eye.fill")
                                    .foregroundColor(self.color)
                            }
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 4).stroke(self.repass != "" ? Color("Color") : self.color,
                                                                             lineWidth: 2))
                        .padding(.top, 25)
                        
                        HStack(spacing: 15){
                            
                            VStack{
                                if self.revisible{
                                    TextField("Re-Enter", text: self.$repass)
                                        .autocapitalization(.none)
                                    
                                }
                                else {
                                    SecureField("Re-Enter", text: self.$repass)
                                        .autocapitalization(.none)
                                    
                                }
                            }
                            
                            Button(action: {
                                showBodyType = true
                                self.revisible.toggle()
                                
                            }) {
                                Image(systemName: self.revisible ? "eye.slash.fill" : "eye.fill")
                                    .foregroundColor(self.color)
                            }
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 4).stroke(self.pass != "" ? Color("Color") : self.color,
                                                                             lineWidth: 2))
                        .padding(.top, 25)
                        
                        Button(action: {
                            showBodyType = true
                            self.register()
                            
                        }) {
                            
                            Text("Register")
                                .foregroundColor(.white)
                                .padding(.vertical)
                                .frame(width: UIScreen.main.bounds.width - 50)
                        }
                        
                        
                        .background(Color("Color"))
                        .cornerRadius(10)
                        .padding(.top, 25)
                        
                        
                    }
                    .padding(.horizontal, 25)
                }
                
                Button(action: {
                    self.show.toggle()
                    
                }) {
                    
                    Image(systemName: "chevron.left")
                        .font(.title)
                        .foregroundColor(Color("Color"))
                    
                }
                
                .padding()
            }
            
            if self.alert{
                ErrorView(alert: self.$alert, error: self.$error)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    func register(){
        if self.email != "" {
            if self.pass == self.repass{
                
                Auth.auth().createUser(withEmail: self.email, password: self.pass){
                    (res, err) in
                    
                    if err != nil{
                        
                        self.error = err!.localizedDescription
                        self.alert.toggle()
                        return
                    }
                    
                    print("success")
                    
                    UserDefaults.standard.set(true, forKey: "status")
                    NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                }
                
            }
            else {
                self.error = "Password Mismatch"
                self.alert.toggle()
            }
        }
        
        else{
            
            self.error = "Please Fill All The Contents Properly"
            self.alert.toggle()
        }
    }
}

struct ErrorView: View {
    
    @State var color = Color.black.opacity(0.7)
    @Binding var alert : Bool
    @Binding var error : String
    
    var body: some View{
        
        GeometryReader{_ in
            
            VStack{
                
                HStack{
                    
                    Text(self.error == "RESET" ? "Message" : "Error")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(self.color)
                        .padding(.leading, 100)
                    
                    Spacer()
                }
                .padding(.horizontal, 25)
                
                Text(self.error == "RESET" ? "Password Reset Link has been Sent Successfully" : self.error)
                    .foregroundColor(self.color)
                    .padding(.top)
                    .padding(.horizontal, 25)
                
                Button(action: {
                    
                    self.alert.toggle()
                }) {
                    
                    Text(self.error == "RESET" ? "Ok" :  "Cancel")
                        .foregroundColor(.white)
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width - 120)
                }
                
                .background(Color("Color"))
                .cornerRadius(10)
                .padding(.top, 25)
            }
            .padding(.vertical, 25)
            .frame(width: UIScreen.main.bounds.width - 70)
            .background(Color.white)
            .cornerRadius(15)
        }
        .padding(.leading, 34)
        .padding(.top, 200)
        .background(Color.black.opacity(0.35).edgesIgnoringSafeArea(.all))
    }
}

struct DetailView : View {
    
    @Binding var firstName : String
    
    var body : some View {
        NavigationView {
            VStack(alignment: .leading){
                ZStack{
                    Image("pic1")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 300)
                    
                    VStack {
                        
                        
                        Spacer()
                        
                        Text("Hello \(globalName)!")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("Welcome to BeFit!")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Text("Become the Best Version of Yourself!")
                            .fontWeight(.regular)
                            .foregroundColor(.white)
                            .padding(20)
                        
                    }
                    .frame(width: 350)
                    
                }
                
                .frame(width: 350, height: 300)
                .cornerRadius(20)
                .clipped()
                .shadow(radius: 8)
                //.padding(.top, 20)
                .padding()
                
                Text("Weekly Workout")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .center)
                
                
                ScrollView(.horizontal, showsIndicators: false){
                    VStack{
                        HStack(spacing: 30){
                            
                            ForEach(workoutsData) { workout in
                                
                                NavigationLink(destination: ListView()){
                                    ZStack{
                                        Image(workout.image)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(height: 220)
                                        
                                        VStack {
                                            
                                            Spacer()
                                            
                                            Text(workout.day)
                                                .font(.title2)
                                                .fontWeight(.semibold)
                                                .foregroundColor(.white)
                                            Text(workout.bodyPart)
                                                .fontWeight(.regular)
                                                .foregroundColor(.white)
                                            
                                        }
                                        
                                        .padding()
                                        .frame(width: 150)
                                        
                                    }
                                }
                                
                                .frame(width: 150, height: 220)
                                .clipped()
                                .cornerRadius(20)
                                .shadow(radius: 8)
                                
                            }
                        }
                        .padding()
                    }
                    
                }
                
                
                
                Spacer()
            }
            
            
            
        }
    }
}


struct Workout: Identifiable {
    //variable UUID is being set to the unique identifier gotten from UUID
    var id = UUID()
    var day : String
    var bodyPart : String
    var image: String
    var routine: [String]
    
    
}

struct DietView : View {
    @State var progressValue: Float = 0.0

    var body : some View {
        NavigationView {
            VStack(alignment: .leading){
                
                Text("Weekly Diet")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .center)
                
                
                ScrollView(.horizontal, showsIndicators: false){
                    VStack{
                        HStack(spacing: 30){
                            
                            ForEach(dietData) { diet in
                                
                                NavigationLink(destination: ListView()){
                                    ZStack{
                                        Image(diet.image)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(height: 220)
                                        
                                        VStack {
                                            
                                            Spacer()
                                            
                                            Text(diet.day)
                                                .font(.title2)
                                                .fontWeight(.semibold)
                                                .foregroundColor(.white)
                                            Text(diet.bodyPart)
                                                .fontWeight(.regular)
                                                .foregroundColor(.white)
                                            
                                        }
                                        
                                        .padding()
                                        .frame(width: 150)
                                        
                                    }
                                }
                                
                                .frame(width: 150, height: 220)
                                .clipped()
                                .cornerRadius(20)
                                .shadow(radius: 8)
                                
                            }
                        }
                        .padding()
                    }
                    
                }
                
                VStack{
                        
                        VStack{
                            Text("Daily Goal")
                                .font(.title)
                                .bold()
                            Text("5 Glasses of Water")
                                .font(.caption)
                                .bold()
                        }
                        
                            VStack{
                                ProgressBar(progress: self.$progressValue)
                                    .frame(width: 150.0, height: 150.0)
                                    .padding(20.0)
                                
                                Button(action: {
                                    self.incrementProgress()
                                }) {
                                    HStack{
                                        Image(systemName: "plus.rectangle.fill")
                                        Text("Drink More Water")
                                    }
                                    .padding(15.0)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 15.0)
                                            .stroke(lineWidth: 2.0)
                                    )
                                }
                                
                            }
                }
                .padding(.leading, 90)
                
                
                Spacer()
            }
            
            
            
        }
        
        }
    func incrementProgress(){
        let randomValue = Float([0.2].randomElement()!)
        self.progressValue += randomValue
    }
}

struct ProgressBar : View {
    @Binding var progress: Float
    
    var body: some View {
        ZStack{
                Circle()
                    .stroke(lineWidth: 20.0)
                    .opacity(0.3)
                    .foregroundColor(Color("Color"))
            
            Circle()
                .trim(from: 0.0, to: CGFloat(min(self.progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(Color("Color"))
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear)
            
            Text(String(format: "%.0f %%", min(self.progress, 1.0)*100.0))
                .font(.largeTitle)
                .bold()
        }
    }
}


let workoutsData = [
    Workout(day: "Monday", bodyPart: "Chest", image: "chest", routine: ["Warmup", "Push-Ups", "Cooldown"]),
    Workout(day: "Tuesday", bodyPart: "Back", image: "back", routine: ["Warmup", "Pull-Ups", "Cooldown"]),
    Workout(day: "Wednesday", bodyPart: "Biceps", image: "biceps", routine: ["Warmup", "Bicep Curls", "Cooldown"]),
    Workout(day: "Thursday", bodyPart: "Triceps", image: "tricep", routine: ["Warmup", "Tricep Pushdowns", "Cooldown"]),
    Workout(day: "Friday", bodyPart: "Shoulders", image: "shoulder", routine: ["Warmup", "Shoulder Press", "Cooldown"]),
    Workout(day: "Saturday", bodyPart: "Legs", image: "squats", routine: ["Warmup", "Squats", "Cooldown"])
    
]

struct Diet: Identifiable {
    //variable UUID is being set to the unique identifier gotten from UUID
    var id = UUID()
    var day : String
    var bodyPart : String
    var image: String
    var routine: [String]
    
    
}

let dietData = [
    Diet(day: "Meal 1", bodyPart: "Breakfast", image: "breakfast", routine: ["Warmup", "Push-Ups", "Cooldown"]),
    Diet(day: "Meal 2", bodyPart: "Snack", image: "snack1", routine: ["Warmup", "Pull-Ups", "Cooldown"]),
    Diet(day: "Meal 3", bodyPart: "Lunch", image: "lunch", routine: ["Warmup", "Bicep Curls", "Cooldown"]),
    Diet(day: "Meal 4", bodyPart: "Snack", image: "snack2", routine: ["Warmup", "Tricep Pushdowns", "Cooldown"]),
    Diet(day: "Meal 5", bodyPart: "Dinner", image: "dinner", routine: ["Warmup", "Shoulder Press", "Cooldown"]),
    
]

struct ImagePicker : UIViewControllerRepresentable{
    @Environment(\.presentationMode) private var presentationMode
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Binding var selectedImage: UIImage
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator
        
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        var parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            
            parent.presentationMode.wrappedValue.dismiss()
        }
        
    }
}

struct UserInfo {
    var firstName: String
    var lastName: String
    // Add other properties as needed
}

struct profile : View {
    @State private var image = UIImage()
    @State private var showSheet = false
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var birthDate = Date()
    
    var body: some View {
        
        VStack{
            VStack {
                Image(uiImage: self.image)
                    .resizable()
                    .cornerRadius(50)
                    .frame(width: 200, height: 200)
                    .background(Color.black.opacity(0.2))
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Circle())
                    .padding(.top, 50)
                
                Text("Change Photo")
                    .font(.title3)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .frame(height: 65)
                    .background(Color("Color"))
                    .cornerRadius(16)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .onTapGesture {
                        showSheet = true
                    }
                    .padding(.top, 50)
            }
            .padding(.top, 25)
            .padding(.bottom, 30)
            .padding(.horizontal, 20)
            .sheet(isPresented: $showSheet) {
                
                ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image)
            }
            
                Form{
                    TextField("First Name", text: $firstName, onEditingChanged: { isEditing in
                        if !isEditing {
                            globalName = firstName
                        }
                    })
                    TextField("Last Name", text: $lastName)
                    DatePicker("Birth Date", selection: $birthDate, displayedComponents: .date)
                    Button("Save") {
                        let userInfo = UserInfo(firstName: firstName, lastName: lastName)
                        saveUserInfo(userInfo)
                    }
                    
            }
        }
        
        
    }
}

func saveUserInfo(_ userInfo: UserInfo) {
    guard let user = Auth.auth().currentUser else {
        print("Error: no authenticated user found")
        return
    }
    
    let db = Firestore.firestore()
    let userRef = db.collection("userinfo").document(user.uid)
    
    let data: [String: Any] = [
        "firstName": userInfo.firstName,
        "lastName": userInfo.lastName,
        // add other properties here
    ]
    
    userRef.setData(data) { error in
        if let error = error {
            print("Error saving user info: \(error.localizedDescription)")
        } else {
            print("User info saved successfully")
        }
    }
}




struct Test: View {
    var bmi: Double
    var body: some View {
        Text("\(bmi)")
            .font(.largeTitle)
            .fontWeight(.bold)
    }
}
