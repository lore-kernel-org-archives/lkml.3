Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407AbaCMIEF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 04:04:05 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:20419 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856AbaCMID4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 04:03:56 -0400
X-AuditID: cbfee68f-b7f156d00000276c-f3-532166665b45
Message-id: <53216666.4080500@samsung.com>
Date: Thu, 13 Mar 2014 17:03:50 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Robert Baldyga <r.baldyga@samsung.com>
Cc: sameo@linux.intel.com, lee.jones@linaro.org, myungjoo.ham@samsung.com,
        dmitry.torokhov@gmail.com, cooloney@gmail.com, rpurdie@rpsys.net,
        dbaryshkov@gmail.com, dwmw2@infradead.org, lgirdwood@gmail.com,
        broonie@kernel.org, a.zummo@towertech.it, paul.gortmaker@windriver.com,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        linux-leds@vger.kernel.org, rtc-linux@googlegroups.com,
        m.szyprowski@samsung.com, k.kozlowski@samsung.com
Subject: Re: [PATCH v2 2/3] mfd: max8997: handle IRQs using regmap
References: <1394631466-6429-1-git-send-email-r.baldyga@samsung.com>
 <1394631466-6429-3-git-send-email-r.baldyga@samsung.com>
 <532111FA.2010706@samsung.com> <53216272.7050304@samsung.com>
In-reply-to: <53216272.7050304@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGKsWRmVeSWpSXmKPExsWyRsSkWDctTTHYYOd6A4slF6+yW0x9+ITN
	4ujOiUwWk568Z7Y4vOgFo8XElZOZLV6/MLS4//Uoo8W3Kx1MFjc/fWO1uLxrDpvF1jfrGC3W
	HrnLbnG7cQWbxbW9x5ktHhzeyW6xe9dTVov9nR2MFqe7WR2EPXbOusvusWfiSTaPzSu0PDat
	6mTzuHNtD5vHvJOBHnvm/2D16NuyitFj+ryfTB6fN8l5rN+ylSmAO4rLJiU1J7MstUjfLoEr
	41zfLMaCh6IVPffesTUwnhLsYuTkkBAwkXjbc5MZwhaTuHBvPVsXIxeHkMBSRomul1/ZYYom
	fXvDDpGYzijRfvQFM4TzilHi0oxLbCBVvAJaEv+3vGMBsVkEVCX+Nq1lArHZgOL7X9wAqxEV
	CJNYOf0KC0S9oMSPyffAbBGgmjsf54NtYxY4yizxvkEOxBYWcJLo2n+WFWLZfkaJGZensIIk
	OAW0JX7c2g/VoCOxv3UaG4QtL7F5zVuw6yQEznBINLxfwARxkYDEt8mHgLZxACVkJTYdgPpZ
	UuLgihssExjFZiG5aRaSsbOQjF3AyLyKUTS1ILmgOCm9yFivODG3uDQvXS85P3cTIzBNnP73
	rH8H490D1ocYk4FWTmSWEk3OB6aZvJJ4Q2MzIwtTE1NjI3NLM9KElcR57z9MChISSE8sSc1O
	TS1ILYovKs1JLT7EyMTBKdXAmGjZzxoSI8pblrl8W9MsEe61y7euYPA/sp5/ykF+vknnLr2K
	9N9Z9zZ7pt+Ti1plnFlWGhyvI5dv/Hk17QDrsiD11MebbXuX8c3LU3jBXzzhk+ha4f13Tx0X
	clV/sPKD3oEV667yqZr9338v3DTGnU144fxvPxTn9Xd5TmAyZlgjHNfzTSNhrhJLcUaioRZz
	UXEiAFzsDQcpAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMKsWRmVeSWpSXmKPExsVy+t9jQd20NMVgg/231SyWXLzKbjH14RM2
	i6M7JzJZTHryntni8KIXjBYTV05mtnj9wtDi/tejjBbfrnQwWdz89I3V4vKuOWwWW9+sY7RY
	e+Quu8XtxhVsFtf2Hme2eHB4J7vF7l1PWS32d3YwWpzuZnUQ9tg56y67x56JJ9k8Nq/Q8ti0
	qpPN4861PWwe804GeuyZ/4PVo2/LKkaP6fN+Mnl83iTnsX7LVqYA7qgGRpuM1MSU1CKF1Lzk
	/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoO+UFMoSc0qBQgGJxcVK+naY
	JoSGuOlawDRG6PqGBMH1GBmggYQ1jBnn+mYxFjwUrei5946tgfGUYBcjJ4eEgInEpG9v2CFs
	MYkL99azdTFycQgJTGeUaD/6ghnCecUocWnGJTaQKl4BLYn/W96xgNgsAqoSf5vWMoHYbEDx
	/S9ugNWICoRJrJx+hQWiXlDix+R7YLYIUM2dj/PBtjELHGWWeN8gB2ILCzhJdO0/ywqxbD+j
	xIzLU1hBEpwC2hI/bu2HatCR2N86jQ3ClpfYvOYt8wRGgVlIdsxCUjYLSdkCRuZVjKKpBckF
	xUnpuUZ6xYm5xaV56XrJ+bmbGMFJ6Jn0DsZVDRaHGAU4GJV4eFcsVwgWYk0sK67MPcQowcGs
	JMLr6aMYLMSbklhZlVqUH19UmpNafIgxGRgEE5mlRJPzgQkyryTe0NjEzMjSyNzQwsjYnDRh
	JXHeg63WgUIC6YklqdmpqQWpRTBbmDg4pRoYZztduhs72dTScFXu8mWWpdO7D4vv3W/r2SHi
	XS4eUJpeueuuGsNuQ+fPf+XzF0yU0VnzXvELa0KE8jIWXQYOXtYXCY8Ld+6dNunVdIWzC5dL
	ypc75DydtftT7vN7RfN2LXv9TGkrwxurozPu7p4x/03/K9sjejvPKE1bVpBp1yuxLs0yVnzL
	cyWW4oxEQy3mouJEAAgKE2SGAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Robert,

On 03/13/2014 04:46 PM, Robert Baldyga wrote:
> Hi,
> On 03/13/2014 03:03 AM, Chanwoo Choi wrote:
>> Hi Robert,
>>
>> On 03/12/2014 10:37 PM, Robert Baldyga wrote:
>>> This patch modifies mfd driver to use regmap for handling interrupts.
>>> It allows to simplify irq handling process. This modifications needed
>>> to make small changes in function drivers, which use interrupts.
>>>
>>> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
>>> ---
>>>  drivers/extcon/extcon-max8997.c     |   35 ++--
>>>  drivers/mfd/Kconfig                 |    2 +-
>>>  drivers/mfd/Makefile                |    2 +-
>>>  drivers/mfd/max8997-irq.c           |  373 -----------------------------------
>>>  drivers/mfd/max8997.c               |  113 ++++++++++-
>>>  drivers/rtc/rtc-max8997.c           |    2 +-
>>>  include/linux/mfd/max8997-private.h |   65 +++++-
>>>  7 files changed, 183 insertions(+), 409 deletions(-)
>>>  delete mode 100644 drivers/mfd/max8997-irq.c
>>>
>>> diff --git a/drivers/extcon/extcon-max8997.c b/drivers/extcon/extcon-max8997.c
>>> index f258c08..15fc5c0 100644
>>> --- a/drivers/extcon/extcon-max8997.c
>>> +++ b/drivers/extcon/extcon-max8997.c
>>> @@ -46,15 +46,15 @@ struct max8997_muic_irq {
>>>  };
>>>  
>>>  static struct max8997_muic_irq muic_irqs[] = {
>>> -	{ MAX8997_MUICIRQ_ADCError,	"muic-ADCERROR" },
>>> -	{ MAX8997_MUICIRQ_ADCLow,	"muic-ADCLOW" },
>>> -	{ MAX8997_MUICIRQ_ADC,		"muic-ADC" },
>>> -	{ MAX8997_MUICIRQ_VBVolt,	"muic-VBVOLT" },
>>> -	{ MAX8997_MUICIRQ_DBChg,	"muic-DBCHG" },
>>> -	{ MAX8997_MUICIRQ_DCDTmr,	"muic-DCDTMR" },
>>> -	{ MAX8997_MUICIRQ_ChgDetRun,	"muic-CHGDETRUN" },
>>> -	{ MAX8997_MUICIRQ_ChgTyp,	"muic-CHGTYP" },
>>> -	{ MAX8997_MUICIRQ_OVP,		"muic-OVP" },
>>> +	{ MAX8997_MUICIRQ_ADCERROR,	"MUIC-ADCERROR" },
>>> +	{ MAX8997_MUICIRQ_ADCLOW,	"MUIC-ADCLOW" },
>>> +	{ MAX8997_MUICIRQ_ADC,		"MUIC-ADC" },
>>> +	{ MAX8997_MUICIRQ_VBVOLT,	"MUIC-VBVOLT" },
>>> +	{ MAX8997_MUICIRQ_DBCHG,	"MUIC-DBCHG" },
>>> +	{ MAX8997_MUICIRQ_DCDTMR,	"MUIC-DCDTMR" },
>>> +	{ MAX8997_MUICIRQ_CHGDETRUN,	"MUIC-CHGDETRUN" },
>>> +	{ MAX8997_MUICIRQ_CHGTYP,	"MUIC-CHGTYP" },
>>> +	{ MAX8997_MUICIRQ_OVP,		"MUIC-OVP" },
>>>  };
>>
>>
>> Why did you modify interrput name? Did you have some reason?
>> I think this modification don't need it.
> 
> I did it to have one naming convention in max8997-private.h file. Any
> other interrupt names uses upper case, but MUIC iqr's from some reason
> uses CamelCase. I think it's much better to have consistent style in
> entire file.

If you want to modify interrupt name, I think you better separate patch for
this modification. This patch handle only regmap according to the title of this patch.

Thanks,
Chanwoo Choi

