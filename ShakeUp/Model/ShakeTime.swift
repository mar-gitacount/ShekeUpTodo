//
//  ShakeTime.swift
//  ShakeUp
//
//  Created by Hal Stroemeria on 2019/12/05.
//  Copyright © 2019 hal-cha-n. All rights reserved.
//

import Foundation
import Combine
import SwiftUI
import Firebase
import FirebaseDatabase
import FirebaseAuth
class ShakeTime: ObservableObject, Identifiable {
    var hour = 0
    var minute = 0
    var isOn = false {
        didSet {
            if isOn {
                print("通知ON")
                LocalPushCenter.sendLocalPush(hour: hour, minute: minute)
            }
        }
    }
}

class Userdata:ObservableObject, Identifiable{
    var name = ""
    var password = ""
    var userflg = false
    var isOn = false {
        didSet{
            Auth.auth().signIn(withEmail:name,password: password)
        }
    }
}

/**Todoリスト一覧 */
class FirebaseTodolist: ObservableObject ,Identifiable{
    var id: String?
    var tasktitle: String?
    var taskBody: String?
    var taskCategory: String?
    var startTime: String?
    var endTime: String?
}
//ファイナルクラスを持たせる
final class UserLoginStatus: ObservableObject {
    private init(){}
    static var shared = UserLoginStatus()
    @Published var isLogin = false
}
//


//class UserdataCheck{
//    //このクラスからモデルにデータを渡して、そこのモデル内でfirebase通信する?
//    func viewLoad() -> (String){
//        var testmessage  = "データ通信チェック"
//
//        
//        if(userdata == ""){
//            
//        }else{
//            return testmessage
//        }
//    }
//}

class Userdatastock {
    @AppStorage("Userdata") var userdata = ""
    @AppStorage("Userdatapassword") var userdatapassword = ""
    @AppStorage("Userid") var userid = ""
    @AppStorage("count_key") var counter = 0
}

class Userdatasotockcheck:ObservableObject, Identifiable{
//    var userdata = ""
//    var userdatapassword = ""
    @State var userdata = Userdatastock().userdata
    @State var userdatapassword = Userdatastock().userdatapassword
    /**データ通信確認先でデータがあればこの中の配列に入れる。 */
    /**このクラスでfirebaseチェックする。 */
    @State var userdadadavalues : [String] = []
    @State var userflg:Bool?
    //通信チェック
    /**userdatachekflgをtrueにするとユーザーチェックする。そのタイミングはインスタンスを作った先で行う。 */
    /**trueになったら通信 */
    var userdatachekflg = true {
        didSet{
            if (userdadadavalues.indices.contains(0)){
                /**　配列に返ってきた値を入れていく */
                userdatachekflg = true
            }
            if(!(userdata == "" && userdatapassword == "")){
                Auth.auth().signIn(withEmail:userdata,password: userdatapassword){(resurt,error)in
                    if let user = resurt?.user {
                        let c_user = Auth.auth().currentUser
                        let usermail = c_user?.email
                        print(c_user?.uid)
                        print("通信中")
                        self.userdadadavalues.append(self.userdata)
                        self.userflg = true
                        print(self.userflg)

                    }
                    if error != nil{
                        self.userdadadavalues.removeAll()
                        print("ない")
                        print(self.userdata)
                        print(self.userdatapassword)
                        print(error)
                        self.userflg = false
                    }
                }

                /**ここで処理が成功すれば、userdatavaluesに値をセットしていく */
                userdatachekflg = true
            }
            else{
                self.userflg = false
                self.userdadadavalues.removeAll()
                print("ユーザーフラグない")
            }
        }
    }
}

class UserSetdefault:ObservableObject, Identifiable{
    var todotext = ""
    var dayreadcount = 0
    var isOn = false {
        didSet{
            if isOn {
                LocalPushCenter.sendLocalPush(hour: dayreadcount, minute: dayreadcount)

            }
        }
    }
}

struct Userdatacheck{
//    var email:String
//    var password:String
   @State var userdata = Userdatastock().userdata
   @State var userdatapassword = Userdatastock().userdatapassword
//    var userdata = "ichikawa.contact@gmail.com"
//    var userdatapassword = "masa1205"
    //init(email:String,password:String){
//        self.email = email
//        self.password = password
//    }
    func testfunc() -> [Userdata]{
        var result = [Userdata]()
        var userdata = Userdata()
        userdata.userflg = true
        return result
    }
    func appvaluecheck() -> Bool {
        //startusercheck()
        if(userdata == ""){
            return false
        }
        else{
            print("-----------------------------------")
            print(userdata)
            print(userdatapassword)
            print("-----------------------------------")

            return true

        }
    }
    func startusercheck()->String{
        var test1 = "ある"
        Auth.auth().signIn(withEmail:userdata,password: userdatapassword){
            
            (resurt,error)in
            if let user = resurt?.user {
                let c_user = Auth.auth().currentUser
                let usermail = c_user?.email
                print(c_user?.uid)

            }
            if error != nil{
                print("ない")
                print(userdata)
                print("errrrrr")
                print(userdatapassword)
                print(error)
            }
            
        }
//        if(self.email == ""){
//
//        }
        return test1

        
    }
}
class ShakeTime_alertsetting: ObservableObject, Identifiable{
    var hour = 0
    var minute = 0
    var isOn = false {
        didSet{
            if isOn {
                LocalPushCenter.sendLocalPush(hour: hour, minute: minute)
            }
        }
    }
}

struct dateType : Identifiable {
    var id : UUID
    var createAt: String
    var startTime: String
    var endTime: String
    var taskBody: String
    var tasktitle: String
    var taskCategory: String
}

struct popupdataType : Identifiable {
    var id : String
    var taskCategory :String
    var startTime: String
    var endTime: String
    var taskTitle: String
}
