//
//  IntentHandler.swift
//  eKarritIntents
//
//  Created by T.Shindou on 2017/04/23.
//  Copyright © 2017年 T.Shindou. All rights reserved.
//

import Intents

// As an example, this class is set up to handle Message intents.
// You will want to replace this or add other intents as appropriate.
// The intents you wish to handle must be declared in the extension's Info.plist.

// You can test your example integration by saying things to Siri like:
// "Send a message using <myApp>"
// "<myApp> John saying hello"
// "Search for messages in <myApp>"

class IntentHandler: INExtension, INPayBillIntentHandling {
    
    override func handler(for intent: INIntent) -> Any {
        // if intent is INPayBillIntent {
        //     // インテントの種類に応じて適切なHandlerを返す
        //     return MyPayBillIntentHandler()
        // }
        
        // 今回は自クラスで処理する
        return self
    }
    
    func resolveTransactionAmount(forPayBill intent: INPayBillIntent, with completion: @escaping (INPaymentAmountResolutionResult) -> Void) {
        // パラメータを検証する

        // パラメータはintentのプロパティに格納されている
        if let transactionAmount = intent.transactionAmount {
            if let currencyCode = transactionAmount.amount?.currencyCode, currencyCode == "JPY" {
                // 日本円ならパラメータとして受け入れる
                
                // 検証結果を表現する型は、パラメータ検証メソッドによって異なる（ここではINPaymentAmountResolutionResult）
                completion(INPaymentAmountResolutionResult.success(with: transactionAmount))
            } else {
                // 日本円以外はサポートしない（「その金額は扱えません」とSiriが応答する）
                completion(INPaymentAmountResolutionResult.unsupported())
            }
        } else {
            completion(INPaymentAmountResolutionResult.needsValue())
        }
    }
    
    // 本来すべてのResolveを実装するのが望ましい
//    func resolveBillPayee(forPayBill intent: INPayBillIntent, with completion: @escaping (INBillPayeeResolutionResult) -> Void) {}
//    func resolveFromAccount(forPayBill intent: INPayBillIntent, with completion: @escaping (INPaymentAccountResolutionResult) -> Void) {}
//    func resolveTransactionScheduledDate(forPayBill intent: INPayBillIntent, with completion: @escaping (INDateComponentsRangeResolutionResult) -> Void) {}
//    func resolveTransactionNote(forPayBill intent: INPayBillIntent, with completion: @escaping (INStringResolutionResult) -> Void) {}
//    func resolveBillType(forPayBill intent: INPayBillIntent, with completion: @escaping (INBillTypeResolutionResult) -> Void) {}
//    func resolveDueDate(forPayBill intent: INPayBillIntent, with completion: @escaping (INDateComponentsRangeResolutionResult) -> Void) {}
    
    func confirm(payBill intent: INPayBillIntent, completion: @escaping (INPayBillIntentResponse) -> Swift.Void) {
        
        // 〜 略（外部サービスも含めて決済の準備が整っているか確認する 〜
        
        // レスポンスを生成
        let response = INPayBillIntentResponse(code: .ready, userActivity: nil)
        // Siriの応答に必要な情報をセット
        response.transactionAmount = intent.transactionAmount
        response.fromAccount = intent.fromAccount
        response.transactionScheduledDate = intent.transactionScheduledDate
        response.transactionNote = intent.transactionNote
        
        completion(response)
    }
    
    func handle(payBill intent: INPayBillIntent, completion: @escaping (INPayBillIntentResponse) -> Void) {
        
        // 〜 略（実際の決済処理） 〜
        
        let response = INPayBillIntentResponse(code: .success, userActivity: nil)
        completion(response)
    }
}

