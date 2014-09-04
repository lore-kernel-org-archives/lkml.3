Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423AbaIDKPo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 06:15:44 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:15714 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527AbaIDKPl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 06:15:41 -0400
X-AuditID: cbfee68d-f79c46d000000b84-d8-54083bcc9b14
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 8BIT
Message-id: <54083BCB.1000603@samsung.com>
Date: Thu, 04 Sep 2014 19:15:39 +0900
From: Jaewon Kim <jaewon02.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.0
To: Lee Jones <lee.jones@linaro.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>
Subject: Re: [PATCH 1/3] mfd: max77693: Initialize haptic register map
References: <1409570071-26719-1-git-send-email-jaewon02.kim@samsung.com>
 <1409570071-26719-2-git-send-email-jaewon02.kim@samsung.com>
 <20140904090605.GB29612@lee--X1>
In-reply-to: <20140904090605.GB29612@lee--X1>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKIsWRmVeSWpSXmKPExsWyRsSkRPeMNUeIwcpzYhbXvzxntTi86AWj
	xf2vRxktbn76xmpxedccNovT3awObB47Z91l97hzbQ+bx7yTgR59W1YxenzeJBfAGsVlk5Ka
	k1mWWqRvl8CVsevAXuaCCeIVH2ZuY21gfCXUxcjBISFgInF0cWoXIyeQKSZx4d56ti5GLg4h
	gaWMEt9OTWeESJhIfJn5ggkiMZ1RYuqUFUwgCV4BQYkfk++xgNjMAmYSX14eZoWwRSQW72ti
	h7C1JZYtfM0M0fyaUWLOukvsEM1aEpMaO5hBbBYBVYlLZxrBmtmAGr6vXwxmiwqESTz7dZAJ
	5FIRARWJc2/MQeYwC+xilHh14hsbSI2wgJvEi6Of2CEWrGKUmLHoIthFnAK6Eq9/vQFLSAic
	Y5dY9GQuG8Q2AYlvkw+xQPwvK7HpADPEm5ISB1fcYJnAKD4LyXOzkDw3C8lzs5A8t4CRZRWj
	aGpBckFxUnqRoV5xYm5xaV66XnJ+7iZGYGye/vesdwfj7QPWhxgFOBiVeHgLXrCHCLEmlhVX
	5h5iNAW6aCKzlGhyPjAB5JXEGxqbGVmYmpgaG5lbmimJ8ypK/QwWEkhPLEnNTk0tSC2KLyrN
	SS0+xMjEwSnVwGjvfFQ1nlehR+j3Uivv7+fuPPusN9tm6kITs873SQtO7HVvD898cc+sfVqU
	W9jkmn+lvDaN+sbC4hdY5p6r2Oi9+Ti37Cy2l7F1uh59YbHvPbLLRTc801562/GNqrj6jCfP
	03f9eqFt9mDl1XDhv2HKbe7HD6cqxYnHHL1xoUzhaxlLj1PFVCWW4oxEQy3mouJEAL+DnazI	AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGIsWRmVeSWpSXmKPExsVy+t9jQd0z1hwhBnO28Vtc//Kc1eLwoheM
	Fve/HmW0uPnpG6vF5V1z2CxOd7M6sHnsnHWX3ePOtT1sHvNOBnr0bVnF6PF5k1wAa1QDo01G
	amJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0AFKCmWJOaVA
	oYDE4mIlfTtME0JD3HQtYBojdH1DguB6jAzQQMIaxoy1N6eyFZwQq+i62MPcwLhIqIuRk0NC
	wETiy8wXTBC2mMSFe+vZuhi5OIQEpjNKTJ2yAizBKyAo8WPyPZYuRg4OZgF5iSOXskHCzAJm
	El9eHmaFqH/NKDFn3SV2iHotiUmNHcwgNouAqsSlM42sIDabgLbE9/WLwWxRgTCJZ78OMoHM
	FBFQkTj3xhxkDrPALkaJVye+sYHUCAu4Sbw4+okdYsEqRokZiy6ygCQ4BXQlXv96wz6BUWAW
	kvtmIdw3C8l9CxiZVzGKphYkFxQnpeca6hUn5haX5qXrJefnbmIEx/EzqR2MKxssDjEKcDAq
	8fAWvGAPEWJNLCuuzD3EKMHBrCTCu9CSI0SINyWxsiq1KD++qDQntfgQoynQdxOZpUST84Ep
	Jq8k3tDYxMzI0sjc0MLI2FxJnPdAq3WgkEB6YklqdmpqQWoRTB8TB6dUA+PK1zpy5f4PC2OK
	v4ha5+9ril6wPHLrsmi7yycruGqff9Lqf7Wa7VF97noTpVNCrjxrlxw8Nyn6gMyzyEmHaz/E
	mqgd5enVeK9V5SlvebN37rqV/9d1tda66Gzfr/LkY6XTt93OTOcnO01rr59zccPkD7vmvlo4
	81lqyqwfXz1fs8uuMuSdH6erxFKckWioxVxUnAgASBLKo/kCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2014년 09월 04일 18:06에 Lee Jones 이(가) 쓴 글:
> On Mon, 01 Sep 2014, Jaewon Kim wrote:
>
>> This patch add regmap_haptic initialization to use haptic register map
>> in haptic device driver.
>>
>> Signed-off-by: Jaewon Kim <jaewon02.kim@samsung.com>
>> Acked-by: Chanwoo Choi <cw00.choi@samsung.com>
>> ---
>>   drivers/mfd/max77693.c |   21 ++++++++++++++++++---
>>   1 file changed, 18 insertions(+), 3 deletions(-)
> Acked-by: Lee Jones <lee.jones@linaro.org>
>
> Can this patch go in without the Input one?

Yes. There is no problem without Input driver patch.
>
>> diff --git a/drivers/mfd/max77693.c b/drivers/mfd/max77693.c
>> index 249c139..fbfed56 100644
>> --- a/drivers/mfd/max77693.c
>> +++ b/drivers/mfd/max77693.c
>> @@ -144,6 +144,12 @@ static const struct regmap_irq_chip max77693_muic_irq_chip = {
>>   	.num_irqs		= ARRAY_SIZE(max77693_muic_irqs),
>>   };
>>   
>> +static const struct regmap_config max77693_regmap_haptic_config = {
>> +	.reg_bits = 8,
>> +	.val_bits = 8,
>> +	.max_register = MAX77693_HAPTIC_REG_END,
>> +};
>> +
>>   static int max77693_i2c_probe(struct i2c_client *i2c,
>>   			      const struct i2c_device_id *id)
>>   {
>> @@ -193,6 +199,15 @@ static int max77693_i2c_probe(struct i2c_client *i2c,
>>   	}
>>   	i2c_set_clientdata(max77693->haptic, max77693);
>>   
>> +	max77693->regmap_haptic = devm_regmap_init_i2c(max77693->haptic,
>> +					&max77693_regmap_haptic_config);
>> +	if (IS_ERR(max77693->regmap_haptic)) {
>> +		ret = PTR_ERR(max77693->regmap_haptic);
>> +		dev_err(max77693->dev,
>> +			"failed to initialize haptic register map: %d\n", ret);
>> +		goto err_regmap;
>> +	}
>> +
>>   	/*
>>   	 * Initialize register map for MUIC device because use regmap-muic
>>   	 * instance of MUIC device when irq of max77693 is initialized
>> @@ -204,7 +219,7 @@ static int max77693_i2c_probe(struct i2c_client *i2c,
>>   		ret = PTR_ERR(max77693->regmap_muic);
>>   		dev_err(max77693->dev,
>>   			"failed to allocate register map: %d\n", ret);
>> -		goto err_regmap_muic;
>> +		goto err_regmap;
>>   	}
>>   
>>   	ret = regmap_add_irq_chip(max77693->regmap, max77693->irq,
>> @@ -214,7 +229,7 @@ static int max77693_i2c_probe(struct i2c_client *i2c,
>>   				&max77693->irq_data_led);
>>   	if (ret) {
>>   		dev_err(max77693->dev, "failed to add irq chip: %d\n", ret);
>> -		goto err_regmap_muic;
>> +		goto err_regmap;
>>   	}
>>   
>>   	ret = regmap_add_irq_chip(max77693->regmap, max77693->irq,
>> @@ -265,7 +280,7 @@ err_irq_charger:
>>   	regmap_del_irq_chip(max77693->irq, max77693->irq_data_topsys);
>>   err_irq_topsys:
>>   	regmap_del_irq_chip(max77693->irq, max77693->irq_data_led);
>> -err_regmap_muic:
>> +err_regmap:
>>   	i2c_unregister_device(max77693->haptic);
>>   err_i2c_haptic:
>>   	i2c_unregister_device(max77693->muic);

