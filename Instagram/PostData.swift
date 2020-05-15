//
//  PostData.swift
//  Instagram
//
//  Created by 石田悠 on 2020/05/10.
//  Copyright © 2020 yuu.ishida. All rights reserved.
//
//MARK:- 言葉
//NSObject...クラスとしての最低限の機能を備えたクラス全てのフレームワークの基本となっている
//           NS...NextStep

import UIKit
import Firebase

class PostData: NSObject {
    var id: String
    var name: String?
    var caption: String?
    var date: Date?
    var likes: [String] = []
    var isLiked: Bool = false
    
  //  var comments:[String?] = []
    //name,comments,date順
    //var postComments:(String,String,Date)
//    var comments: [String] = []
    //配列中に辞書型を設置→ [["日時"：yyymmdd,"投稿者":name,"コメント":comment]]
    var comments : [[String:String]] = [[:]]
    
    //FirebaseからQueryDocumentSnapshotクラスのデータが渡される
    init(document: QueryDocumentSnapshot) {
        self.id = document.documentID
        
        //data()形式で辞書型データを取出しできる
        let postDic = document.data()

        self.name = postDic["name"] as? String

        self.caption = postDic["caption"] as? String

        let timestamp = postDic["date"] as? Timestamp
        self.date = timestamp?.dateValue()
        
        //「いいね」をした人のIDの配列
        if let likes = postDic["likes"] as? [String] {
            self.likes = likes
        }
        //「いいね」を自分がしたかのフラグ
        //myid != nilの時の処理(基本nilでないが、nilの場合があったらとリスクヘッジ)
        if let myid = Auth.auth().currentUser?.uid {

// likesの配列の中にmyidが含まれているかチェックすることで、自分がいいねを押しているかを判断
            if self.likes.firstIndex(of: myid) != nil {
                // myidがあれば、いいねを押していると認識する。
                self.isLiked = true
            }
        }
//MARK: - コメントの情報を記入
        //「コメント」の配列
        if let comments = postDic["comments"] as? [[String:String]] {
           self.comments = comments

        }
      }
}
