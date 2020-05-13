//
//  HomeViewController.swift
//  Instagram
//
//  Created by 石田悠 on 2020/05/06.
//  Copyright © 2020 yuu.ishida. All rights reserved.
//
//MARK:- 言葉
//スナップショット...ある時点でのファイル、DBの状態を抜き出した物

import UIKit
import Firebase

class HomeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!

    // 投稿データを格納する配列
    var postArray: [PostData] = []
    
    // Firestoreのリスナー(Firestoreのデータの読込み更新監視を行うか判定)
    var listener: ListenerRegistration!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self

        // カスタムセルを登録する nib(Next Interface Builder)ファイル = xibファイル
        let nib = UINib(nibName: "PostTableViewCell", bundle: nil)
        //registar..カスタムセル登録メソッド
        //nibオブジェクトをテーブルオブジェクトにCellというIdentiferで登録
        tableView.register(nib, forCellReuseIdentifier: "Cell")
    }
    
//MARK: - 表示データの読込み(addSnapshotListeneで監視しているリスナーが更新を検知)
    
    //画面が表示される「前」に呼出されるメソッド
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("DEBUG_PRINT: viewWillAppear")
        
        //ログイン済の判定
        if Auth.auth().currentUser != nil {
            
            // ログイン済み...(Firestoreのデータの読込み更新監視を行うか判定)
            //リスナー監視装置を2台作らないようにしている。
            if listener == nil {
                // listener未登録なら、登録してスナップショットを受信する
                let postsRef = Firestore.firestore().collection(Const.PostPath).order(by: "date", descending: true)
                
                //postsRefで取得できるドキュメントをaddSnapshotListener()で監視
                //クロージャはドキュメントが追加・更新される都度呼出される
                listener = postsRef.addSnapshotListener() { (querySnapshot, error) in
                    if let error = error {
                        print("DEBUG_PRINT: snapshotの取得が失敗しました。 \(error)")
                        return
                    }
                    // 取得したdocumentをもとにPostDataを作成し、postArrayの配列にする。
                    self.postArray = querySnapshot!.documents.map { document in
                        print("DEBUG_PRINT: document取得 \(document.documentID)")
                        let postData = PostData(document: document)
                        return postData
                    }
                    // TableViewの表示を更新する
                    self.tableView.reloadData()
                }
            }
        } else {
            // ログイン未(またはログアウト済み)
            if listener != nil {
                // listener登録済みなら削除してpostArrayをクリアする
                listener.remove()
                listener = nil
                postArray = []
                tableView.reloadData()
            }
        }
    }

//MARK: - データの数を返す必須メソッド
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return postArray.count
       }

//MARK: - セルの内容を返す必須メソッド
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           // セルを取得してデータを設定する 再利用可能なセルを取得する
           let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PostTableViewCell
            
//PostTableViewCellの「setPostData」メソッドでpostArrayの配列の要素を返す
//「setPostData」メソッド...(func setPostData(_ postData: PostData))
           cell.setPostData(postArray[indexPath.row])
        
        // セル内のボタンのアクションをソースコードで設定する
        //handleButton(_:forEvent:)...第1引数:(省略:)、第2引数:(forEvent:)
        //第1引数には、UIButtonインスタンス、第2引数には、UIEvent型のタップイベントが格納
        cell.likeButton.addTarget(self, action:#selector(handleButton(_:forEvent:)), for: .touchUpInside)

        //コメント閲覧ボタンクリック時
        cell.commentButton.addTarget(self, action:#selector(commentHandleButton(_:forEvent:)), for: .touchUpInside)
        
        //コメント追記ボタンクリック時
        cell.inputCommentButton.addTarget(self, action:#selector(inputCommentHandleButton(_:forEvent:)), for: .touchUpInside)


           return cell
       }
//MARK: - いいねボタンがタップされた時に呼ばれるメソッド
    // セル内のボタンがタップされた時に呼ばれるメソッド
    @objc func handleButton(_ sender: UIButton, forEvent event: UIEvent) {
        print("DEBUG_PRINT: likeボタンがタップされました。")

        // タップされたセルのインデックスを求める
        let touch = event.allTouches?.first
        //location(in:)タッチした座標(TableView内の座標)
        let point = touch!.location(in: self.tableView)
        let indexPath = tableView.indexPathForRow(at: point)

        // 配列からタップされたインデックスのデータを取り出す
        let postData = postArray[indexPath!.row]

        // likesを更新する
        if let myid = Auth.auth().currentUser?.uid {
            // 更新データを作成する
            var updateValue: FieldValue
            if postData.isLiked {
                // すでに「いいね」をしている場合は、いいね解除のためmyidを取り除く更新データを作成
                updateValue = FieldValue.arrayRemove([myid])
            } else {
                // 今回新たに「いいね」を押した場合は、myidを追加する更新データを作成
                updateValue = FieldValue.arrayUnion([myid])
            }
            // likesに更新データを書き込む
            //Firebase「posts」フォルダのドキュメントの指定idを指定
            let postRef = Firestore.firestore().collection(Const.PostPath).document(postData.id)
            postRef.updateData(["likes": updateValue]) //updateDataにて更新
        }
    }
    
//MARK: - コメント閲覧ボタンがタップされた時に呼ばれるメソッド
    // セル内のボタンがタップされた時に呼ばれるメソッド
    @objc func commentHandleButton(_ sender: UIButton, forEvent event: UIEvent) {
        print("DEBUG_PRINT: commentボタンがタップされました。")
        // タップされたセルのインデックスを求める
            let touch = event.allTouches?.first
        //location(in:)タッチした座標(TableView内の座標)
            let point = touch!.location(in: self.tableView)
            let indexPath = tableView.indexPathForRow(at: point)
                
        // 配列からタップされたインデックスのデータを取り出す
            let postData = postArray[indexPath!.row]
                
        //遷移先(InputVC)のVC取得
        let comntVC = self.storyboard?.instantiateViewController(withIdentifier: "Comment") as! CommentViewController

                //遷移先のプロパティに情報セット
              //  comntVC.addNameLabel = postData.name!
        //inputVC.addCaptionLabel = postData.caption!
                //InputVCへ遷移 & 情報渡し
                self.present(comntVC, animated: true, completion: nil)
        
        
    //    performSegue(withIdentifier: "commentSegue", sender: nil)

       
    }

    //MARK: - コメント入力ボタンがタップされた時に呼ばれるメソッド
        // セル内のボタンがタップされた時に呼ばれるメソッド
        @objc func inputCommentHandleButton(_ sender: UIButton, forEvent event: UIEvent) {
            print("DEBUG_PRINT: inputCommentボタンがタップされました。")
            // タップされたセルのインデックスを求める
                let touch = event.allTouches?.first
            //location(in:)タッチした座標(TableView内の座標)
                let point = touch!.location(in: self.tableView)
                let indexPath = tableView.indexPathForRow(at: point)
            
            // 配列からタップされたインデックスのデータを取り出す
            let postData = postArray[indexPath!.row]
            
            //遷移先(InputVC)のVC取得
            let inputVC = self.storyboard?.instantiateViewController(withIdentifier: "Input") as! InputViewController

            //遷移先のプロパティに情報セット
            inputVC.addNameLabel = postData.name!
            inputVC.addCaptionLabel = postData.caption!
            //InputVCへ遷移 & 情報渡し
            self.present(inputVC, animated: true, completion: nil)
           
        }
//MARK: -
}
