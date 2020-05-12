//
//  Const.swift
//  Instagram
//
//  Created by 石田悠 on 2020/05/10.
//  Copyright © 2020 yuu.ishida. All rights reserved.
//
//MARK: -　『用途』Firebase関連の定数の定義
//          - アプリ全体を使って使用する定数の定義 -

import Foundation

struct Const {
    //Storage内の画像ファイルの保存場所を定義
    //ここでは
    static let ImagePath = "images"
    
    //Firestore内(DB内)の投稿データ(投稿者名、キャプション、投稿日時等)の保存場所を定義
    //ここでは"posts"がFirestore内のフォルダ
    static let PostPath = "posts"

}
