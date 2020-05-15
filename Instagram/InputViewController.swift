//
//  InputViewController.swift
//  Instagram
//
//  Created by 石田悠 on 2020/05/12.
//  Copyright © 2020 yuu.ishida. All rights reserved.
//

import UIKit
import Firebase

class InputViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addCommentsText: UITextView!
    @IBOutlet weak var captionTextView: UITextView!
    
    var postData:PostData!
    var date:Date = Date()

    
//MARK: - 投稿ボタン押下
    @IBAction func addCommentButton(_ sender: Any) {
        print("DEBUG_PRINT: 投稿ボタンを押下しました")
        //テキスト未入力時には何も返さない
        guard let addComment = addCommentsText.text else{
            return
        }
        
        // 更新データを作成する(フィールドの値)
        var updateValue: FieldValue
        //dateString,name,addCommentをまとめる変数
//        var margeString:String = ""
        var dicString: [[String:String]] = [[:]]
        
        //Firebase「posts」フォルダのドキュメントの指定idを指定
        let postRef = Firestore.firestore().collection(Const.PostPath).document(postData.id)
        
        
        //自動ID付与
        //postRef.childByAutoId().setValue(comments)
        
        //name : "投稿者名" 　data:"投稿者名"と"コメント"設置
        let name = Auth.auth().currentUser?.displayName
        
        //日付データ取得
        let date = Date()
         let formatter = DateFormatter()
        // DateFormatter を使用して書式とロケールを指定する
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yMMMdHms", options: 0, locale: Locale(identifier: "ja_JP"))
        let dateString = formatter.string(from: date)
        
//        margeString = (dateString + "　投稿者：" + name! + "　コメント：" + addComment)
        dicString = [["コメント":addComment,"投稿者":name!,"日時":dateString]]
        
        // 今回「投稿する」を押した場合は、[name,addComment]を追加する更新データを作成
        updateValue = FieldValue.arrayUnion(dicString)
        
        postRef.updateData(["comments": updateValue]) //updateDataにて更新
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    // 背景をタップしたらdismissKeyboardメソッドを呼ぶように設定する
    let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(dismissKeyboard))
    self.view.addGestureRecognizer(tapGesture)
        
        self.nameLabel.text = postData.name
        self.captionTextView.text = postData.caption
    }
    
    @objc func dismissKeyboard(){
    // キーボードを閉じる
    view.endEditing(true)
    }
}
