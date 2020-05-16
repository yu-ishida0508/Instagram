//
//  CommentViewController.swift
//  Instagram
//
//  Created by 石田悠 on 2020/05/12.
//  Copyright © 2020 yuu.ishida. All rights reserved.
//

import UIKit
//import Firebase

class CommentViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    var postData:PostData!
    var index:Int = 0
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.backgroundColor = .rgb(red: 118, green: 140, blue: 180)

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //コメント毎の高さを自動調節　20は最低の高さ
        self.tableView.estimatedRowHeight = 20
        return UITableView.automaticDimension
    }
    
    // データの数（＝セルの数）を返すメソッド
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return postData.comments.count  //コメントのカウント
       }
    // 各セルの内容を返すメソッド
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 再利用可能な cell を得る
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! CustomTableViewCell
        //as! CustomTableViewCellはCustomTableを作る際に必要
        //名前、日付、コメントの出力
        print("DEBUG_PRINT: コメント掃き出し")
        print("DEBUG_PRINT: 生成セル数\(postData.comments.count)")
        print("DEBUG_PRINT: コメント\(postData.comments[indexPath.row]["コメント"])")
        print("DEBUG_PRINT: 投稿者\(postData.comments[indexPath.row]["投稿者"])")
        print("DEBUG_PRINT: 日時\(postData.comments[indexPath.row]["日時"])")
        
        //コメントがない場合は、全て非表示にしてreturn
        if postData.comments[indexPath.row]["コメント"] == nil {
            cell.myTextViewLabel?.isHidden = true //コメントの非表示
            cell.myTextCommentorLabel?.isHidden = true //投稿者の非表示
            cell.myDateLabel?.isHidden = true //日時の非表示
            cell.myTextLabel?.isHidden = true //コメント件数の非表示
            return cell
        }else {
            
            cell.myTextViewLabel?.isHidden = false //コメントの表示
            cell.myTextCommentorLabel?.isHidden = false //投稿者の表示
            cell.myDateLabel?.isHidden = false //日時の表示
            cell.myTextLabel?.isHidden = false //コメント件数の表示
            
        //indexPath.rowでcellの[行番号取得][" 辞書型データ取得"]
        cell.myTextViewLabel?.text = postData.comments[indexPath.row]["コメント"]
        cell.myTextCommentorLabel?.text = postData.comments[indexPath.row]["投稿者"]
        cell.myDateLabel?.text = postData.comments[indexPath.row]["日時"]
        cell.myTextLabel?.text = "\(indexPath.row +  1)件目のコメント"
            return cell
        }
        

    }
}
