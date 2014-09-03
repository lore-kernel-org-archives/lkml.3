Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580AbaICGjI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 02:39:08 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:27790 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248AbaICGjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 02:39:05 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee690-f79ce6d00000115a-ed-5406b787f383
Content-transfer-encoding: 8BIT
Message-id: <5406B786.3020301@samsung.com>
Date: Wed, 03 Sep 2014 15:39:02 +0900
From: jonghwa3.lee@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120411
 Thunderbird/11.0.1
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, myungjoo.ham@samsung.com,
        r.baldyga@samsung.com
Subject: Re: [PATCH] extcon: max77693: Fix a bug occured at changing ADC
 debounce time.
References: <1409723407-21221-1-git-send-email-jonghwa3.lee@samsung.com>
 <5406AD6C.3090306@samsung.com>
In-reply-to: <5406AD6C.3090306@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmkeLIzCtJLcpLzFFi42JZI2JSotu+nS3EYHm/oMX1L89ZLS7vmsNm
	cbtxBZvFg8M72R1YPPq2rGL0+LxJLoApissmJTUnsyy1SN8ugStj3qNvrAWfhCpm/LzN1MA4
	jb+LkZNDQsBEYsuDD+wQtpjEhXvr2boYuTiEBJYySlxYc4q5i5EDrOj9jnSI+CJGicsLl7CB
	NPAKCEr8mHyPBaSGWUBe4silbJAws4C6xKR5i5gh6l8zSrQt7WGCqNeSmHtrPQuIzSKgKnF+
	0URmEJtNQE7ibdM3RhBbVCBM4uqE42A1IgIaEjP/XmGEGBosMWlPB1i9sECkxM1nm8HiQgKZ
	Eh8+TwC7h1NAW2LBjB6wByQElrFLnHz5ixVimYDEt8mHWCCekZXYdIAZ4mFJiYMrbrBMYBSb
	heSdWQjvzELyzgJG5lWMoqkFyQXFSelFJnrFibnFpXnpesn5uZsYgXFz+t+zCTsY7x2wPsQo
	wMGoxMO7IIAtRIg1say4MvcQoynQEROZpUST84HRmVcSb2hsZmRhamJqbGRuaaYkzvta6mew
	kEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBkb3Pfvftb/uW1c/Ra/v5XL2LdG3T5c9Ot6850bC
	4ae3bZhETos2usbtKJE8ohj9xOkwY1lM9dIfjz/sfKNyecsO/wtthhILeA9bfs+TS/xybXWW
	yr6aWb65mvt7hG94rlr3WGyuG2OtdNhPe6mfQi+nFN9YdK2Ze6e54cK/alLLRDh4Wy6cfnNH
	iaU4I9FQi7moOBEAjrCpB5YCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLIsWRmVeSWpSXmKPExsVy+t9jAd327WwhBts/c1pc//Kc1eLyrjls
	FrcbV7BZPDi8k92BxaNvyypGj8+b5AKYohoYbTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwM
	dQ0tLcyVFPISc1NtlVx8AnTdMnOANikplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0Jgusx
	MkADCWsYM+Y9+sZa8EmoYsbP20wNjNP4uxg5OCQETCTe70jvYuQEMsUkLtxbz9bFyMUhJLCI
	UeLywiVsIAleAUGJH5PvsYDUMwvISxy5lA0SZhZQl5g0bxEzRP1rRom2pT1MEPVaEnNvrWcB
	sVkEVCXOL5rIDGKzCchJvG36xghiiwqESVydcBysRkRAQ2Lm3yuMEEODJSbt6QCrFxaIlLj5
	bDNYXEggU+LD5wlg93AKaEssmNHDNoFRYBaS82YhnDcLyXkLGJlXMYqmFiQXFCel5xrpFSfm
	Fpfmpesl5+duYgRH5TPpHYyrGiwOMQpwMCrx8C4IYAsRYk0sK67MPcQowcGsJMLrmwgU4k1J
	rKxKLcqPLyrNSS0+xGgK9NxEZinR5HxgwsgriTc0NjEzsjQyN7QwMjZXEuc92GodKCSQnliS
	mp2aWpBaBNPHxMEp1cConnnePWWflJrV7Be/22303igmz0+p8ivs3nD0dvuFq+Xm5/6mMD5Y
	ZNXn4ds5bWdEk+TWb8xmN8yzchw/T3xToSqm+anuyXHfnMTbjG+22E965n/xicLDpgb9voV9
	l7a9k+DsWKfvd8iXb9qy5O+ffAMu/2XctiLw+1sZR7/F9sHsRxpcm5cqsRRnJBpqMRcVJwIA
	AlzqVuACAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014년 09월 03일 14:55, Chanwoo Choi wrote:

> On 09/03/2014 02:50 PM, Jonghwa Lee wrote:
>> When it writes some value other than 0 to BTLDset and JIGset, muic device
>> will be reset automatically. And it happens during updating ADC debounce time,
>> because it shares same register. To update ADC debounce time without reset,
>> set value only to ADCDbset and 0 to BTLDset and JIGset.
>>
>> Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
>> ---
>>  drivers/extcon/extcon-max77693.c |   11 ++++++++---
>>  1 file changed, 8 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/extcon/extcon-max77693.c b/drivers/extcon/extcon-max77693.c
>> index 77460f2..661a3bb 100644
>> --- a/drivers/extcon/extcon-max77693.c
>> +++ b/drivers/extcon/extcon-max77693.c
>> @@ -255,10 +255,15 @@ static int max77693_muic_set_debounce_time(struct max77693_muic_info *info,
>>  	case ADC_DEBOUNCE_TIME_10MS:
>>  	case ADC_DEBOUNCE_TIME_25MS:
>>  	case ADC_DEBOUNCE_TIME_38_62MS:
>> -		ret = regmap_update_bits(info->max77693->regmap_muic,
>> +		/*
>> +		 * Don't touch BTLDset, JIGset when you want to change adc
>> +		 * debounce time. BTLDset, JIGset reflects actual pin status
>> +		 * and are not configurable.
>> +		 */
>> +		ret = regmap_write_bits(info->max77693->regmap_muic,
>>  					  MAX77693_MUIC_REG_CTRL3,
>> -					  CONTROL3_ADCDBSET_MASK,
>> -					  time << CONTROL3_ADCDBSET_SHIFT);
>> +					  (CONTROL3_ADCDBSET_MASK &
>> +					  time << CONTROL3_ADCDBSET_SHIFT));
> 
> Do you make this patch on extcon-next branch?
> 
> The max77693_muic_set_debounce_time() of extcon-max77693.c
> use regmap_update_bits instead of regmap_write_bits as following:


This patch intends to use 'regmap_write_bits()' not 'regmap_update_bits()'.
With using regmap_update_bits(), it would writes some value to BTLDset and
JIGset then muic device will loose current state.

Thanks,
Jonghwa

> 
> 	switch (time) {
> 	case ADC_DEBOUNCE_TIME_5MS:
> 	case ADC_DEBOUNCE_TIME_10MS:
> 	case ADC_DEBOUNCE_TIME_25MS:
> 	case ADC_DEBOUNCE_TIME_38_62MS:
> 		ret = regmap_update_bits(info->max77693->regmap_muic,
> 					  MAX77693_MUIC_REG_CTRL3,
> 					  CONTROL3_ADCDBSET_MASK,
> 					  time << CONTROL3_ADCDBSET_SHIFT);
> 		if (ret) {
> 			dev_err(info->dev, "failed to set ADC debounce time\n");
> 			return ret;
> 		}
> 
> 
> Thanks,
> Chanwoo Choi
> 
> 
> 


