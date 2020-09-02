//
//  ViewController.swift
//  Words
//
//  Created by Cassin on 2020/01/07.
//  Copyright © 2020 Cassin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var txtLines = [String]()
    var txtIndex = Int()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        var txtLines = [String]()
        
        guard let path = Bundle.main.path(forResource:"dataList", ofType:"txt") else {
            print("txtファイルが見つかりません。")
            return
        }
        
        do {
            let csvString = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
            txtLines = csvString.components(separatedBy: .newlines)
            txtLines.removeLast()
             self.txtLines = txtLines
        } catch let error as NSError {
            print("エラー: \(error)")
            return
        }
        
       genUIObjects()
    }
    
    // ボタンが押された時に呼ばれるメソッド
    @objc func buttonEvent(_ sender: UIButton) {
        for v in view.subviews {
            if let v = v as? UIButton {
                // そのオブジェクトを親のviewから取り除く
                v.removeFromSuperview()
            } else if let v = v as? UITextField {
                v.removeFromSuperview()
            }
        }
        
        
        if sender.titleLabel?.text  == self.txtLines[self.txtIndex].components(separatedBy: ":")[1] {
            genUITextField(value: UIColor.blue, text: "◯ ")
        } else {
            genUITextField(value: UIColor.red, text: "✗ ")
        }
        
       genUIObjects()
    }
    
    func genUITextField(value: Any, text: String) {
        let label = UITextField(frame: CGRect(x: 0, y: self.view.frame.height-520, width:view.frame.size.width-20, height: 20))
        let attrText = NSMutableAttributedString(string: text + self.txtLines[self.txtIndex])
        attrText.addAttribute(.foregroundColor, value: value, range: NSMakeRange(0, 1))
        label.attributedText = attrText
                   
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont.systemFont(ofSize: 20)
        self.view.addSubview(label)
    }
    
    func genUIObjects() {
        var qs = self.genQ()
              qs = qs.shuffled()
              self.genButton(index: 0, qs: qs, height: 80)
              self.genButton(index: 1, qs: qs, height: 160)
              self.genButton(index: 2, qs: qs, height: 240)
              self.genButton(index: 3, qs: qs, height: 320)
             
        let label = UITextField(frame: CGRect(x: 0, y:self.view.frame.height-420, width:view.frame.size.width-20, height:40))
        label.text = self.txtLines[self.txtIndex].components(separatedBy: ":")[0]
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont.systemFont(ofSize: 20)
        self.view.addSubview(label)
    }
    
    func genQ() -> [String] {
          self.txtIndex = Int.random(in: 0..<self.txtLines.count)
          let txtLine = self.txtLines[self.txtIndex]
          var qs = [String]()
          qs.append(txtLine)
          for _ in 0..<3 {
              let txtIndex = Int.random(in: 0..<self.txtLines.count)
              qs.append(self.txtLines[txtIndex])
          }
          return qs
    }
      
    func genButton(index: Int, qs: [String], height: CGFloat) {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.addTarget(self, action: #selector(buttonEvent(_:)), for: UIControl.Event.touchUpInside)
        let q = qs[index].components(separatedBy: ":")[1]
        button.setTitle(q, for: UIControl.State.normal)
        button.sizeToFit()
        button.layer.position = CGPoint(x: self.view.frame.width/2, y:self.view.frame.height - height)
        self.view.addSubview(button)
    }
}

