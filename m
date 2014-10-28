Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839AbaJ1Kuv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 06:50:51 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:60750 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752057AbaJ1Kus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 06:50:48 -0400
X-AuditID: cbfee68f-f791c6d000004834-1b-544f75067a1f
From: Kukjin Kim <kgene@kernel.org>
To: "'Chanwoo Choi'" <cw00.choi@samsung.com>
Cc: mark.rutland@arm.com, arnd@arndb.de, olof@lixom.net, tomasz.figa@gmail.com,
        inki.dae@samsung.com, sw0312.kim@samsung.com,
        kyungmin.park@samsung.com, m.szyprowski@samsung.com,
        yj44.cho@samsung.com, jaewon02.kim@samsung.com, ideal.song@samsung.com,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        "'Ben Dooks'" <ben-linux@fluff.org>,
        "'Russell King'" <linux@arm.linux.org.uk>
References: <1414471570-5135-1-git-send-email-cw00.choi@samsung.com>
 <1414471570-5135-3-git-send-email-cw00.choi@samsung.com>
In-reply-to: <1414471570-5135-3-git-send-email-cw00.choi@samsung.com>
Subject: RE: [PATCHv3 2/2] ARM: dts: Add dts files for Exynos4415 SoC
Date: Tue, 28 Oct 2014 19:50:46 +0900
Message-id: <043f01cff29d$0732c9f0$15985dd0$@kernel.org>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQH/tORJBMpfx1bCqynpf3js161IYwG85DcNm9fkipA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKKsWRmVeSWpSXmKPExsVy+t8zI122Uv8QgzcnFSz+TjrGbjFp3QEm
	i+tfnrNa7Pp7n9Fi0v0JLBY7Go6wWpxtesNusenxNVaLy7vmsFnMOL+PyeL2ZV6LtUfuslss
	vX6RyeLU9c9A8ckv2SxW7frDaLF352RGB0GPNfPWMHq0NPewefz+NYnR4++qF8weO2fdZffY
	vKTe48qJJlaPvi2rGD0+b5IL4IzisklJzcksSy3St0vgyvjS0cxecM+wonvJQsYGxs+qXYyc
	HBICJhKPnh1ngbDFJC7cW8/WxcjFISSwjFHi/MvnrDBFj8/eZ4VILGKUmH3mFzOE85dRYvXv
	e0AZDg42AWWJxiZ9kAZhAS2JhVuawKaKANkTO2cygdQzC2xjlvhz+igjSEJIoF7iYfMEsA2c
	Aq4SGy/PYoZodpX4teAPO4jNIqAqsen8SWaQ+bwCFhL936pAwrwCghI/Jt8Dm88MNH/9zuNM
	ELa8xOY1b5khjlaQ2HH2NSNIq4iAlcTzvXwQJSIS+168Y4QoucMhMXdHEMQmAYlvkw+xgJRL
	CMhKbDoANUVS4uCKGywTGCVnIVk8C8niWUgWz0KyYQEjyypG0dSC5ILipPQiY73ixNzi0rx0
	veT83E2MkNTSv4Px7gHrQ4wCHIxKPLwGD/1ChFgTy4orcw8xmgJdNJFZSjQ5H5jA8kriDY3N
	jCxMTUyNjcwtzZTEeRdK/QwWEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwJh+SGdvy/Q7qQez
	T+d/z9nrt2rt56SjGQ/zZmyfd/CdWHqAZTjjhlnWvn0PX7N99k54H8BcvK/eRfK1o+Oq5OM6
	W9V9V2/612J0Y3p/aLUQa/DXg69NgwU3C94Uc/35PlBybrXXshid2zKy1XNvXI9VNyvUePb2
	3osDjSsWiIsGP5y67WrPhO9KLMUZiYZazEXFiQBh3UL1KAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAKsWRmVeSWpSXmKPExsVy+t9jAV22Uv8Qg96NUhZ/Jx1jt5i07gCT
	xfUvz1ktdv29z2gx6f4EFosdDUdYLc42vWG32PT4GqvF5V1z2CxmnN/HZHH7Mq/F2iN32S2W
	Xr/IZHHq+meg+OSXbBardv1htNi7czKjg6DHmnlrGD1amnvYPH7/msTo8XfVC2aPnbPusnts
	XlLvceVEE6tH35ZVjB6fN8kFcEY1MNpkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqY
	KynkJeam2iq5+AToumXmAP2ipFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3JAiux8gADSSs
	Y8z40tHMXnDPsKJ7yULGBsbPql2MnBwSAiYSj8/eZ4WwxSQu3FvP1sXIxSEksIhRYvaZX8wQ
	zl9GidW/7wFVcXCwCShLNDbpgzQIC2hJLNzSxAJiiwDZEztnMoHUMwtsY5b4c/ooI0hCSKBe
	4mHzBLANnAKuEhsvz2KGaHaV+LXgDzuIzSKgKrHp/ElmkPm8AhYS/d+qQMK8AoISPybfA5vP
	DDR//c7jTBC2vMTmNW+ZIY5WkNhx9jUjSKuIgJXE8718ECUiEvtevGOcwCg8C8mkWUgmzUIy
	aRaSlgWMLKsYRVMLkguKk9JzDfWKE3OLS/PS9ZLzczcxglPXM6kdjCsbLA4xCnAwKvHwGjz0
	CxFiTSwrrsw9xCjBwawkwhsR4x8ixJuSWFmVWpQfX1Sak1p8iNEU6M+JzFKiyfnAtJpXEm9o
	bGJmZGlkZmFkYm6uJM57oNU6UEggPbEkNTs1tSC1CKaPiYNTqoFx3efltU/DvluyOe1R2LLH
	QmiO+LN7DdfOVYvU7jvA+TeULb8/JF9g45nuO4/dIt691JD4dmdyw9VzDz5P8Syb8jfK82xu
	YYSHugDb84cP3a+ryRTYid64Lmie+exLmrCiFNfktKM1S5qjrvcm2zJ26n5m8784I7TgPWvm
	7sRJWj/DssP6vTYosRRnJBpqMRcVJwIAxNdGQHMDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chanwoo Choi wrote:
> 
Hi,

> This patch adds new exynos4415.dtsi to support Exynos4415 SoC
> based on Cortex-A9 quad cores and includes following dt nodes:
> 
> - GIC interrupt controller (GIC-400)
> - Pinctrl to control three GPIO parts
> - CMU (Clock Management Unit) for CMU/CMU_DMC/AUDSS
> - CPU information (Cortex-A9 quad cores)
> - UART to support serial port
> - MCT (Multi Core Timer)
> - ADC (Analog Digital Converter)
> - RTC (Real Time Clock)
> - I2C/SPI busses
> - Power domains (CAM, TV, MFC, G3D, LCD0, ISP0/1)
> - PMU (Performance Monitoring Unit)
> - MSHC (Mobile Storage Host Controller)
> - EHCI (Enhanced Host Controller Interface)
> - OHIC (Open Host Controller Interface)
> - USB 2.0 device with hsotg
> - PWM (Pluse Width Modulation) Timer
> - AMBA bus for PDMA0/1
> - SYSRAM node for memory mapping
> - SYSREG node for memory mapping
> - PMU (Power Management Unit) node for memory mapping
> 
> Cc: Kukjin Kim <kgene.kim@samsung.com>
> Cc: Ben Dooks <ben-linux@fluff.org>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Olof Johansson <olof@lixom.net>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Signed-off-by: Seung-Woo Kim <sw0312.kim@samsung.com>
> [m.szyprowski: Add OHCI node and correct EHCI node]
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> [yj44.cho: Add mipi-phy node]
> Signed-off-by: YoungJun Cho <yj44.cho@samsung.com>
> [jaewon02: Add EHCI and SPI_2 node]
> Signed-off-by: Jaewon Kim <jaewon02.kim@samsung.com>
> [ideal.song: Add I2S0 node for audio interface]
> Signed-off-by: Inha Song <ideal.song@samsung.com>
> [tomasz.figa: Add L2 cache node]
> Signed-off-by: Tomasz Figa <tomasz.figa@gmail.com>
> Acked-by: Kyungmin Park <Kyungmin Park@samsung.com>
> ---
>  arch/arm/boot/dts/exynos4415-pinctrl.dtsi | 613 +++++++++++++++++++++++++++++
>  arch/arm/boot/dts/exynos4415.dtsi         | 627 ++++++++++++++++++++++++++++++
>  2 files changed, 1240 insertions(+)
>  create mode 100644 arch/arm/boot/dts/exynos4415-pinctrl.dtsi
>  create mode 100644 arch/arm/boot/dts/exynos4415.dtsi

[...]

> +
> +	mp00: mp00 {
> +		gpio-controller;
> +		#gpio-cells = <2>;
> +	};

After talking about above gpio ports in intranet, I thought again. And I'm still
thinking just to remove them would be better because it will not be used. Let's
remove useless mp related gpio ports (nodes) here.

> +
> +	mp01: mp01 {
> +		gpio-controller;
> +		#gpio-cells = <2>;
> +	};
> +
> +	mp02: mp02 {
> +		gpio-controller;
> +		#gpio-cells = <2>;
> +	};
> +
> +	mp03: mp03 {
> +		gpio-controller;
> +		#gpio-cells = <2>;
> +	};
> +
> +	mp04: mp04 {
> +		gpio-controller;
> +		#gpio-cells = <2>;
> +	};
> +
> +	mp05: mp05 {
> +		gpio-controller;
> +		#gpio-cells = <2>;
> +	};
> +
> +	mp06: mp06 {
> +		gpio-controller;
> +		#gpio-cells = <2>;
> +	};

Same as above.

[...]

> +	etc: etc {
> +		gpio-controller;
> +		#gpio-cells = <2>;
> +	};

Same, above 'etc' port will not be used I think.

> +};
> diff --git a/arch/arm/boot/dts/exynos4415.dtsi b/arch/arm/boot/dts/exynos4415.dtsi
> new file mode 100644
> index 0000000..078b1b8
> --- /dev/null
> +++ b/arch/arm/boot/dts/exynos4415.dtsi
> @@ -0,0 +1,627 @@
> +/*
> + * Samsung's Exynos4415 SoC device tree source
> + *
> + * Copyright (c) 2014 Samsung Electronics Co., Ltd.
> + *
> + * Samsung's Exynos4415 SoC device nodes are listed in this file. Exynos4415
> + * based board files can include this file and provide values for board specfic
> + * bindings.
> + *
> + * Note: This file does not include device nodes for all the controllers in
> + * Exynos4415 SoC. As device tree coverage for Exynos4415 increases, additional
> + * nodes can be added to this file.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include "skeleton.dtsi"
> +#include <dt-bindings/clock/exynos4415.h>
> +#include <dt-bindings/clock/exynos-audss-clk.h>
> +
> +/ {
> +	compatible = "samsung,exynos4415";
> +	interrupt-parent = <&gic>;
> +
> +	aliases {
> +		pinctrl0 = &pinctrl_0;
> +		pinctrl1 = &pinctrl_1;
> +		pinctrl2 = &pinctrl_2;
> +		mshc0 = &mshc_0;
> +		mshc1 = &mshc_1;
> +		mshc2 = &mshc_2;
> +		spi0 = &spi_0;
> +		spi1 = &spi_1;
> +		spi2 = &spi_2;
> +		i2c0 = &i2c_0;
> +		i2c1 = &i2c_1;
> +		i2c2 = &i2c_2;
> +		i2c3 = &i2c_3;
> +		i2c4 = &i2c_4;
> +		i2c5 = &i2c_5;
> +		i2c6 = &i2c_6;
> +		i2c7 = &i2c_7;
> +	};
> +
> +	cpus {
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +
> +		cpu0: cpu@0 {
> +			device_type = "cpu";
> +			compatible = "arm,cortex-a9";
> +			reg = <0xa00>;

This should be same with above value of 'cpu@0', 0.

You need to use one of following:

	cpu0: cpu@a00 {
Or
	reg = <0x0>;

> +			clock-frequency = <1600000000>;
> +		};
> +
> +		cpu1: cpu@1 {
> +			device_type = "cpu";
> +			compatible = "arm,cortex-a9";
> +			reg = <0xa01>;

Same as above.

> +			clock-frequency = <1600000000>;
> +		};
> +
> +		cpu2: cpu@2 {
> +			device_type = "cpu";
> +			compatible = "arm,cortex-a9";
> +			reg = <0xa02>;

Same.

> +			clock-frequency = <1600000000>;
> +		};
> +
> +		cpu3: cpu@3 {
> +			device_type = "cpu";
> +			compatible = "arm,cortex-a9";
> +			reg = <0xa03>;

Same.

> +			clock-frequency = <1600000000>;
> +		};
> +	};
> +
> +	soc: soc {
> +		compatible = "simple-bus";
> +		#address-cells = <1>;
> +		#size-cells = <1>;
> +		ranges;
> +
> +		fixed-rate-clocks {

Maybe 'fixed-rate-clocks' depends on board not SoC so need to move to board dt
file?

> +			#address-cells = <1>;
> +			#size-cells = <0>;
> +
> +			xusbxti: clock@0 {
> +				compatible = "fixed-clock";
> +				#address-cells = <1>;
> +				#size-cells = <0>;
> +				reg = <0>;
> +				clock-frequency = <0>;
> +				#clock-cells = <0>;
> +				clock-output-names = "xusbxti";
> +			};
> +
> +			xxti: clock@1 {
> +				compatible = "fixed-clock";
> +				reg = <1>;
> +				clock-frequency = <0>;
> +				#clock-cells = <0>;
> +				clock-output-names = "xxti";
> +			};
> +		};

[...]

