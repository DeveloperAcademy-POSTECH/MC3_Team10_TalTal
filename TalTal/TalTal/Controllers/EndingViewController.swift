//
//  EndingViewController.swift
//  TalTal
//
//  Created by Ruyha on 2022/08/12.
//

import UIKit

class EndingViewController: UIViewController {

    @IBAction func closeButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}

/*
 이 View의 작업사항은 다음과 같습니다.
 1. 타이틀을 추가해주세요. X버튼의 위치도 수정해야 합니다.
 2. 앱을 끝까지 사용한 사용자들에게 해주고 싶은 말을 추가해주세요.
 3. 2번이 너무 내용이 많아서 짤린다면 스크롤뷰를 이용해보세요.
 4. 언제든지 하다가 막히면 질문하세요.
 
 */
