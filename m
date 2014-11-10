Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751855AbaKJBDL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 20:03:11 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:29942 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538AbaKJBDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 20:03:08 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee68e-f79b46d000002b74-95-54600ec71ffa
Content-transfer-encoding: 8BIT
Message-id: <54600EC7.4020008@samsung.com>
Date: Mon, 10 Nov 2014 10:03:03 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
To: Kukjin Kim <kgene@kernel.org>
Cc: "'Krzysztof Kozlowski'" <k.kozlowski@samsung.com>,
        "'Ben Dooks'" <ben-linux@fluff.org>,
        "'Rob Herring'" <robh+dt@kernel.org>,
        "'Pawel Moll'" <pawel.moll@arm.com>,
        "'Mark Rutland'" <mark.rutland@arm.com>,
        "'Ian Campbell'" <ijc+devicetree@hellion.org.uk>,
        "'Kumar Gala'" <galak@codeaurora.org>,
        "'Russell King'" <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'BartlomiejZolnierkiewicz'" <b.zolnierkie@samsung.com>
Subject: Re: [PATCH] ARM: dts: Fix booting on Rinato market device
References: <1415360662-30390-1-git-send-email-k.kozlowski@samsung.com>
 <545CB220.9030007@samsung.com> <1415361564.31102.2.camel@AMDC1943>
 <004701cffb3d$1edef9e0$5c9ceda0$@kernel.org>
In-reply-to: <004701cffb3d$1edef9e0$5c9ceda0$@kernel.org>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNIsWRmVeSWpSXmKPExsWyRsSkUPc4X0KIwccrJhYbZ6xntZi07gCT
	xfwj51gt+t8sZLU492olo8XrF4YW/Y9fM1ucbXrDbrHp8TVWi8u75rBZzDi/j8ni9mVei6XX
	LzJZTJi+lsWide8Rdgd+jzXz1jB6tDT3sHlc7utl8vi76gWzx8rlX9g8Nq3qZPPYvKTeo2/L
	KkaPz5vkAjijuGxSUnMyy1KL9O0SuDJmnO9kKbggUrGnexFzA2OfYBcjJ4eEgInEgQ39LBC2
	mMSFe+vZuhi5OIQEljJKzDl7jwWmaO++l8wQiUWMEkvP3wJL8AoISvyYDFLEwcEsIC9x5FI2
	SJhZQF1i0rxFUPWvGSX6rx1hg6jXkpj2dDpYL4uAqsTlmQ9YQWw2oPj+FzfAakQFwiRWTr8C
	NlNEQFFi8wIFiJk7WSSmfxYHsYUFnCQW7noFdehuRok/t9YygSQ4BSwlPi6ezwKSkBBYyCHx
	8/hrJohlAhLfJh8CGyohICux6QAzxGOSEgdX3GCZwCg2C8k7sxDemYXknQWMzKsYRVMLkguK
	k9KLjPSKE3OLS/PS9ZLzczcxAuP89L9nfTsYbx6wPsQowMGoxMPr8DY+RIg1say4MvcQoynQ
	EROZpUST84HJJK8k3tDYzMjC1MTU2Mjc0kxJnDdB6mewkEB6YklqdmpqQWpRfFFpTmrxIUYm
	Dk6pBka+HxzN7sckN5lNFje8VHPQfOe8+ifMTNzrA4T3fVDYnRk/8aTSn1ePXh371/L58o8Q
	Re6LxQ9dVgV/j9B7HpfPyH6h0aGhYXn3V9+i3Ssu5Ly6vVy0dUqt43JOP7Wqmy+XaUddjvrv
	FVT9pOhoedDSc93X7/0pZOy6XTTHJu7nw6V/SvT6pjoqsRRnJBpqMRcVJwIAAYePtO4CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKKsWRmVeSWpSXmKPExsVy+t9jAd3jfAkhBrPn6FhsnLGe1WLSugNM
	FvOPnGO16H+zkNXi3KuVjBavXxha9D9+zWxxtukNu8Wmx9dYLS7vmsNmMeP8PiaL25d5LZZe
	v8hkMWH6WhaL1r1H2B34PdbMW8Po0dLcw+Zxua+XyePvqhfMHiuXf2Hz2LSqk81j85J6j74t
	qxg9Pm+SC+CMamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ
	0HXLzAF6QEmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMOYMeN8J0vBBZGK
	Pd2LmBsY+wS7GDk5JARMJPbue8kMYYtJXLi3nq2LkYtDSGARo8TS87dYQBK8AoISPybfA7I5
	OJgF5CWOXMoGCTMLqEtMmreIGaL+NaNE/7UjbBD1WhLTnk4H62URUJW4PPMBK4jNBhTf/+IG
	WI2oQJjEyulXwGaKCChKbF6gADFzJ4vE9M/iILawgJPEwl2voO7ZzSjx59ZaJpAEp4ClxMfF
	81kmMArMQnLeLITzZiE5bwEj8ypG0dSC5ILipPRcQ73ixNzi0rx0veT83E2M4CTyTGoH48oG
	i0OMAhyMSjy8Dm/jQ4RYE8uKK3MPMUpwMCuJ8Nb+BwrxpiRWVqUW5ccXleakFh9iNAV6biKz
	lGhyPjDB5ZXEGxqbmBlZGpkbWhgZmyuJ8x5otQ4UEkhPLEnNTk0tSC2C6WPi4JRqYPRySO7v
	eT//wyf/k7n7u44s/WWsr+uurbT0177tAgq/bx1M2rf80u8fB+9+Od3w5rBZqV+Q1Kn+ab85
	lNnXZH9r+GjPv4dTfn9zn8vLph/vDDRVmj9Mvef7J367Me+BG49VUz7w7JoeYscgZ5V/1stq
	7e8WQY/sywftez1i5z79pip5RUHESlOJpTgj0VCLuag4EQDS8Qn6OAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Kukjin,

On 11/08/2014 07:16 PM, Kukjin Kim wrote:
> Krzysztof Kozlowski wrote:
>>
>> On pią, 2014-11-07 at 20:50 +0900, Chanwoo Choi wrote:
>>> Hi Krzysztof,
>>>
>>> On 11/07/2014 08:44 PM, Krzysztof Kozlowski wrote:
>>>> The bootloader on market Rinato (Gear 2) device checks for revision in
>>>> compatible field of DTB. If it is not present or lower than required
>>>> then booting fails with: "Could not do normal boot. (no DTB found)".
>>>>
>>>> Log of bootloader in case of failure:
>>>> h/w: revision  = 0x06
>>>> h/w: schematic = SM-R380_Rev0.5_Final_0205
>>>> date = 2000/01/01 12:00:21 (UTC)
>>>> cmu_div:4, div:5, src_clk:800000000, pixel_clk:31860720
>>>> load_kernel: loading boot image from 57344.. (BOOT)
>>>> load_kernel: found zImage, size: 0x3267e8
>>>> 0xbc Error!
>>>> Verify_Binary_Signature: failed.
>>>> pit_check_signature (BOOT) invalid.
>>>> load_kernel: found custom kernel (ret:-2147483647)
>>>>  No need to update kernel type.
>>>> Detected board: samsung,rinato-rev06
>>>> Could not do normal boot. (no DTB found)
>>>> : Entering usb mode for SM-R380_EUR_XX (65535)..
>>>>
>>>> Add a "rev06" suffix to compatible to satisfy the bootloader.
>>>>
>>>> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
>>>> ---
>>>>  arch/arm/boot/dts/exynos3250-rinato.dts | 3 ++-
>>>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/arch/arm/boot/dts/exynos3250-rinato.dts b/arch/arm/boot/dts/exynos3250-rinato.dts
>>>> index 84380fa13e37..f72ba0a1d915 100644
>>>> --- a/arch/arm/boot/dts/exynos3250-rinato.dts
>>>> +++ b/arch/arm/boot/dts/exynos3250-rinato.dts
>>>> @@ -18,7 +18,8 @@
>>>>
>>>>  / {
>>>>  	model = "Samsung Rinato board";
>>>> -	compatible = "samsung,rinato", "samsung,exynos3250", "samsung,exynos3";
>>>> +	compatible = "samsung,rinato", "samsung,rinato-rev06",
>>>> +			"samsung,exynos3250", "samsung,exynos3";
>>>
>>> I think it is wrong. The released bootloader from Samsung is not u-boot.
>>> Instead, you have to update u-boot to support Exynos3250-basd Rinato board.
>>
>> The bootloader on device also was not a u-boot. So the fix is for native
>> bootloader delivered on device.
>>
>> I do not insist that this is proper fix. It was just needed to boot the
>> device with custom kernel.
>>
>> Anyway, thanks for comments!
>>
> Hi Krzysztof and Chanwoo,
> 
> So, we don’t need this to fix the problem Krzysztof said? OK.

Yes.
The released bootloader from Samsung is not general and not opened.
We have to support Exynos3250-based Rinato on general bootloader.

Beset Regards,
Chanwoo Choi
