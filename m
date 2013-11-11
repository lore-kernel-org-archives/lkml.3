Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807Ab3KKIDU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 03:03:20 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:25460 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895Ab3KKIDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 03:03:12 -0500
X-AuditID: cbfec7f5-b7fe66d00000432e-59-52808f3d763c
Message-id: <52808F3B.2000804@samsung.com>
Date: Mon, 11 Nov 2013 12:03:07 +0400
From: Tarek Dakhran <t.dakhran@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.1.0
MIME-version: 1.0
To: Tomasz Figa <tomasz.figa@gmail.com>,
        Vyacheslav Tyrtov <v.tyrtov@samsung.com>
Cc: linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
        Mike Turquette <mturquette@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Heiko Stuebner <heiko@sntech.de>,
        Naour Romain <romain.naour@openwide.fr>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, Dave.Martin@arm.com,
        nicolas.pitre@linaro.org
Subject: Re: [PATCH v3 4/4] ARM: dts: Add initial device tree support for
 EXYNOS5410
References: <1383811969-32712-1-git-send-email-v.tyrtov@samsung.com>
 <1383811969-32712-5-git-send-email-v.tyrtov@samsung.com>
 <19495187.Nrl1zS8Kog@flatron>
In-reply-to: <19495187.Nrl1zS8Kog@flatron>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNIsWRmVeSWpSXmKPExsVy+t/xq7q2/Q1BBlsO2lhMWneAyWLeZ1mL
	prl7GC3mHznHavH/0WtWi3OvVjJa9C64ymax6fE1VouFbUtYLC7vmsNmMeP8PiaL25d5LZZe
	v8hk8XTCRTaLT8/+sVtMmL6WxeLwCqBp615OZ7HY8rOD0eLVwTYWi82bpjJbrNr1h9Fi6owf
	7A7iHmvmrWH0aGnuYfNY8PkKu8ffVS+YPXbOusvusXL5FzaPV6tnsnrcubaHzePduXPsHpuX
	1Hu8usbi0bdlFaPH9mvzmD0+b5Lz2Dg3NIA/issmJTUnsyy1SN8ugSvj8NHJLAWL1SrW/DNo
	YLwu28XIySEhYCLx9PMXJghbTOLCvfVsXYxcHEICSxklWte8YYVw3jNK/L1+jhGkildAS+Lv
	nStgNouAqsTH3beAujk42AS0Jbbs8AIJiwpESBxd/YwVolxQ4sfkeywgtohAsMSOnauYQWYy
	C/xgldjwYxdYkbBAmMS6K08YIZbNZ5SYuuENWAcn0LJzH7cwg9jMAtYSKydtY4Sw5SU2r3nL
	PIFRYBaSJbOQlM1CUraAkXkVo2hqaXJBcVJ6rpFecWJucWleul5yfu4mRkiEf93BuPSY1SFG
	AQ5GJR5eBrmGICHWxLLiytxDjBIczEoivFkeQCHelMTKqtSi/Pii0pzU4kOMTBycUg2MIWtt
	Zt6TyM54ftZ/33TT2BLBr/1NbhfW/a4ten3FSqB958k03valoYcN+CNrrVb5+ATc2ttScfK5
	i9CX7a+9T77/J1ebfNn2uaLOdp2958Kj9peubl5/aMHdE7Jzxdc+3bDr98FrdgpzXiemX/mV
	cTc35W7pkh2+P462s4W0MGyZsW3N3u8qykosxRmJhlrMRcWJAPGpom/OAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 10.11.2013 22:02, Tomasz Figa wrote:
> Hi,
>
> Please see my comments inline.
>
> On Thursday 07 of November 2013 12:12:49 Vyacheslav Tyrtov wrote:
>> From: Tarek Dakhran <t.dakhran@samsung.com>
>>
>> Add initial device tree nodes for EXYNOS5410 SoC and SMDK5410 board.
>>
>> Signed-off-by: Tarek Dakhran <t.dakhran@samsung.com>
>> Signed-off-by: Vyacheslav Tyrtov <v.tyrtov@samsung.com>
>> ---
>>   arch/arm/boot/dts/Makefile                |   1 +
>>   arch/arm/boot/dts/exynos5410-smdk5410.dts |  65 ++++++++++
>>   arch/arm/boot/dts/exynos5410.dtsi         | 209 ++++++++++++++++++++++++++++++
>>   3 files changed, 275 insertions(+)
>>   create mode 100644 arch/arm/boot/dts/exynos5410-smdk5410.dts
>>   create mode 100644 arch/arm/boot/dts/exynos5410.dtsi
> [snip]
>> diff --git a/arch/arm/boot/dts/exynos5410-smdk5410.dts b/arch/arm/boot/dts/exynos5410-smdk5410.dts
>> new file mode 100644
>> index 0000000..06ae479
>> --- /dev/null
>> +++ b/arch/arm/boot/dts/exynos5410-smdk5410.dts
>> @@ -0,0 +1,65 @@
>> +/*
>> + * SAMSUNG SMDK5410 board device tree source
>> + *
>> + * Copyright (c) 2013 Samsung Electronics Co., Ltd.
>> + *		http://www.samsung.com
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> +*/
>> +
>> +/dts-v1/;
>> +#include "exynos5410.dtsi"
>> +/ {
>> +	model = "Samsung SMDK5410 board based on EXYNOS5410";
>> +	compatible = "samsung,smdk5410", "samsung,exynos5410";
>> +
>> +	memory {
>> +		reg = <0x40000000 0x80000000>;
>> +	};
>> +
>> +	chosen {
>> +		bootargs = "console=ttySAC2,115200";
>> +	};
>> +
>> +	oscclk: oscclk {
> coding style: According to ePAPR recommendation, node name should
> represent hardware type, not particular instance of hardware.
>
> So instead, the preferred way would be to specify the clock using
> following layout:
>
> 	clocks {
> 		compatible = "simple-bus";
> 		#address-cells = <1>;
> 		#size-cells = <0>;
>
> 		oscclk: clock@0 {
> 			compatible = "fixed-clock";
> 			reg = <0>;
> 			#clock-cells = <0>;
> 			clock-frequency = <24000000>;
> 			clock-output-names = "fin_pll";
> 		};
> 	};
>
>> +		compatible = "fixed-clock";
>> +		#clock-cells = <0>;
>> +		clock-frequency = <24000000>;
>> +		clock-output-names = "fin_pll";
>> +	};
> [snip]
>> +
>> +};
>> diff --git a/arch/arm/boot/dts/exynos5410.dtsi b/arch/arm/boot/dts/exynos5410.dtsi
>> new file mode 100644
>> index 0000000..9921b66
>> --- /dev/null
>> +++ b/arch/arm/boot/dts/exynos5410.dtsi
>> @@ -0,0 +1,209 @@
>> +/*
>> + * SAMSUNG EXYNOS5410 SoC device tree source
>> + *
>> + * Copyright (c) 2013 Samsung Electronics Co., Ltd.
>> + *		http://www.samsung.com
>> + *
>> + * SAMSUNG EXYNOS5410 SoC device nodes are listed in this file.
>> + * EXYNOS5410 based board files can include this file and provide
>> + * values for board specfic bindings.
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + */
>> +
>> +#include <dt-bindings/clock/exynos5410.h>
>> +#include "exynos5.dtsi"
>> +/ {
> [snip]
>> +	clock: clock-controller@10010000 {
>> +		compatible = "samsung,exynos5410-clock";
>> +		reg = <0x10010000 0x30000>;
>> +		#clock-cells = <1>;
>> +	};
>> +
>> +	mct@101C0000 {
> A generic name would be: timer@101C0000
>
>> +		compatible = "samsung,exynos4210-mct";
>> +		reg = <0x101C0000 0xB00>;
>> +		interrupt-controller;
>> +		#interrups-cells = <1>;
> MCT is not an interrupt controller, so both interrupt-controller and
> #interrupt-cells properties are incorrect. I guess that's due to the
> broken example in the documentation, that I already posted patches to fix.
>
>> +		interrupt-parent = <&mct_map>;
>> +		interrupts = <0>, <1>, <2>, <3>,
>> +			<4>, <5>, <6>, <7>,
>> +			<8>, <9>, <10>, <11>;
>> +		clocks = <&oscclk>, <&clock CLK_MCT>;
>> +		clock-names = "fin_pll", "mct";
>> +
>> +		mct_map: mct-map {
> Again, interrupt-map would be a better name for this node.
>
>> +			#interrupt-cells = <1>;
>> +			#address-cells = <0>;
>> +			#size-cells = <0>;
>> +			interrupt-map = <0 &combiner 23 3>,
>> +					<1 &combiner 23 4>,
>> +					<2 &combiner 25 2>,
>> +					<3 &combiner 25 3>,
>> +					<4 &gic 0 120 0>,
>> +					<5 &gic 0 121 0>,
>> +					<6 &gic 0 122 0>,
>> +					<7 &gic 0 123 0>,
>> +					<8 &gic 0 128 0>,
>> +					<9 &gic 0 129 0>,
>> +					<10 &gic 0 130 0>,
>> +					<11 &gic 0 131 0>;
>> +		};
>> +	};
> Otherwise, the patch looks good.
>
> Best regards,
> Tomasz
>
>
Thanks a lot, Tomasz.
All will be corrected in v4.

Best regards,
     Tarek Dakhran
