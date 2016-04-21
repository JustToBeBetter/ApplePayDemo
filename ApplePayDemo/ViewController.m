//
//  ViewController.m
//  ApplePayDemo
//
//  Created by 李金柱 on 16/4/21.
//  Copyright © 2016年 likeme. All rights reserved.
//
#import <PassKit/PassKit.h>

#import "ViewController.h"

@interface ViewController ()<PKPaymentAuthorizationViewControllerDelegate>
{
    NSMutableArray *_summaryItemsArray;
    NSMutableArray *_shippingMethodsArray;
   
}
- (IBAction)applePayEvent:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)applePayEvent:(id)sender {
    
    if([PKPaymentAuthorizationViewController canMakePayments]) {//判断是否支持ApplePay
        
        if ([PKPaymentAuthorizationViewController canMakePaymentsUsingNetworks:@[PKPaymentNetworkChinaUnionPay, PKPaymentNetworkMasterCard, PKPaymentNetworkVisa]] ) {//判断是否已经绑定银行卡(银联卡，万事达卡，visa卡)
            
            NSLog(@"可以使用Applepay");
            
            PKPaymentRequest *request = [[PKPaymentRequest alloc] init];
            
            PKPaymentSummaryItem *goods1 = [PKPaymentSummaryItem summaryItemWithLabel:@"修身小马甲"
                                                                                amount:[NSDecimalNumber decimalNumberWithString:@"698.00"]];
            
            PKPaymentSummaryItem *goods2 = [PKPaymentSummaryItem summaryItemWithLabel:@"无敌风火轮"
                                                                                amount:[NSDecimalNumber decimalNumberWithString:@"998.00"]];
            
            PKPaymentSummaryItem *total = [PKPaymentSummaryItem summaryItemWithLabel:@"杭州像我一样科技有限公司"
                                                                              amount:[NSDecimalNumber decimalNumberWithString:@"0.11"]];
            
            _summaryItemsArray = [NSMutableArray arrayWithArray:@[goods1, goods2, total]];
            
            request.paymentSummaryItems = _summaryItemsArray;
            request.countryCode = @"CN";//中国 国家代码
            request.currencyCode = @"CNY";//货币代码
            request.supportedNetworks = @[PKPaymentNetworkChinaUnionPay, PKPaymentNetworkMasterCard, PKPaymentNetworkVisa];
            request.merchantIdentifier = @"merchant.com.likeme.DesignerLikeMe";
            request.merchantCapabilities =  PKMerchantCapabilityEMV;
            
            
//            
//            request.requiredShippingAddressFields = PKAddressFieldPostalAddress|PKAddressFieldPhone|PKAddressFieldName;
//            //送货地址信息，这里设置需要地址和联系方式和姓名，如果需要进行设置，默认PKAddressFieldNone(没有送货地址)
//            //设置两种配送方式
//            PKShippingMethod *freeShipping = [PKShippingMethod summaryItemWithLabel:@"包邮" amount:[NSDecimalNumber zero]];
//            freeShipping.identifier = @"freeshipping";
//            freeShipping.detail = @"6-8 天 送达";
//            
//            PKShippingMethod *expressShipping = [PKShippingMethod summaryItemWithLabel:@"极速送达" amount:[NSDecimalNumber decimalNumberWithString:@"10.00"]];
//            expressShipping.identifier = @"expressshipping";
//            expressShipping.detail = @"2-3 小时 送达";
//          
//            _shippingMethodsArray = [NSMutableArray arrayWithArray:@[freeShipping, expressShipping]];
//            //shippingMethods为配送方式列表，类型是 NSMutableArray，这里设置成成员变量，在后续的代理回调中可以进行配送方式的调整。
//            request.shippingMethods = _shippingMethodsArray;
//            
//            
            
            
            PKPaymentAuthorizationViewController *paymentPane = [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest:request];
            paymentPane.delegate = self;
            [self presentViewController:paymentPane animated:YES completion:nil];
        }else{//未绑卡 前往wallet绑卡
            
            PKPassLibrary *library = [[PKPassLibrary alloc]init];
            [library openPaymentSetup];
        }
        
        
    } else {
        
        NSLog(@"设备不支持ApplePay");
    }

}



#pragma
#pragma  mark =================paymentAuthorizationViewControllerDelegate=================
//必须实现的两个代理
- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                       didAuthorizePayment:(PKPayment *)payment
                                completion:(void (^)(PKPaymentAuthorizationStatus status))completion{
    NSLog(@"支付已授权: payment%@", payment);
    BOOL asyncSuccessful = NO;
    
//    PKPaymentToken *payToken = payment.token;
//    //支付凭据，发给服务端进行验证支付是否真实有效
//    PKContact *billingContact = payment.billingContact;     //账单信息
//    PKContact *shippingContact = payment.shippingContact;   //送货信息
//  
//    NSLog(@"payToken:%@ billingContact:%@ shippingContact:%@",payToken,billingContact,shippingContact);
    //等待服务器返回结果后再进行系统block调用
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        //模拟服务器通信
//        completion(PKPaymentAuthorizationStatusSuccess);
//    });

  
    //授权状态
    //    PKPaymentAuthorizationStatusSuccess, // Merchant auth'd (or expects to auth) the transaction successfully. //授权成功
    //    PKPaymentAuthorizationStatusFailure, // Merchant failed to auth the transaction.   //授权失败
    //
    //    PKPaymentAuthorizationStatusInvalidBillingPostalAddress,  // Merchant refuses service to this billing address.//无效的账单地址
    //    PKPaymentAuthorizationStatusInvalidShippingPostalAddress, // Merchant refuses service to this shipping address.//无效的邮寄地址
    //    PKPaymentAuthorizationStatusInvalidShippingContact        // Supplied contact information is insufficient.//无效的联系方式 信息不足
    
    if(asyncSuccessful) {
        completion(PKPaymentAuthorizationStatusSuccess);

        NSLog(@"===支付成功===%@",completion);//处理支付成功后的逻辑
        
    } else {
        completion(PKPaymentAuthorizationStatusFailure);

        NSLog(@"===支付失败===:%@",completion);//处理支付失败的逻辑

    }
    

}
-(void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller{
    
    NSLog(@"支付结束");

    // 隐藏支付控制器
    [controller dismissViewControllerAnimated:YES completion:nil];
}
//选择实现的代理方法
- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                   didSelectShippingMethod:(PKShippingMethod *)shippingMethod
                                completion:(void (^)(PKPaymentAuthorizationStatus status, NSArray<PKPaymentSummaryItem *> *summaryItems))completion{
//    //配送方式回调，如果需要根据不同的送货方式进行支付金额的调整，比如包邮和付费加速配送，可以实现该代理
//    PKShippingMethod *oldShippingMethod = [_summaryItemsArray objectAtIndex:2];
//    PKPaymentSummaryItem *total = [_summaryItemsArray lastObject];
//    total.amount = [total.amount decimalNumberBySubtracting:oldShippingMethod.amount];
//    total.amount = [total.amount decimalNumberByAdding:shippingMethod.amount];
//
//    completion(PKPaymentAuthorizationStatusSuccess, _summaryItemsArray);
    
}
- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                  didSelectShippingContact:(PKContact *)contact
                                completion:(void (^)(PKPaymentAuthorizationStatus status, NSArray<PKShippingMethod *> *shippingMethods,
                                                     NSArray<PKPaymentSummaryItem *> *summaryItems))completion{
    //contact送货地址信息，PKContact类型

    
}
- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller didSelectPaymentMethod:(PKPaymentMethod *)paymentMethod completion:(void (^)(NSArray<PKPaymentSummaryItem *> * _Nonnull))completion{
    //支付银行卡回调，如果需要根据不同的银行调整付费金额，可以实现该代理
  
}

@end
