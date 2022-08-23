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

    @IBOutlet weak var subTitleLabel: UILabel!
    
    @IBAction func closeButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingEndingSubTitleTextLabel()
//        clearMissionSetting()
    }

}

//MARK: MissionAessts를 가지고 일일미션과 주간미션의 색상를 변경합니다.
extension EndingViewController {
    private func settingEndingSubTitleTextLabel() {
        
        let dailyClearQuest = UserDefaults.standard.integer(forKey: "clearDailyMissionCount")
        let weeklyClearQuest = UserDefaults.standard.integer(forKey: "clearWeeklyMissionCount")
        
        let endingSubTitleText1 = "일일 미션 \(dailyClearQuest)개 "
        let endingSubTitleText2 = " 주간 미션 \(weeklyClearQuest)개"

        let endingSubTitleTextLabelString = missionAessts.changeTextColor(fullText: endingSubTitleText1, color: UIColor(hex: "FF8166"), changeWords: ["일일 미션 \(dailyClearQuest)개"])

        let endingSubTitleTextLabelStringPart2 = missionAessts.changeTextColor(fullText: endingSubTitleText2, color: UIColor(hex: "6261F8"), changeWords: ["주간 미션 \(weeklyClearQuest)개"])

        endingSubTitleTextLabelString.append(endingSubTitleTextLabelStringPart2)
        subTitleLabel.attributedText = endingSubTitleTextLabelString
    }
}

