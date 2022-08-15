//
//  MissionViewController.swift
//  TalTal
//
//  Created by Ruyha on 2022/07/25.
//

import UIKit
@IBDesignable
final class MissionViewController: UIViewController {
    let missionAessts = MissionAssets()
    // MissionAessts()를 사용하기위해 선언
    
    //스토리보드에 있는 객체들을 연결
    @IBOutlet weak var dailyView: MissionQuestView!
    @IBOutlet weak var weeklyView: MissionQuestView!
    @IBOutlet weak var questTextLabel: UILabel!
    @IBOutlet weak var endingViewPushButton: UIButton!
    @IBOutlet weak var missionTabBarItem: UITabBarItem!
    
    //endingViewPushButton이 클릭되었을때
    @IBAction func endingViewPushButton(_ sender: Any) {
        //코드로 뷰를 Show하는 부분 입니다.
        let storyboard = UIStoryboard(name: "Ending", bundle: nil)
        let secondVC = storyboard.instantiateViewController(identifier: "Ending") as! EndingViewController
        secondVC.modalPresentationStyle = .fullScreen
        show(secondVC, sender: self)
    }
 
    private var dailyMission: Mission? = nil
    private var weeklyMission: Mission? = nil
    
    
    /*
     유저디폴트에서 주간 미션과 일간 미션을 받아오게 만들어서 아래의 변수에 넣거나
     함수에 값을가져오게 만들어주세요.
     */
    var dailyBtnValue = UserDefaults.standard.bool(forKey: "isDailyMissionClear")
    var weeklyBtnValue = UserDefaults.standard.bool(forKey: "isWeeklyMissionClear")
    
    // 한눈에 봐도 에러가 보이는 화면으로 변경
    var dailyClearQuest = 404
    var dailyQuestStirng = "안녕하세요. 탈탈입니다."
    
    var weeklyClearQuest = 404
    var weeklyQuestStirng = "앱을 재설치 해주세요."
    
    // 하단주석3 참고
    override func awakeFromNib() {
        super.awakeFromNib()
        missionTabBarItem.title = "TabBarItemMinsson".localized
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMission()
        questTextLabel.textColor = UIColor(hex: "8A8A8E")
        settingQuestView()
        settingTextLabel()
        isMissonClear(daily: dailyBtnValue, weekly: weeklyBtnValue)
        settingEndingButton()
        endingButtonViewingCheck()
    }
    
}

//MARK: MissionQuestVeiw의 questButton이 클릭 되었때 동작하는 것
//델리게이트 패턴을 사용해 데일리인지 위클리 인지 확인한다.
extension MissionViewController: MissionQuestViewDelegate {
    func didQuestButton(type: MissionQuest) {
        //코드로 뷰를 Show하는 부분 입니다.
        let storyboard = UIStoryboard(name: "MissionClear", bundle: nil)
        let secondVC = storyboard.instantiateViewController(identifier: "MissionClear") as! MissionClearViewController
        secondVC.missionType = type
        secondVC.delegate = self
        secondVC.questLabelText = setQuestTextReturn(type: type)
        show(secondVC, sender: self)
    }
    
    func setQuestTextReturn(type: MissionQuest) -> String {
        switch type {
        case.daily:
            return dailyQuestStirng
        case.weekly:
            return weeklyQuestStirng
        }
    }
}

//MARK: 미션 클리어 뷰가 닫힐떄 미션뷰가 소환한 미션퀘스트뷰에 접근해 버튼을 비활성화 시킨다.
extension MissionViewController: MissionClearViewDelegate {
    func confirmButtonClicked(type: MissionQuest, reflectionText: String?) {
        // MissionClearView에서 Done 클릭시 Core Data에 저장하는 로직
        MissionDataManager.shared.saveMission(mission: type == .daily ? self.dailyMission! : self.weeklyMission!, reflection: reflectionText, type: type)
        switch type {
            // 주간/일간 값에 따라서 Clear Count 증가
        case .daily:
            UserDefaults.standard.set(UserDefaults.standard.integer(forKey: "clearDailyMissionCount") + 1, forKey: "clearDailyMissionCount")
            UserDefaults.standard.set(true, forKey: "isDailyMissionClear")
        case .weekly:
            UserDefaults.standard.set(UserDefaults.standard.integer(forKey: "clearWeeklyMissionCount") + 1, forKey: "clearWeeklyMissionCount")
            UserDefaults.standard.set(true, forKey: "isWeeklyMissionClear")
        }
        // 저장된 값을 다시 보여주기 위해서 뷰 리로드
        self.viewDidLoad()
        
        //TODO: 싱글톤 내에서 데이터 동기화 처리해야 함
        questButtonIsUnabled(type: type)
    }
    
    
    //굳이 confirmButtonClicked안에 안넣은 이유는
    //뷰가 로드 될때도 사용해야되기 때문
    //버튼 사용불가 만들기
    func questButtonIsUnabled(type: MissionQuest) {
        switch type {
        case.daily:
            dailyView.questButtonClose()
            dailyView.questButton.setTitle("오늘도 해냈어요!!", for: .normal)
        case.weekly:
            weeklyView.questButtonClose()
            weeklyView.questButton.setTitle("이번주도 해냈어요!!", for: .normal)
        }
    }
    
    //버튼 사용 가능 만들기
    //그냥 뷰를 리로드 시키면 될지도..?
    func questButtonIsEnabled(type: MissionQuest) {
        switch type {
        case.daily:
            dailyView.questButtonOpen(type: .daily)
        case.weekly:
            weeklyView.questButtonOpen(type: .weekly)
        }
    }
    
    
    //뷰디드 로드에 넣음
    //이 함수가 실행되면 dailyBtnValue, weeklyBtnValue에 따라서 해당 버튼이 활성화 비활성화됨
    func isMissonClear(daily: Bool, weekly: Bool) {
        if daily {
            questButtonIsUnabled(type: .daily)
        }
        if weekly {
            questButtonIsUnabled(type: .weekly)
        }
    }
}

//MARK: view의 생명주기 함수에 들어가는 부분들을 함수화 및 extension으로 빼서 사용하면 깔끔해집니다.
extension MissionViewController {
    //하단 주석1 참고
    private func settingTextLabel() {
        let questText1 = "지금까지\n\(dailyClearQuest)개의 일일 미션과\n"
        let questText2 = "\(weeklyClearQuest)개의 주간 미션을 완료했어요!"
        
        let questTextLabelString = missionAessts.changeTextColor(fullText: questText1, color: UIColor(hex: "FF8166"), changeWords: ["\(dailyClearQuest)", "일일 미션"])
        
        let questTextLabelStringPart2 = missionAessts.changeTextColor(fullText: questText2, color: UIColor(hex: "6261F8"), changeWords: ["\(weeklyClearQuest)", "주간 미션"])
        
        questTextLabelString.append(questTextLabelStringPart2)
        questTextLabel.attributedText = questTextLabelString
    }
    
    //하단 주석2 참고
    private func settingQuestView() {
        self.dailyView.configureView(type: .daily, quest: dailyQuestStirng)
        self.weeklyView.configureView(type: .weekly, quest: weeklyQuestStirng)
        dailyView.delegate = self
        weeklyView.delegate = self
        dailyView.layer.cornerRadius = missionAessts.viewCornerRadius
        weeklyView.layer.cornerRadius = missionAessts.viewCornerRadius
    }
    
    //엔딩버튼의 디자인관련된 함수입니다.
    func settingEndingButton(){
        endingViewPushButton.imageView?.contentMode = .scaleAspectFit
        endingViewPushButton.setImage(UIImage(named: "launchScreenimage"), for: .normal)
        endingViewPushButton.imageEdgeInsets = UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)
    }
    
    //모든 미션이 클리어된 상태에서만 엔딩뷰 버튼이 보여야 한다.
    func endingButtonViewingCheck(){
        //UserDefaults의 값이 nil이면모든 해당 미션이클리어된 상태입니다.
        //때문에 주간 일간 미션의 UserDefaults의 값이 둘 다 nil이라면 모든 미션이 클리어된 상태입니다.
        //사실 상수에 할당 안해도 되지만 조건문에서 조건이 너무 길어져 할당했습니다.
        let dailyQuestValue = UserDefaults.standard.string(forKey: "currentDailyMission")
        let weeklyQuestValue = UserDefaults.standard.string(forKey: "currentWeeklyMission")
        
        if dailyQuestValue == nil && weeklyQuestValue == nil{
            //버튼을 숨김처리하는 코드
            endingViewPushButton.isHidden = false
            return
        }
        
        //MARK: 개발단계에서는 버튼이 보여야 동작에 관한 테스트가 가능해서 하단 코드를 주석 처리 했습니다.
        //미션을 모두 클리어한 상태가 아니면 버튼을 숨김처리
//        endingViewPushButton.isHidden = true
    }
    
}

// TODO: 만약 일일 미션은 모두 소진됐는데 주간 미션은 아직 남아 있는 경우 뷰 처리도 필요할 것 같아요
// MARK: 유저디폴트 관련 메소드 모음입니다
extension MissionViewController {
    
    // 앱을 처음으로 켰을 때 유저의 기본 값을 세팅하는 메소드
    private func userInitialSetting() {
        // UserDefaults의 기본 세팅을 합니다
        // 기존의 코드에서 랜덤을 한번만 불러오는것으로 수정했습니다.
        let setRandomDailyMisson = MissionDataManager.shared.requestDailyMission(stage: .beginner)
        let setRandomWeeklyMisson = MissionDataManager.shared.requestWeeklyMission(stage: .beginner)
        
        UserDefaults.standard.set(Date.now.addingTimeInterval(3600 * 24), forKey: "refreshDailyMissionDate")
        UserDefaults.standard.set(Date.now.addingTimeInterval(getTimeIntervalForNextMonday(Date.now)), forKey: "refreshWeeklyMissionDate")
        UserDefaults.standard.set(MissionStage.beginner.rawValue, forKey: "dailyUserStage")
        UserDefaults.standard.set(MissionStage.beginner.rawValue, forKey: "weeklyUserStage")
        UserDefaults.standard.set(setRandomDailyMisson!.content, forKey: "currentDailyMission")
        UserDefaults.standard.set(setRandomWeeklyMisson!.content, forKey: "currentWeeklyMission")
        UserDefaults.standard.set(setRandomDailyMisson!.intention, forKey: "currentDailyMissoinIntention")
        UserDefaults.standard.set(setRandomWeeklyMisson!.intention, forKey: "currentWeeklyMissoinIntention")
        UserDefaults.standard.set(0, forKey: "clearDailyMissionCount")
        UserDefaults.standard.set(0, forKey: "clearWeeklyMissionCount")
        UserDefaults.standard.set(false, forKey: "isDailyMissionClear")
        UserDefaults.standard.set(false, forKey: "isWeeklyMissionClear")
        
        // 현재 보여줄 미션을 가져옵니다
        self.dailyMission = setRandomDailyMisson
        self.weeklyMission = setRandomWeeklyMisson
        
        // 현재 UI의 내용을 담고있는 변수들에 값을 넣습니다
        dailyClearQuest = UserDefaults.standard.integer(forKey: "clearDailyMissionCount")
        dailyQuestStirng = UserDefaults.standard.string(forKey: "currentDailyMission")!
        weeklyClearQuest = UserDefaults.standard.integer(forKey: "clearWeeklyMissionCount")
        weeklyQuestStirng = UserDefaults.standard.string(forKey: "currentWeeklyMission")!
        dailyBtnValue = UserDefaults.standard.bool(forKey: "isDailyMissionClear")
        weeklyBtnValue = UserDefaults.standard.bool(forKey: "isWeeklyMissionClear")
    }
    
    private func configureMission() {
        // 앱 첫 실행 검사
        guard let _ = UserDefaults.standard.object(forKey: "refreshDailyMissionDate") else {
            userInitialSetting()
            return
        }
        
        // TODO: 현재 작동에는 문제가 없지만 더 좋은 코드로 리팩토링 할 수 있을 것 같습니다. 추후에 변경하겠습니다.
        guard let currentDailyUserStage = MissionStage(rawValue: UserDefaults.standard.string(forKey: "dailyUserStage") ?? "") else { return }
        guard let currentWeeklyUserStage = MissionStage(rawValue: UserDefaults.standard.string(forKey: "weeklyUserStage") ?? "") else { return }
        
        // 앱에 접속한 날짜와 refresh가 되어야 할 날짜를 비교하기 위해 DateFormatter을 사용했습니다
        let now = Date.now
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY.MM.dd."
        
        // 현재 UI에 표시할 프로퍼티 값을 유저디폴트에서 불러옵니다
        // 유저디폴트가 nil이면 모든 미션을 클리어 한 상태입니다
        if UserDefaults.standard.string(forKey: "currentDailyMission") != nil {
            self.dailyMission = Mission(content: UserDefaults.standard.string(forKey: "currentDailyMission")!, stage: currentDailyUserStage, intention: UserDefaults.standard.string(forKey: "currentDailyMissoinIntention")!)
        }
        if UserDefaults.standard.string(forKey: "currentWeeklyMission") != nil {
            self.weeklyMission = Mission(content: UserDefaults.standard.string(forKey: "currentWeeklyMission")!, stage: currentDailyUserStage, intention: UserDefaults.standard.string(forKey: "currentWeeklyMissoinIntention")!)
        }
        
        // 날짜 변경을 감지하여 필요하면 일일 미션을 바꿉니다
        if dateFormatter.string(from: now) >= dateFormatter.string(from: UserDefaults.standard.object(forKey: "refreshDailyMissionDate") as? Date ?? now) {
            self.dailyMission = MissionDataManager.shared.requestDailyMission(stage: currentDailyUserStage)
            
            if dailyMission != nil {
                UserDefaults.standard.set(now.addingTimeInterval(3600 * 24), forKey: "refreshDailyMissionDate")
                UserDefaults.standard.set(dailyMission!.content, forKey: "currentDailyMission")
                UserDefaults.standard.set(dailyMission!.intention, forKey: "currentDailyMissoinIntention")
                UserDefaults.standard.set(false, forKey: "isDailyMissionClear")
            } else { // 모든 일일 미션 클리어
                UserDefaults.standard.set(nil, forKey: "currentDailyMission")
                UserDefaults.standard.set(true, forKey: "isDailyMissionClear")
            }
            
            // 모든 주간미션을 클리어하고 다음날 모든 미션을 클리어했다고 나타내기 위해 임시로 넣은 코드입니다. 추후에 변경하겠습니다
            if MissionDataManager.shared.requestWeeklyMission(stage: currentWeeklyUserStage) == nil {
                UserDefaults.standard.set(nil, forKey: "currentWeeklyMission")
                UserDefaults.standard.set(true, forKey: "isWeeklyMissionClear")
            }
        }
        
        // 날짜 변경을 감지하여 필요하면 주간 미션을 바꿉니다
        if dateFormatter.string(from: now) >= dateFormatter.string(from: UserDefaults.standard.object(forKey: "refreshWeeklyMissionDate") as? Date ?? now) {
            self.weeklyMission = MissionDataManager.shared.requestWeeklyMission(stage: currentWeeklyUserStage)
            
            if weeklyMission != nil {
                UserDefaults.standard.set(now.addingTimeInterval(getTimeIntervalForNextMonday(now)), forKey: "refreshWeeklyMissionDate")
                UserDefaults.standard.set(weeklyMission!.content, forKey: "currentWeeklyMission")
                UserDefaults.standard.set(weeklyMission!.intention, forKey: "currentWeeklyMissoinIntention")
                UserDefaults.standard.set(false, forKey: "isWeeklyMissionClear")
            } else {
                UserDefaults.standard.set(nil, forKey: "currentWeeklyMission")
                UserDefaults.standard.set(true, forKey: "isWeeklyMissionClear")
            }
        }
        
        // MARK: 클리어 한 미션 수와 미션에 실제 데이터(유저디폴트 값)를 넣습니다
        dailyClearQuest = UserDefaults.standard.integer(forKey: "clearDailyMissionCount")
        dailyQuestStirng = UserDefaults.standard.string(forKey: "currentDailyMission") ?? "모든 미션을 클리어 하셨습니다"
        weeklyClearQuest = UserDefaults.standard.integer(forKey: "clearWeeklyMissionCount")
        weeklyQuestStirng = UserDefaults.standard.string(forKey: "currentWeeklyMission") ?? "모든 미션을 클리어 하셨습니다"
        dailyBtnValue = UserDefaults.standard.bool(forKey: "isDailyMissionClear")
        weeklyBtnValue = UserDefaults.standard.bool(forKey: "isWeeklyMissionClear")
        
        // userStage 업데이트
        if (dailyMission != nil) && (currentDailyUserStage != dailyMission!.stage) {
            UserDefaults.standard.set(dailyMission!.stage.rawValue, forKey: "dailyUserStage")
        }
        if (weeklyMission != nil) && (currentWeeklyUserStage != weeklyMission!.stage) {
            UserDefaults.standard.set(weeklyMission!.stage.rawValue, forKey: "weeklyUserStage")
        }
    }
    
    // 특정 요일에서 다음주 월요일까지 필요한 Time Interval 값을 구하는 메소드
    private func getTimeIntervalForNextMonday(_ date: Date) -> Double {
        let dayString = getCurrentDayString(date)
        
        switch dayString {
        case "월요일":
            return 3600 * 24 * 7
        case "화요일":
            return 3600 * 24 * 6
        case "수요일":
            return 3600 * 24 * 5
        case "목요일":
            return 3600 * 24 * 4
        case "금요일":
            return 3600 * 24 * 3
        case "토요일":
            return 3600 * 24 * 2
        case "일요일":
            return 3600 * 24 * 1
        default:
            return 0
        }
        
    }
    
    // 특정 날짜의 요일을 구하는 메소드
    private func getCurrentDayString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        formatter.locale = Locale(identifier: "ko_KR")
        let dayString = formatter.string(from: date)
        return dayString
    }
}



/*
 하단주석 1
 changeTextColor함수의 한계점을 해결하기위해 두가지 파트로 나눠서 작성하였습니다.
 for문을 사용하면 조금더 짧게 제작 할 수 있지만 굳이 두번밖에 반복이 안되기에 이렇게 사용했으며
 추후 여러군데서 사용하게 된다면 Assets로 제작 하겠습니다.
 코드를 간단히 설명하면
 하단주석 2 questText1과 questText2의 문자열의 특정 부분을 원하는 색상으로 변경후
 questText1에 questText2를 추가해서 해당 label에 추가 하는 코드입니다.
 
 하단 주석2
 dailyView와 weekilyView는 제작한 xib파일입니다. (같은 파일)
 해당 view를 사용하기위해서 설정 하는 함수를 불러와 사용했으며
 view의 cornerRadius를 추가하기위해 값을 주었습니다.
 
 하단 주석3
 missionTabBarItem.title = "TabBarItemMinsson".localized
 이 코드는 단순합니다.
 하지만 왜 뷰 라이프 사이클에 넣지 않았을까요?
 탭바의 아이템은 각각의 뷰컨트롤러에서 설정이 가능하고
 뷰 라이프 사이클은 뷰의 생명주기에 따라 실행됩니다.
 즉, 0번째 탭바 이후 (혹은 가장 먼저실행되는 뷰)말고는
 뷰가 실행되기 전까지 탭바 아이템을 설정할 수 없습니다.
 그래서 생명주기에 설정을 하면
 해당 탭바가 실행되기 전까지는 탭바아이템의 텍스트나 이미지가 누락되는 가슴 아픈 일이 생겨서
 override func awakeFromNib() {
 }
 안에 코드를 작성한것입니다.
 
 */

