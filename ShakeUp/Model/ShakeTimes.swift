//
//  ShakeTimes.swift
//  ShakeUp
//
//  Created by Hal Stroemeria on 2019/12/05.
//  Copyright © 2019 hal-cha-n. All rights reserved.
//

import Combine
import Foundation
import UserNotifications
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseFirestore
import LocalAuthentication
import FirebaseMessaging

//final class TodoModel: ObservableObject {
//    //@Published var taskList: [Task] = createTaskList()
//
//}
final class AuthManager{
    static let shared = AuthManager()
    func Login(email:String,password:String,comolition:@escaping(Bool)->Void){
        
    }
}



class GetData: ObservableObject {
    var popupdatas = [popupdataType]()
        init(){
            var datas = [FirebaseTodolist]()
            var shaketimesviewmodel = ShakeTimesViewModel().userid
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy'年'M'月'd'日('EEEEE') 'H'時'm'分's'秒'"
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
            //ここでfirebaseと通信する処理をしている。
            //とりあえずタイトルとidだけ持ってきて、クリックしたら、全データを持ってくる。
            Firestore.firestore().collection("users").document(shaketimesviewmodel).collection("tasklist").order(by:"startTime" , descending: true).addSnapshotListener{ (snaps, error) in
                if let error = error{
                    fatalError("\(error)")
                    guard let snaps = snaps else {return}
                }
                for document in snaps!.documentChanges{
                    //var testdata = document.document.get("startTime") as! Timestamp
                        if document.type == .added{
    
                            let category = document.document.get("taskCategory") as! String
                            let tasktitle = document.document.get("tasktitle") as! String
                            let startTimestamp = document.document.get("startTime") as! Timestamp
                            let endTimestamp = document.document.get("endTime") as! Timestamp
                            let id = document.document.get("id") as! String
                            let formatterDate = DateFormatter()
                            formatterDate.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                            let startTime = formatterDate.string(from: startTimestamp.dateValue())
                            let endTime = formatterDate.string(from: endTimestamp.dateValue())
                            //let id = document.document.get("")
                           // let str = dateFormatter.string(from:startTime.dateValue())
                            print("-----------------------------------")
                            print(category)
                            print(id)
                            print(startTimestamp)
                            print("-----------------------------------")
                            DispatchQueue.main.async {
                                self.popupdatas.append(popupdataType(id:id, taskCategory: category, startTime:startTime, endTime: endTime, taskTitle:tasktitle))
                            }
                        }
                    //testresult.append(document.data())
                }
        }
    }
}
class FirebasetododatagetModel: ObservableObject {
    @Published var datas = [dateType]()
    @Published var popupdatas = [popupdataType]()

//    
//    init(){
//
//        //var datas = [FirebaseTodolist]()
//
//        var shaketimesviewmodel = ShakeTimesViewModel().userid
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy'年'M'月'd'日('EEEEE') 'H'時'm'分's'秒'"
//        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
//        dateFormatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
//        //ここでfirebaseと通信する処理をしている。
//        //とりあえずタイトルとidだけ持ってきて、クリックしたら、全データを持ってくる。
//        Firestore.firestore().collection("users").document(shaketimesviewmodel).collection("tasklist").order(by:"startTime" , descending: true).addSnapshotListener{ (snaps, error) in
//            if let error = error{
//                fatalError("\(error)")
//                guard let snaps = snaps else {return}
//            }
//            for document in snaps!.documentChanges{
//                //var testdata = document.document.get("startTime") as! Timestamp
//                    if document.type == .added{
//
//                        let category = document.document.get("taskCategory") as! String
//                        let tasktitle = document.document.get("tasktitle") as! String
//                        let startTimestamp = document.document.get("startTime") as! Timestamp
//                        let endTimestamp = document.document.get("endTime") as! Timestamp
//                        let id = document.document.get("id") as! String
//                        let formatterDate = DateFormatter()
//                        formatterDate.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
//                        let startTime = formatterDate.string(from: startTimestamp.dateValue())
//                        let endTime = formatterDate.string(from: endTimestamp.dateValue())
//                        //let id = document.document.get("")
//                       // let str = dateFormatter.string(from:startTime.dateValue())
//                        print("-----------------------------------")
//                        print(category)
//                        print(id)
//                        print(startTimestamp)
//                        print("-----------------------------------")
//                        DispatchQueue.main.async {
//                            self.popupdatas.append(popupdataType(id:id, taskCategory: category, startTime:startTime, endTime: endTime, taskTitle:tasktitle))
//                        }
//                    }
//                //testresult.append(document.data())
//            }
//        }
//    }
   // var popupdatas = [popupdataType]()
    func fetchDateMain(){
        var shaketimesviewmodel = ShakeTimesViewModel().userid
        Firestore.firestore().collection("users").document(shaketimesviewmodel).collection("tasklist").getDocuments {  (snaps, error) in
//            for data in snap!.data()!{
//
//            }
            print("firebase関数に入っている")
            if let error = error {
                fatalError("\(error)")
                guard let snaps = snaps else {return}
                return
                for document in snaps.documents{
                    var testdata = document.data()
                    print(testdata)
                }
            }
                print("関数はエラーではない")
                for document in snaps!.documents{
                    var testdata = document.data()
                    print(testdata)
                }
        }
    }
    //引数はタスク
    //デフォルトで20個渡す。更新したら画面も更新する。
    //
    func Datas(taskcategory:String,quantity:Int){
        
    }
    //データを取得する。
    func fetchData()->[popupdataType]{
       // var datas = [FirebaseTodolist]()
        var popupdatas = [popupdataType]()
        var shaketimesviewmodel = ShakeTimesViewModel().userid
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'年'M'月'd'日('EEEEE') 'H'時'm'分's'秒'"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        //ここでfirebaseと通信する処理をしている。
        //とりあえずタイトルとidだけ持ってきて、クリックしたら、全データを持ってくる。
        Firestore.firestore().collection("users").document(shaketimesviewmodel).collection("tasklist").order(by:"startTime" , descending: true).limit(to:10).addSnapshotListener{ (snaps, error) in
            if let error = error{
                fatalError("\(error)")
                guard let snaps = snaps else {return}
            }
            for document in snaps!.documentChanges{
                //var testdata = document.document.get("startTime") as! Timestamp
                    if document.type == .added{
                        let category = document.document.get("taskCategory") as! String
                        let tasktitle = document.document.get("tasktitle") as! String
                        let startTimestamp = document.document.get("startTime") as! Timestamp
                        let endTimestamp = document.document.get("endTime") as! Timestamp
                        let id = document.document.get("id") as! String
                        let formatterDate = DateFormatter()
                        formatterDate.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                        let startTime = formatterDate.string(from: startTimestamp.dateValue())
                        let endTime = formatterDate.string(from: endTimestamp.dateValue())
                        //let id = document.document.get("")
                       // let str = dateFormatter.string(from:startTime.dateValue())
                        print("-----------------------------------")
                        print(category)
                        print(id)
                        print(startTimestamp)
                        print("-----------------------------------")
                        DispatchQueue.main.async {
                            self.popupdatas.append(popupdataType(id: id, taskCategory: category, startTime: startTime, endTime: endTime, taskTitle: tasktitle))
                        }
                    }
                //testresult.append(document.data())
            }
        }
        return popupdatas
    }
    //ユーザーごと削除された時に走る処理もじ通りすべて削除
    func alldelete(){
        var deletetaskdata = ShakeTimesViewModel().userid
        Firestore.firestore().collection("users").document(deletetaskdata).delete(){ err in
            if let err = err {
                print("Error removing document: \(err)")
                print("エラー入ってる")
            }
            else{
                print("削除成功")
            }
        }
        
    }
    func deleteData(){
        var shaketimesviewmodel = ShakeTimesViewModel().userid
        Firestore.firestore().collection("users").document(shaketimesviewmodel).collection("tasklist").getDocuments{(snaps ,error) in
            if let error = error{
                print("error")
            }
            else{
                for document in snaps!.documents{
                    print(document.data())
                    document.reference.delete()
                }
            }
        }
    }
}



class ToDoListViewModel: ObservableObject{
    @Published var showPopUpDialog = false
    @Published var testtext = ""
    @Published var titletext = ""
    @Published var bodytext = ""
    @Published var firevaseid = ""
    //タスクカテゴリー
    @Published var taskCategory = "実行中"
    //時間
    @Published var startTtime = Date()
    @Published var endTime = Date()
}

class Userpreservaitonconfirmation :ObservableObject{
    init(){
        print("ユーザーチェック関数")
        getuser()
    }
    func getuser (){
        if let _ = Auth.auth().currentUser{
            print("ユーザー!!")
        }else{
            print("nil")
        }
    }
}

final class TodoUserModel: ObservableObject {
    @Published var isLogin = false
//    static private func ConstructFromeUserDefaults(userflg:[String]) -> [Userdata]{
//       // $userflg == ""
//        var result = [Userdata]()
//        //retrunでviewにtrueかfalseを返す。
//        return result
//    }
}
//常に管理対象とする。何かするたび呼び出せばいい?
class AuthControlManager: ObservableObject {
    @Published var isLoggedIn = false
    @Published var username:String?
    //Firebase AuthenticationのAuthオブジェクトに対して、認証状態の変更を監視するためのハンドル。
    private var handle: AuthStateDidChangeListenerHandle?
    init(){
        //初期化時点で認証状態を監視し、その値を代入する。
        handle = Auth.auth().addStateDidChangeListener{ (auth,user) in
            self.isLoggedIn = user != nil
            self.username = user?.email
        }
    }
    //メモリ上のインスタンスを解放する。
    deinit {
        if let handle = handle{
            //監視状態を解除する。
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    //呼び出されるたびにログインステータスを変更する。
    func loggeintoggle(){
        isLoggedIn.toggle()
    }
    
}

class ShakeTimesViewModel: ObservableObject {
    @Published var userdata = Userdatastock().userdata
    @Published var userdatapassword = Userdatastock().userdatapassword
    @Published var userdataid = Userdatastock().userid
    @Published var userstatus = false
   // var firebasemodel = FirebasetododatagetModel()

    //値が変更される度に以下のブロックが実行され、代入される。
    /**ユーザーデータid*/
    @Published var userid:String {
        didSet{
            UserDefaults.standard.set(userid,forKey: "userid")
        }
    }
    /**ユーザーデータEメール */
    @Published var userdataEmail:String {
        didSet {
            UserDefaults.standard.set(userdataEmail,forKey: "userdataEmail")
            }
    }
    /**ユーザーデータパスワード */
    @Published var userdataPassword:String {
        didSet {
            UserDefaults.standard.set(userdataPassword,forKey: "userdataPassword")
        }
    }
    let auth = Auth.auth()
    var errMessage:String = ""

    func Login(email:String,password:String,complition:@escaping(Bool)->Void){
        print("ログイン関数に入ってる。")
//        Firestore.firestore().collection("users").document(shaketimesviewmodel).collection("tasklist").order(by:"startTime").getDocuments{ (snaps, error) in
//            if let error = error{
//                fatalError("\(error)")
//                guard let snaps = snaps else {return}
//                for document in snaps.documents{
//                    print(document.data())
//                    //testresult.append(document.data())
//                }
//            }
//            
//        }
        print(email)
        print(password)
        auth.signIn(withEmail:email,password:password){result, error in
            if error == nil {
                if result?.user != nil{
                    complition(true)
                    print("ログイン関数true")
                }else{
                    print("ログイン関数else")
                    complition(false)
                }
            }else{
                self.setErrorMessage(error)
                print("ログイン関数エラー")
                print(self.errMessage)
                complition(false)
            }
        }
    }
    func setErrorMessage(_ error:Error?)->String{
        if let error = error as NSError? {
            if let erroCode = AuthErrorCode.Code(rawValue: error.code){
                switch erroCode {
                case .invalidEmail:
                    self.errMessage = "メールアドレスの形式が違います。"
                case .emailAlreadyInUse:
                    self.errMessage = "このメールアドレスは使われています。"
                case .weakPassword:
                    self.errMessage = "パスワードが弱すぎます。"
                case.userNotFound, .wrongPassword:
                    self.errMessage = "メールアドレス、またはパスワードが間違っています。"
                case.userDisabled:
                    self.errMessage = "このユーザーは無効です。"
                default:
                    self.errMessage = "予期せぬエラーです。"
                }
            
            }
        }
        return errMessage
    }
    /**ユーザーデータ群ここまで */
    static var launchWakeUp = CurrentValueSubject<Bool, Never>(false)
    @Published var shakeTimes = ConstructFromUserDefaults()
    //@Published var Shakehour = ConstructFormdefaultsHour()
    @Published var userDafultCheck = ConctructUserDataCheck()
    @Published var firabaseuserdatacheck = FirebaseUserDataCheck()
    @Published var isPresentingShakeUpView = false
    @Published var userpreservaitonconfirmation = UserPreservationConfirmation()
    @Published var usercheckflg:Bool?
    private var cancellable: Cancellable?
    /**呼び出し側で、変数を設定し、格納、それを以下関数の引数に渡す。i~20呼び出されるたびにi~20 */
    static private func FirebaseConstructgetData(){
        var shaketimesviewmodel = ShakeTimesViewModel().userid
        var result = [FirebaseTodolist]()
        var testresult:[String]
        Firestore.firestore().collection("users").document(shaketimesviewmodel).collection("tasklist").order(by:"startTime").getDocuments{ (snaps, error) in
            if let error = error{
                fatalError("\(error)")
                guard let snaps = snaps else {return}
                for document in snaps.documents{
                    var testdata = document.data()
                    print(testdata)
                    //testresult.append(document.data())
                }
            }
        }
       // return result
    }
    static private func ConstructFromUserDefaults() -> [ShakeTime] {
        var result = [ShakeTime]()
        let shakeTimeison = ShakeTime()
        (0...23).forEach { i in
            let shakeTime = ShakeTime()
            shakeTime.hour = i
            //shakeTime.minute = 0
            //shakeTime.isOn = false
            
            (0...59).forEach{j in
                shakeTime.minute = j
            }
            result.append(shakeTime)
        }
        shakeTimeison.isOn = false
        result.append(shakeTimeison)
        return result
    }
    /**ここがtrueならConctruntUserDataCheckにデータをインサートする。 */
    
    static private func FirebaseUserDataCheck() -> Bool{
        let userdata = Userdatastock().userdata
        let userdatapassword = Userdatastock().userdatapassword
        if(userdata == "" || userdatapassword == ""){
            return false
        }
        return true
    }

    static private func UserPreservationConfirmation() -> Bool{
        var userdata = Userdatastock().userdata
        var userpass = Userdatastock().userdatapassword
        var flg:Bool = true
        if let _ = Auth.auth().currentUser{
            print("ユーザー")
        }else{
            print("nil")
        }
        Auth.auth().signIn(withEmail:userdata,password: userpass){
                        (resurt,error)in
//            print("ユーザーチェック関数")
//            print(userdata)
//            print(userpass)
                      if let user = resurt?.user {
                         Auth.auth().currentUser
                          flg = true
                          //print("初期化処理実行()")
                      }
                      else {
                           //self.logintesttext = "なし"
                          print(error)
                          print("初期化できず。")
                          flg = false
                         userdata = ""
                   }
         }
        print(flg)
        return flg
    }
    static private func ConctructUserDataCheck() -> [String]{
        /** Appstorageが空の場合→ログイン画面。*/
        /**Appstorageの値が存在しない場合。→ログイン画面 */
        /**Appstoragaの値が存在する場合。 */
        var userdata = Userdatastock().userdata
        var userdatapassword = Userdatastock().userdatapassword
        //var userid = Userdatastock()
        var result = [Userdatasotockcheck]()
        //var userresult:[String] = []
        let userchecker = Userdatasotockcheck()
        userchecker.userdatachekflg = true
        var usercheckerarray = userchecker.userdadadavalues
        /**空の配列を返す。 */
        if(userdata == "" || userdatapassword == ""){
            usercheckerarray.removeAll()
            return usercheckerarray
        }
        if(userchecker.userflg == false){
            //result = []
            result.removeAll()
            return usercheckerarray
        }
        /**この時点でAppstorageのユーザーをチェックして、なければそのまま空の配列を返す。 */
        else{
            //result.append(userchecker)
            usercheckerarray.append(userdata)
            usercheckerarray.append(userdatapassword)
            return usercheckerarray
        }
        
       
      
    }
    init() {
        /**ログインについての初期化処理 */
        userid = UserDefaults.standard.string(forKey:"userid") ?? ""
        userdataEmail = UserDefaults.standard.string(forKey:"userdataEmail") ?? ""
        userdataPassword = UserDefaults.standard.string(forKey: "userdataPassword") ?? ""
        //var login = Login(email:userid, password:userdataPassword, complition:Void)
        Login(email:userdataEmail,password:userdataPassword){result in
            if result{
                print("成功")
            }else{
                self.userid = ""
                self.userdataEmail = ""
                self.userdatapassword = ""
                print("失敗")
                
            }
        }
        print("関数抜ける")
        /**初期化処理 */
        self.usercheckflg = userpreservaitonconfirmation
        //userpreservaitonconfirmation()
        //音を鳴らす処理を実行する。
        cancellable = ShakeTimesViewModel.launchWakeUp.sink {
            self.isPresentingShakeUpView = $0
        }
        
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("Allowedです")
            } else {
                print("Didn't allowed")
            }
        }
    }
}
