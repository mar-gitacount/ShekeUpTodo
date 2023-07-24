//
//  ShakeTimesListView.swift
//  ShakeUp
//
//  Created by Hal Stroemeria on 2019/12/05.
//  Copyright © 2019 hal-cha-n. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseDatabase

import FirebaseAuth
import FirebaseDatabase
import FirebaseFirestore
import LocalAuthentication
import FirebaseMessaging
import CoreData
import EventKit

struct LoadView{
    func showLoading() {
        Color.black
            .opacity(1.0)
            .ignoresSafeArea()
            .overlay(
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
            )
    }
}
//メイン画面
struct MainView: View{
   // @Binding var Actionflg:Bool?
    @ObservedObject var authControlManager = AuthControlManager()
//    @ObservedObject var firebasemodel = FirebasetododatagetModel()
    @StateObject private var  firebasemodel = FirebasetododatagetModel()
    @Environment(\.presentationMode) var presentationMode
//    @EnvironmentObject var shakeTimes: ShakeTimesViewModel
    @StateObject var viewModel = ToDoListViewModel()
    @State private var showPopUpDialog = false
    //ビューを強制的に更新するリロードフラグ
    @State private var reloadFlg = false
    @State var searchText = ""
    //以下はビューを更新するためのコード
    @State private var viewuploadConrollflg = false
    @Binding var childviewchangeflg : Bool
    @State private var isLoading = false
    let loadingview = LoadView()
    
    
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    var body: some View{
        //横方向オブジェクト
        HStack{
            //Text("+").frame(alignment: .trailing)
            //todo作成縦方向
            NavigationStack{
                VStack{}.toolbar {
                    ToolbarItem(placement:.navigationBarLeading){
                        menu
                    }
                    ToolbarItem(placement:.navigationBarTrailing){
                        HStack {
                            Image(systemName: "magnifyingglass") //検索アイコン
                            TextField("タスクを検索 ...", text: $searchText)
//                            firebasemodel.serchvalue = "t"
                        }.padding()
                            .background(Color(.systemGray6))//背景色
                            .padding()
                    }
                    //ユーザーデータがtrueならボタン表示
                    ToolbarItem(placement:.navigationBarTrailing){
                        Button(action: {
                            viewModel.showPopUpDialog = true
                            showPopUpDialog = true
                            viewModel.startTtime = Date()
                            viewModel.endTime = Date()
                            
                        }){
                            Image(systemName: "plus")
                        }
                    }
                }.sheet(isPresented:$showPopUpDialog,onDismiss: {
                    childviewchangeflg.toggle()
                    firebasemodel.fetchData()
                    firebasemodel.loddingflg = true
                    
                  //  isLoading = true
                   
                }){
                    PopupView(isPresent: $showPopUpDialog,
                              firebaseid: $viewModel.firevaseid,
                              //firebaseid: $testsansyo,
                              tasktitle: $viewModel.titletext,
                              //tasktitle: $testsansyo,
                              taskBody: $viewModel.bodytext,
                              taskCategory: $viewModel.taskCategory,
                              startTime: $viewModel.startTtime,
                              endTIme: $viewModel.endTime,viewchange:$childviewchangeflg).onDisappear{
                       // firebasemodel.popupdatas.removeAll()
//                        firebasemodel.fetchData()
                        isLoading = true
                        viewModel.firevaseid = ""
                        viewModel.titletext = ""
                        viewModel.bodytext = ""
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            isLoading = false
                        }
                        
                        presentationMode.wrappedValue.dismiss()
                        childviewchangeflg.toggle()
                    }
                }.id(reloadFlg)
                if viewModel.showPopUpDialog{
                }
                if authControlManager.isLoggedIn{
                    ZStack{
                        List{
                            
                            ForEach(firebasemodel.popupdatas) { data in
                                //  Text(data.taskTitle.isEmpty ? "なし":data.taskTitle)
                                //スワイプしたら編集ボタンと削除ボタンを出現させる。
                                //ここで
                            
                                Text(data.taskTitle).swipeActions(edge: .trailing) {
                                    
                                    
                                    
                                    //削除ボタン
                                    Button {
                                        // 処理ここで指定したレコードを削除する。
                                        isLoading = true
                                        firebasemodel.singledelete(data:data.id)
                                        firebasemodel.popupdatas.removeAll()
                                        guard let userid = Auth.auth().currentUser?.uid else {
                                            print("なし")
                                            return
                                        }
                                        Firestore.firestore().collection("users").document(userid).collection("tasklist")
                                            .document(data.id).delete(){ err in
                                                if let err = err {
                                                    print("デリートエラー")
                                                }
                                                else{
                                                    print("消しました。")
                                                    firebasemodel.fetchData()
                                                }
                                            }
                                    } label: {
                                        Text("削除")
                                    }
                                    .tint(.red)
                                    
                                    
                                    //編集ボタン
                                    Button(action: {
                                        // 編集に関する処理を記述
                                        // 値を渡す。
                                        viewModel.titletext = data.taskTitle
                                        viewModel.bodytext = data.taskBody
                                        viewModel.firevaseid = data.id
                                        viewModel.startTtime = StringChangeDate(string:data.startTime)
                                        viewModel.taskCategory = data.taskCategory
                                        showPopUpDialog = true
                                        
                                    }) {
                                        Label("編集", systemImage: "pencil")
                                    }
                                    .tint(.blue)
//                                    .sheet(isPresented: $showPopUpDialog) {
//                                    // シートの表示内容をここに記述
//                                    PopupView(isPresent: $showPopUpDialog, firebaseid: $viewModel.firevaseid, tasktitle: "", taskBody: $viewModel.bodytext, taskCategory: $viewModel.taskCategory, startTime: $viewModel.startTtime, endTIme: $viewModel.endTime, viewchange: $childviewchangeflg)
//                                }
                                    
                                }
                                
                                //ここで渡ってきたidを取得するような値を持たさなくてはならない。
                                .onTapGesture {
                                    // タップ時の処理
                                    viewModel.titletext = data.taskTitle
                                    viewModel.bodytext = data.taskBody
                                    viewModel.firevaseid = data.id
                                    viewModel.startTtime = StringChangeDate(string:data.startTime)
                                    viewModel.taskCategory = data.taskCategory
                                    showPopUpDialog = true
                                    childviewchangeflg.toggle()
                                    print("Tapped item: \(data.id)")
                                    guard let userid = Auth.auth().currentUser?.uid else {
                                        print("なし")
                                        return
                                        
                                    }
//                                    Firestore.firestore().collection("users").document(userid).collection("tasklist")
//                                        .document(data.id).delete(){ err in
//                                            if let err = err {
//                                                print("デリートエラー")
//                                            }
//                                            else{
//                                                print("消しました。")
//                                            }
//                                        }
                                }
                            }
//
                        }
//                        .overlay( Rectangle()
//                            .frame(height: 1)
//                            .foregroundColor(.red))
                        if isLoading {
                            // ローディング画面を表示
//                            loadingview.showLoading()
//                            Color.black
//                                .opacity(1.0)
//                                .ignoresSafeArea()
//                                .overlay(
//                                    ProgressView()
//                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
//                                )
                        }
                        
                    }
                        .onAppear{
                            //ここで検索方法を制御する
                            if !searchText.isEmpty {
                                firebasemodel.fetchData(serachvalue:searchText)
                                return
                            }
                            firebasemodel.fetchData()
                            //3秒後にローディング画面を非表示にする。
                            // 3秒後にローディングを非表示にする
//                                                    if firebasemodel.loddingflg{
//                                                        Color.black
//                                                    }
                            if isLoading {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                    isLoading = false
                                }
                            }
                         
                        }
                        .onChange(of:searchText){ newValue in
                            if !newValue.isEmpty {
                                firebasemodel.fetchData(serachvalue:searchText)
                                print("検索文字入力されてる")
                            }
                            else{
                                firebasemodel.fetchData()
                                print("検索文字入力されていない")
                            }
                            
                        }
                }
            }
        }
//        .gesture(
//            TapGesture()
//                .onEnded { _ in
//                    hideKeyboard() // Call hideKeyboard() to hide the keyboard
//                }
//        )
//        Button(action: {
//        }) {
//            Button(action: {
//                authControlManager.logout()
//            }) {
//                //Text(Auth.auth().currentUser?.uid != nil ? "User ID: \(Auth.auth().currentUser!.uid)" : "User not logged in")
//                Text("ログアウト")
//            }
//        }
        //trueならfirebase接続する。

    }
    //メニュー一覧
    var menu: some View {
        Menu(content: {
            NavigationLink("ユーザー画面",destination:Userdatainfo())
            
            Button(action: {
                print("Hello")
                presentationMode.wrappedValue.dismiss()
                firebasemodel.popupdatas.removeAll()
            }, label: {
                Text("ユーザー")
            })
            Button(action: {
                print("Hello")
                firebasemodel.popupdatas = [popupdataType]()
                firebasemodel.deleteData()
            }, label: {
                Text("全削除")
            })
            Button(action: {
                print("テスト")
            }, label: {
                Text("テスト")
            })
            Button(action: {
                print("Hello")
            }, label: {
                Text("Hello4")
            })
        }, label: {
            Image(systemName: "list.bullet")
        })
    }
}


//ログイン制御画面
struct LoginView: View{
    @EnvironmentObject var authcontrolmanager:AuthControlManager
    //ログインが成功したら閉じるための変数
    @Environment(\.presentationMode) var presentationMode
    @State private var email = ""
    @State private var password = ""
    @State private var isSigningIn = false
    @State private var isShowingAlert = false
    @State private var alertMessage = ""
    @State private var signupshow = false
    @State private var signInWithAppleObject = SignInWithAppleObject()
    var body: some View{
        VStack {
            Text("Sign In")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 30)
            
            TextField("Email", text: $email)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.bottom, 20)
            
            SecureField("Password", text: $password)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.bottom, 20)
            
            Button(action: {
                authcontrolmanager.signin(email: email, password: password)
                  self.isSigningIn = false
//                    //モーダルを閉じる
                  self.presentationMode.wrappedValue.dismiss()
//                authcontrolmanager.signin(email: email, password: password) { [weak self] (result: Result<User, Error>) in
//                    guard let self = self else { return }
//
//                }
            })
            {
                Text(isSigningIn ? "Signing In..." : "Sign In")
                    .foregroundColor(.white)
                    .frame(width: 200, height: 50)
                    .background(Color(.systemBlue))
                    .cornerRadius(10)
                    .padding(.top, 30)
            }
            .disabled(isSigningIn)
            //            .alert(isPresented: $isShowingAlert) {
            //                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            //            }
            .padding()
            Button(action: {
                signInWithAppleObject.signInWithApple()
                print("アップルログイン")
            },label:{
                SignInWithAppleButton()
                    .frame(width: 200,height: 50)
                    .cornerRadius(16)
            }).padding()

                Button(action: {
                //モーダルを閉じる
                signupshow = true
                })
            {
                Text("Go Signing Up")
            }.sheet(isPresented: $signupshow){
                SignUpView()
            }
        }
    }
}

//サインアップ機能
struct SignUpView: View {
    @EnvironmentObject var authcontrolmanager:AuthControlManager
    @State private var email = ""
    @State private var password = ""
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        VStack{
            Text("Sign UP")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 30)
            
            TextField("Email", text: $email)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.bottom, 20)
            
            SecureField("Password", text: $password)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.bottom, 20)
            Button(action:{
                authcontrolmanager.signup(email:email, password:password)
            })
            {
                //ボタン
                Text("Signing Up")
                    .foregroundColor(.white)
                    .frame(width: 200, height: 50)
                    .background(Color(.systemBlue))
                    .cornerRadius(10)
                    .padding(.top, 30)
            }
        }
    }
}



struct TestView: View {
    var body: some View{
        Text("呼ばれてるよ")
    }
}
struct LogoutView :View{
    //var logoutview: LogoutView
    var body: some View{
        Text("ログアウト")
    }
}


struct Userdatainfo :View {
    @EnvironmentObject var shakeTimes: ShakeTimesViewModel
    @ObservedObject var firebasemodel = FirebasetododatagetModel()
    @ObservedObject var authControlManager = AuthControlManager()
    @Environment(\.presentationMode) var presentationMode
    //var shakeTimes = ShakeTimesViewModel()
    var body: some View{
//        if !presentationMode.wrappedValue.isPresented{
//            Text("呼ばれていない")
//
//        }else{
//            Text("呼ばれている")
//        }

        NavigationStack{
            if !presentationMode.wrappedValue.isPresented{
                //Text("呼ばれていない")
                
            }else{
                //Text("呼ばれている")
            }
            VStack{
                Text(Auth.auth().currentUser?.email ?? "")
                if (Auth.auth().currentUser?.email == "ichikawa.contact@gmail.com"){
                    Text("ichikawa")
                    //ユーザーデータ一覧
                }
                Button(action:{
                    //Appstorageを空にする処理を自動的に実装する。
                    firebasemodel.alldelete()
                    authControlManager.isLoggedIn = false
                    Auth.auth().currentUser?.delete{error in
                        if error == nil {
                            presentationMode.wrappedValue.dismiss()
                            shakeTimes.userid = ""
                            shakeTimes.userdataEmail = ""
                            shakeTimes.userdataPassword = ""
                            shakeTimes.userstatus = false
                        }else{
                            print("エラー")
                        }
                    }
                },label:{Text("ユーザー削除する")}).padding()
                Button(action:{
                    do {
                        try Auth.auth().signOut()
                    } catch let sugnOutError as NSError {
                        print("エラー")
                    }
                    print(shakeTimes.userdataEmail)
                    authControlManager.isLoggedIn = false
                    presentationMode.wrappedValue.dismiss()
                    shakeTimes.userid = ""
                    shakeTimes.userdataEmail = ""
                    shakeTimes.userdataPassword = ""
                    shakeTimes.userstatus = false
                },label: {Text("画面遷移テスト")})
            }
        }
        //.navigationDestination(for:LogoutView.self)
    }
}



struct UserSignUpandSignin: View {
    //@Binding var userdata
    @State private var userdata = Userdatastock().userdata
    @State private var userdatapassword = Userdatastock().userdatapassword
    @State private var email: String = ""
    @State private var email_edittiig = false
    @State private var password:String = ""
    @State private var Password_editing = false
    @State var alertflg = false
    @State var alertmessage = ""
    @State var shaketimeslistview = ShakeTimesListView()
    @State var shaketimesviewmodel = ShakeTimesViewModel()
    @State var alertParametaer:Bool = false
    //@State var userdatacheck = [Userdatacheck]()
    @State var userdatacheck = Userdatacheck()
    var body: some View{
        if Auth.auth().currentUser != nil {
            ShakeTimesListView()
        }
        else{
            //authusernotsigned
            if(userdatacheck.appvaluecheck()){
                VStack{
                    ShakeTimesListView()
                }
            }else{
                TextField("Eメールを入力してください", text: self.$email,onEditingChanged: {
                    begin in
                    if begin {
                        self.email_edittiig = true    // 編集フラグをオン
                        self.email = ""
                    } else {
                        self.email_edittiig = false   // 編集フラグをオフ
                    }
                }).autocapitalization(.none).textFieldStyle(RoundedBorderTextFieldStyle()).padding()
                    .shadow(color: email_edittiig ? .blue : .clear, radius: 3)
                SecureField("パスワードを入力してください。",text:$password).autocapitalization(.none).textFieldStyle(RoundedBorderTextFieldStyle()).padding()
                    .shadow(color: Password_editing ? .blue : .clear, radius: 3)
                Button(action:{
                    if(self.email == "" || self.password == ""){
                        self.alertmessage = "情報を入力してください。"
                        self.alertflg = true
                    }
                    else {
                        //ここの処理に入った時、ユーザーデータを処理する
                        //self.alertflg = false
                        //self.alertflg = true
                        //self.alertmessage = "はい"
                        //モデルで値が返ってきた時、trueならストレージに入れてfalseならまた分岐分岐先でtrueなら、データを作ってstorage
                        self.userdata = self.email
                        self.password = self.password
                        print(self.userdata)
                    }
                },label: {Text("ログイン")}).alert(isPresented:$alertflg){
                    Alert(title:Text(alertmessage))
                    //ユーザーデータがないとき、ここでデータ作成する処理を記載する。
                }
            }
        }
    }}
//func firebasedatacheckSignin(userdata:String)->Bool{
//    @State var flg:Bool?
//    //@State var userdata = Userdatastock().userdata
//    @State var userdatapassword = Userdatastock().userdatapassword
//    print(userdata)
//    print("呼ばれてる")
//    Auth.auth().signIn(withEmail:userdata,password: userdatapassword){(resurt,error)in
//
//        if let user = resurt?.user {
//            let c_user = Auth.auth().currentUser
//            let usermail = c_user?.email
//            flg = true
//
//        }
//        if error != nil{
//            flg = false
//        }
//    }
//}




func existenceuser_backStirng()->String{
    @EnvironmentObject var shakeTimes: ShakeTimesViewModel
//    @State var userdata = Userdatastock().userdata
//    @State var userid = Userdatastock().userid
//    @State var userdatapass = Userdatastock().userdatapassword
    var userdataemail = shakeTimes.userdataEmail
    var userdatapass = shakeTimes.userdataPassword
    var backstring = ""
    Auth.auth().signIn(withEmail:userdataemail,password: userdatapass){
        (resurt,error)in
    if let user = resurt?.user {
        backstring = userdataemail
    }
    else {
        backstring = ""
    }
        
    }
    return backstring
}

struct PasswordForgetView: View{
    @State var editemail = ""
//    self.userdataalertmessage = "登録があります。この情報でログインしますか?"
//    self.userdataalertflg = true
    var body: some View{
        TextField("メールアドレスを入力してください",text:$editemail).autocapitalization(.none).textFieldStyle(RoundedBorderTextFieldStyle()).padding()
        Button(action:{
            Auth.auth().sendPasswordReset(withEmail: editemail) { error in }
        },label: {Text("メールを送る")})
    }
}

//
struct ShakeTimesListView: View{
    //@ObservedObject var userdatainfo:Userdatainfo
    @EnvironmentObject var shakeTimes: ShakeTimesViewModel
    @EnvironmentObject var todousermodel:TodoUserModel
    //ログイン制御する
    //@EnvironmentObject var authcontrolmanager:AuthControlManager
    @ObservedObject var authControlManager = AuthControlManager()
    //@EnvironmentObject var userc = shakeTimes.firabaseuserdatacheck
    //@State var test = shakeTimes.usertestdata
    @State private var selection = 0
    @State private var viewnewflg = 0
    //appstorageの情報を持たせて自動的にアクセスする。
    //一意に発行したユーザーIDをもとにデータを参照しに行く。
   @AppStorage("count_key") var counter = 0
  // @AppStorage("Userdata") var userdata = ""
   @State private var userdata = Userdatastock().userdata
   @State private var userid = Userdatastock().userid
   @State private var userdatapass = Userdatastock().userdatapassword
   @State private var count = Userdatastock().counter
   @State private var userdataflg = true
   @State private var email: String = ""
   @State private var email_edittiig = false
   @State private var password:String = ""
   @State private var Password_editing = false
   @State var alertflg = false
    @State private  var viewnew:Bool?
   @State var alertmessage = ""
   @State var userdataalertflg = false
   @State var userdataalertmessage = ""
   @State var chekusertest = Userdatacheck()
   @State var usersignupmodalflg = false
   @State var logintesttext = ""
   @State var actionflg = true
   @StateObject var usercheck = Userpreservaitonconfirmation()
   @StateObject var viewModel = ToDoListViewModel()
   @ObservedObject var firebasemodel = FirebasetododatagetModel()
    @State private var viewchangeflg = false
   //@State var firebasebackdata:[popupdataType]
   //@State var usercheckstatu = shakeTimes.self.userDafultCheck
   //@AppStorage("UserFlg") var userflg = true
//   var array:[String]
//    array.append($userdata)
   @ObservedObject var userstatus = UserLoginStatus.shared
   //@State private var userflg = true
    
    private func signIn(){
        if let _ =  Auth.auth().currentUser {
            print("true!!")
        }else{
            print("false!!")
        }
    }
    
 
    var body: some View {
        if authControlManager.isLoggedIn{
//            HStack {
//                Text("")
//                Spacer()
//                menu.frame(alignment: .trailing)
//            }
            MainView(childviewchangeflg:$viewchangeflg)
                .transition(.opacity)
                .animation(.easeInOut)
//            Text(authControlManager.username!)
//            Text(shakeTimes.userdataEmail)
        }
        else {
            //ログインしていない場合、ユーザーのログイン画面に遷移する。
            LoginView().environmentObject(authControlManager)
        }
        
//        let usercheckcl = {
//            Auth.auth().signIn(withEmail:shakeTimes.userdataEmail,password: shakeTimes.userdataPassword){
//                (resurt,error)in
//            if let user = resurt?.user {
//                self.logintesttext = shakeTimes.userdataEmail
////                Firestore.firestore().collection("users").document(userid).collection("tasklist").order(by:"startTime").getDocuments{ (snaps, error) in
////                    if let error = error{
////                        fatalError("\(error)")
////                        guard let snaps = snaps else {return}
////                        for document in snaps.documents{
////                            print(document.data())
////                            //testresult.append(document.data())
////                        }
////                    }
////
////                }
//                print("ユーザー存在している処理")
//            }
//            else {
//                self.shakeTimes.userdataEmail = ""
//                print("ユーザー存在チェック")
//            }
//
//            }
//        }
////        if(!shakeTimes.userstatus){
////            UserSignUpandSignin()
////        }
//        if(shakeTimes.firabaseuserdatacheck){}
//        if(shakeTimes.userdataEmail == ""){
//            NavigationStack {
//                //                Form{
//                //                    NavigationLink(destination: Text("Destination")) {
//                //                        Text("Label")
//                //                    }
//                //
//                //                }
//
//            //usercheckcl()
//            //signIn()
//            //ユーザーログイン画面に遷移する。遷移先でログインしたらビューは変わるかチェック
//
//            TextField("Eメールを入力してください", text: self.$email,onEditingChanged: {
//                //print(shakeTimes.userDafultCheck[0])
//                begin in
//                if begin {
//                    self.email_edittiig = true    // 編集フラグをオン
//                    self.email = ""
//                } else {
//                    self.email_edittiig = false   // 編集フラグをオフ
//                }
//            }).autocapitalization(.none).textFieldStyle(RoundedBorderTextFieldStyle()).padding()
//                .shadow(color: email_edittiig ? .blue : .clear, radius: 3)
//            TextField("パスワードを入力してください。",text:$password).autocapitalization(.none).textFieldStyle(RoundedBorderTextFieldStyle()).padding()
//                .shadow(color: Password_editing ? .blue : .clear, radius: 3)
//            Button(action:{
//                if(self.email == "" || self.password == ""){
//                    self.alertmessage = "情報を入力してください。"
//                    self.alertflg = true
//                }
//                else{
//
//                    print("入力")
//                    Auth.auth().signIn(withEmail:email
//                                       ,password: password){(resurt,error)in
//
//                        if let user = resurt?.user {
//                            self.userdata = self.email
//                            self.userdatapass = self.password
//                            shakeTimes.userdataEmail = self.email
//                            shakeTimes.userdataPassword = self.password
//                            shakeTimes.userdata = email
//                            shakeTimes.userdatapassword = password
//                            shakeTimes.userid = user.uid
//                            shakeTimes.userDafultCheck.append(self.userdata)
//                            let c_user = Auth.auth().currentUser
//                            let usermail = c_user?.email
//                            print(c_user?.uid)
//                            //shakeTimes.usertestdata = email
//                            print("通信中")
//
//
//                        }
//                        if error != nil{
//                            print("えらー")
//                            print(error)
//                            self.alertflg = true
//                            self.alertmessage = "何かしらのエラーです。"
////                            print("-----------------------------------")
////                            print()
////                            shakeTimes.shakeTimes
////                            print("-----------------------------------")
//                            self.alertmessage = shakeTimes.setErrorMessage(error)
//                            self.alertflg = true
//                                  shakeTimes.Login(email: self.email, password: self.password){result in
//                                if result{
//                                    print("成功")
//                                }else{
////                                    self.userid = ""
////                                    self.userdataEmail = ""
////                                    self.userdatapassword = ""
//                                    print("失敗")
//
//                                }
//                            }
//                        }
//                    }
//                }
//            },label: {Text("ログイン")}).alert(isPresented:$alertflg){
//                Alert(title:Text(alertmessage))
//            }.padding()
//            Button(action:{
//                self.usersignupmodalflg.toggle()
//            }){
//                Text("ユーザー登録")
//            }.sheet(isPresented: $usersignupmodalflg){
//                TextField("Eメールを入力してください", text: self.$email,onEditingChanged: {
//                    //print(shakeTimes.userDafultCheck[0])
//                    begin in
//                    if begin {
//                        self.email_edittiig = true    // 編集フラグをオン
//                        self.email = ""
//                    } else {
//                        self.email_edittiig = false   // 編集フラグをオフ
//                    }
//                }).autocapitalization(.none).textFieldStyle(RoundedBorderTextFieldStyle()).padding()
//                    .shadow(color: email_edittiig ? .blue : .clear, radius: 3)
//                TextField("パスワードを入力してください。",text:$password).autocapitalization(.none).textFieldStyle(RoundedBorderTextFieldStyle()).padding()
//                    .shadow(color: Password_editing ? .blue : .clear, radius: 3)
//                Button(action:{
//                    if(self.email == "" || self.password == ""){
//                        self.alertmessage = "情報を入力してください。"
//                        self.alertflg = true
//                    }
//                    else{
//                        /**一応ユーザーチェックする */
//                        Auth.auth().signIn(withEmail:email
//                                           ,password: password){(resurt,error)in
//                            if let user = resurt?.user {
//                                print("ユーザーチェック")
//                                self.userdataalertmessage = "登録があります。この情報でログインしますか?"
//                                self.userdataalertflg = true
//                                //以下でログイン
////                                shakeTimes.userdataEmail = email
////                                shakeTimes.userdataPassword = password
////                                shakeTimes.userdata = self.email
////                                shakeTimes.userdatapassword = self.password
//                                //                                self.userdatapass = self.password
//                                //                                shakeTimes.userdataEmail = email
//                                //                                shakeTimes.userdataPassword = password
//                                //                                shakeTimes.userDafultCheck.append(self.userdata)
//                                //                                let c_user = Auth.auth().currentUser
//                                //                                let usermail = c_user?.email
//                                //                                print(c_user?.uid)
//                                //                                shakeTimes.usertestdata = email
//                                //                                print("通信中")
//
//
//                            }
//                            if error != nil{
//                                /**登録が完了したら、ユーザーデフォルトを書き換えてログインする。 */
//                                print("エラーゾーン！")
//                                self.alertmessage = shakeTimes.setErrorMessage(error)
//                                self.alertflg = true
//                                print(shakeTimes.setErrorMessage(error))
//                                Auth.auth().createUser(withEmail:self.email, password:self.password){authResult, error in
//                                    if let user = authResult?.user {
//                                        let request = user.createProfileChangeRequest()
//                                        let db = Firestore.firestore()
//                                        //guard let uid = Auth.auth().currentUser?.uid else{return}
//                                        //db.collection("users").addDocument(data: ["name":user.uid])
//                                        user.sendEmailVerification(completion:{
//                                            error in
//                                            if error == nil{
//                                                print("登録完了")
//                                            }
//                                        })
//                                        let values = ["name":user.uid,"email":email]
//                                        //ここでユーザーデータを保存する。しかし、タスクを保存するときのエラーの原因になってるポイ、、
//                                        db.collection("users").document(user.uid).setData(values)
//
//                                        Database.database().reference().child("users").updateChildValues(values,withCompletionBlock: {(error, reference)
//                                            in
//                                            if error != nil {
//                                                print("エラー")
//                                                print(error!)
//                                                return
//                                            }
//                                            print("保存")
//                                        })
//                                        shakeTimes.userdataEmail = email
//                                        shakeTimes.userdataPassword = password
//                                        shakeTimes.userdata = email
//                                        shakeTimes.userdatapassword = password
//                                        shakeTimes.userid = user.uid
//                                        actionflg.toggle()
//                                    }
//                                    //shakeTimes.userdataEmail = email
//                                }
//                            }
//                        }
//                    }
//                },label: {Text("登録")})
//                /**ユーザー情報不足アラート */
//                .alert(isPresented:$alertflg){
//                    /**ユーザー情報が存在するときのアラートを上げる */
//                    Alert(title:Text(alertmessage))
//
//                }
//                /**ユーザー情報存在アラートtrueならログインする */
//                .alert(isPresented:$userdataalertflg){
//                    Alert(title:Text(userdataalertmessage),primaryButton: .default(Text("OK"),action:{
//                        shakeTimes.userdataEmail = email
//                        shakeTimes.userdataPassword = password
//                        usersignupmodalflg.toggle()
//
//                    }),secondaryButton:.destructive(Text("いいえ")))
//                }
//                .padding()
//            }
//            .padding()
//
//                NavigationLink("パスワードをお忘れの方",destination:PasswordForgetView()).navigationTitle("ログイン")
//                    //.navigetionDe
//
//            }
//        }
//        else{
//           // var test = firebasemodel.fetchData()
//                NavigationStack {
//                    VStack{
//                        ZStack{
//                            VStack{
//                                //                            Image(systemName:"sun.max")
//                                //                            NavigationLink("ユーザー画面",destination:Userdatainfo())
//                                //                            NavigationLink{Userdatainfo()}label: {
//                                //                            Label("Go Second View", systemImage: "figure.walk")
//                                //                                                    .font(.title)                            }
//                            }.toolbar {
//                                ToolbarItem(placement:.navigationBarTrailing){
//                                    Button(action: {
//                                        viewModel.showPopUpDialog = true
//                                    }){
//                                        Image(systemName: "plus")
//                                    }
//                                }
//                                ToolbarItem(placement: .navigationBarLeading) {
//                                    menu
//                                }
//                            }
//                            //                    if(chekusertest.appvaluecheck()){
//                            //
//                            //                        Text()
//                            //                    }
//                            //}
//
//                            //                    VStack {
//                            //                        Text(userdata)
//                            //                        Text("Count: クラスの\(count)")
//                            //                            .padding()
//                            //                        Button("カウント") {
//                            //                            counter += 1
//                            //                            count += 1
//                            //                            //                                    ForEach(shakeTimes.userDafultCheck){ userdafult in
//                            //                            //
//                            //                            //                                    }
//                            //                        }
//                            //                        .buttonStyle(.borderedProminent)
//                            //                        Button("リセット") {
//                            //                            counter = 0
//                            //                        }
//                            //                        .buttonStyle(.borderedProminent)
//                            //                    }
//                            //                    Picker(selection: $selection, label: Text("0")){
//                            //                        ForEach(shakeTimes.shakeTimes){
//                            //                            shakeTime in
//                            //                            ShakeTimeView(shakeTime: shakeTime)//.tag(shakeTime.hour)
//                            //                        }
//                            //                    }.pickerStyle(.wheel)
//                            //                    List{
//                            //
//                            //                    }
//                            //                   if viewModel.showPopUpDialog {
//                            //                       PopUpDialogView()
//                            //                   }
//
////                            VStack{
////                                                Firestore.firestore().collection("users").document(userid).collection("tasklist").order(by:"startTime").getDocuments{ (snaps, error) in
////                                                    if let error = error{
////                                                        fatalError("\(error)")
////                                                        guard let snaps = snaps else {return}
////                                                        for document in snaps.documents{
////                                                            print(document.data())
////                                                            //testresult.append(document.data())
////                                                        }
////                                                    }
////
////                                                }
////                            }
////                            VStack{
////                                Text(firebasemodel.fetchData())
////                            }
////
////                            List{
////                                EmptyView()
////                                ForEach(firebasemodel.popupdatas) { data in
////                                    Text(data.taskTitle ?? "なし")
////                                }
////                            }.onAppear{
////                                firebasemodel.fetchData()
////                            }
////                            List(firebasemodel.popupdatas){ data in
////                                Text(data.taskTitle ?? "なし")
////                            }.onAppear{
////                                firebasemodel.fetchData()
////                            }
////                            List {
////                                ForEach(shakeTimes.shakeTimes) { shakeTime in
////                                    ShakeTimeView(shakeTime: shakeTime)
////                                }
////                            }
////                            .sheet(isPresented: $shakeTimes.isPresentingShakeUpView) {
////                                ShakeUpView()
////                            }
//
//                            //                    NavigationLink(destination: InputView(delegate: self, text:"")){
//                            //                        Text("+")
//                            //                            .foregroundColor(Color.white)
//                            //                            .font(Font.system(size:20))
//                            //                    }.frame(width: 60, height: 60)
//                            //                        .background(Color.orange)
//                            //                        .cornerRadius(30)
//                            if viewModel.showPopUpDialog {
//                                PopupView(
//                                    isPresent: $viewModel.showPopUpDialog,
//                                    firebaseid: $viewModel.firevaseid,
//                                          tasktitle: $viewModel.titletext,
//                                          taskBody: $viewModel.bodytext,
//                                          taskCategory: $viewModel.taskCategory,
//                                          startTime: $viewModel.startTtime,
//                                    endTIme: $viewModel.endTime)//.background(Color.gray)
//                                    //Text("テスト")
//                                    //viewModel.showPopUpDialog = false
//
//                            }
//                        }.onAppear{
//                            Task{
//                                await usercheck.getuser()
//                            }
//                        }//Zstack
//                    }
//                }
////            .sheet(isPresented:$userdataflg){
////                UserSignUpandSignin()
////
////            }
//
//        }
    }
    //メニュー一覧
    var menu: some View {
        Menu(content: {
            NavigationLink("ユーザー画面",destination:Userdatainfo())
            Button(action: {
                print("Hello")
                firebasemodel.popupdatas.removeAll()
            }, label: {
                Text("ユーザー")
            })
            Button(action: {
                print("Hello")
                firebasemodel.popupdatas = [popupdataType]()
                firebasemodel.deleteData()
            }, label: {
                Text("全削除")
            })
            Button(action: {
                print($userid)
            }, label: {
                Text(shakeTimes.userid)
            })
            Button(action: {
                print("Hello")
            }, label: {
                Text("Hello4")
            })
        }, label: {
            Image(systemName: "list.bullet")
        })
    }
}
protocol InputViewDelegate {
    func addTodo(text: String)
}

//extension PopUpDialogView {
//
//    init(isPresented: Binding<Bool>,
//         isEnabledToCloseByBackgroundTap: Bool = true,
//         @ViewBuilder _ content: () -> Content) {
//        _isPresented = isPresented
//        self.isEnabledToCloseByBackgroundTap = isEnabledToCloseByBackgroundTap
//        self.content = content()
//    }
//}
struct taskCategorysIdentifiable :Identifiable{
    var id = UUID()     // ユニークなIDを自動で設定
    var name : String
}

func timestampchange(date:Date) ->Timestamp{
    let stampchenge = Firebase.Timestamp(date: date)
    return stampchenge
}

func uuidreturn()->String{
    let uuid = UUID()
    let uuidString = uuid.uuidString
    return uuidString
}

func StringChangeDate(string:String)->Date{
    let dateFormatter = DateFormatter()
//    dateFormatter.dateFormat = "yyyy'年'M'月'd'日('EEEEE') 'H'時'm'分's'秒'"
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z" // 日付の形式に合わせてフォーマットを設定
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    dateFormatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
    let formattedDatestr = string.replacingOccurrences(of: "T", with: " ")
    let newDate = Date()
    print(formattedDatestr)
    if let date = dateFormatter.date(from:formattedDatestr){
        print("データ確認")
        print(date)
        return date
    }
    else{
        print("データ確認失敗")
        print(newDate)
        return newDate
    }
}
func dateChangeString(date:Date)->String{
    //let sNum3:String = date.description
//    let sChangejapandate = date
    let dateFormatter = DateFormatter()
//    dateFormatter.dateFormat = "yyyyMMddHHmmss"
    dateFormatter.dateFormat = "yyyy'年'M'月'd'日('EEEEE') 'H'時'm'分's'秒'"
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    dateFormatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
    let stampchenge = Firebase.Timestamp(date: date)
    print("-----------------タイムスタンプ------------------")
    print(Timestamp())
    print("-------------------タイムスタンプ----------------")
    let str = dateFormatter.string(from:date)
    let time = dateFormatter.date(from:str)
    return str
//    return  date.description
}

func dataChangeTimeStamp(date:Date)->Timestamp{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy'年'M'月'd'日('EEEEE') 'H'時'm'分's'秒'"
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    dateFormatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
    let stampchenge = Firebase.Timestamp(date: date)
    return stampchenge
}

struct PopupView: View {
   // let title = ""
    @Binding var isPresent: Bool
    @Binding var tasktitle: String
    @Binding var taskBody: String
    @Binding var taskCategory: String
    @Binding var startTime: Date
    @Binding var endTime: Date
    @Binding var firebaseid:String
    @Binding var viewchange:Bool
    
//    @Binding var viewuploadConrollflg:Bo
    
    @State private var timeFlg = false
    @State private var userTimeFlg = false
    //キーボードの閉じるボタンの実装のためのフラグ変数。
    @FocusState  var focasisActive:Bool
    @State private var startTimeString:String?
    @State private var endTimeString:String?
    @State private var starttimestamptest:Timestamp?
    @State private var starttimeStamp:Timestamp?
    @State private var endTimeStamp:Timestamp?
    @State private var userid = ShakeTimesViewModel().userid
    @ObservedObject var firebasemodel = FirebasetododatagetModel()
    @ObservedObject var shaketimesviewmodel = ShakeTimesViewModel()
//    let df = DateFormatter()
//    df.locale = Locale(identifier: "ja_JP")
//    df.calendar = Calendar(identifier: .japanese)
//    df.dateFormat = "令和yy年M月dd日 EEEE HH時mm分"
    //let firebaseApp = Firebase.initializeApp(FIREBASE_CONFIG);
   //let test =  Firebase.firestore.Timestamp.fromDate(Date(1980, 10, 15)),
    //let now = Firebase.FieldValue.serverTimestamp();
//    let timeinterval = now.timeIntervalSince1970
//    //firebaseタイムスタンプ変換クロージャー
//    let timestanp = {(datetimedata: Date) in
//        Firebase.firestore.Timestamp.fromDate(new Date(datetimedata));
//        print("")
//    }
//    @Binding var time: Date
    /**InputTimeに代入する。 */
    init(isPresent:Binding<Bool>, firebaseid:Binding<String>,tasktitle:Binding<String>,taskBody: Binding<String>,taskCategory:Binding<String>,startTime:Binding<Date>,endTIme:Binding<Date>,viewchange: Binding<Bool>){
        self._isPresent = isPresent
        self._firebaseid = firebaseid
        self._tasktitle = tasktitle
        self._taskBody = taskBody
        self._taskCategory = taskCategory
        self._startTime = startTime
        self._endTime = endTIme
        self._viewchange = viewchange
        self.userTimeFlg = userTimeFlg
   
        
    }
    //@State private var title = ""
    //@State private var taskbody = ""
    //@State private var taskCategory = "タスク実行ステータス"
    
    @State private var showingDialog = false
    private let buttonSize: CGFloat = 24
    @State private var taskCategorys = [
        taskCategorysIdentifiable(name:"実行中"),
        taskCategorysIdentifiable(name:"保留中"),
        taskCategorysIdentifiable(name:"済み")
    ]
    //let isEnbledTocloseByBackgroundTap:Bool
    var body: some View {
        GeometryReader {proxy in
            let dialogWidth = proxy.size.width * 0.95
            ZStack{
                BackgroundView(color: .gray.opacity(0.7)).onTapGesture {
                    withAnimation {
                        if(!(self.tasktitle == "" || self.taskBody == "")){
                           
                            self.showingDialog = true
                        }
                        else{
                            isPresent = false
                        }
                    }
                    //isPresent = false
                }.confirmationDialog("",isPresented:$showingDialog,titleVisibility: .visible){
                    Button("キャンセル"){
                        showingDialog = false
                    }
                    Button("破棄",role:.destructive){
                        isPresent = false
                        tasktitle = ""
                        taskBody = ""
                    }
                    
                }
                //↑ここでもダイアログ表示する。
                VStack(spacing: 12) {
                    Text("タスクタイトルを追加する。")
                        .font(Font.system(size: 18).bold())
                    TextField("タイトル",text: $tasktitle)
                        .padding()
                        .background(Color(uiColor: .systemGray5))
                    Text("タスクの詳細を記入する")
                        .font(Font.system(size: 18).bold())
                    HStack(alignment: .firstTextBaseline){
                        TextEditor(text: $taskBody)
                            .padding()
                            .frame(height:200,alignment: .topLeading)
                            .focused($focasisActive)
                            .toolbar {
                                ToolbarItemGroup(placement: .keyboard) {
                                    Spacer()         // 右寄せにする
                                    Button("閉じる") {
                                        focasisActive = false  //  フォーカスを外す
                                    }
                                }
                            }
//                        Button("閉じる") {
//                                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
//                                    }
                            .multilineTextAlignment(TextAlignment.leading)
                            .background(Color(uiColor: .systemGray5))
                            .lineLimit(nil)
                    }
                    Toggle(isOn: $timeFlg){
                        Text("時間設定")
                    }
                    UnderRectangleView()
//                    .padding(.all)
//                    .border(Color.blue, width: 3)
                    //時間が設定されている場合、timeFlgをfalseにしてInputViewに保存したstarttimeとendtimeを渡す。
                    if(timeFlg){
                        //Calender()
                        InputDate(startDate: $startTime, endDate:$endTime).environment(\.locale, Locale(identifier: "ja_JP")).padding()
                        UnderRectangleView()
                    }
                    Menu {
                        ForEach(taskCategorys){category in
                            Button(category.name,action:{self.taskCategory = category.name})
                            
                        }
//                        Button("保留中",action: {self.taskCategory = "保留中"})
//                        Button("実行中",action: {self.taskCategory = "実行中"})
//                        Button("済み",action: {self.taskCategory = "済み"})
                    }label: {
                        Label(self.taskCategory,systemImage:"menucard")
                    }
                    UnderRectangleView()
                    HStack {
                        //モデルに値を渡す。
                        Button(action:{
                            /**下を参考にTODO
                             を保存する。*/
                            
                            let db = Firestore.firestore()
                            //.environment(\.locale, Locale(identifier: "ja_JP"))
                            startTimeString = dateChangeString(date:startTime)
                            endTimeString  = dateChangeString(date:endTime)
                            starttimestamptest = timestampchange(date:startTime)
                            starttimeStamp = timestampchange(date: startTime)
                            endTimeStamp = timestampchange(date: endTime)
                            if firebaseid == "" {
                                print("新規保存")
                            }else{
                                print(firebaseid)
                                print("firebaseあり")
                            }

                        
                            //idが空でない場合、それを取得してテーブルを検索し、データを編集する。
                            let values = ["tasktitle":tasktitle,"id":firebaseid ,"taskBody":taskBody,"taskCategory":taskCategory,"startTime":starttimeStamp,"endTime":endTimeStamp, "createAt":Timestamp()] as [String : Any]
                            //以下をモデルに渡す仕様にする。→時間もないので、今回のアプリはMMV？設計仕様にはしない、次回からそれを活かす。
                            //allow write: if request.auth != null && request.auth.token.email == "ichikawa.contact@gmail.com";
                            if let currentUser = Auth.auth().currentUser{
                                print("ログインされているよん")
                                if let email = currentUser.email{
                                    print("ユーザーメールも設定されているよん")
                                }
                                else{
                                    print("ユーザーメールは設定されていないよん")
                                }
                            } else {
                                print("ログインされてないよん")
                            }
                            if firebaseid == "" {
                                firebaseid = uuidreturn()
                                
                                db.collection("users").document(Auth.auth().currentUser?.uid ?? "").collection("tasklist").document().setData(values){error in
                                    if let error = error {
                                        print("データの書き込みエラー：", error.localizedDescription)
                                    }
                                    else{
                                        print("正しく書き込みました。")
                                        //ここでfirebasemodelの関数を呼び出し、そこでpopupdatasの関数を実行してみる、
                                        firebasemodel.popupdatasremove()
                                        firebasemodel.popupdatas.removeAll()
                                        isPresent = false
                                        viewchange.toggle()
                                        //                                    firebasemodel.fetchData()
                                        
                                    }
                                }
                            }
                            else{
                                let documentRef =  db.collection("users").document(Auth.auth().currentUser?.uid ?? "").collection("tasklist").document(firebaseid)
                                documentRef.updateData(values)
                            }
                           // db.collection("users").document(userid).collection("tasklist").setData(values)
                            //firebasemodel.fetchData()
                            self.tasktitle = ""
                            self.taskBody = ""
                            isPresent = false
                            

                        }) {
                            Text("保存する。")
                                //.font(.smallTitle)
                                .foregroundColor(Color.white)

                        }
                        .padding(.all)
                        .background(Color.blue)
                        
                        CloseButton(fontSize: buttonSize,
                                    weight: .bold,
                                    color: .gray.opacity(0.7)) {
                            withAnimation {
                                if(!(self.tasktitle == "" || self.taskBody == "")){
                                    //ダイアログ
                                    print("ダイアログ")
                                    self.showingDialog = true
                                    
                                }
                                else{
                                    isPresent = false
                                }
                                
                            }
                        }
                                    .padding(4)
                        
                                    .confirmationDialog("",isPresented:$showingDialog,titleVisibility:.visible){
                                        Button("キャンセル"){
                                            showingDialog = false
                                        }
                                        Button("破棄",role:.destructive){
                                            isPresent = false
                                            tasktitle = ""
                                            taskBody = ""
                                        }
                                    }
                    }
                }
                //.frame(height: 1000, alignment: .center)
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()         // 右寄せにする
                        Button("閉じる") {
                            focasisActive = false  //  フォーカスを外す
                        }
                    }
                }
                //UnderRectangleView()
            }//ZStack
        }//GeometryReader
    }
}
//struct PopUpDialogView<Content: View>: View{
//    @Binding var isPresented:Bool
//    let isEnabledToCloseByBackgroundTap: Bool
//    let content: Content
//    private let buttonSize: CGFloat = 24
//    var body: some View{
//        GeometryReader { proxy in
//                    let dialogWidth = proxy.size.width * 0.75
//
//                    ZStack {
//
//                        BackgroundView(color: .gray.opacity(0.7))
//                            .onTapGesture {
//                                if isEnabledToCloseByBackgroundTap {
//                                    withAnimation {
//                                        isPresented = false
//                                    }
//                                }
//                            }
//
//                        content
//                            .frame(width: dialogWidth)
//                            .padding()
//                            .padding(.top, buttonSize)
//                            .background(.white)
//                            .cornerRadius(12)
//                            .overlay(alignment: .topTrailing) {
//
//                                CloseButton(fontSize: buttonSize,
//                                            weight: .bold,
//                                            color: .gray.opacity(0.7)) {
//                                    withAnimation {
//                                        isPresented = false
//                                    }
//                                }
//                                .padding(4)
//                            }
//                    }
//                }
//    }
//}
struct UnderRectangleView: View{
    
    var body: some View{
        Rectangle()
                .foregroundColor(.gray)
                .frame(height: 1)
    }
}
struct BackgroundView: View {

    let color: Color

    var body: some View {
        Rectangle()
            .fill(color)
            .ignoresSafeArea()
    }
}
struct CloseButton: View {

    let fontSize: CGFloat
    let weight: Font.Weight
    let color: Color
    let action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: "xmark.circle")
        }
        .font(.system(size: fontSize,
                      weight: weight,
                      design: .default))
        .foregroundColor(color)
    }
}
                                 
struct InputView:View {
    @Environment(\.presentationMode) var presentation
    @State var text :String
    let delegate: InputViewDelegate
    var body: some View{
        VStack(spacing: 16){
            TextField("入力してください。",text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Button("+"){
                delegate.addTodo(text: text)
                presentation.wrappedValue.dismiss()
            }
        }
    }
}


func test(){
    print("test")
}

struct ContentView: View{
    @ObservedObject var  authControlManager = AuthControlManager()
    @ObservedObject var firebasemodel = FirebasetododatagetModel()
    @StateObject var viewModel = ToDoListViewModel()
    @State private var viewchangeflg = false
    var body: some View{
        if authControlManager.isLoggedIn{
            MainView(childviewchangeflg:$viewchangeflg)
        }
        else{
            LoginView()
        }
    }
}

struct ShakeTimesListView_Previews: PreviewProvider {
    static var previews: some View {
        let authcontrolManager = AuthControlManager()
        //ContentView().environmentObject(ShakeTimesViewModel())
        ShakeTimesListView()
            .environmentObject(authcontrolManager)
            .environmentObject(ShakeTimesViewModel())
            //.environmentObject(Userdatainfo())

    }
}
struct Calender: View{
    //
    @State var ekEventStore = EKEventStore()
    @State var events : [EKEvent] = [EKEvent]()
    @State var authStatus: EKAuthorizationStatus = .notDetermined
    @State var startDate = Date()
    @State var endData = Date()
    var body: some View{
        VStack{
            InputDate(startDate: $startDate, endDate:$endData).environment(\.locale, Locale(identifier: "ja_JP")).padding()
            //カレンダーを取り込む
//            Button("カレンダーを取り込む") {
//                Task {
//                    //アクセス許可リクエストイベント
//                    await getRequestAccess()
//                    authStatus = EKEventStore.authorizationStatus(for: .event)
//                    if authStatus == .authorized {
//                        events = getCalenderEvent()
//                    }
//                    
//                }
//            }
            /**アクセス許可 */
            switch authStatus {
            case .authorized:
                List {
                    ForEach(events, id: \.self){event in
                        HStack{
                            Text(event.title)
                            Text("\(event.startDate)").environment(\.locale, Locale(identifier: "ja_JP"))
                            Text("\(event.endDate)").environment(\.locale, Locale(identifier: "ja_JP"))
                        }
                    }
                }
            case .denied:
                Text("アクセスが拒否されました。")
            case .notDetermined:
                Text("アクセス許可を待っています。")
            case .restricted:
                Text("アクセスの制限がかかっています。")
            @unknown default:
                fatalError()
            }
        }
    }
    /**----------------------------------- */
    /**アクセス許可リクエスト処理 */
    /**----------------------------------- */
    func getRequestAccess() async {
        if EKEventStore.authorizationStatus(for: .event) != .authorized {
            do {
                try await ekEventStore.requestAccess(to: .event)
            }
            catch {
                fatalError()
            }
        }
    }
    /**----------------------------------- */
    /**カレンダーのイベント処理*/
    /**----------------------------------- */
    func getCalenderEvent() -> [EKEvent]{
        var events = [EKEvent]()
        let calendars = ekEventStore.calendars(for:.event)
        /**イベント取得事の絞り込み */
        let predicate = ekEventStore.predicateForEvents(withStart: startDate, end: endData, calendars: calendars)
                events = ekEventStore.events(matching: predicate)
                return events
    }

}

//参考：カレンダーの取得日時を設定するためのビュー
struct InputDate: View {
    @Binding var startDate: Date
    @Binding var endDate: Date
    var body: some View {
        VStack {
            DatePicker("タスク開始", selection: $startDate)
            DatePicker("タスク終了", selection: $endDate)
            
        }
    }
}
