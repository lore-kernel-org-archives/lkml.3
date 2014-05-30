Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932790AbaE3JtJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 05:49:09 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:18884 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755246AbaE3JtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 05:49:06 -0400
X-AuditID: cbfee690-b7fb56d000003439-54-5388540ff3d4
Message-id: <5388540F.7070507@samsung.com>
Date: Fri, 30 May 2014 18:49:03 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, Mark Brown <broonie@kernel.org>,
        Graeme Gregory <gg@slimlogic.co.uk>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: Re: [PATCH] extcon: Set parent device of extcon device using	prameter
 of devm_extcon_dev_allocate
References: <1401414099-10937-1-git-send-email-cw00.choi@samsung.com>
 <20140530093638.GA11951@opensource.wolfsonmicro.com>
In-reply-to: <20140530093638.GA11951@opensource.wolfsonmicro.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGIsWRmVeSWpSXmKPExsWyRsSkRJc/pCPY4NA/c4upD5+wWfybcoPd
	on+Li8XrF4YWF572sFmcbXrDbnF51xw2i9uNK9gcODw2repk83g58TebR9+WVYweU6f8ZfQ4
	fmM7k8fnTXIBbFFcNimpOZllqUX6dglcGXd7frEXnBWsuP5uDUsD40W+LkZODgkBE4lP/06z
	Q9hiEhfurWfrYuTiEBJYyijR+mYVE0zR7K/bWSES0xklTu44wgLhvGaUuLtwB1gVr4CWxMPu
	3SwgNouAqkTf1e/MIDYbUHz/ixtsILaoQJjEyulXWCDqBSV+TL4HZosIWEhMWXILrJ5Z4Aej
	xMVp9SC2sECOxJG5qxlBbCGBGonrk98DncrBwSngKHHuWzVEuY7E/tZpbBC2vMTmNW+ZQW6T
	ELjHLrHzzhk2iHsEJL5NPsQC0ishICux6QAzxGOSEgdX3GCZwCg2C8lFs5CMnYVk7AJG5lWM
	oqkFyQXFSelFJnrFibnFpXnpesn5uZsYgXF4+t+zCTsY7x2wPsSYDLRyIrOUaHI+MI7zSuIN
	jc2MLExNTI2NzC3NSBNWEudVe5QUJCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoFxXjGnRffE
	Hw7ucXofGT73rgt7FLjhj/3tY6u0slfGuVV9DjcIaCwSSW394pa2dce2fT7a9259+cXHE6D5
	c6LoM+nQ5LYbGccmeF7tjvcv9rmuv+H6iztyt9zlpWV5xDMlON/lHw27u8rlsUbyw2mMEok5
	SRXzZq71vJRz43S7/2utxPl6KiJKLMUZiYZazEXFiQDAmTor2QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMKsWRmVeSWpSXmKPExsVy+t9jQV3+kI5gg+/N+hZTHz5hs/g35Qa7
	Rf8WF4vXLwwtLjztYbM42/SG3eLyrjlsFrcbV7A5cHhsWtXJ5vFy4m82j74tqxg9pk75y+hx
	/MZ2Jo/Pm+QC2KIaGG0yUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVc
	fAJ03TJzgO5RUihLzCkFCgUkFhcr6dthmhAa4qZrAdMYoesbEgTXY2SABhLWMGbc7fnFXnBW
	sOL6uzUsDYwX+boYOTkkBEwkZn/dzgphi0lcuLeerYuRi0NIYDqjxMkdR1ggnNeMEncX7mAC
	qeIV0JJ42L2bBcRmEVCV6Lv6nRnEZgOK739xgw3EFhUIk1g5/QoLRL2gxI/J98BsEQELiSlL
	boHVMwv8YJS4OK0exBYWyJE4Mnc1I4gtJFAjcX3ye/YuRg4OTgFHiXPfqiHKdST2t05jg7Dl
	JTavecs8gVFgFpINs5CUzUJStoCReRWjaGpBckFxUnqukV5xYm5xaV66XnJ+7iZGcJQ/k97B
	uKrB4hCjAAejEg/vhPT2YCHWxLLiytxDjBIczEoivHt9OoKFeFMSK6tSi/Lji0pzUosPMSYD
	A2Ais5Rocj4wAeWVxBsam5gZWRqZG1oYGZuTJqwkznuw1TpQSCA9sSQ1OzW1ILUIZgsTB6dU
	AyOfZf+l3lszrjOtvnM1ZqJLhexc9Xyhs3FhrncXa280iPu9J3rhukrXPra6ELt++4mdv16b
	NMtm1yWbcG/KnnhNIrv69gs/jkOSexpf3TKZ926JF89r7pV6lb2NL6393X6sc0uR93cxOjr9
	5lXmmsONK99q6j/rTb38O8Xg+rw01X1vbVd1HVZiKc5INNRiLipOBAAdt+XeNgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Charles,

On 05/30/2014 06:36 PM, Charles Keepax wrote:
> On Fri, May 30, 2014 at 10:41:39AM +0900, Chanwoo Choi wrote:
>> This patch set the parent device of extcon device using first parameter of
>> devm_extco_dev_allocate() to remove duplicate code on all of extcon provider
>> drivers.
>>
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> Reported-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
>> Cc: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
>> Cc: Mark Brown <broonie@kernel.org>
>> Cc: Graeme Gregory <gg@slimlogic.co.uk>
>> Cc: Kishon Vijay Abraham I <kishon@ti.com>
>> Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
>> ---
>>  drivers/extcon/extcon-adc-jack.c | 1 -
>>  drivers/extcon/extcon-arizona.c  | 1 -
>>  drivers/extcon/extcon-class.c    | 2 ++
>>  drivers/extcon/extcon-gpio.c     | 1 -
>>  drivers/extcon/extcon-max77693.c | 1 -
>>  drivers/extcon/extcon-max8997.c  | 1 -
>>  drivers/extcon/extcon-palmas.c   | 1 -
>>  7 files changed, 2 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/extcon/extcon-adc-jack.c b/drivers/extcon/extcon-adc-jack.c
>> index e18f95b..d860229 100644
>> --- a/drivers/extcon/extcon-adc-jack.c
>> +++ b/drivers/extcon/extcon-adc-jack.c
>> @@ -112,7 +112,6 @@ static int adc_jack_probe(struct platform_device *pdev)
>>  		dev_err(&pdev->dev, "failed to allocate extcon device\n");
>>  		return -ENOMEM;
>>  	}
>> -	data->edev->dev.parent = &pdev->dev;
>>  	data->edev->name = pdata->name;
>>  
>>  	/* Check the length of array and set num_cables */
>> diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
>> index c634796..d9bd3c3 100644
>> --- a/drivers/extcon/extcon-arizona.c
>> +++ b/drivers/extcon/extcon-arizona.c
>> @@ -1165,7 +1165,6 @@ static int arizona_extcon_probe(struct platform_device *pdev)
>>  		return -ENOMEM;
>>  	}
>>  	info->edev->name = "Headset Jack";
>> -	info->edev->dev.parent = arizona->dev;
>>  
>>  	ret = devm_extcon_dev_register(&pdev->dev, info->edev);
> 
> This changes the parent device for the Arizona stuff, I don't
> think this is a problem but I should probably test here first.

OK, Let me know about test result.

Thanks,
Chanwoo Choi


