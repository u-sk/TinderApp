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
    
    var centerOfCard: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 場所の初期値を保存
        centerOfCard = basicCard.center
    }

    
    @IBAction func swipeCard(_ sender: UIPanGestureRecognizer) {
        let card = sender.view
        // どれだけスワイプしたかの距離を判定(大元のviewを基準にどの程度動いたか)
        let point = sender.translation(in: view)
        
        // カードがスワイプした分だけ動く
        card!.center = CGPoint(x: card!.center.x + point.x, y: card!.center.y + point.y)
        // viewのセンターとカードのセンターの差をとる
        let xFromCenter = card!.center.x - view.center.x
        // 角度を変える(ラジアン45度：-0.785)
        // xFromCenter / (view.frame.width / 2)は距離の差が0〜1の間で動く
        card?.transform = CGAffineTransform(rotationAngle: xFromCenter / (view.frame.width / 2) * -0.785)
        
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
            if card!.center.x < 50 {
                UIView.animate(withDuration: 0.2, animations: {
                    // x座標を-300の位置に吹っ飛ばす
                    card!.center = CGPoint(x: card!.center.x - 300, y: card!.center.y)
                })
                return
                // 右から75ポイントより大きい場合(右から75ポイントより右にある)
            } else if card!.center.x > self.view.frame.width - 50 {
                UIView.animate(withDuration: 0.2, animations: {
                    // x座標を300の位置に吹っ飛ばす
                    card!.center = CGPoint(x: card!.center.x + 300, y: card!.center.y)
                })
                return
            }
            // アニメーションして元に戻る処理
            UIView.animate(withDuration: 0.2, animations: {
                // 初期値に戻す
                card!.center = self.centerOfCard
                // 元の角度に戻す
                card!.transform = .identity
            })
            // imageViewの透明度を0に
             imageView.alpha = 0
        }
        
        
    }
    

}

