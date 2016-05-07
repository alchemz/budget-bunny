//
//  AccountScreen.swift
//  BudgetBunny
//
//  Created by Kiefer Yap on 5/7/16.
//  Copyright © 2016 Kiefer Yap. All rights reserved.
//

import XCTest

@available(iOS 9.0, *)
class AddAccountScreen: BaseScreen {
    
    func tapAccountNameTextField() {
        self.app.tables.textFields["My Wallet"].tap()
    }
    
    func tapAmountTextField() {
        self.app.tables.textFields["100"].tap()
    }
    
    func tapIsDefaultSwitch() {
        self.app.tables.cells.switches["Default Account, The default account to use for everyday transactions"].tap()
    }
    
    func tapCurrencyCell() {
        self.app.tables.staticTexts["United States: USD ($)"].tap()
    }
    
    func tapOutside() {
        self.app.childrenMatchingType(.Window).elementBoundByIndex(0).childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Table).element.tap()
    }
    
}
