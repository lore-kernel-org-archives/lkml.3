Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756165AbaDPKvy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 06:51:54 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:16116 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755861AbaDPKvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 06:51:47 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee690-b7f266d00000287c-64-534e60c1dc16
Content-transfer-encoding: 8BIT
Message-id: <534E60C6.4080005@samsung.com>
Date: Wed, 16 Apr 2014 19:51:50 +0900
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
In-reply-to: <1397645078.6147.11.camel@AMDC1943>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHIsWRmVeSWpSXmKPExsWyRsSkWPdggl+wwZ25lhYbZ6xntZj68Amb
	xesXhhZnm96wW9z/epTR4tuVDiaLy7vmsFmsPXKX3eJ24wo2i9PdrA5cHjtn3WX32LSqk83j
	zrU9bB7zTgZ69G1ZxejxeZNcAFsUl01Kak5mWWqRvl0CV8bdy39YC17wVey4HNDA2MrTxcjJ
	ISFgInHgQQsjhC0mceHeerYuRi4OIYGljBINqy4xwRTNW3sArEhIYBGjxLmrriA2r4CgxI/J
	91i6GDk4mAXkJY5cygYJMwuoS0yat4gZYs5rRolDB14yQtRrSWxe/5IZxGYRUJWY+uQEWJwN
	KL7/xQ02EFtUIExi5fQrLCC2iIChxMHd25lABjELvGeSeLbmPthBwgLOEivOfWWC2NDLKDH3
	5z2wSZwCBhLfH51lBUlICHxkl3j/uIMNYp2AxLfJh8BOlRCQldh0gBniM0mJgytusExgFJuF
	5KFZCA/NQvLQAkbmVYyiqQXJBcVJ6UUmesWJucWleel6yfm5mxiBcXn637MJOxjvHbA+xJgM
	tHEis5Rocj4wrvNK4g2NzYwsTE1MjY3MLc1IE1YS51V7lBQkJJCeWJKanZpakFoUX1Sak1p8
	iJGJg1OqgTHa7kD3tzfJl8+ncujNi0hOe/7fde4NwV0iaS1vF0k3GjCVKil9LKl9HbPjY/lx
	e6Ec7u8pnM+utcXW3FPKP7BwXcO02bbZ+n/7fjt+uHWyU4LlziP3paZ627QZZ65wOPXysLXc
	PB3JlawPdWMU7Zsa8+xOO8yb6Pr1roVZs3Yp42XJEN20dUosxRmJhlrMRcWJALQSYh/hAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNKsWRmVeSWpSXmKPExsVy+t9jAd2DCX7BBrd2GFhsnLGe1WLqwyds
	Fq9fGFqcbXrDbnH/61FGi29XOpgsLu+aw2ax9shddovbjSvYLE53szpweeycdZfdY9OqTjaP
	O9f2sHnMOxno0bdlFaPH501yAWxRDYw2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW
	5koKeYm5qbZKLj4Bum6ZOUCHKSmUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ
	axgz7l7+w1rwgq9ix+WABsZWni5GTg4JAROJeWsPMELYYhIX7q1nA7GFBBYxSpy76gpi8woI
	SvyYfI+li5GDg1lAXuLIpWyQMLOAusSkeYuYuxi5gMpfM0ocOvCSEaJeS2Lz+pfMIDaLgKrE
	1CcnwOJsQPH9L26AzRcVCJNYOf0KC4gtImAocXD3diaQQcwC75kknq25zwSSEBZwllhx7isT
	xIZeRom5P++BTeIUMJD4/ugs6wRGgVlIDpyFcOAsJAcuYGRexSiaWpBcUJyUnmukV5yYW1ya
	l66XnJ+7iREc9c+kdzCuarA4xCjAwajEwzszxzdYiDWxrLgy9xCjBAezkghvY6RfsBBvSmJl
	VWpRfnxRaU5q8SHGZKD3JjJLiSbnAxNSXkm8obGJmZGlkbmhhZGxOWnCSuK8B1utA4UE0hNL
	UrNTUwtSi2C2MHFwSjUwSvs07wp6d80itDxrNZ8B18Ot09/p2h+576bTlVwuNNFJ55luh+gq
	sxuT6ze/TZ1q0dx2oXKFrXOnydKtU8VNX62+yng+u1u/5rYlmyhbgMJvy1kmy0+HWro06kbl
	/I8U7EyXZ3rK9oi97SnP0R9auTk323dImbcfFdKW+Bv5/dJt0xqOzAYlluKMREMt5qLiRADC
	gBPqPgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Krzysztof,

On 04/16/2014 07:44 PM, Krzysztof Kozlowski wrote:
> On śro, 2014-04-16 at 11:28 +0100, Lee Jones wrote:
>>> This is first part of fifth version of patchset adding support for
>>> MAX77836 device to the max14577 driver.
>>>
>>> I decided to split the patchset into smaller parts. I hope this would
>>> help in getting necessary review/acks from maintainers.
>>>
>>> The first part introduces changes in max14577 driver and adds support
>>> for MAX77836 in MFD, extcon and regulator drivers. Most of these
>>> patches already have required acks from maintainers.
>>> Full v4 patchset can be found here:
>>> http://thread.gmane.org/gmane.linux.kernel/1654267
>>
>> So what's the plan for this driver now? What's missing? Do you have
>> all the Acks you need? If so, I'm happy to apply this patch-set and
>> supply a pull-request to the other maintainers.
> 
> Next patches (part 2):
> 1. charger: max14577: Add support for MAX77836 charger
> 2. power: max17040: Add ID for MAX77836 Fuel Gauge block
> 3. regulator/mfd: max14577: Export symbols for calculating charger 
>    current
> 4. charger: max14577: Configure battery-dependent settings from DTS
> 5. Documentation: mfd: max14577: Add device tree bindings document
> 6. regulator: max14577: Implement SUSPEND mode for MAX77836 LDO-s
> 
> They are quite independent from each other so I think it would be the
> best if you could prepare an immutable branch with first part of
> patches.

I have to modify all extcon device drivers for some reason,
If your patchset including extcon patch apply other git repository,
this patchset may have potential merge conflict.

If you possible, following patchset would divide two patchset for each mfd/extcon
to remove potential merge conflict in 3.15 merge window.
- [PATCH v5 0/9] mfd: max14577: Add support for MAX77836

Thanks,
Chanwoo Choi
