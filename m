Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115AbbAMK3u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 05:29:50 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:36815 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116AbbAMK3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 05:29:45 -0500
X-AuditID: cbfee68e-f79b46d000002b74-e7-54b4f396dd64
Message-id: <54B4F396.3090105@samsung.com>
Date: Tue, 13 Jan 2015 19:29:42 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: myungjoo.ham@samsung.com
Cc: "kgene@kernel.org" <kgene@kernel.org>,
        =?UTF-8?B?67CV6rK966+8?= <kyungmin.park@samsung.com>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        ABHILASH KESAVAN <a.kesavan@samsung.com>,
        "tomasz.figa@gmail.com" <tomasz.figa@gmail.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        =?UTF-8?B?64yA7J246riw?= <inki.dae@samsung.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>
Subject: Re: [PATCHv3 1/8] devfreq: exynos: Add generic exynos memory bus
 frequency driver
References: <2009992739.970611421140038667.JavaMail.weblogic@epmlwas05d>
In-reply-to: <2009992739.970611421140038667.JavaMail.weblogic@epmlwas05d>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCIsWRmVeSWpSXmKPExsWyRsSkQHf65y0hBpM3s1o8XrOYyWLjjPWs
	FpPuT2CxeP3C0KL/8Wtmi7NNb9gtNj2+xmpxedccNovPvUcYLWac38dksfT6RSaL240r2Cwe
	r3jLbtG69wi7xapdfxgd+D3WzFvD6LFz1l12j8V7XjJ5bFrVyeaxeUm9R9+WVYwenzfJBbBH
	cdmkpOZklqUW6dslcGX0bXvPXLBLvOL6tJmMDYzNwl2MnBwSAiYSF1v/sULYYhIX7q1n62Lk
	4hASWMoo8f9OExNM0fZ9LYwQiUWMEi+eTGKFcF4zSjy98AmohYODV0BL4lZzAkgDi4CqxP8D
	G8CmsgGF97+4wQZiiwqESaycfoUFxOYVEJT4MfkemC0iICNxdeN2FpCZzAK9bBLv1i9iBkkI
	C8RIdN2/zQhiCwl4SPx8dQDM5hTwlDj34gVYDbOAusSkeYugbHmJzWveMoMMkhCYyiHxefI9
	RoiLBCS+TT7EAnKohICsxKYDzBCfSUocXHGDZQKj2CwkN81CMnYWkrELGJlXMYqmFiQXFCel
	FxnpFSfmFpfmpesl5+duYgRG9ul/z/p2MN48YH2IUYCDUYmHd0f2lhAh1sSy4srcQ4ymQFdM
	ZJYSTc4Hpo+8knhDYzMjC1MTU2Mjc0szJXHeBKmfwUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4
	pRoY5+lXXLp3V/XlPHnd3i8JO7LMw7Wuh3l+fcMmy779XeU+QdXfv/vUjp3f1hIjqMOwKCyr
	vXQv81/vn9OstiokF5+YXHGydMmDxz8azPK5iyqV3rxaWhj06+v8d/e9tp6ysjnIbpv5MGrb
	8ucvLyk9DJzMzCE166bxU+vMezxtv9oZ/U+Jn1jDpsRSnJFoqMVcVJwIABq4oGbnAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHKsWRmVeSWpSXmKPExsVy+t9jAd1pn7eEGJz5a2nxeM1iJouNM9az
	Wky6P4HF4vULQ4v+x6+ZLc42vWG32PT4GqvF5V1z2Cw+9x5htJhxfh+TxdLrF5ksbjeuYLN4
	vOItu0Xr3iPsFqt2/WF04PdYM28No8fOWXfZPRbvecnksWlVJ5vH5iX1Hn1bVjF6fN4kF8Ae
	1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQN0t5JC
	WWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsIYxo2/be+aCXeIV16fNZGxgbBbu
	YuTkkBAwkdi+r4URwhaTuHBvPVsXIxeHkMAiRokXTyaxQjivGSWeXvgElOHg4BXQkrjVnADS
	wCKgKvH/wAZWEJsNKLz/xQ02EFtUIExi5fQrLCA2r4CgxI/J98BsEQEZiasbt7OAzGQW6GWT
	eLd+ETNIQlggRqLr/m2wK4QEPCR+vjoAZnMKeEqce/ECrIZZQF1i0rxFULa8xOY1b5knMArM
	QrJjFpKyWUjKFjAyr2IUTS1ILihOSs811CtOzC0uzUvXS87P3cQIThvPpHYwrmywOMQowMGo
	xMMrkLclRIg1say4MvcQowQHs5II7/zbQCHelMTKqtSi/Pii0pzU4kOMpsAgmMgsJZqcD0xp
	eSXxhsYmZkaWRuaGFkbG5krivEr2bSFCAumJJanZqakFqUUwfUwcnFINjJOFpdNWH7nKonEy
	VXKWoGSUxPrJPZ82Mczu5UpaafYjv3Nh0kO+yiu9GUu2X37NZLH5dvuTclsxB74FTlLaiivr
	UxLYdq4t63/AGNT9aclr+fRlCXd/2/x4dPHP6ryQC9xv9NpPq153yF8WVmjOeXve6wUZfqJK
	iz9GtdZ1fXVn0i3L3cGjosRSnJFoqMVcVJwIAGKIttcxAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2015 06:07 PM, MyungJoo Ham wrote:
>>  
>> Dear Myungjoo,
>>
>> On 01/13/2015 05:42 PM, MyungJoo Ham wrote:
>>>>   
>>>>  This patch adds the generic exynos bus frequency driver for memory bus
>>>> with DEVFREQ framework. The Samsung Exynos SoCs have the common architecture
>>>> for memory bus between DRAM memory and MMC/sub IP in SoC. This driver can
>>>> support the memory bus frequency driver for Exynos SoCs.
>>>>
>>>> Each memory bus block has a clock for memory bus speed and frequency
>>>> table which is changed according to the utilization of memory bus on runtime.
>>>> And then each memory bus group has the one more memory bus blocks and
>>>> OPP table (including frequency and voltage), regulator, devfreq-event
>>>> devices.
>>>>
>>>> There are a little difference about the number of memory bus because each Exynos
>>>> SoC have the different sub-IP and different memory bus speed. In spite of this
>>>> difference among Exynos SoCs, we can support almost Exynos SoC by adding
>>>> unique data of memory bus to devicetree file.
>>>>
>>>> Cc: Myungjoo Ham <myungjoo.ham@samsung.com>
>>>> Cc: Kyungmin Park <kyungmin.park@samsung.com>
>>>> Cc: Kukjin Kim <kgene@kernel.org>
>>>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>>>> ---
>>>>  drivers/devfreq/Kconfig          |  15 +
>>>>  drivers/devfreq/Makefile         |   1 +
>>>>  drivers/devfreq/exynos-busfreq.c | 589 +++++++++++++++++++++++++++++++++++++++
>>>>  3 files changed, 605 insertions(+)
>>>>  create mode 100644 drivers/devfreq/exynos-busfreq.c
>>>
>>> Exynos drivers are located at drivers/devfreq/exynos/
>>> Please relocate/rename exynos-busfreq.c
>>
>> OK. I'll move it at drivers/devfreq/exynos directory.
>> Do you prefer 'exynos-bus.c' instead of 'exynos-busfreq.c'?
>> If you reply, I'll change it.
> 
> exynos-bus looks more pretty :)

OK, I'll change the driver name according to your comment.

Best Regards,
Chanwoo Choi

> 
>>
>>>
>>> []
>>>
>>>> diff --git a/drivers/devfreq/exynos-busfreq.c b/drivers/devfreq/exynos-busfreq.c
>>>> new file mode 100644
>>>> index 0000000..b180f43
>>>> --- /dev/null
>>>> +++ b/drivers/devfreq/exynos-busfreq.c
>>>
>>> []
>>>
>>>> +
>>>> +#define BUS_SATURATION_RATIO	40
>>>
>>> In order to be a common driver, this should be tunable.
>>>
>>> Because .dts is supposed to have hardware configuration only,
>>> you may keep a table of { chip-name, saturation ratio} in this
>>> driver and look up the saturation ratio based on the chip-name.
>>
>> OK, I'll add new property for saturation_ratio.
>>
>> I'll implement to use default saturation_ratio value ,
>> if dt node don't include saturation_ratio property.
> 
> Yes. I didn't talk with DT maintainers and I do not have much
> experience with DT; however, it appears that such values are not
> recommended to be in DTS files and this value is determined by
> the SoC model number without complications in the driver file.
> 

