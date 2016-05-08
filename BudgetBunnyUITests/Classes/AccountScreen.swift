//
//  AccountScreen.swift
//  BudgetBunny
//
//  Created by Kiefer Yap on 5/7/16.
//  Copyright © 2016 Kiefer Yap. All rights reserved.
//

import XCTest

@available(iOS 9.0, *)
class AccountScreen: BaseScreen {
        
    func tapAddAccountButton() {
        self.app.navigationBars["Account"].buttons["+"].tap()
    }

}