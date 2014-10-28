Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900AbaJ1Kyb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 06:54:31 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:61383 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602AbaJ1Ky3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 06:54:29 -0400
X-AuditID: cbfee68e-f79b46d000002b74-fc-544f75e3db1f
Message-id: <544F75E2.3000402@samsung.com>
Date: Tue, 28 Oct 2014 19:54:26 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Kukjin Kim <kgene@kernel.org>
Cc: mark.rutland@arm.com, arnd@arndb.de, olof@lixom.net, tomasz.figa@gmail.com,
        inki.dae@samsung.com, sw0312.kim@samsung.com,
        kyungmin.park@samsung.com, m.szyprowski@samsung.com,
        yj44.cho@samsung.com, jaewon02.kim@samsung.com, ideal.song@samsung.com,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        "'Ben Dooks'" <ben-linux@fluff.org>,
        "'Russell King'" <linux@arm.linux.org.uk>
Subject: Re: [PATCHv3 2/2] ARM: dts: Add dts files for Exynos4415 SoC
References: <1414471570-5135-1-git-send-email-cw00.choi@samsung.com>
 <1414471570-5135-3-git-send-email-cw00.choi@samsung.com>
 <043f01cff29d$0732c9f0$15985dd0$@kernel.org>
In-reply-to: <043f01cff29d$0732c9f0$15985dd0$@kernel.org>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLIsWRmVeSWpSXmKPExsWyRsSkWPdxqX+IwaynIhZ/Jx1jt5i07gCT
	xa6/9xktJt2fwGKxo+EIq0X/49fMFmeb3rBbbHp8jdXi8q45bBYzzu9jsrh9mddi7ZG77BZL
	r19ksjh1/TNQfPJLNotVu/4wWuzdOZnRQdBjzbw1jB4tzT1sHr9/TWL0+LvqBbPHzll32T02
	repk89i8pN7jyokmVo++LasYPT5vkgvgiuKySUnNySxLLdK3S+DKWLXmH2vBJdOKDY9nszUw
	vtPoYuTkkBAwkTi9bTcThC0mceHeerYuRi4OIYGljBKfJ81ghyn6Pn0fK0RiEaPE5TWroJzX
	jBK9MzaxglTxCmhJHLzUzAZiswioSmw/eBbMZgOK739xA8wWFQiTWDn9CgtEvaDEj8n3gGwO
	DhEBRYnNCxRAZjILbGOW+HP6KCNIjbCAq8SvKX+glq1jlHj07iPYIE4BS4nny9rBbGYBHYn9
	rdOgbHmJzWveMkOcvYVD4udkXYiDBCS+TT4EtkxCQFZi0wGoEkmJgytusExgFJuF5KRZSKbO
	QjJ1ASPzKkbR1ILkguKk9CIjveLE3OLSvHS95PzcTYzAVHD637O+HYw3D1gfYhTgYFTi4TV4
	6BcixJpYVlyZe4jRFOiKicxSosn5wISTVxJvaGxmZGFqYmpsZG5ppiTOmyD1M1hIID2xJDU7
	NbUgtSi+qDQntfgQIxMHp1QDo0jA3NNlL29pr2K3u6WaEPIx8mZvi7FNT8XOKL+UimUiU79K
	nM77eVdI1vWq0ZSYv6svssZqLzrOsiZQ0PmXBY9w0L7JQoZzfnHEqBwv9302SUpYZcb+jakd
	P+7fVOLrFn+hcNjgX/nuxNl8m5ITaieHW7XcuMJ2x0Hnx6l8bdveFwwKOV0aSizFGYmGWsxF
	xYkAJWQC1QADAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBKsWRmVeSWpSXmKPExsVy+t9jAd3Hpf4hBgsbuSz+TjrGbjFp3QEm
	i11/7zNaTLo/gcViR8MRVov+x6+ZLc42vWG32PT4GqvF5V1z2CxmnN/HZHH7Mq/F2iN32S2W
	Xr/IZHHq+meg+OSXbBardv1htNi7czKjg6DHmnlrGD1amnvYPH7/msTo8XfVC2aPnbPusnts
	WtXJ5rF5Sb3HlRNNrB59W1YxenzeJBfAFdXAaJORmpiSWqSQmpecn5KZl26r5B0c7xxvamZg
	qGtoaWGupJCXmJtqq+TiE6DrlpkD9JCSQlliTilQKCCxuFhJ3w7ThNAQN10LmMYIXd+QILge
	IwM0kLCGMWPVmn+sBZdMKzY8ns3WwPhOo4uRk0NCwETi+/R9rBC2mMSFe+vZuhi5OIQEFjFK
	XF6zihXCec0o0TtjE1gVr4CWxMFLzWwgNouAqsT2g2fBbDag+P4XN8BsUYEwiZXTr7BA1AtK
	/Jh8D8jm4BARUJTYvEABZCazwDZmiT+njzKC1AgLuEr8mvIHatk6RolH7z6CDeIUsJR4vqwd
	zGYW0JHY3zoNypaX2LzmLfMERoFZSHbMQlI2C0nZAkbmVYyiqQXJBcVJ6bmGesWJucWleel6
	yfm5mxjBqeaZ1A7GlQ0WhxgFOBiVeHgNHvqFCLEmlhVX5h5ilOBgVhLhjYjxDxHiTUmsrEot
	yo8vKs1JLT7EaAoMgonMUqLJ+cA0mFcSb2hsYmZkaWRuaGFkbK4kznug1TpQSCA9sSQ1OzW1
	ILUIpo+Jg1OqgfFQVrqCvvsni84+naKy4jK2rp1+1+sMz4TOt5bYHvvm4L59Sbw5X3sthMW3
	Vlb/cpBcv5ZRXM78lPzCRLcezx1z1T4GW/EecywI2nP3y1v7qyt0fmbEX+XdcNSEqzHuo0nq
	hJwNmu98ue+ftezK3au+/cOMrpXxVo/kGdeV1wvOeBoo9O7zYyWW4oxEQy3mouJEALuwEUxL	AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Kukjin,

On 10/28/2014 07:50 PM, Kukjin Kim wrote:
> Chanwoo Choi wrote:
>>
> Hi,
> 
>> This patch adds new exynos4415.dtsi to support Exynos4415 SoC
>> based on Cortex-A9 quad cores and includes following dt nodes:
>>
>> - GIC interrupt controller (GIC-400)
>> - Pinctrl to control three GPIO parts
>> - CMU (Clock Management Unit) for CMU/CMU_DMC/AUDSS
>> - CPU information (Cortex-A9 quad cores)
>> - UART to support serial port
>> - MCT (Multi Core Timer)
>> - ADC (Analog Digital Converter)
>> - RTC (Real Time Clock)
>> - I2C/SPI busses
>> - Power domains (CAM, TV, MFC, G3D, LCD0, ISP0/1)
>> - PMU (Performance Monitoring Unit)
>> - MSHC (Mobile Storage Host Controller)
>> - EHCI (Enhanced Host Controller Interface)
>> - OHIC (Open Host Controller Interface)
>> - USB 2.0 device with hsotg
>> - PWM (Pluse Width Modulation) Timer
>> - AMBA bus for PDMA0/1
>> - SYSRAM node for memory mapping
>> - SYSREG node for memory mapping
>> - PMU (Power Management Unit) node for memory mapping
>>
>> Cc: Kukjin Kim <kgene.kim@samsung.com>
>> Cc: Ben Dooks <ben-linux@fluff.org>
>> Cc: Russell King <linux@arm.linux.org.uk>
>> Cc: Mark Rutland <mark.rutland@arm.com>
>> Cc: Olof Johansson <olof@lixom.net>
>> Cc: Arnd Bergmann <arnd@arndb.de>
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> Signed-off-by: Seung-Woo Kim <sw0312.kim@samsung.com>
>> [m.szyprowski: Add OHCI node and correct EHCI node]
>> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
>> [yj44.cho: Add mipi-phy node]
>> Signed-off-by: YoungJun Cho <yj44.cho@samsung.com>
>> [jaewon02: Add EHCI and SPI_2 node]
>> Signed-off-by: Jaewon Kim <jaewon02.kim@samsung.com>
>> [ideal.song: Add I2S0 node for audio interface]
>> Signed-off-by: Inha Song <ideal.song@samsung.com>
>> [tomasz.figa: Add L2 cache node]
>> Signed-off-by: Tomasz Figa <tomasz.figa@gmail.com>
>> Acked-by: Kyungmin Park <Kyungmin Park@samsung.com>
>> ---
>>  arch/arm/boot/dts/exynos4415-pinctrl.dtsi | 613 +++++++++++++++++++++++++++++
>>  arch/arm/boot/dts/exynos4415.dtsi         | 627 ++++++++++++++++++++++++++++++
>>  2 files changed, 1240 insertions(+)
>>  create mode 100644 arch/arm/boot/dts/exynos4415-pinctrl.dtsi
>>  create mode 100644 arch/arm/boot/dts/exynos4415.dtsi
> 
> [...]
> 
>> +
>> +	mp00: mp00 {
>> +		gpio-controller;
>> +		#gpio-cells = <2>;
>> +	};
> 
> After talking about above gpio ports in intranet, I thought again. And I'm still
> thinking just to remove them would be better because it will not be used. Let's
> remove useless mp related gpio ports (nodes) here.

OK.

> 
>> +
>> +	mp01: mp01 {
>> +		gpio-controller;
>> +		#gpio-cells = <2>;
>> +	};
>> +
>> +	mp02: mp02 {
>> +		gpio-controller;
>> +		#gpio-cells = <2>;
>> +	};
>> +
>> +	mp03: mp03 {
>> +		gpio-controller;
>> +		#gpio-cells = <2>;
>> +	};
>> +
>> +	mp04: mp04 {
>> +		gpio-controller;
>> +		#gpio-cells = <2>;
>> +	};
>> +
>> +	mp05: mp05 {
>> +		gpio-controller;
>> +		#gpio-cells = <2>;
>> +	};
>> +
>> +	mp06: mp06 {
>> +		gpio-controller;
>> +		#gpio-cells = <2>;
>> +	};
> 
> Same as above.

OK.

> 
> [...]
> 
>> +	etc: etc {
>> +		gpio-controller;
>> +		#gpio-cells = <2>;
>> +	};
> 
> Same, above 'etc' port will not be used I think.

OK.

> 
>> +};
>> diff --git a/arch/arm/boot/dts/exynos4415.dtsi b/arch/arm/boot/dts/exynos4415.dtsi
>> new file mode 100644
>> index 0000000..078b1b8
>> --- /dev/null
>> +++ b/arch/arm/boot/dts/exynos4415.dtsi
>> @@ -0,0 +1,627 @@
>> +/*
>> + * Samsung's Exynos4415 SoC device tree source
>> + *
>> + * Copyright (c) 2014 Samsung Electronics Co., Ltd.
>> + *
>> + * Samsung's Exynos4415 SoC device nodes are listed in this file. Exynos4415
>> + * based board files can include this file and provide values for board specfic
>> + * bindings.
>> + *
>> + * Note: This file does not include device nodes for all the controllers in
>> + * Exynos4415 SoC. As device tree coverage for Exynos4415 increases, additional
>> + * nodes can be added to this file.
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + */
>> +
>> +#include "skeleton.dtsi"
>> +#include <dt-bindings/clock/exynos4415.h>
>> +#include <dt-bindings/clock/exynos-audss-clk.h>
>> +
>> +/ {
>> +	compatible = "samsung,exynos4415";
>> +	interrupt-parent = <&gic>;
>> +
>> +	aliases {
>> +		pinctrl0 = &pinctrl_0;
>> +		pinctrl1 = &pinctrl_1;
>> +		pinctrl2 = &pinctrl_2;
>> +		mshc0 = &mshc_0;
>> +		mshc1 = &mshc_1;
>> +		mshc2 = &mshc_2;
>> +		spi0 = &spi_0;
>> +		spi1 = &spi_1;
>> +		spi2 = &spi_2;
>> +		i2c0 = &i2c_0;
>> +		i2c1 = &i2c_1;
>> +		i2c2 = &i2c_2;
>> +		i2c3 = &i2c_3;
>> +		i2c4 = &i2c_4;
>> +		i2c5 = &i2c_5;
>> +		i2c6 = &i2c_6;
>> +		i2c7 = &i2c_7;
>> +	};
>> +
>> +	cpus {
>> +		#address-cells = <1>;
>> +		#size-cells = <0>;
>> +
>> +		cpu0: cpu@0 {
>> +			device_type = "cpu";
>> +			compatible = "arm,cortex-a9";
>> +			reg = <0xa00>;
> 
> This should be same with above value of 'cpu@0', 0.
> 
> You need to use one of following:
> 
> 	cpu0: cpu@a00 {
> Or
> 	reg = <0x0>;

OK, I'll fix it.

> 
>> +			clock-frequency = <1600000000>;
>> +		};
>> +
>> +		cpu1: cpu@1 {
>> +			device_type = "cpu";
>> +			compatible = "arm,cortex-a9";
>> +			reg = <0xa01>;
> 
> Same as above.

OK.

> 
>> +			clock-frequency = <1600000000>;
>> +		};
>> +
>> +		cpu2: cpu@2 {
>> +			device_type = "cpu";
>> +			compatible = "arm,cortex-a9";
>> +			reg = <0xa02>;
> 
> Same.

OK.

> 
>> +			clock-frequency = <1600000000>;
>> +		};
>> +
>> +		cpu3: cpu@3 {
>> +			device_type = "cpu";
>> +			compatible = "arm,cortex-a9";
>> +			reg = <0xa03>;
> 
> Same.

OK.

> 
>> +			clock-frequency = <1600000000>;
>> +		};
>> +	};
>> +
>> +	soc: soc {
>> +		compatible = "simple-bus";
>> +		#address-cells = <1>;
>> +		#size-cells = <1>;
>> +		ranges;
>> +
>> +		fixed-rate-clocks {
> 
> Maybe 'fixed-rate-clocks' depends on board not SoC so need to move to board dt
> file?

OK, I'll remove fixed-rate-clocks.

> 
>> +			#address-cells = <1>;
>> +			#size-cells = <0>;
>> +
>> +			xusbxti: clock@0 {
>> +				compatible = "fixed-clock";
>> +				#address-cells = <1>;
>> +				#size-cells = <0>;
>> +				reg = <0>;
>> +				clock-frequency = <0>;
>> +				#clock-cells = <0>;
>> +				clock-output-names = "xusbxti";
>> +			};
>> +
>> +			xxti: clock@1 {
>> +				compatible = "fixed-clock";
>> +				reg = <1>;
>> +				clock-frequency = <0>;
>> +				#clock-cells = <0>;
>> +				clock-output-names = "xxti";
>> +			};
>> +		};
> 
> [...]
> 
> 

Best Regards,
Chanwoo Choi

