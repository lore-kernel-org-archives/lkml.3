Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757663Ab3BGBna (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 20:43:30 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:51604 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752296Ab3BGBn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 20:43:29 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee61b-b7fb06d000000f28-59-511306bfb4f1
Content-transfer-encoding: 8BIT
Message-id: <511306BB.2020708@samsung.com>
Date: Thu, 07 Feb 2013 10:43:23 +0900
From: jonghwa3.lee@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, a.zummo@towertech.it,
        rtc-linux@googlegroups.com
Subject: Re: [PATCH] rtc: max8997: Add driver for max8997 rtc.
References: <1360149785-19645-1-git-send-email-jonghwa3.lee@samsung.com>
 <20130206130615.86121923.akpm@linux-foundation.org>
In-reply-to: <20130206130615.86121923.akpm@linux-foundation.org>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBIsWRmVeSWpSXmKPExsVy+t8zbd39bMKBBp9nKltc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MFXvOMBX8FKmY8vU+WwPjdoEuRk4OCQETiZ77Z5khbDGJC/fW
	s3UxcnEICSxjlJj0cDsbTNGljysZIRKLGCV+HLkFluAVEJT4MfkeSxcjBwezgLzEkUvZIGFm
	AXWJSfMWMUPUdzFJHLp3gRmiXkvixfwvTCA2i4CqRNu7U2A2m4CcxNumb4wgc0QFIiR+9XOA
	hEUEdCVWPd/FDDEzROLJwhNga4UF7CT2TFsAFhcSqJM4sXgfI4jNKeAg8e/wL7A7JQS62SXm
	7H7DBrFLQOLb5ENgd0oIyEpsOgD1sKTEwRU3WCYwis1C8s0shG9mIflmASPzKkbR1ILkguKk
	9FwjveLE3OLSvHS95PzcTYyQeJDewbiqweIQowAHoxIP782lQoFCrIllxZW5hxglOJiVRHiz
	nwKFeFMSK6tSi/Lji0pzUosPMSYD3TeRWUo0OR8Yq3kl8YbGBsaGhpaGZqaWpgakCSuJ8zKe
	ehIgJJCeWJKanZpakFoEs4WJg1OqgbG8Zn4LF5fRzGvpKy70rXyt/2FK/JIvxvnxPLaixWc7
	dJUYnmxmd+4ScHgmN+/e1bCwpddmfOLLPXbNubg29paYYdW+2Bjt/HkvQzMmLH4ZuJLbI+/a
	oUt7zh5YzyD1qnllqaXsr22Fp9hlm72vc12tkNO0TJYUu2Q5JfzQ289sMzusBVLWmCuxFGck
	GmoxFxUnAgBChecfywIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOIsWRmVeSWpSXmKPExsVy+t9jAd39bMKBBnP6pCwu75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxoo9Z5gKfopUTPl6n62B
	cbtAFyMnh4SAicSljysZIWwxiQv31rN1MXJxCAksYpT4ceQWG0iCV0BQ4sfkeyxdjBwczALy
	EkcuZYOEmQXUJSbNW8QMUd/FJHHo3gVmiHotiRfzvzCB2CwCqhJt706B2WwCchJvm74xgswR
	FYiQ+NXPARIWEdCVWPV8FzPEzBCJJwtPgK0VFrCT2DNtAVhcSKBO4sTifWB3cgo4SPw7/Itx
	AqPALCTXzUK4bhaS6xYwMq9iFE0tSC4oTkrPNdIrTswtLs1L10vOz93ECI62Z9I7GFc1WBxi
	FOBgVOLhvblUKFCINbGsuDL3EKMEB7OSCG/2U6AQb0piZVVqUX58UWlOavEhxmSg3yYyS4km
	5wMTQV5JvKGxiZmRpZGZsYm5sTFpwkrivIynngQICaQnlqRmp6YWpBbBbGHi4JRqYMz/9rZ7
	0amHW9MCfslNvGp+h+/+ke4yrnIX1nnqc81SK7wDkoO87k+a7XrMjP33s6r5yycFrtw44RTz
	4jMhkQvmKDf+rjRaPHVKpv7NjzLzPZKuvIlaEGIe6HWNb6NqHvu7G4vMXukfO2MREDDzbbDQ
	ir2Mcz4Y6nJEMRd218s5/X6cFW6bt0SJpTgj0VCLuag4EQBU3woN+gIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013년 02월 07일 06:06, Andrew Morton wrote:
> On Wed, 06 Feb 2013 20:23:05 +0900
> Jonghwa Lee <jonghwa3.lee@samsung.com> wrote:
> 
>> This patch adds rtc driver for Maxim 8997 multifunction chip.
>> Max8997 has rtc module in it. and it can be used for timekeeping
>> clock and system alarm. It provide various operational mode those are
>> BCD/binary, 24/12hour, am/pm. Driver sets binary/24/ for default.
>> Maxim 8997 also supports SMPL(Sudden Momentary Power Loss), WTSR
>> (Watchdog Timeout and Software Reset).
>>
>> ...
>>
>> --- a/drivers/rtc/Kconfig
>> +++ b/drivers/rtc/Kconfig
>> @@ -233,6 +233,36 @@ config RTC_DRV_MAX8998
>>  	  This driver can also be built as a module. If so, the module
>>  	  will be called rtc-max8998.
>>  
>> +config RTC_DRV_MAX8997
>> +	tristate "Maxim MAX8997"
>> +	depends on MFD_MAX8997
>> +	help
>> +	  If you say yes here you will get support for the
>> +	  RTC of Maxim MAX8997 PMIC.
>> +
>> +	  This driver can also be built as a module. If so, the module
>> +	  will be called rtc-max8997.
>> +
>> +config MAX8997_RTC_WTSR
>> +	bool "MAX8997_RTC_WTSR"
>> +	depends on RTC_DRV_MAX8997
>> +	help
>> +	  MAX8997 rtc can supports WTSR(Watchdog Timeout and Software Reset).
>> +	  WTSR event would keep the PMIC on regardless of PWRHOLD signal.
>> +	  When PWRHOLD signal is falling, it turns on WTSR timer rather executes
>> +	  reset imidiately. After timer expiring, it determine to reset the PMIC
>> +	  depends on PWRHOLD state.
>> +
>> +config MAX8997_RTC_SMPL
>> +	bool "MAX8997_RTC_SMPL"
>> +	depends on RTC_DRV_MAX8997
>> +	help
>> +	  MAX8997 rtc can supports SMPL(Sudden Momentary Power Loss).
>> +	  SMPL function can be used to intiate a power up sequence after momentarily
>> +	  loosing contact to the battery pack. If battery goes under UVLO(Under
>> +	  Lock Out) it starts SMPL timer. After timer exipiring, it checks battery
>> +	  whether its state recovers from UVLO or not to make power supplies keep on.
> 
> Can we avoid creating CONFIG_MAX8997_RTC_WTSR and
> CONFIG_MAX8997_RTC_SMPL?  It would be much better for the users if
> these features were always available in all kernel builds.
> 
Okay, I'll apply it.

> The best way of handling this sort of thing is for the driver to probe
> the hardware, work out its capabilities and "do the right thing".
> 
> The second best way is to require that the user add certain module
> parameters to enable the functionality.
> 

How do we create sysfs node for enabling these options?


Thanks,
Jonghwa

> The worst way is to require the user to make the decision at kernel
> build time!
> 
> 
