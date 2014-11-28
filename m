Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751735AbaK1NvL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 08:51:11 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:57524 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465AbaK1NvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 08:51:06 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-16-54787dc73113
Message-id: <54787DC7.3040600@samsung.com>
Date: Fri, 28 Nov 2014 22:51:03 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "jh80.chung@samsung.com" <jh80.chung@samsung.com>,
        "geunsik.lim@samsung.com" <geunsik.lim@samsung.com>,
        "kgene.kim@samsung.com" <kgene.kim@samsung.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "tomasz.figa@gmail.com" <tomasz.figa@gmail.com>,
        "a.kesavan@samsung.com" <a.kesavan@samsung.com>,
        "inki.dae@samsung.com" <inki.dae@samsung.com>,
        "sw0312.kim@samsung.com" <sw0312.kim@samsung.com>,
        "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
        "thomas.abraham@linaro.org" <thomas.abraham@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "s.nawrocki@samsung.com" <s.nawrocki@samsung.com>,
        "olof@lixom.net" <olof@lixom.net>,
        "chanho61.park@samsung.com" <chanho61.park@samsung.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 16/19] arm64: dts: exynos: Add dts files for 64-bit
 Exynos5433 SoC
References: <1417073716-22997-1-git-send-email-cw00.choi@samsung.com>
 <1417073716-22997-17-git-send-email-cw00.choi@samsung.com>
 <5476FC55.1020606@arm.com>
In-reply-to: <5476FC55.1020606@arm.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01Sa0hTURz37N7dXVfKbU47GT0YWKJlqZueSKQvwa1PllJZgq15U0nn3PUV
	FIn5AEtbLnAMU/ExUwfCtNCVr1lqL1M0HakzskxxYiWUmo72KPLb7/xe5/fhT2KCddyXTJZn
	MEq5NEVE8HG9UJx+eOBmTszRmlZ/NKuv5aDNsn4eWtbdBWi0OxBVPR/iog1VAYHKZlQ4Mq8X
	clFJ9XsCvc2z8tCDjQYOMsyOc9GosYJAmndd9vyUjUD1EyMc9GpihUB91iIu0qgXCNSvqQOo
	ybgB0ML3QfyED62v1AP693oZoDu00zx6avwZQbfW3aLHBvO4dGlbE6BXDHujyIv8iAQmJTmL
	UR6JvMxPUpsrgKJYmFNSxOaCr57FwJ2ElBi2rViBC/vAYUsLUQz4pICqB3DSquH9M9U2NwKX
	UA7gYvtLnuuxCOCdkYdOlwcVAEc38gkHxik/2DOkwh2YsPPd82Yn702dg43lY7jLvwOuqi1O
	LKQOwi/35pylGDVLQlOvDXMIXtQF2Nk5zXH9VgXgD1WNs8ndnmguMNoF0p4IgjMjAQ4ao/bB
	Vv0S5po9TMKBshuuQRT8qTbhDjuk9kBDz1/LLtj7yIyrgI92yyTt/1LtltJqgDUBb0YhU7BX
	EpXiIFaaymbKE4NkaakGYD+J17Y5VTuw9Bw3AYoEou0eq7bsGAFXmsVeTzUBiX3EfczXW5Zm
	vyJ5RnxwaFgIkogloSHhx8JEOz0WfdeiBVSiNIO5xjAKRhmvzExhWBPgkO6+ucBz3uvp0pOu
	hE9+AxKvdMXpbvrQcrxRUiiMxj7ouqKmN8PjSg9MNCjPfqs8c0pW7s9P0Mdw9tO6KK7UnE70
	xQ7N46rNYIuupC9faN3t1my0fD4ruHT1fPZUbrugQLRNhK112PobP1a90d/u9vsVe7LF5PZC
	M/V4UhyJaQPjIkQ4myQNDsCUrPQPuZFTuQ0DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKKsWRmVeSWpSXmKPExsVy+t9jQd3jtRUhBp8fylo8XrOYyeLvpGPs
	Fu+X9TBaXN6vbTH/yDlWiz8TWtksJt2fwGJx41cbq0XvgqtsFmeb3rBbTPmznMli0+NrrBaX
	d81hs5hxfh9Q/51/bBZLr19ksjh1/TObxeE37awWMya/ZLM4NmMJo8WqXX8YLV5+PMHiIOax
	Zt4aRo/fvyYxeuycdZfd4861PWwem5fUe1w50cTq0bdlFaPH501yARxRDYw2GamJKalFCql5
	yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUD/KSmUJeaUAoUCEouLlfTt
	ME0IDXHTtYBpjND1DQmC6zEyQAMJaxgzJt+Yw1jQJVLR217cwPicr4uRk0NCwERi8eqVjBC2
	mMSFe+vZuhi5OIQEpjNKvN5xkh3Cec0o0X1xLjtIFa+AlsTlPy1sIDaLgKrEgXMTWEBsNqD4
	/hc3wOKiAmESK6dfYYGoF5T4MfkemC0ioC7xtP8Z2FBmgcccEocO/mMGSQgLREjs3XuXCWLb
	fEaJTxMWgU3iBOpY3boLKMEB1KEncf+iFkiYWUBeYvOat8wTGAVmIdkxC6FqFpKqBYzMqxhF
	UwuSC4qT0nMN9YoTc4tL89L1kvNzNzGCk9AzqR2MKxssDjEKcDAq8fD++FceIsSaWFZcmXuI
	UYKDWUmEN72kIkSINyWxsiq1KD++qDQntfgQoykwBCYyS4km5wMTZF5JvKGxiZmRpZG5oYWR
	sbmSOO+Nm7khQgLpiSWp2ampBalFMH1MHJxSDYyLhTROpD+e+btn21Hf3+qu8z1W3swTzd22
	3ODfx75jPB6d2Xvu3pZ5xBB36b5fqNn1BXPu1Nrdv5wwz4F//w+WgtuXvVkPHPLir9Y0PfQo
	dpEHJ0PlpA1mcp4/WX1jbz8t59FgXhm/+cPWyqfXTDcdj33OvrC2unlFts1Zhq4XxcuXzbD8
	uZNNiaU4I9FQi7moOBEAhOISUVgDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Marc,

On 11/27/2014 07:26 PM, Marc Zyngier wrote:
> On 27/11/14 07:35, Chanwoo Choi wrote:
>> This patch adds new Exynos5433 dtsi to support 64-bit Exynos5433 SoC
>> based on Octal core CPUs (quad Cortex-A57 and quad Cortex-A53).
>>
>> Cc: Kukjin Kim <kgene.kim@samsung.com>
>> Cc: Mark Rutland <mark.rutland@arm.com>
>> Cc: Arnd Bergmann <arnd@arndb.de>
>> Cc: Olof Johansson <olof@lixom.net>
>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>> Cc: Will Deacon <will.deacon@arm.com>
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> Acked-by: Inki Dae <inki.dae@samsung.com>
>> Acked-by: Geunsik Lim <geunsik.lim@samsung.com>
>> ---
>>  arch/arm64/boot/dts/exynos/exynos5433-pinctrl.dtsi | 698 +++++++++++++++++++++
>>  arch/arm64/boot/dts/exynos/exynos5433.dtsi         | 523 +++++++++++++++
>>  2 files changed, 1221 insertions(+)
>>  create mode 100644 arch/arm64/boot/dts/exynos/exynos5433-pinctrl.dtsi
>>  create mode 100644 arch/arm64/boot/dts/exynos/exynos5433.dtsi
>>
> 
> [...]
> 
>> diff --git a/arch/arm64/boot/dts/exynos/exynos5433.dtsi b/arch/arm64/boot/dts/exynos/exynos5433.dtsi
>> new file mode 100644
>> index 0000000..3d8b576
>> --- /dev/null
>> +++ b/arch/arm64/boot/dts/exynos/exynos5433.dtsi
> 
> [...]
> 
>> +               timer {
>> +                       compatible = "arm,armv8-timer";
>> +                       interrupts = <1 13 0xff01>,
>> +                                    <1 14 0xff01>,
>> +                                    <1 11 0xff01>,
>> +                                    <1 10 0xff01>;
> 
> This is wrong. Timer interrupts for both A53 and A57 are level triggered.

I'll fix it level triggering instead of edge triggering.

If possible, could you give the document url to check the correct type of level trigger?
whether irq is high level trigger or low level trigger.

> 
>> +                       clock-frequency = <24000000>;
> 
> Please go and fix your firmware. Really...
> 
>> +                       use-clocksource-only;
>> +                       use-physical-timer;
>> +               };
> 
> Well, that's a total NAK. Neither of these properties are part of the
> binding, and we've already established that none of that would never be
> valid on arm64.
> 
> I suggest you finally do what we've been asking for years, which is to
> fix your boot ROM by adding the 5 lines of assembly code that are needed
> instead of repeatedly post the same bogus DT files.

I'll remove last three properties.

Best Regards,
Chanwoo Choi


