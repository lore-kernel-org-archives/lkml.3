Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756515AbaJXMNr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 08:13:47 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:63700 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756259AbaJXMNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 08:13:45 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee68e-f79b46d000002b74-af-544a42779c20
Content-transfer-encoding: 8BIT
Message-id: <544A4277.70909@samsung.com>
Date: Fri, 24 Oct 2014 21:13:43 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
To: =?UTF-8?B?S3J6eXN6dG9mIEtvesWCb3dza2k=?= <k.kozlowski@samsung.com>
Cc: kgene.kim@samsung.com, mark.rutland@arm.com,
        Jaehoon Chung <jh80.chung@samsung.com>, geunsik.lim@samsung.com,
        linux-samsung-soc@vger.kernel.org, arnd@arndb.de,
        sw0312.kim@samsung.com, tomasz.figa@gmail.com,
        linux-kernel@vger.kernel.org, inki.dae@samsung.com,
        kyungmin.park@samsung.com, olof@lixom.net,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv3 1/3] ARM: dts: Add board dts file for Exynos3250-based
 Rinato board
References: <1414150795-31105-1-git-send-email-cw00.choi@samsung.com>
 <1414150795-31105-2-git-send-email-cw00.choi@samsung.com>
 <544A3EBB.3020906@samsung.com>
In-reply-to: <544A3EBB.3020906@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPIsWRmVeSWpSXmKPExsWyRsSkSLfcySvEYNofA4u/k46xW/yZ0Mpm
	Men+BBaLG7/aWC1evzC06F1wlc3ibNMbdotNj6+xWlzeNYfNYsb5fUwWS69fZLI4df0zkDv5
	JZvFql1/GB34PNbMW8Po8fvXJEaPnbPusntsXlLvceVEE6tH35ZVjB6fN8kFsEdx2aSk5mSW
	pRbp2yVwZZzvWslacF2+4kPLa+YGxmOSXYycHBICJhKvNzeyQ9hiEhfurWfrYuTiEBJYyiix
	fe0WNpiiizOmsEIkFjFKPJjYygyS4BUQlPgx+R5LFyMHB7OAvMSRS9kgYWYBdYlJ8xYxQ9S/
	ZpToPXWYEaJeQ+L/7QmsIDaLgKrE08a3LCA2m4CWxP4XN8CWiQqESaycfgUsLiLgJnH64mom
	kEHMAveYJN7Pmgo2SFggWuL9pG8scBftfrgabCqngLbEguNbwH6QEJjIIfHp8ytmiHUCEt8m
	HwI7VUJAVmLTAWaI1yQlDq64wTKBUWwWkodmITw0C8lDCxiZVzGKphYkFxQnpRcZ6RUn5haX
	5qXrJefnbmIExvPpf8/6djDePGB9iFGAg1GJh/fGDM8QIdbEsuLK3EOMpkBHTGSWEk3OByaN
	vJJ4Q2MzIwtTE1NjI3NLMyVx3gSpn8FCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGAtKpE5+
	1b7i1tI8RzPthjnr7GKLt/on+xxU/7dciJQVKJq8i895yQWtJS61P7q7G++daNoXePFUbttm
	/lfT435J3WHv/5j09cQdh7c7f01u/+3X4Orjrp72pk1Pbc1OefuvvsssrqdIu0X0PNrOJSgX
	M/+KmkDaXnsHxwhmy4PVlgJTSuY8UmIpzkg01GIuKk4EADOrIibiAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJKsWRmVeSWpSXmKPExsVy+t9jAd1yJ68Qg9WT1S3+TjrGbvFnQiub
	xaT7E1gsbvxqY7V4/cLQonfBVTaLs01v2C02Pb7GanF51xw2ixnn9zFZLL1+kcni1PXPQO7k
	l2wWq3b9YXTg81gzbw2jx+9fkxg9ds66y+6xeUm9x5UTTawefVtWMXp83iQXwB7VwGiTkZqY
	klqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA3SykkJZYk4pUCgg
	sbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwhjHjfNdK1oLr8hUfWl4zNzAek+xi5OSQEDCR
	uDhjCiuELSZx4d56ti5GLg4hgUWMEg8mtjKDJHgFBCV+TL7H0sXIwcEsIC9x5FI2SJhZQF1i
	0rxFzBD1rxklek8dZoSo15D4f3sC2FAWAVWJp41vWUBsNgEtif0vbrCB2KICYRIrp18Bi4sI
	uEmcvriaCWQQs8A9Jon3s6aCDRIWiJZ4P+kbC9xFux+uBpvKKaAtseD4FrYJjAKzkBw4C+HA
	WUgOXMDIvIpRNLUguaA4KT3XUK84Mbe4NC9dLzk/dxMjOFk8k9rBuLLB4hCjAAejEg/vjRme
	IUKsiWXFlbmHGCU4mJVEeL1MvEKEeFMSK6tSi/Lji0pzUosPMZoCvTeRWUo0OR+YyPJK4g2N
	TcyMLI3MDS2MjM2VxHkPtFoHCgmkJ5akZqemFqQWwfQxcXBKNTB2sYmu/n2jaRrTpd8VMR/M
	brkn273vTfn5Z2KFf0b+lz+R7GxFCQ5pMye/UPMr3Ls0uW/hJhkrnRX1XNrujxbPMXh11Uuu
	Y+U+CY7G7fYWGUVe0eWaTp58et8Uu+RaU/z3bZlyS7XwbTaPnt7vaxOWKF14IRm8v2T2jb31
	qtb7u9VrFeYUhSuxFGckGmoxFxUnAgBdwFVGLAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Krzysztof,

On 10/24/2014 08:57 PM, Krzysztof Kozłowski wrote:
> On 24.10.2014 13:39, Chanwoo Choi wrote:
>> This patch add support for device tree sources for Samsung Rinato baord
>> (Gear 2) based on Exynos3250 SoC.
>>
>> This dts file support following features:
>> - eMMC
>> - Main PMIC (Samsung S2MPS14)
>> - Interface PMIC (Maxim MAX77836, MUIC, fuel-gauge, charger)
>> - RTC of Exynos3250
>> - ADC of Exynos3250 with NTC thermistor
>> - I2S of Exynos3250
>> - TMU of Exynos3250
>> - MFC of Exynos3250
>> - Secure firmware for Exynos3250 secondary cpu boot
>> - Serial ports of Exynos3250
>> - gpio-key for power key
>>
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> Signed-off-by: Inki Dae <inki.dae@samsung.com>
>> Signed-off-by: Seung-Woo Kim <sw0312.kim@samsung.com>
>> Signed-off-by: Jaehoon Chung <jh80.chung@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
>>  arch/arm/boot/dts/Makefile              |   3 +-
>>  arch/arm/boot/dts/exynos3250-rinato.dts | 433 ++++++++++++++++++++++++++++++++
>>  2 files changed, 435 insertions(+), 1 deletion(-)
>>  create mode 100644 arch/arm/boot/dts/exynos3250-rinato.dts
>>
>> diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
>> index 4a75e29..91cd4d0 100644
>> --- a/arch/arm/boot/dts/Makefile
>> +++ b/arch/arm/boot/dts/Makefile
>> @@ -67,7 +67,8 @@ dtb-$(CONFIG_ARCH_BRCMSTB) += \
>>  dtb-$(CONFIG_ARCH_DAVINCI) += da850-enbw-cmc.dtb \
>>  	da850-evm.dtb
>>  dtb-$(CONFIG_ARCH_EFM32) += efm32gg-dk3750.dtb
>> -dtb-$(CONFIG_ARCH_EXYNOS) += exynos4210-origen.dtb \
>> +dtb-$(CONFIG_ARCH_EXYNOS) += exynos3250-rinato.dtb \
>> +	exynos4210-origen.dtb \
>>  	exynos4210-smdkv310.dtb \
>>  	exynos4210-trats.dtb \
>>  	exynos4210-universal_c210.dtb \
>> diff --git a/arch/arm/boot/dts/exynos3250-rinato.dts b/arch/arm/boot/dts/exynos3250-rinato.dts
>> new file mode 100644
>> index 0000000..be0ba8d
>> --- /dev/null
>> +++ b/arch/arm/boot/dts/exynos3250-rinato.dts
>> @@ -0,0 +1,433 @@
>> +/*
>> + * Samsung's Exynos3250 based Rinato board device tree source
>> + *
>> + * Copyright (c) 2014 Samsung Electronics Co., Ltd.
>> + *		http://www.samsung.com
>> + *
>> + * Device tree source file for Samsung's Rinato board which is based on
>> + * Samsung Exynos3250 SoC.
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + */
>> +
>> +/dts-v1/;
>> +#include "exynos3250.dtsi"
>> +#include <dt-bindings/input/input.h>
>> +
>> +/ {
>> +	model = "Samsung Rinato board";
>> +	compatible = "samsung,rinato", "samsung,exynos3250", "samsung,exynos3";
>> +
>> +	aliases {
>> +		i2c7 = &i2c_max77836;
>> +	};
>> +
>> +	memory {
>> +		reg =  <0x40000000 0x1ff00000>;
>> +	};
>> +
>> +	chosen {
>> +		bootargs = "console=ttySAC1,115200N8 root=/dev/mmcblk0p15 rootwait earlyprintk panic=5";
>> +	};
>> +
>> +	firmware@0205F000 {
>> +		compatible = "samsung,secure-firmware";
>> +		reg = <0x0205F000 0x1000>;
>> +	};
>> +
>> +	gpio_keys {
>> +		compatible = "gpio-keys";
>> +
>> +		power_key {
>> +			interrupt-parent = <&gpx2>;
>> +			interrupts = <7 0>;
>> +			gpios = <&gpx2 7 1>;
>> +			linux,code = <KEY_POWER>;
>> +			label = "power key";
>> +			debounce-interval = <10>;
>> +			gpio-key,wakeup;
>> +		};
>> +	};
>> +
>> +	vemmc_reg: voltage-regulator-0 {
>> +	        compatible = "regulator-fixed";
>> +		regulator-name = "V_EMMC_2.8V-fixed";
>> +		regulator-min-microvolt = <2800000>;
>> +		regulator-max-microvolt = <2800000>;
>> +		gpio = <&gpk0 2 0>;
>> +		enable-active-high;
>> +	};
> 
> Hi Chanwoo,
> 
> I wonder if this regulator-fixed is needed. The LDO11 and LDO12 has
> external GPIO control set up. So maybe this could be removed?

OK, I'll remove 'vemmc_reg' and then use ldo12_reg insead of 'vemmc_reg' on mshc_0 dt node.

Best Regards,
Chanwoo Choi


