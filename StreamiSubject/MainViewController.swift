//
//  MainViewController.swift
//  StreamiSubject
//
//  Created by 이철우 on 2020/04/30.
//  Copyright © 2020 LeeCheolWoo. All rights reserved.
//

import UIKit
import RxSwift
import SnapKit

class MainViewController: BaseViewController {
    
    /// 메인 뷰 화면 표시
    @IBOutlet weak var viewMain: UIView!
    
    /// ViewModel
    var viewModel: MainViewModel = MainViewModel()
    
    /// 현재 표시하고 있는뷰
    weak var curViewController: BaseViewController? = nil {
        didSet (oldValue) {
            if oldValue != nil {
                oldValue?.view.removeFromSuperview()
            }
        }
    }
    
    /**
     * Singleton MainViewController
     */
    static let sharedInstance: MainViewController = {
        var instance = MainViewController.init(nibName: "MainViewController", bundle: nil)
        return instance
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        /// 마스터 옵저버 등록
        coinMasterObservable()
    }
    
    /// 메인 뷰 옵저버 등록 및 표시 뷰 요청
    private func mainScreen() {
        mainScreenObservable()
        viewModel.mainScreen()
    }
    
    private func coinMasterComplete() {
        mainScreen()
    }
    
}

// MARK: - Observable
extension MainViewController {
    
    /// 코인 마스터 옵저버
    func coinMasterObservable() {
        CoinMaster.sharedInstance
            .coinMasterObservable
            .subscribe({ [weak self] event in
                switch event {
                    
                case .completed:
                    /// 코인마스터 요청이 완료되면 화면을 표시한다.
                    self?.coinMasterComplete()
                    
                default :
                    break
                }
            }).disposed(by: disposeBag)
    }
    
    /// 메인 뷰 옵저버
    func mainScreenObservable() {
        viewModel
            .screenObservable
            .subscribe(onNext: { [weak self] viewController in
                
                guard let view = viewController.view else {
                    return
                }
                self?.curViewController = viewController
                self?.addChild(viewController)
                self?.viewMain.addSubview(view)
                
                view.snp.makeConstraints { make in
                    make.leading.equalTo(0)
                    make.trailing.equalTo(0)
                    make.top.equalTo(0)
                    make.bottom.equalTo(0)
                }
                
            }).disposed(by: disposeBag)
    }
}
