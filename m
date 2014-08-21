Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553AbaHUFqG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 01:46:06 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:41487 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081AbaHUFqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 01:46:00 -0400
MIME-version: 1.0
Content-type: text/plain; charset=EUC-KR
X-AuditID: cbfee691-b7f306d000003d81-c6-53f5878d013b
Content-transfer-encoding: 8BIT
Message-id: <53F5878D.3030700@samsung.com>
Date: Thu, 21 Aug 2014 14:45:49 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
To: myungjoo.ham@samsung.com
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, Mark Brown <broonie@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>
Subject: Re: [PATCH 2/2] extcon: sm5502: EXTCON_SM5502 should depend on I2C
References: <2048653519.580921408598869113.JavaMail.weblogic@epmlwas01c>
In-reply-to: <2048653519.580921408598869113.JavaMail.weblogic@epmlwas01c>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDIsWRmVeSWpSXmKPExsWyRsSkQLev/WuwwfNNbBZTHz5hs3h2ay+T
	RfPi9WwWHX+/MFpc3jWHzaLx4012i9uNK9gc2D02repk8zh0uIPRY//cNewefVtWMXp83iQX
	wBrFZZOSmpNZllqkb5fAldF5J6bgvWjFziVfmBsYtwl1MXJySAiYSBx7PY0VwhaTuHBvPVsX
	IxeHkMBSRokrex+xwxRtOnuUHSKxiFHi+cH5YAleAUGJH5PvsXQxcnAwC8hLHLmUDRJmFtCQ
	mPr6NCNE/WtGiXMt8xgh6rUknpx5wwZiswioSmy+upUFxGYDiu9/cQMsLioQJrFy+hWwuIiA
	jMTVjdtZQAYxC+xgkvi04SRYQljAW2L62w1gRwgJeEi8/PmHGeQITgFPiWMPE0DqJQQusUsc
	mfSdFWKZgMS3yYfADpUQkJXYdIAZ4jFJiYMrbrBMYBSbheSdWQjvzELyzgJG5lWMoqkFyQXF
	SelFpnrFibnFpXnpesn5uZsYgTF3+t+ziTsY7x+wPsSYDLRxIrOUaHI+MGbzSuINjc2MLExN
	TI2NzC3NSBNWEudNf5QUJCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoFR5FeQMcOHvsl12b28
	q3e278zwy3TJmmMWqGWyYQJfgcsy7+RHf6W42qZZFSsvuTlHaP7VSYoSCtIcrA9jP69NXfRp
	semM3Uv/iRZayp02tPoxZfdVhaA9cr7pJ0/90ZNJCBYXzZ2pJ3BJ3qdWoE1l4/k6vbgVrGx3
	Hfb5Tm+aG9e4P+TizqtKLMUZiYZazEXFiQBRyZyazwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNIsWRmVeSWpSXmKPExsVy+t9jAd3e9q/BBtu7rC2mPnzCZvHs1l4m
	i+bF69ksOv5+YbS4vGsOm0Xjx5vsFrcbV7A5sHtsWtXJ5nHocAejx/65a9g9+rasYvT4vEku
	gDWqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB+gO
	JYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+IUFwPUYGaCBhDWNG552YgveiFTuXfGFuYNwm
	1MXIySEhYCKx6exRdghbTOLCvfVsXYxcHEICixglnh+cD5bgFRCU+DH5HksXIwcHs4C8xJFL
	2SBhZgENiamvTzNC1L9mlDjXMo8Rol5L4smZN2wgNouAqsTmq1tZQGw2oPj+FzfA4qICYRIr
	p18Bi4sIyEhc3bidBWQQs8AOJolPG06CJYQFvCWmv90AdoSQgIfEy59/mEGO4BTwlDj2MGEC
	o8AsJOfNQjhvFpLzFjAyr2IUTS1ILihOSs811CtOzC0uzUvXS87P3cQIjuhnUjsYVzZYHGIU
	4GBU4uFtWPAlWIg1say4MvcQowQHs5IIb2nb12Ah3pTEyqrUovz4otKc1OJDjKZAz01klhJN
	zgcmm7ySeENjEzMjSyNzQwsjY3Mlcd4DrdaBQgLpiSWp2ampBalFMH1MHJxSDYwNrcprGrRX
	5Qfly6+ew5oadOjULIVWr4yNVf+OvBE93Gg0x1xAj/eTsXBjRmthILdG94X8DOGtH36fKsvb
	M3/1vzMnn8pIvnyZ3bau+Od5PzNnTtW1a5NlPmrdyhZzzpkf632SsXFd4/LaPSyW+reuBa/c
	d+Jixc//k1jEH39exfA6dMo+xcNKLMUZiYZazEXFiQA/mn2o/gIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Myungjoo,

On 08/21/2014 02:27 PM, MyungJoo Ham wrote:
>> Hi Geert
>>
>> Thanks for your report. I already sent a patch[1] to fix this build break
>> and I'll send pull request to includec this patch in 3.17-rc2.
>>
>> [1] https://lkml.org/lkml/2014/8/13/761
>>
>> Best Regards,
>> Chanwoo Choi
> 
> I do not object to this patch or your patch[1].
> 
> However, wouldn't it be better to add depends on I2C at REGMAP_I2C?
> When you use REGMAP_I2C, you assume that I2C is already there, don't you?

The previous REGMAP_I2C has not the dependency on I2C.
So, Greert posted following patch[1] to fix it.
[1] https://lkml.org/lkml/2014/8/17/27

Also, if I2C is 'm' (module) and some driver has not dependency on I2C,
build break happen.

Thanks
Chanwoo Choi,


> 
> 
> Cheers,
> MyungJoo
> 
>>
>>
>> On 08/17/2014 07:08 PM, Geert Uytterhoeven wrote:
>>> EXTCON_SM5502 selects REGMAP_I2C, but if I2C=n:
>>>
>>> drivers/base/regmap/regmap-i2c.c: In function ¡®regmap_smbus_byte_reg_read¡¯:
>>> drivers/base/regmap/regmap-i2c.c:28: error: implicit declaration of function ¡®i2c_smbus_read_byte_data¡¯
>>> drivers/base/regmap/regmap-i2c.c: In function ¡®regmap_smbus_byte_reg_write¡¯:
>>> drivers/base/regmap/regmap-i2c.c:46: error: implicit declaration of function ¡®i2c_smbus_write_byte_data¡¯
>>> drivers/base/regmap/regmap-i2c.c: In function ¡®regmap_smbus_word_reg_read¡¯:
>>> drivers/base/regmap/regmap-i2c.c:64: error: implicit declaration of function ¡®i2c_smbus_read_word_data¡¯
>>> drivers/base/regmap/regmap-i2c.c: In function ¡®regmap_smbus_word_reg_write¡¯:
>>> drivers/base/regmap/regmap-i2c.c:82: error: implicit declaration of function ¡®i2c_smbus_write_word_data¡¯
>>> drivers/base/regmap/regmap-i2c.c: In function ¡®regmap_i2c_write¡¯:
>>> drivers/base/regmap/regmap-i2c.c:96: error: implicit declaration of function ¡®i2c_master_send¡¯
>>> drivers/base/regmap/regmap-i2c.c: In function ¡®regmap_i2c_gather_write¡¯:
>>> drivers/base/regmap/regmap-i2c.c:117: error: implicit declaration of function ¡®i2c_check_functionality¡¯
>>> drivers/base/regmap/regmap-i2c.c:130: error: implicit declaration of function ¡®i2c_transfer¡¯
>>>
>>> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
>>> ---
>>>  drivers/extcon/Kconfig | 1 +
>>>  1 file changed, 1 insertion(+)
>>>
>>> diff --git a/drivers/extcon/Kconfig b/drivers/extcon/Kconfig
>>> index 6f2f4727de2c..764f3a113e0a 100644
>>> --- a/drivers/extcon/Kconfig
>>> +++ b/drivers/extcon/Kconfig
>>> @@ -72,6 +72,7 @@ config EXTCON_PALMAS
>>>  
>>>  config EXTCON_SM5502
>>>  	tristate "SM5502 EXTCON support"
>>> +	depends on I2C
>>>  	select IRQ_DOMAIN
>>>  	select REGMAP_I2C
>>>  	select REGMAP_IRQ
>>>
>>
>>
>>
>>
>>        
>>   
>>          
>>

