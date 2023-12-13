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
                            let taskBody = document.document.get("taskBody") as! String
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
                                self.popupdatas.append(popupdataType(id:id, taskCategory: category, startTime:startTime, endTime: endTime, taskTitle:tasktitle,taskBody:taskBody))
                                
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
    @Published var loddingflg = true
    @Published var serchvalue = ""

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
    //データ検索しても、popupdatasに入稿する。
    //データの取得パターン
    //検索からの取得
    //カテゴリからの取得
    //すべての取得
    //データを取得する。
    func fetchData(datasnumbers:Int = 10,serachvalue:String = "",categoryvalue:String = "")->[popupdataType]{
       // var datas = [FirebaseTodolist]()
        let popupdatas = [popupdataType]()
        let shaketimesviewmodel = ShakeTimesViewModel().userid
        let shaketimesviewmodelemail = ShakeTimesViewModel().userdataEmail
        let currentuser = Auth.auth().currentUser
        // 検索する文字列（例えば、serachvalue = "た" など）

        // ひらがな・カタカナを検索する場合は、全角英数字を追加して範囲を指定します（"あ"から"ん"まで）
        let endChar = serachvalue < "あ" || serachvalue >= "ん" ? "ｚ" : "z"

        self.loddingflg = true
        guard let uid = currentuser?.uid else {return popupdatas}
//        if shaketimesviewmodelemail.isEmpty {
//            print("から判定")
//            return popupdatas
//        }
        //配列を一度空にする
        self.popupdatas.removeAll()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'年'M'月'd'日('EEEEE') 'H'時'm'分's'秒'"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        //ここでfirebaseと通信する処理をしている。
        //とりあえずタイトルとidだけ持ってきて、クリックしたら、全データを持ってくる。
//            .limit(to:datasnumbers)
        //検索文字がからでない場合、渡された文字列で検索してpopupdatasに入れ込む。
        if !serachvalue.isEmpty{
            print("空でない")
            //謎変数
            var matchingDocuments = [QueryDocumentSnapshot]()
            //タスクリストコレクションの取得。
            let query = Firestore.firestore().collection("users").document(uid).collection("tasklist")
            
            
            
            // Firestoreからデータを取得
            query.getDocuments { (snapshot, error) in
                if let error = error {
                    print("データ取得エラー: \(error)")
                } else {
                    var matchingDocuments = [QueryDocumentSnapshot]()

                    // Firestoreから取得したデータをローカルに保持
                    if let documents = snapshot?.documents {
                        matchingDocuments = documents.filter { document in
                            // 部分検索を行う（大文字小文字を無視する場合はcaseInsensitiveにする）
                            if let tasktitle = document.data()["tasktitle"] as? String {
                                return tasktitle.range(of: serachvalue, options: .caseInsensitive) != nil
                            }
                            return false
                        }
                    }
                        
                    // 部分検索の結果を処理してpopupdatasに入稿
                    DispatchQueue.main.async {
                        self.popupdatas.removeAll()
                        for document in matchingDocuments{
                            let documentID = document.documentID
                            //ドキュメントidを取得したので、その中のデータを抽出する。
                            print(document.get("tasktitle") as! String)
                            print(documentID)
                            print("データ一覧内")
                            let category = document.get("taskCategory") as! String
                            let tasktitle = document.get("tasktitle") as! String
                            let taskBody = document.get("taskBody") as! String
                            let startTimestamp = document.get("startTime") as! Timestamp
                            let endTimestamp = document.get("endTime") as! Timestamp
                            //let id = document.get("id") as! String
                            let formatterDate = DateFormatter()
                            formatterDate.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                            let startTime = formatterDate.string(from: startTimestamp.dateValue())
                            let endTime = formatterDate.string(from: endTimestamp.dateValue())
           
                            self.popupdatas.append(popupdataType(id: documentID, taskCategory: category, startTime: startTime, endTime: endTime, taskTitle: tasktitle,taskBody: taskBody))
                            self.loddingflg = false
                            //この処理が終わるまでローディングフラグをONにし、zstackでロード画面にする。ビュー側ではローディングフラグがonな限り、zstackを実行する。
                        }
                        
                    }

                }//error=else
            }
            
            
            
//            Firestore.firestore().collection("users").document(uid).collection("tasklist")
//                .whereField("tasktitle",isGreaterThanOrEqualTo: serachvalue)
//                .whereField("tasktitle",isLessThan: serachvalue + "z")
//                .getDocuments{(snaps,error) in
//                    if let error = error {
//                        print("Error getting documents: \(error)")
//                        return
//                    }
//                    guard let documents = snaps?.documents else{
//                        print("検索０件")
//                        return
//                    }
//                    print(documents)
//
//                    DispatchQueue.main.async {
//                        self.popupdatas.removeAll()
//                        for document in documents{
//                            let documentID = document.documentID
//                            //ドキュメントidを取得したので、その中のデータを抽出する。
//                            print(document.get("tasktitle") as! String)
//                            print(documentID)
//                            print("データ一覧内")
//                            let category = document.get("taskCategory") as! String
//                            let tasktitle = document.get("tasktitle") as! String
//                            let taskBody = document.get("taskBody") as! String
//                            let startTimestamp = document.get("startTime") as! Timestamp
//                            let endTimestamp = document.get("endTime") as! Timestamp
//                            //let id = document.get("id") as! String
//                            let formatterDate = DateFormatter()
//                            formatterDate.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
//                            let startTime = formatterDate.string(from: startTimestamp.dateValue())
//                            let endTime = formatterDate.string(from: endTimestamp.dateValue())
//
//                            self.popupdatas.append(popupdataType(id: documentID, taskCategory: category, startTime: startTime, endTime: endTime, taskTitle: tasktitle,taskBody: taskBody))
//                            self.loddingflg = false
//                            //この処理が終わるまでローディングフラグをONにし、zstackでロード画面にする。ビュー側ではローディングフラグがonな限り、zstackを実行する。
//
//                        }
//
//                    }
//
//                }// Firestore.firestore().collection("users").document(uid).collection("tasklist")
            return popupdatas
        }
        
        Firestore.firestore().collection("users").document(uid).collection("tasklist").order(by:"startTime" , descending: true).addSnapshotListener{ (snaps, error) in
            print("空である。")
            if let error = error{
                return
                //fatalError("\(error)")
                guard let snaps = snaps else {return}
            }
            guard let documents = snaps?.documents else {
                return
            }
                DispatchQueue.main.async {
                    self.popupdatas.removeAll()
                    //            ここの繰り返し処理を非同期処理内に移動する。
                    print("検索結果が空の場合に入ってる。")
                                for document in documents{
                                    let documentID = document.documentID
                                    //ドキュメントidを取得したので、その中のデータを抽出する。
                                    print(document.get("tasktitle") as! String)
                                    print(documentID)
                                    let category = document.get("taskCategory") as! String
                                    let tasktitle = document.get("tasktitle") as! String
                                    let taskBody = document.get("taskBody") as! String
                                    let startTimestamp = document.get("startTime") as! Timestamp
                                    let endTimestamp = document.get("endTime") as! Timestamp
                                    //let id = document.get("id") as! String
                                    let formatterDate = DateFormatter()
                                    formatterDate.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                                    let startTime = formatterDate.string(from: startTimestamp.dateValue())
                                    let endTime = formatterDate.string(from: endTimestamp.dateValue())
                   
                    self.popupdatas.append(popupdataType(id: documentID, taskCategory: category, startTime: startTime, endTime: endTime, taskTitle: tasktitle,taskBody: taskBody))
                    self.loddingflg = false
                }//この処理が終わるまでローディングフラグをONにし、zstackでロード画面にする。ビュー側ではローディングフラグがonな限り、zstackを実行する。
                
            }
//            for document in snaps!.documentChanges{
//                //var testdata = document.document.get("startTime") as! Timestamp
//                    if document.type == .added{
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
//                       // let str = dateFormatter.strinCzg(from:startTime.dateValue())
//                        print("-----------------------------------")
//                        print(category)
//                        print(id)
//                        print(startTimestamp)
//                        print("-----------------------------------")
//                        DispatchQueue.main.async {
//                            self.popupdatas.append(popupdataType(id: id, taskCategory: category, startTime: startTime, endTime: endTime, taskTitle: tasktitle))
//                        }
//                    }
//                //testresult.append(document.data())
//            }
        }
        return popupdatas
    }
    //ユーザーごと削除された時に走る処理もじ通りすべて削除
    func alldelete(){
        var deletetaskdata = ShakeTimesViewModel().userid
        guard let userid = Auth.auth().currentUser?.uid else {return}
        Firestore.firestore().collection("users").document(userid).delete(){ err in
            if let err = err {
                print("Error removing document: \(err)")
                print("エラー入ってる")
            }
            else{
                print("削除成功")
            }
        }
    }
    func popupdatasremove(){
        self.popupdatas.removeAll()

    }
    func singledelete(data:String){
        guard let userid = Auth.auth().currentUser?.uid else {
            print("なし")
            return
        }
        //以下のドキュメントの部分のidを取得し、削除する。
        Firestore.firestore().collection("users").document(userid).collection("tasklist")
            .document().delete(){ err in
                if let err = err {
                    print("デリートエラー")
                }
                else{
                    print("消しました。関数")
                }
            }
    }
    
    func deleteData(){
        _ = ShakeTimesViewModel().userid
        
        guard let userid = Auth.auth().currentUser?.uid else {return}
        print("-----------------------------------")
        print(userid)
        print("-----------------------------------")

        Firestore.firestore().collection("users").document(userid).collection("tasklist").getDocuments{(snaps ,error) in
            if let error = error{
                print("削除失敗")
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
    @Published var user:User?
    //Firebase AuthenticationのAuthオブジェクトに対して、認証状態の変更を監視するためのハンドル。
    private var handle: AuthStateDidChangeListenerHandle?
    init(){
        //初期化時点で認証状態を監視し、その値を代入する。
        handle = Auth.auth().addStateDidChangeListener{ (auth,user) in
            self.isLoggedIn = user != nil
        }
    }
    //メモリ上のインスタンスを解放する。
    deinit {
        if let handle = handle{
            //監視状態を解除する。
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    //ログイン関数
    func signin(email:String,password:String){
        Auth.auth().signIn(withEmail:email,password: password){result, error in
            if let user = result?.user{
                //ここがtrueになればビューが再描画される。
                self.isLoggedIn = true
                DispatchQueue.main.async {
                    self.user = user
                }
            } else if let error = error{
                print("エラー")
            }
        }
    }
    //サインアップ関数
    func signup(email:String,password:String){
        Auth.auth().createUser(withEmail:email, password: password){ authResult, error in
            if let user = authResult?.user {
                self.isLoggedIn = true
                let request = user.createProfileChangeRequest()
                let db = Firestore.firestore()
                //メールエラーでない場合、登録メールを送る。
                user.sendEmailVerification(completion:{error in
                    if error == nil {
                        print("登録完了")
                    }
                })
                let values = ["name":user.uid,"email":email]
                //を登録する。
                db.collection("users").document(user.uid).setData(values)
            }
        }
    }
    //ログアウト関数
    func logout(){
        do {
            self.isLoggedIn = false
            try Auth.auth().signOut()
        } catch let error as NSError {
            print("サインアウトできませんでした。")
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
