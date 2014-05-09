Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751785AbaEIGuG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 02:50:06 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:9901 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880AbaEIGuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 02:50:02 -0400
X-AuditID: cbfee68f-b7eff6d000002b70-a1-536c7a96b8e3
Message-id: <536C7A96.3000906@samsung.com>
Date: Fri, 09 May 2014 15:49:58 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: kgene.kim@samsung.com, t.figa@samsung.com, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, ben-linux@fluff.org, arnd@arndb.de,
        olof@lixom.net, marc.zyngier@arm.com, thomas.abraham@linaro.org,
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
In-reply-to: <535B9A98.3060206@gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA5VSa0iTURjm7Pu+swsoX17yJJggRDe7eulEqfUnPigoKqL6ka35Na05ZdMK
	MzRz5qTp2qqN0cWovExLmgppTs0uNEvN5mWkFmWaOpNklmbO2qXAv/17zvM853neF14e4Wel
	gnlJ0jRWJhVKwqCArAyIlK3RZUj2rZ9QQ+zUvODih/oqCmseNHOwtWk1vvWsncJF47cp7PiW
	y8XtY+UAaz6oSWybzaOwqrgb4raccS42DfZQ2Fp/HWJ9RyMH91l9sLN/HuJ7vZ0c3NrrgFit
	u09ihfkZF1vmVAB/fjpJYb12FOIqvZ3EL/R3ATbWzwF80WmG2FynBdtCmMqblYDJvXAJMr9m
	NYCxFqo4jNM4QjB1hgEuU146BRmTUQmZ/p4GyFTfzWK6XuZQTGGNETAO09I9PocFWxNYSdIp
	VrYu9qggcWB4d6oq5Mz16hoyG9iDCgCfh+hINHbpKunFi9Gb91WwAAh4fvQ9gEZGB7j/TF0P
	OjheQQfQxLvXwPuwAzQ2VQbcLh96FVJOT3iiSHoZqne0eXjo4ptGbNCNA+kDqFzXRXr9i9CM
	9r0HB9DL0Y8rRVx3KEE/gmi0pI3jFvzpnWio2PK37TFA2d13PDPx6ZXIWGL1YIIOR02Ka9CL
	Q1F15VfC/QHRpXzU2jNPeUei0Q9ti6uO5xJCkKmZ8O62BD0ps5FqsNiwYCjDgljDgthiQBhB
	IJsqSpUfE8si1sqFyfJ0qXitKCXZBFwH9Wp+uOgRGGje0gJErsrLRHCgKMV1cNK0+A0R0Rtx
	VGRUxMZNm6P/jw4L8vnw8dheP1osTGNPsmwqK4uXpUtYeQvg8PjB2YB623FnKqBisO933Kbo
	gzN5dLrueZBj2eSO/ENHdjlP51teNsbcUJxDk318ZdW0WXdWW+t76lNXU0O40q60dlZkHU/a
	X5D5dfv2oZyYWsvW85lOxZfkUP+sGYFq/kScLfbjz+8J5LWf5Fhh6/chvb+veEVG/r7mq8ND
	YoktcWV/QRgpTxRuWEXI5MI/7L/fUmYDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAJsWRmVeSWpSXmKPExsVy+t9jQd1pVTnBBtvfmFn8nXSM3WLjjPWs
	FpPWHWCyuLxf22L+kXOsFv1vFrJafP7Qwm5x7tVKRotJ9yewWNz41cZq0bvgKpvF2aY37Bab
	Hl9jtbi8aw6bxYzz+5gsbl/mtfh75x+bxdLrF5ksTl3/zGYxYfpaFovWvUfYLU7+6WW0eHL4
	I6vFjMkv2SzWz3jNYnFsxhJGi1W7/jBatP/dy2axd+dkRgdZjzXz1jB6tDT3sHn8/jWJ0eNy
	Xy+Tx99VL5g9ds66y+6xcvkXNo9NqzrZPO5c28PmsXlJvceVE02sHn1bVjF6fN4kF8Ab1cBo
	k5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQMMGiWFssSc
	UqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYQ1jxt1n/gW9shVzNm9haWB8Ld7FyMkh
	IWAicWXdeSYIW0ziwr31bF2MXBxCAtMZJd7dOsMI4bxmlHj1ZQUjSBWvgJZE5/d3LCA2i4Cq
	xK7PZ8HibEDx/S9usIHYogJhEiunX2GBqBeU+DH5HpgtIqAu8W1KPzvIUGaBHWwSL5edBVst
	LOAt8XTBSahtuxklGq4uZgdJcApoSqxadhnMZhbQkdjfOo0NwpaX2LzmLfMERoFZSJbMQlI2
	C0nZAkbmVYyiqQXJBcVJ6blGesWJucWleel6yfm5mxjB6e+Z9A7GVQ0WhxgFOBiVeHhfTMkO
	FmJNLCuuzD3EKMHBrCTCK5WeEyzEm5JYWZValB9fVJqTWnyIMRkYBhOZpUST84GpOa8k3tDY
	xMzI0sjc0MLI2Jw0YSVx3oOt1oFCAumJJanZqakFqUUwW5g4OKUaGIW3loV4zcwtNecUrrjq
	03nj9OX5no6366M8toSdCpHc/N36v9KKTBML3vfTC/g/qSn2lOa0HeG/fuyv8+kPKxMfPnbf
	d6X1ctGX6Vxhy97Plah18/onrPDROoZ94cSzLX9+aemdujeZ0TXgcILgkyWHwl/LvtWcJFAY
	fC1NYoGC8AcHlyJTaSWW4oxEQy3mouJEAFoOzEXDAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomasz,

On 04/26/2014 08:38 PM, Tomasz Figa wrote:
> On 26.04.2014 02:51, Tomasz Figa wrote:
>> Hi Chanwoo,
>>
>> On 25.04.2014 03:16, Chanwoo Choi wrote:
>>> From: Tomasz Figa <t.figa@samsung.com>
>>>
>>> This patch add new exynos3250.dtsi to support Exynos3250 SoC based on
>>> Cortex-A7
>>> dual core and includes following dt nodes:
>>>
>>> - GIC interrupt controller
>>> - Pinctrl to control GPIOs
>>> - Clock controller
>>> - CPU information (Cortex-A7 dual core)
>>> - UART to support serial port
>>> - MCT (Multi Core Timer)
>>> - ADC (Analog Digital Converter)
>>> - I2C/SPI bus
>>> - Power domain
>>> - PMU (Performance Monitoring Unit)
>>> - MSHC (Mobile Storage Host Controller)
>>> - PWM (Pluse Width Modulation)
>>> - AMBA bus
>>>
>>> Signed-off-by: Tomasz Figa <t.figa@samsung.com>
>>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>>> Signed-off-by: Inki Dae <inki.dae@samsung.com>
>>> Signed-off-by: Hyunhee Kim <hyunhee.kim@samsung.com>
>>> Signed-off-by: Jaehoon Chung <jh80.chung@samsung.com>
>>> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
>>> Cc: Ben Dooks <ben-linux@fluff.org>
>>> Cc: Kukjin Kim <kgene.kim@samsung.com>
>>> Cc: Rob Herring <robh+dt@kernel.org>
>>> Cc: Pawel Moll <pawel.moll@arm.com>
>>> Cc: Mark Rutland <mark.rutland@arm.com>
>>> Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
>>> Cc: Kumar Gala <galak@codeaurora.org>
>>> Cc: Russell King <linux@arm.linux.org.uk>
>>> Cc: devicetree@vger.kernel.org
>>> ---
>>>   arch/arm/boot/dts/exynos3250-pinctrl.dtsi | 477 +++++++++++++++
>>>   arch/arm/boot/dts/exynos3250.dtsi         | 405 +++++++++++++
>>>   arch/arm/boot/dts/exynos4212-tizenw.dts   | 926
>>> ++++++++++++++++++++++++++++++
>>>   3 files changed, 1808 insertions(+)
>>>   create mode 100644 arch/arm/boot/dts/exynos3250-pinctrl.dtsi
>>>   create mode 100644 arch/arm/boot/dts/exynos3250.dtsi
>>>   create mode 100644 arch/arm/boot/dts/exynos4212-tizenw.dts
>>>
>>> diff --git a/arch/arm/boot/dts/exynos3250-pinctrl.dtsi
>>> b/arch/arm/boot/dts/exynos3250-pinctrl.dtsi
>>> new file mode 100644
>>> index 0000000..976490b
>>> --- /dev/null
>>> +++ b/arch/arm/boot/dts/exynos3250-pinctrl.dtsi
>>> @@ -0,0 +1,477 @@
>>> +/*
>>> + * Samsung's Exynos3250 SoCs pin-mux and pin-config device tree source
>>> + *
>>> + * Copyright (c) 2014 Samsung Electronics Co., Ltd.
>>> + *        http://www.samsung.com
>>> + *
>>> + * Samsung's Exynos3250 SoCs pin-mux and pin-config optiosn are
>>> listed as device
>>> + * tree nodes are listed in this file.
>>> + *
>>> + * This program is free software; you can redistribute it and/or modify
>>> + * it under the terms of the GNU General Public License version 2 as
>>> + * published by the Free Software Foundation.
>>> +*/
>>> +
>>> +/ {
>>> +    pinctrl@11400000 {
>>
>> Could you use references instead of re-specifying the whole tree
>> hierarchy in every file a node is used?
>>
>> Instead of
>>
>> / {
>>      pinctrl@11400000 {
>>
>>      };
>> };
>>
>> one may simply use
>>
>> &pinctrl_0 {
>>
>> };
>>
>> You might just need to change the location of #include
>> "exynos3250-pinctrl.dtsi" from top of exynos3250.dtsi to bottom of it.
> 
> Oh, well, you also should move all nodes of on-SoC devices under a simple-bus node called soc. You can see the patch adding dts file for Exynos5260 for an example [1].
> 
> [1] http://thread.gmane.org/gmane.linux.kernel.samsung-soc/29360/focus=29361


OK, I'll move nodes dependent on SoC under 'soc' dt node as example patch[1] except for 'amba-bus' dt node.

Thanks,
Chanwoo Choi

