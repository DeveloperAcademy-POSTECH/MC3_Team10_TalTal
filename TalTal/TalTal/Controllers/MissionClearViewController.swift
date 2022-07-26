//
//  MissionClearViewController.swift
//  TalTal
//
//  Created by Toby on 2022/07/25.
//

import UIKit
import SwiftUI

protocol MissionClearViewDelegate {
	func confirmButtonClicked(type: MissionQuest, reflectionText: String?)
}

class MissionClearViewController: UIViewController {

	var delegate: MissionClearViewDelegate?
	//타입설정
	var missionType: MissionQuest = .daily
	var questLabelText = ""
	private var isTextViewSelected: Bool = true

	@IBOutlet var missionTypeLabel: UILabel!
	@IBOutlet var reflectionView: UIView!
	@IBOutlet var reflectionTextView: UITextView!
	@IBOutlet var reflectionTextCountLable: UILabel!
	@IBOutlet weak var cancelButton: UIBarButtonItem!
	@IBOutlet weak var confirmButton: UIBarButtonItem!
	//퀘스트가 연결될 레이블
	@IBOutlet weak var questLabel: UILabel!


	@IBAction func cancelButtonAction(_ sender: Any) {
		//TODO: Close Modal
		self.dismiss(animated: true, completion: nil)
	}

	@IBAction func confirmButtonAction(_ sender: Any) {
		//TODO: Save Reflection & Close Modal
		delegate?.confirmButtonClicked(type: missionType, reflectionText: reflectionTextView.text)
		self.dismiss(animated: true, completion: nil)
	}


	override func viewDidLoad() {
		super.viewDidLoad()
		settingViewDesign()
		reflectionTextView.delegate = self
		reflectionTextView.returnKeyType = .done

		view.backgroundColor = UIColor(red: 248 / 255, green: 248 / 255, blue: 248 / 255, alpha: 1)
		initMissionTypeLabel()
		initReflection()
		questLabel.text = questLabelText
	}

}

//MARK: 주간미션 일간 미션 구분을 위한 셋팅

extension MissionClearViewController {

	//버튼 색상등 설정할 부분
	private func settingViewDesign() {
		let array = returnTextAndColor()
		missionTypeLabel.text = array[0] as? String
		missionTypeLabel.backgroundColor = array[1] as? UIColor
	}

	private func returnTextAndColor() -> Array<Any> {
		switch missionType {
		case.daily:
			return ["일간 미션", UIColor(named: "PointPink")!]
		case.weekly:
			return ["주간 미션", UIColor(named: "PointBlue")!]
		}
	}

	private func initMissionTypeLabel() {
		missionTypeLabel.clipsToBounds = true
		missionTypeLabel.layer.cornerRadius = 13
		view.addSubview(missionTypeLabel)
	}

	private func initReflection() {
		reflectionView.clipsToBounds = true
		reflectionView.backgroundColor = .white
		reflectionView.layer.cornerRadius = 15
		view.addSubview(reflectionView)

		//라인제한
		reflectionTextView.textContainer.maximumNumberOfLines = 5
		reflectionTextView.clipsToBounds = true
		reflectionTextView.backgroundColor = .clear
		reflectionView.addSubview(reflectionTextView)
		reflectionView.addSubview(reflectionTextCountLable)
	}
}

extension MissionClearViewController: UITextViewDelegate {
	func textViewDidChange(_ textView: UITextView) {
		// 50 글자 이상 방지
		if textView.text.count > 50 {
			let start = textView.text.startIndex
			let end = textView.text.index(textView.text.startIndex, offsetBy: 50)
			let range = start..<end
			textView.text = String(textView.text[range])
		}
		reflectionTextCountLable.text = "\(textView.text.count) / 50"
	}


	func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
		if isTextViewSelected {
			textView.text = ""
			textView.textColor = .black
			isTextViewSelected = false
		}
		return true
	}


	func textViewDidEndEditing(_ textView: UITextView) {
		if textView.text.count == 0 {
			isTextViewSelected = true
			textView.text = "50자 이내로 적어주세요."
			textView.textColor = UIColor(red: 199 / 255, green: 199 / 255, blue: 204 / 255, alpha: 1)
		}
	}
}
