Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225AbaEIIP3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 04:15:29 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:31748 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316AbaEIIPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 04:15:15 -0400
X-AuditID: cbfee68e-b7fd86d0000038e3-a7-536c8e90b8ae
Message-id: <536C8E90.6030607@samsung.com>
Date: Fri, 09 May 2014 17:15:12 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Tomasz Figa <t.figa@samsung.com>
Cc: Tomasz Figa <tomasz.figa@gmail.com>, kgene.kim@samsung.com,
        linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        ben-linux@fluff.org, arnd@arndb.de, olof@lixom.net,
        marc.zyngier@arm.com, thomas.abraham@linaro.org,
        kyungmin.park@samsung.com, inki.dae@samsung.com,
        sw0312.kim@samsung.com, hyunhee.kim@samsung.com, yj44.cho@samsung.com,
        chanho61.park@samsung.com, sajjan.linux@gmail.com,
        tushar.behera@linaro.org, sachin.kamat@linaro.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: Re: [PATCHv4 7/7] ARM: dts: Add device tree sources for Exynos3250
References: <1398388572-30239-1-git-send-email-cw00.choi@samsung.com>
 <1398388572-30239-8-git-send-email-cw00.choi@samsung.com>
 <535B0324.50705@gmail.com> <535B9A98.3060206@gmail.com>
 <536C7A96.3000906@samsung.com> <536C8B48.90706@samsung.com>
In-reply-to: <536C8B48.90706@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA5WSeUiTYRzHefYe2yzhbTl7tAtnBtnllT0dRIjBWxJIVlAENtebWh5rs6jo
	EI8Oj7Uj3ZodWkptraxZoJFuLlke6bSZB5omHVgaVDNRa9EOAv/tv8/z/X35fn8P/DgY7zUR
	yEnNyGIkGcI0AemDG/yixKsVsrSEMHMMciqtbPRYU00g5UMzC9lNK9Gtpg4CXRmvIJDjWx4b
	dXzRAaQcluOob+YCgYrL35CoPWecjYzvewhkf3adRBpbAwsN2H2Rc/APiap6u1iotddBIrn6
	AY7y65vYqOV3MUAfXnwnkEb1mUTVmjEcWTWVAOmf/QboorOeRPV1KrB1MW24aQB0Xm4RSf+a
	UQLaLitm0U79KEbXad+yad3dCZI26i+T9GDPc5KuqTxPdzfnELTsiR7QDuOSeN/9PpsPMWmp
	JxjJ2i0HfVJ6uyYwcW3QyV/jDVg2aF1YALgcSEXBn5M/2V72h51D1WQB8OHwqCoAf7SUEP9M
	VaMOwjtQA6hzXgbexxiAhYW1mNvlS4VCRdFV0s04FQLLBkZwN5Mu3TTa59H51F6oU3fjXv88
	OKUa8rAftQzaW9WeUIxqI2Fv/oSnej4VBz+WtwA386hpAEtnDrqZS62A7e1THh2jVkFTfinp
	5aWwxvAVcwdB6j4X5qo/sr0bUXBSZXG1cVyDxdBoxrxfC4CN9/pwOfDXztpJOytWOyu2HGB6
	wGfEIrE0KVkSsUYqTJcez0heI8pMNwLXPbX9+SSrBf3mTRYgclUqsEC+KNN1bxlZieGR0RFo
	XdS6yIj1G6L/TxYs8L09krSLRyULs5ijDCNmJImS42mM1AJYHG5gNuAHHa6ILsm2hIAPn+L6
	h/dfm6jf5ugfuEHIbenKrTuli/ZsD94h3NdQW3pqSePQnOC87kWygkfjcIUo5lBQcy7un3kk
	zCozUcu1L8+kHLsjsB0IsM+NexyZuMX2tHNm49n4TTW6S69404oEW0lqpPNcbFez1XS6bHfO
	6nfvq1SxZgEuTRGGh2ISqfAv4kZ1n2UDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAJsWRmVeSWpSXmKPExsVy+t9jQd0JfTnBBo/3GVr8nXSM3WLjjPWs
	FpPWHWCyuLxf22L+kXOsFv1vFrJafP7Qwm5x7tVKRotJ9yewWNz41cZq0bvgKpvF2aY37Bab
	Hl9jtbi8aw6bxYzz+5gsbl/mtfh75x+bxdLrF5ksTl3/zGYxYfpaFovWvUfYLU7+6WW0eHL4
	I6vFjMkv2SzWz3jNYnFsxhJGi1W7/jBatP/dy2axd+dkRgdZjzXz1jB6tDT3sHn8/jWJ0eNy
	Xy+Tx99VL5g9ds66y+6xcvkXNo9NqzrZPO5c28PmsXlJvceVE02sHn1bVjF6fN4kF8Ab1cBo
	k5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQMMGiWFssSc
	UqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYQ1jxvWLX5gLdihW/H6zj7mB8ZR0FyMn
	h4SAicTSF59ZIWwxiQv31rN1MXJxCAlMZ5RY+beTEcJ5zSjR3b2DGaSKV0BLYmLPFDYQm0VA
	VWL27YcsIDYbUHz/ixtgcVGBMImV06+wQNQLSvyYfA/MFhFQkbh8ajrYUGaB02wS11u/gK0W
	FvCWeLrgJCOILSTwk1Fi2q8EEJtTQFPi7NkfYHFmAR2J/a3T2CBseYnNa94yT2AUmIVkxywk
	ZbOQlC1gZF7FKJpakFxQnJSea6RXnJhbXJqXrpecn7uJEZz+nknvYFzVYHGIUYCDUYmH98WU
	7GAh1sSy4srcQ4wSHMxKIrwevTnBQrwpiZVVqUX58UWlOanFhxiTgUEwkVlKNDkfmJrzSuIN
	jU3MjCyNzA0tjIzNSRNWEuc92GodKCSQnliSmp2aWpBaBLOFiYNTqoFxftW2xuBJ12bWtoXe
	vja1Q8n1YKZJMm/QXpZvuyZESvU/YX23wSav7S/fx1Nruy5dKLr/rtFFPFJVuCLJeOcZybKe
	mKv2ZbeWXL7B6uu4VuLbjS3nayT7owJ/9h7IWKN65dhB/SmanvyRRc2Hnkn4aMRw/t8jI23y
	de+lKYHL063CX+9TO2SkxFKckWioxVxUnAgAcmpIt8MDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomasz,

On 05/09/2014 05:01 PM, Tomasz Figa wrote:
> On 09.05.2014 08:49, Chanwoo Choi wrote:
>> Hi Tomasz,
>>
>> On 04/26/2014 08:38 PM, Tomasz Figa wrote:
>>> On 26.04.2014 02:51, Tomasz Figa wrote:
>>>> Hi Chanwoo,
>>>>
>>>> On 25.04.2014 03:16, Chanwoo Choi wrote:
>>>>> From: Tomasz Figa <t.figa@samsung.com>
>>>>>
>>>>> This patch add new exynos3250.dtsi to support Exynos3250 SoC based on
>>>>> Cortex-A7
>>>>> dual core and includes following dt nodes:
>>>>>
>>>>> - GIC interrupt controller
>>>>> - Pinctrl to control GPIOs
>>>>> - Clock controller
>>>>> - CPU information (Cortex-A7 dual core)
>>>>> - UART to support serial port
>>>>> - MCT (Multi Core Timer)
>>>>> - ADC (Analog Digital Converter)
>>>>> - I2C/SPI bus
>>>>> - Power domain
>>>>> - PMU (Performance Monitoring Unit)
>>>>> - MSHC (Mobile Storage Host Controller)
>>>>> - PWM (Pluse Width Modulation)
>>>>> - AMBA bus
>>>>>
>>>>> Signed-off-by: Tomasz Figa <t.figa@samsung.com>
>>>>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>>>>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>>>>> Signed-off-by: Inki Dae <inki.dae@samsung.com>
>>>>> Signed-off-by: Hyunhee Kim <hyunhee.kim@samsung.com>
>>>>> Signed-off-by: Jaehoon Chung <jh80.chung@samsung.com>
>>>>> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
>>>>> Cc: Ben Dooks <ben-linux@fluff.org>
>>>>> Cc: Kukjin Kim <kgene.kim@samsung.com>
>>>>> Cc: Rob Herring <robh+dt@kernel.org>
>>>>> Cc: Pawel Moll <pawel.moll@arm.com>
>>>>> Cc: Mark Rutland <mark.rutland@arm.com>
>>>>> Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
>>>>> Cc: Kumar Gala <galak@codeaurora.org>
>>>>> Cc: Russell King <linux@arm.linux.org.uk>
>>>>> Cc: devicetree@vger.kernel.org
>>>>> ---
>>>>>   arch/arm/boot/dts/exynos3250-pinctrl.dtsi | 477 +++++++++++++++
>>>>>   arch/arm/boot/dts/exynos3250.dtsi         | 405 +++++++++++++
>>>>>   arch/arm/boot/dts/exynos4212-tizenw.dts   | 926
>>>>> ++++++++++++++++++++++++++++++
>>>>>   3 files changed, 1808 insertions(+)
>>>>>   create mode 100644 arch/arm/boot/dts/exynos3250-pinctrl.dtsi
>>>>>   create mode 100644 arch/arm/boot/dts/exynos3250.dtsi
>>>>>   create mode 100644 arch/arm/boot/dts/exynos4212-tizenw.dts
>>>>>
>>>>> diff --git a/arch/arm/boot/dts/exynos3250-pinctrl.dtsi
>>>>> b/arch/arm/boot/dts/exynos3250-pinctrl.dtsi
>>>>> new file mode 100644
>>>>> index 0000000..976490b
>>>>> --- /dev/null
>>>>> +++ b/arch/arm/boot/dts/exynos3250-pinctrl.dtsi
>>>>> @@ -0,0 +1,477 @@
>>>>> +/*
>>>>> + * Samsung's Exynos3250 SoCs pin-mux and pin-config device tree source
>>>>> + *
>>>>> + * Copyright (c) 2014 Samsung Electronics Co., Ltd.
>>>>> + *        http://www.samsung.com
>>>>> + *
>>>>> + * Samsung's Exynos3250 SoCs pin-mux and pin-config optiosn are
>>>>> listed as device
>>>>> + * tree nodes are listed in this file.
>>>>> + *
>>>>> + * This program is free software; you can redistribute it and/or modify
>>>>> + * it under the terms of the GNU General Public License version 2 as
>>>>> + * published by the Free Software Foundation.
>>>>> +*/
>>>>> +
>>>>> +/ {
>>>>> +    pinctrl@11400000 {
>>>>
>>>> Could you use references instead of re-specifying the whole tree
>>>> hierarchy in every file a node is used?
>>>>
>>>> Instead of
>>>>
>>>> / {
>>>>      pinctrl@11400000 {
>>>>
>>>>      };
>>>> };
>>>>
>>>> one may simply use
>>>>
>>>> &pinctrl_0 {
>>>>
>>>> };
>>>>
>>>> You might just need to change the location of #include
>>>> "exynos3250-pinctrl.dtsi" from top of exynos3250.dtsi to bottom of it.
>>>
>>> Oh, well, you also should move all nodes of on-SoC devices under a simple-bus node called soc. You can see the patch adding dts file for Exynos5260 for an example [1].
>>>
>>> [1] http://thread.gmane.org/gmane.linux.kernel.samsung-soc/29360/focus=29361
>>
>>
>> OK, I'll move nodes dependent on SoC under 'soc' dt node as example patch[1] except for 'amba-bus' dt node.
> 
> I don't see any reason why amba-bus node shouldn't be under soc node as
> well. Any on-chip devices should be.

I didn't understand the correct meaning of 'simple-bus'.
OK, I'll move 'amba-bus' dt node under 'soc' dt node.

Best Regards,
Chanwoo Choi



