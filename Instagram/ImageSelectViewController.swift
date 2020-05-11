//
//  ImageSelectViewController.swift
//  Instagram
//
//  Created by 石田悠 on 2020/05/06.
//  Copyright © 2020 yuu.ishida. All rights reserved.
//
//MARK: - 言葉
//ImageSelectViewController...「ライブラリ」「カメラ」「キャンセル」の一覧のコントローラ
//UIImagePickerController()...カメラ、写真アルバム、フォトライブラリから画像を取得するクラス
//dismiss①...dismissを指定したVCから画面遷移しているVCがあれば、遷移先のVCを閉じる
//dismiss②...dismissを指定したVCから画面遷移しているVCが無ければ、指定されたVCを閉じる
//self.presentingViewController...selfの呼び出し元のVCを取得

//MARK: -

import UIKit
import CLImageEditor //写真加工画面でCoCoaPodsから持ってきたもの

class ImageSelectViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate,CLImageEditorDelegate{
//MARK: - ライブラリ押下時
    @IBAction func handleLibraryButton(_ sender: Any) {
        // ライブラリ（カメラロール）を指定してピッカー(写真ライブラリ)を開く
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = .photoLibrary
            //presentプロパティで遷移先(ライブラリ)のモーダル表示
//self(ここではImageSelectVC)は、selfの遷移先のVCまたは、selfのVCを閉じる。
            self.present(pickerController, animated: true, completion: nil)
        }
    }
    
//MARK: - カメラ押下時
    @IBAction func handleCameraButton(_ sender: Any) {
        // カメラを指定してピッカーを開く
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = .camera
//self(ここではImageSelectVC)は、selfの遷移先のVCまたは、selfのVCを閉じる。
            self.present(pickerController, animated: true, completion: nil)
               }
    }
//MARK: - キャンセル押下時
    @IBAction func handleCancelButton(_ sender: Any) {
        // 画面を閉じる
//self(ここではImageSelectVC)は、selfの遷移先のVCまたは、selfのVCを閉じる。
        self.dismiss(animated: true, completion: nil)
    }
//MARK: - 写真を撮影/選択したときに呼ばれるメソッド
    //「func handleCameraButton」でカメラを起動して撮影後に呼ばれる
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //[.originalImage]は撮影した画像を取得するメソッド
        if info[.originalImage] != nil {
            // 撮影/選択された画像を取得する
            let image = info[.originalImage] as! UIImage

            // あとでCLImageEditorライブラリで加工する
            print("DEBUG_PRINT: image = \(image)")
            
            // CLImageEditorにimageを渡して、加工画面を起動する。
            let editor = CLImageEditor(image: image)!
            editor.delegate = self
            //画像加工画面(ClImageEditor)へ遷移
            //「self」だとImageSelectVC を指す。
            picker.present(editor, animated: true, completion: nil)

        }
    }
//MARK: - CLImageEditorで加工が終わったときに呼ばれるメソッド
    
    func imageEditor(_ editor: CLImageEditor!, didFinishEditingWith image: UIImage!) {
        // 投稿画面を開く
        let postViewController = self.storyboard?.instantiateViewController(withIdentifier: "Post") as! PostViewController
        postViewController.image = image!
        //presentプロパティで遷移先(投稿画面)のモーダル表示
        //selfでないのは、HomeVC → ImageSelectVC → ImageEditorの順で遷移しており、「editor」はImageEditorを指して値渡しする
        //「self」だとImageSelectVC を指してしまう。
        editor.present(postViewController, animated: true, completion: nil)
    }

//MARK: - CLImageEditorの編集がキャンセルされた時に呼ばれるメソッド
    func imageEditorDidCancel(_ editor: CLImageEditor!) {
        
//MARK: - self.presentingViewController?.dismissの説明
//HomeVC → ImageSelectVC→CLImageEditorに遷移している。
//「self」はImageSelectVCを指し、presentingViewControllerでHomeVCを指定している。
//「dismiss」でHomeVCの遷移先のVC(ImageSelectVC)の配下を閉じる。
        
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
//MARK: - UIImagePickerControllerの画面内でキャンセルボタンをタップした時に呼ばれるメソッド
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // ImageSelectViewController画面を閉じてタブ画面に戻る
//MARK: - self.presentingViewController?.dismissの説明
//HomeVC → ImageSelectVC→ImagePCに遷移している。
//「self」はImageSelectVCを指し、presentingViewControllerでHomeVCを指定している。
//「dismiss」でHomeVCの遷移先のVC(ImageSelectVC)の配下を閉じている
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
//MARK: -
    override func viewDidLoad() {
           super.viewDidLoad()

           // Do any additional setup after loading the view.
       }

}
