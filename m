Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755743AbaDPLgt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 07:36:49 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:21163 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755563AbaDPLgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 07:36:48 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee68f-b7f156d00000276c-b2-534e6b4ed8ae
Content-transfer-encoding: 8BIT
Message-id: <534E6B52.9080706@samsung.com>
Date: Wed, 16 Apr 2014 20:36:50 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Lee Jones <lee.jones@linaro.org>, MyungJoo Ham <myungjoo.ham@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH v5 0/9] mfd: max14577: Add support for MAX77836
References: <1397467040-30502-1-git-send-email-k.kozlowski@samsung.com>
 <20140416102846.GL4754@lee--X1> <1397645078.6147.11.camel@AMDC1943>
 <534E60C6.4080005@samsung.com> <1397646165.6147.16.camel@AMDC1943>
In-reply-to: <1397646165.6147.16.camel@AMDC1943>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAIsWRmVeSWpSXmKPExsWyRsSkQNcv2y/YoPuEoMXGGetZLaY+fMJm
	8fqFocXZpjfsFve/HmW0+Halg8ni8q45bBZrj9xlt7jduILN4nQ3qwOXx85Zd9k9Nq3qZPO4
	c20Pm8e8k4EefVtWMXp83iQXwBbFZZOSmpNZllqkb5fAlfHwy1nGgpPCFT9fH2FtYPzB38XI
	ySEhYCLxtWMxI4QtJnHh3nq2LkYuDiGBpYwScx/sZ4Mp2vnpFVRiOqPEzL0tLCAJXgFBiR+T
	7wHZHBzMAvISRy5lg4SZBdQlJs1bxAxR/5pR4vHTd4wQ9VoSG/dvZgexWQRUJfYfvQu2gA0o
	vv/FDTBbVCBMYuX0K2DzRQQMJQ7u3s4EMohZ4D2TxLM195lAEsICzhIrzn1lgthwiVHiRvNa
	VpAEp4CBxIFbp8BWSwh8ZJeYfGgvC8Q6AYlvkw+BnSohICux6QAzxGuSEgdX3GCZwCg2C8lD
	sxAemoXkoQWMzKsYRVMLkguKk9KLjPWKE3OLS/PS9ZLzczcxAmPz9L9n/TsY7x6wPsSYDLRx
	IrOUaHI+MLbzSuINjc2MLExNTI2NzC3NSBNWEue9/zApSEggPbEkNTs1tSC1KL6oNCe1+BAj
	EwenVANj/f4rsY1HtRLiP06f8XvSqV6Jysl+InaBa+9FrRR4te7Hh8OB9yvyUnMSFtYU8YvU
	FaiGX2tJ7Co99qtCgTknmZvhzjW7gKC3/ju8LP821ayOcPvf89w969n74hedMyO/5/E7Xpue
	1Xz5t9uiyh9HJnDf8K9eqpw7oT7YXScm4ILu2lXnf71TYinOSDTUYi4qTgQAmaAWwuMCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLKsWRmVeSWpSXmKPExsVy+t9jQV2/bL9gg5ajHBYbZ6xntZj68Amb
	xesXhhZnm96wW9z/epTR4tuVDiaLy7vmsFmsPXKX3eJ24wo2i9PdrA5cHjtn3WX32LSqk83j
	zrU9bB7zTgZ69G1ZxejxeZNcAFtUA6NNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWF
	uZJCXmJuqq2Si0+ArltmDtBhSgpliTmlQKGAxOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDC
	GsaMh1/OMhacFK74+foIawPjD/4uRk4OCQETiZ2fXrFB2GISF+6tB7K5OIQEpjNKzNzbwgKS
	4BUQlPgx+R6QzcHBLCAvceRSNkiYWUBdYtK8RcwQ9a8ZJR4/fccIUa8lsXH/ZnYQm0VAVWL/
	0btgC9iA4vtf3ACzRQXCJFZOvwI2X0TAUOLg7u1MIIOYBd4zSTxbc58JJCEs4Cyx4txXJogN
	lxglbjSvZQVJcAoYSBy4dYp5AqPALCQHzkI4cBaSAxcwMq9iFE0tSC4oTkrPNdQrTswtLs1L
	10vOz93ECI78Z1I7GFc2WBxiFOBgVOLhnZHjGyzEmlhWXJl7iFGCg1lJhFcp1S9YiDclsbIq
	tSg/vqg0J7X4EGMy0HsTmaVEk/OBSSmvJN7Q2MTMyNLI3NDCyNicNGElcd4DrdaBQgLpiSWp
	2ampBalFMFuYODilGhj5tIOS+ETU93Q8LozeNKfsoOKSjisHEt78jOyd8fHX2rSDExdZXrr/
	OuBgkNrU2Ls8d1q2Lspp/3VrxkZPhbxrR3Q+zTnALcm1Vm72tTCOQ2qmRT0/LQUvzvEJj0o9
	80p7n2irS9hixpeuZmuPr/xadMPlXckzM2GLta8tu+oWiii87nh2/EqWEktxRqKhFnNRcSIA
	vXwDNEADAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16/2014 08:02 PM, Krzysztof Kozlowski wrote:
> On śro, 2014-04-16 at 19:51 +0900, Chanwoo Choi wrote:
>> Hi Krzysztof,
>>
>> On 04/16/2014 07:44 PM, Krzysztof Kozlowski wrote:
>>> On śro, 2014-04-16 at 11:28 +0100, Lee Jones wrote:
>>>>> This is first part of fifth version of patchset adding support for
>>>>> MAX77836 device to the max14577 driver.
>>>>>
>>>>> I decided to split the patchset into smaller parts. I hope this would
>>>>> help in getting necessary review/acks from maintainers.
>>>>>
>>>>> The first part introduces changes in max14577 driver and adds support
>>>>> for MAX77836 in MFD, extcon and regulator drivers. Most of these
>>>>> patches already have required acks from maintainers.
>>>>> Full v4 patchset can be found here:
>>>>> http://thread.gmane.org/gmane.linux.kernel/1654267
>>>>
>>>> So what's the plan for this driver now? What's missing? Do you have
>>>> all the Acks you need? If so, I'm happy to apply this patch-set and
>>>> supply a pull-request to the other maintainers.
>>>
>>> Next patches (part 2):
>>> 1. charger: max14577: Add support for MAX77836 charger
>>> 2. power: max17040: Add ID for MAX77836 Fuel Gauge block
>>> 3. regulator/mfd: max14577: Export symbols for calculating charger 
>>>    current
>>> 4. charger: max14577: Configure battery-dependent settings from DTS
>>> 5. Documentation: mfd: max14577: Add device tree bindings document
>>> 6. regulator: max14577: Implement SUSPEND mode for MAX77836 LDO-s
>>>
>>> They are quite independent from each other so I think it would be the
>>> best if you could prepare an immutable branch with first part of
>>> patches.
>>
>> I have to modify all extcon device drivers for some reason,
>> If your patchset including extcon patch apply other git repository,
>> this patchset may have potential merge conflict.
>>
>> If you possible, following patchset would divide two patchset for each mfd/extcon
>> to remove potential merge conflict in 3.15 merge window.
>> - [PATCH v5 0/9] mfd: max14577: Add support for MAX77836
> 
> I think we can resolve this after preparing by Lee the immutable branch
> with this patches. You could pull it so your changes to extcon-max14577
> would be on newest version.

I'm reluctant for your suggestion.
IMO, If Lee agree, I'd like to apply this patchset on extcon git
after getting ack for all patchset from maintainer.
And you would send your patchset (part 2) after 3.15 merge window.

Thanks,
Chanwoo Choi

