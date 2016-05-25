//
//  AddAccountUITests.swift
//  BudgetBunny
//
//  Created by Kiefer Yap on 5/7/16.
//  Copyright © 2016 Kiefer Yap. All rights reserved.
//

import XCTest
import CoreData

@available(iOS 9.0, *)
class AddAccountUITests: XCTestCase {
    
    /*
      *  Important note! Hardware > Keyboard > Connect Hardware Keyboard must be unchecked.
    */
    
    var app = XCUIApplication();
    
    override func setUp() {
        super.setUp()
        app.launchEnvironment = ["isTesting": "1"]
        app.launch()
        continueAfterFailure = false
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: ACC-0001 Test Cases
    
    func proceedToAddAccountScreen() {
        self.proceedToAccountTab()
        
        let accountScreen: AccountScreen = AccountScreen.screenFromApp(self.app)
        accountScreen.tapAddAccountButton()
    }
    
    func testCellExistence() {
        self.proceedToAddAccountScreen()
        
        let addAccountScreen: AddAccountScreen = AddAccountScreen.screenFromApp(self.app)
        addAccountScreen.tapAccountNameTextField()
        addAccountScreen.tapAmountTextField()
        addAccountScreen.tapCurrencyCell()
    }
    
    func testAddAccountTextFields() {
        self.proceedToAddAccountScreen()
        
        let accountName: String = "my bank account"
        let initialAmount: String = "450"
        
        let addAccountScreen: AddAccountScreen = AddAccountScreen.screenFromApp(self.app)
        addAccountScreen.tapAccountNameTextField()
        addAccountScreen.typeAccountNameTextField(accountName)
        addAccountScreen.assertTextFieldEquality(accountName)
        
        addAccountScreen.tapOutside()
        addAccountScreen.tapAmountTextField()
        addAccountScreen.typeAmountTextField(initialAmount)
        addAccountScreen.assertTextFieldEquality(initialAmount)
    
    }
    
    func testAddAccountTextFieldLength() {
        self.proceedToAddAccountScreen()
        
        let length30 = "123456789012345678901234567890"
        let length25 = "1234567890123456789012345"
        
        // Assert that the 25-character limit is enforced in the Account Name
        let addAccountScreen: AddAccountScreen = AddAccountScreen.screenFromApp(self.app)
        addAccountScreen.tapAccountNameTextField()
        addAccountScreen.typeAccountNameTextField(length30)
        addAccountScreen.assertTextFieldEquality(length25)
    }
    
    func testAmountTextFieldLength() {
        self.proceedToAddAccountScreen()
        
        let length30 = "123456789012345678901234567890"
        let length15 = "123456789012345"
        
        // Assert that the 22-character limit is enforced in the Account Name
        let addAccountScreen: AddAccountScreen = AddAccountScreen.screenFromApp(self.app)
        addAccountScreen.tapAmountTextField()
        addAccountScreen.typeAmountTextField(length30)
        addAccountScreen.assertTextFieldEquality(length15)
    }
    
    func testMultiDecimal() {
        self.proceedToAddAccountScreen()
        
        let multiDecimal = "1..25"
        let singleDecimal = "1.25"
        
        // Assert that the 22-character limit is enforced in the Account Name
        let addAccountScreen: AddAccountScreen = AddAccountScreen.screenFromApp(self.app)
        addAccountScreen.tapAmountTextField()
        addAccountScreen.typeAmountTextField(multiDecimal)
        addAccountScreen.assertTextFieldEquality(singleDecimal)
    }
    
    func testDecimalFormatting() {
        self.proceedToAddAccountScreen()

        let decimalOnly = ".25"
        let formattedDecimal = "$ 0.25"
        let accountName = "test"
        
        // Assert that the 22-character limit is enforced in the Account Name
        let addAccountScreen: AddAccountScreen = AddAccountScreen.screenFromApp(self.app)
        addAccountScreen.tapAmountTextField()
        addAccountScreen.typeAmountTextField(decimalOnly)
        
        addAccountScreen.tapOutside()
        addAccountScreen.tapAccountNameTextField()
        addAccountScreen.typeAccountNameTextField(accountName)
        addAccountScreen.tapDoneButton()
        
        // Assert that the decimal is saved properly
        let accountScreen: AccountScreen = AccountScreen.screenFromApp(self.app)
        accountScreen.assertCellTextWithIndex(0, textToFind: formattedDecimal)
    }
    
    func testCurrencyCell() {
        self.proceedToAddAccountScreen()
        
        let usdCurrency = "United States: USD ($)"
        let japanCurrency = "Japan: JPY (¥)"
        let japanSearchKey = "Japan"
        
        // Test 01: Tapping the currency cell and returning should not change the current cell
        let addAccountScreen: AddAccountScreen = AddAccountScreen.screenFromApp(self.app)
        addAccountScreen.assertStaticTextEquality(usdCurrency)
        addAccountScreen.tapCurrencyCell()
    
        let currencyPickerScreen: CurrencyPickerScreen = CurrencyPickerScreen.screenFromApp(self.app)
        currencyPickerScreen.tapBackButton()
        addAccountScreen.assertStaticTextEquality(usdCurrency)
        
        // Test 02: Tapping the currency cell and changing the currency should change the cell
        addAccountScreen.tapCurrencyCell()
        currencyPickerScreen.tapElementWithCountryName(japanSearchKey)
        currencyPickerScreen.tapBackButton()
        addAccountScreen.assertStaticTextEquality(japanCurrency)
        
        // TO-DO: I can't get the type-search-bar-tap-first-element to work because it apparently couldn't find the element after searching. I'll look into this in depth next time.
    }
    
    func testErrorScenario01() {
        self.proceedToAddAccountScreen()
        
        // Test 01: Both are empty
        let addAccountScreen: AddAccountScreen = AddAccountScreen.screenFromApp(self.app)
        addAccountScreen.tapDoneButton()
        addAccountScreen.tapErrorAlertOkButton()
        
        // Test 02: Currency is empty
        addAccountScreen.tapAccountNameTextField()
        addAccountScreen.typeAccountNameTextField("test")
        addAccountScreen.tapDoneButton()
        addAccountScreen.tapErrorAlertOkButton()
    }
    
    func testErrorScenario02() {
        self.proceedToAddAccountScreen()
        
        // Test 01: Account name is empty
        let addAccountScreen: AddAccountScreen = AddAccountScreen.screenFromApp(self.app)
        addAccountScreen.tapAmountTextField()
        addAccountScreen.typeAmountTextField("120")
        addAccountScreen.tapDoneButton()
        addAccountScreen.tapErrorAlertOkButton()
    }
    
    func testSuccess() {
        // Successfully add a non-default account
        self.proceedToAddAccountScreen()
        let japanSearchKey = "Japan"
        
        let addAccountScreen: AddAccountScreen = AddAccountScreen.screenFromApp(self.app)
        addAccountScreen.tapAccountNameTextField()
        addAccountScreen.typeAccountNameTextField("test")
        
        addAccountScreen.tapOutside()
        addAccountScreen.tapAmountTextField()
        addAccountScreen.typeAmountTextField("120")
        
        addAccountScreen.tapCurrencyCell()
        let currencyPickerScreen: CurrencyPickerScreen = CurrencyPickerScreen.screenFromApp(self.app)
        currencyPickerScreen.tapElementWithCountryName(japanSearchKey)
        currencyPickerScreen.tapBackButton()
        
        addAccountScreen.tapDoneButton()
        
        // Successfully add a default account
        self.proceedToAddAccountScreen()
        let usSearchKey = "United States"
        
        addAccountScreen.tapAccountNameTextField()
        addAccountScreen.typeAccountNameTextField("test2")
        addAccountScreen.tapCurrencyCell()
        
        currencyPickerScreen.tapElementWithCountryName(usSearchKey)
        currencyPickerScreen.tapBackButton()
        
        addAccountScreen.tapAmountTextField()
        addAccountScreen.typeAmountTextField("65536")
        addAccountScreen.tapIsDefaultSwitch()
        addAccountScreen.tapDoneButton()
        
        // Assert, in the Account List screen, that test2 is marked as default, while test is not
        let accountScreen: AccountScreen = AccountScreen.screenFromApp(self.app)
        accountScreen.assertCellIsNotDefaultAccount(0)
        accountScreen.assertCellIsDefaultAccount(1)
    }
    
    func testSearchBar() {
        self.proceedToAddAccountScreen()
        
        let addAccountScreen: AddAccountScreen = AddAccountScreen.screenFromApp(self.app)
        addAccountScreen.tapCurrencyCell()
        
        let currencyPickerScreen: CurrencyPickerScreen = CurrencyPickerScreen.screenFromApp(self.app)
        currencyPickerScreen.tapElementWithCountryName("Japan")
        currencyPickerScreen.tapSearchBar()
        currencyPickerScreen.typeSearchBar("Test")
        currencyPickerScreen.tapSearchBarClearText()
        currencyPickerScreen.tapSearchBar()
        currencyPickerScreen.tapSearchBarCancel()
        currencyPickerScreen.tapBackButton()
    }

    // MARK: ACC-0002 Test Cases
    
    func proceedToAccountTab() {
        // Delete accounts core data
        ScreenManager.tapAccountsTab(self.app)
        
    }
    
    func testAddAccount() {
        self.proceedToAccountTab()
    }
    
    func testDeleteAccount() {
        self.proceedToAccountTab()
    }
    
    //TO-DO: Implement uniqueness of account name and isDefault
    
}
