//
//  ViewController.swift
//  TinderApp
//
//  Created by 板垣有祐 on 2019/09/21.
//  Copyright © 2019 Yusuke Itagaki. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var basicCard: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var person1: UIView!
    @IBOutlet weak var person2: UIView!
    @IBOutlet weak var person3: UIView!
    @IBOutlet weak var person4: UIView!
    
    var centerOfCard: CGPoint!
    var people = [UIView]()
    var selectedCardcount: Int = 0
    
    let name = ["ほのか", "あかね", "みほ", "カルロス"]
    var likedName = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 場所の初期値を保存
        centerOfCard = basicCard.center
        
        people.append(person1)
        people.append(person2)
        people.append(person3)
        people.append(person4)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = true
    }

    
    func resetcard() {
        // 初期値に戻す
        basicCard!.center = self.centerOfCard
        // 元の角度に戻す
        basicCard!.transform = .identity
    }
    
    @IBAction func swipeCard(_ sender: UIPanGestureRecognizer) {
        let card = sender.view
        // どれだけスワイプしたかの距離を判定(大元のviewを基準にどの程度動いたか)
        let point = sender.translation(in: view)
        
        // カードがスワイプした分だけ動く
        card!.center = CGPoint(x: card!.center.x + point.x, y: card!.center.y + point.y)
        people[selectedCardcount].center = CGPoint(x: card!.center.x + point.x, y: card!.center.y + point.y)
        
        // viewのセンターとカードのセンターの差をとる
        let xFromCenter = card!.center.x - view.center.x
        // 角度を変える(ラジアン45度：-0.785)
        // xFromCenter / (view.frame.width / 2)は距離の差が0〜1の間で動く
        card?.transform = CGAffineTransform(rotationAngle: xFromCenter / (view.frame.width / 2) * -0.785)
        people[selectedCardcount].transform = CGAffineTransform(rotationAngle: xFromCenter / (view.frame.width / 2) * -0.785)
        // スワイプ方向によって表示する画像を変える
        if xFromCenter > 0 {
            imageView.image = UIImage(named: "good")
            imageView.alpha = 1
            imageView.tintColor = UIColor.red
        } else if xFromCenter < 0 {
            imageView.image = UIImage(named: "bad")
            imageView.alpha = 1
            imageView.tintColor = UIColor.blue
        }
        
        // 小さいスワイプであれば戻る(離した時に初期値に戻る)
        // 指が離れた時の判定(if文)
        if sender.state == UIGestureRecognizer.State.ended {
            
            // 大きくスワイプした場合(カードの中心がx座標 75より低い/左にある)
            if card!.center.x < 75 {
                UIView.animate(withDuration: 0.2, animations: {
                    // x座標を-300の位置に吹っ飛ばす
//                    card!.center = CGPoint(x: card!.center.x - 300, y: card!.center.y)
                    // basicCardは戻す必要がある(飛ばすのはpersonカードのみ)
                    self.resetcard()
                     // personカードの挙動
                    self.people[self.selectedCardcount].center = CGPoint(x: self.people[self.selectedCardcount].center.x - 300, y: self.people[self.selectedCardcount].center.y)
                })
                imageView.alpha = 0
                selectedCardcount += 1
                if selectedCardcount >= people.count {
                    performSegue(withIdentifier: "PushList", sender: nil)
                }
                return
                // 右から75ポイントより大きい場合(右から75ポイントより右にある)
            } else if card!.center.x > self.view.frame.width - 75 {
                UIView.animate(withDuration: 0.2, animations: {
                    // x座標を300の位置に吹っ飛ばす
//                    card!.center = CGPoint(x: card!.center.x + 300, y: card!.center.y)
                    // basicCardは戻す必要がある(飛ばすのはpersonカードのみ)
                    self.resetcard()
                    // personカードの挙動
                    self.people[self.selectedCardcount].center = CGPoint(x: self.people[self.selectedCardcount].center.x + 300, y: self.people[self.selectedCardcount].center.y)
                })
                imageView.alpha = 0
                likedName.append(name[selectedCardcount])
                selectedCardcount += 1
                if selectedCardcount >= people.count {
                    performSegue(withIdentifier: "PushList", sender: nil)
                }
                return
            }
            // アニメーションして元に戻る処理
            UIView.animate(withDuration: 0.2, animations: {
                self.resetcard()
                self.people[self.selectedCardcount].center = self.centerOfCard
                self.people[self.selectedCardcount].transform = .identity
            })
            // imageViewの透明度を0に
             imageView.alpha = 0
        }
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PushList" {
            let listVC = segue.destination as! ListViewController
            listVC.likedName = likedName
        }
    }
    
    
}

