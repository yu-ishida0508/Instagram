//
//  PostViewController.swift
//  Instagram
//
//  Created by 石田悠 on 2020/05/06.
//  Copyright © 2020 yuu.ishida. All rights reserved.
//
//MARK: - 写真投稿用コントローラ

import UIKit
import Firebase
import SVProgressHUD

class PostViewController: UIViewController {
    //ImageSelectViewControllerから受け取り用プロパティ
    var image: UIImage!

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    
//MARK: -    投稿ボタンをタップしたときに呼ばれるメソッド
    @IBAction func handlePostButton(_ sender: Any) {
        // 画像をJPEG形式に変換する　圧縮率0.75
        let imageData = image.jpegData(compressionQuality: 0.75)
        
    // 画像と投稿データの保存場所を定義する
        //Firestore...Firebaseアプリ開発用DB保存先
//collection()メソッドの引数に、Const.PostPath("posts")を指定→
//Firebase「posts」フォルダのドキュメントに投稿データ格納先として指定
        let postRef = Firestore.firestore().collection(Const.PostPath).document()
        
    //Storage...Firebaseアプリ開発用Storage
//child()メソッドの引数にConst.ImagePathを指定→「images」フォルダに画像データ格納
//投稿データと紐付けするために.child(postRef.documentID + ".jpg")を付けることで、
//投稿データのdocumentIDを紐付ける
        let imageRef = Storage.storage().reference().child(Const.ImagePath).child(postRef.documentID + ".jpg")
        // HUDで投稿処理中の表示を開始
        SVProgressHUD.show()
        // Storageに画像をアップロードする
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        //putDataメソッドで画像をStrageにアップロード、後置クロージャでアップロード完了後の処理を記述している
        imageRef.putData(imageData!, metadata: metadata) { (metadata, error) in
            //errorがnilでない時の処理
            if error != nil {
                // 画像のアップロード失敗
                print(error!)
                SVProgressHUD.showError(withStatus: "画像のアップロードが失敗しました")
                // 投稿処理をキャンセルし、先頭画面に戻る
                UIApplication.shared.windows.first{ $0.isKeyWindow }?.rootViewController?.dismiss(animated: true, completion: nil)
                return
            }
            //errorがnilの時
            // FireStoreに投稿データを保存する
            //FieldValue.serverTimestamp()→保存日時はFirestore上の日時
            let name = Auth.auth().currentUser?.displayName
            let postDic = [
                "name": name!,
                "caption": self.textField.text!,
                "date": FieldValue.serverTimestamp(),
                ] as [String : Any]
            //setDataメソッドを実行することでFirestoreにデータ保存できる
            postRef.setData(postDic)
            // HUDで投稿完了を表示する
            SVProgressHUD.showSuccess(withStatus: "投稿しました")
            // 投稿処理が完了したので先頭画面に戻る
           UIApplication.shared.windows.first{ $0.isKeyWindow }?.rootViewController?.dismiss(animated: true, completion: nil)
        }
    }
//MARK: -    キャンセルボタンをタップしたときに呼ばれるメソッド
    @IBAction func handleCancelButton(_ sender: Any) {
        // 加工画面に戻る
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 受け取った画像をImageViewに設定する
        imageView.image = image
    }

}
