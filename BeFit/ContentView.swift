//
//  ContentView.swift
//  BeFit
//
//  Created by Sahib Anand on 05/01/23.
//

import SwiftUI
import Firebase
import Combine


struct ContentView: View {
    
    @Binding var email : String
    @Binding var password : String
    
    let dataManager = DataManager()
    
    var body: some View {
        VStack {
            Home()
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
        
        let allowedChars = CharacterSet.decimalDigits
        
        
        var body: some View {
            GeometryReader {_ in
                
                VStack{
                    Image("logo")
                    
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
//                        .onReceive(Just(height)) { newValue in
//                            let filtered = newValue.filter { allowedChars.contains(Unicode.Scalar(String($0))!) }
//                            if filtered != newValue {
//                                self.height = filtered
//                            }
//                        }
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
//                        .onReceive(Just(weight)) { newValue in
//                            let filtered = newValue.filter { allowedChars.contains(Unicode.Scalar(String($0))!) }
//                            if filtered != newValue {
//                                self.weight = filtered
//                            }
//                        }
                    if let myBMI = userBMI {
                        Text(String(format: "%.2f", myBMI))
                            .font(.largeTitle)
                            .fontWeight(.black)
                            .padding(.top, 30)
                    } else {
                        Text("Fill Fields Above")
                            .font(.largeTitle)
                            .fontWeight(.black)
                            .padding(.top, 30)
                    }
                }
                .padding(.horizontal, 25)
                
            }
            
            
            
//            NavigationLink(destination: Test(bmi: userBMI ?? 3.14)) {
                
                Button(action: {
                    // Calculate BMI
                    print("Change screen")
//                    print("User BMI Before: \(String(describing: userBMI))")
                    let weightDouble = Double(self.$weight.wrappedValue) ?? 0.0
                    let heightDouble = (Double(self.$height.wrappedValue) ?? 0.0) / 100.0
                    userBMI = weightDouble / (heightDouble * heightDouble)
                    print("User BMI After: \(String(describing: userBMI))")
                }){
                    Text("Get BMI")
                        .foregroundColor(.white)
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width - 50)
                }
                .background(Color("Color"))
                .cornerRadius(10)
                .padding(.top, 25)
//            }

            
        }
        
    }
}

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
                        
                        Text("Full Body Workout")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Text("For Beginners")
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
                
                Text("Weekly Plan")
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
                
                TabView{
                    DetailView()
                        .tabItem(){
                            Image(systemName: "figure.run")
                            Text("Workout")
                        }
                    ViewB()
                        .tabItem(){
                            Image(systemName: "fork.knife")
                            Text("Diet")
                        }
                    ViewC()
                        .tabItem(){
                            Image(systemName: "person.crop.circle")
                            Text("Profile")
                            
                            
                        }
                    
                }
                
                
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


let workoutsData = [
    Workout(day: "Monday", bodyPart: "Chest", image: "chest", routine: ["Warmup", "Push-Ups", "Cooldown"]),
    Workout(day: "Tuesday", bodyPart: "Back", image: "back", routine: ["Warmup", "Pull-Ups", "Cooldown"]),
    Workout(day: "Wednesday", bodyPart: "Biceps", image: "biceps", routine: ["Warmup", "Bicep Curls", "Cooldown"]),
    Workout(day: "Thursday", bodyPart: "Triceps", image: "tricep", routine: ["Warmup", "Tricep Pushdowns", "Cooldown"]),
    Workout(day: "Friday", bodyPart: "Shoulders", image: "shoulder", routine: ["Warmup", "Shoulder Press", "Cooldown"]),
    Workout(day: "Saturday", bodyPart: "Legs", image: "squats", routine: ["Warmup", "Squats", "Cooldown"])
    
]

struct Test: View {
    var bmi: Double
    var body: some View {
        Text("\(bmi)")
            .font(.largeTitle)
            .fontWeight(.bold)
    }
}
