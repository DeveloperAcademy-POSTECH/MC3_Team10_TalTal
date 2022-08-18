//
//  EndingViewController.swift
//  TalTal
//
//  Created by Ruyha on 2022/08/12.
//

import UIKit

class EndingViewController: UIViewController {
    let missionAessts = MissionAssets()
    // MissionAessts()를 사용하기위해 선언

    @IBOutlet weak var endingSubTitle: UILabel!
    @IBOutlet weak var endingComment: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    
    //TODO: closeButton을 누르면 MissionView로 가야함.
    @IBAction func closeButton(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingEndingSubTitleTextLabel()
    }
    
}


//MARK: MissionAessts를 가지고 일일미션과 주간미션의 색상를 변경합니다.
//TODO: 코어데이터에서 미션 클리어 갯수를 가지고 와야함.
extension EndingViewController {
    private func settingEndingSubTitleTextLabel() {
        let endingSubTitleText1 = "일일 미션 00개 "
        let endingSubTitleText2 = " 주간 미션 00개"

        let endingSubTitleTextLabelString = missionAessts.changeTextColor(fullText: endingSubTitleText1, color: UIColor(hex: "FF8166"), changeWords: ["일일 미션 00개"])

        let endingSubTitleTextLabelStringPart2 = missionAessts.changeTextColor(fullText: endingSubTitleText2, color: UIColor(hex: "6261F8"), changeWords: ["주간 미션 00개"])

        endingSubTitleTextLabelString.append(endingSubTitleTextLabelStringPart2)
        endingSubTitle.attributedText = endingSubTitleTextLabelString
    }
}



/*
 이 View의 작업사항은 다음과 같습니다.
 1. 타이틀을 추가해주세요. X버튼의 위치도 수정해야 합니다.
 2. 앱을 끝까지 사용한 사용자들에게 해주고 싶은 말을 추가해주세요.
 3. 2번이 너무 내용이 많아서 짤린다면 스크롤뷰를 이용해보세요.
 4. 언제든지 하다가 막히면 질문하세요.
 
 */
