Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933432AbaEMNGr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 09:06:47 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:20452 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933390AbaEMNGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 09:06:41 -0400
X-AuditID: cbfee68e-b7fd86d0000038e3-a3-537218dd9295
From: Chanwoo Choi <cw00.choi@samsung.com>
To: kgene.kim@samsung.com, t.figa@samsung.com
Cc: linux-kernel@vger.kernel.org, linux@arm.linux.org.uk, ben-linux@fluff.org,
        arnd@arndb.de, olof@lixom.net, marc.zyngier@arm.com,
        thomas.abraham@linaro.org, kyungmin.park@samsung.com,
        cw00.choi@samsung.com, inki.dae@samsung.com, sw0312.kim@samsung.com,
        hyunhee.kim@samsung.com, yj44.cho@samsung.com,
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
Subject: [PATCHv5 5/5] ARM: dts: Add device tree sources for Exynos3250
Date: Tue, 13 May 2014 22:05:08 +0900
Message-id: <1399986308-23744-6-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1399986308-23744-1-git-send-email-cw00.choi@samsung.com>
References: <1399986308-23744-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA5WS2U8TURSHvdOZ20KCGct2IYEHEkJkk92LGKKJ4gjEKCZqTAyWOgJha1ow
	vomVJbKUTaUgArJKZQkVF5C1IlGQRZClQjWIyCIxGMBApSht/Qd8+52T73z5PRweh59J2fKi
	4xNZcbwg1gGakvUWPoluGiQ+67FRzse6/D4ubpY3UTi/sZvAY10ueHJ9gcJlvUMUzll5SOG1
	1RQuHlquAzj/cy6Jp7RpFM4uH4d4ULrCxcq5CQqPtZVALB/uJPD0mBnWzexAXD35nsD9k2sQ
	5xY2kDi1o5eL325nA/z11U8KywuWIG6Sfydxn7wK4HRdB8QdrQXgiB1TX1oPmJRbWZD5rc0H
	zJgsm2B0ikUO01qs4TJ1teuQUSpuQ2Zmoh0yT6puMB/eSClG1qIAzJrS/rTZRdPDV9jY6Gus
	+EDgZdOo3pV5UtT/FFzfTH1AJoOCTJABTHiI9kHvHo9zjdkKjXxqghnAlMenqwFqqVBRGYBn
	gAZenjPuKwBSKdRc4yAl0MfmNqi/hrQz6lqcMmQL2g3dKZqh9BCHroJotKmR1JvM6ROo//4p
	PUPSjih1XWPgzejjKGum7F8je7Ta/sXQyIQOQtrpFEPm7zI1gxpC70T0Jg89b+gDRhGNfhWo
	SGNTO6Ts5hg9Nqjn0RSZC8zLwR4FsGRFQpEkIlLs5S4RxEmS4iPdhQlxSrD7CAM732QvgLo7
	QAWEu7o8jq2lMGH3UeITwz29/bywr4+vt9dBf7//WztYm1XMRoTx6UhBIhvDsiJWHC5OimUl
	KkDwTGyTQUitZnlT4k9Le7lJx5ZLOE5plYST+tKGNOxCUZCLujDALvRZw6gLP7jZY0v8+iqC
	DTLV3cCpUp0wTc2rHjkUsfRjWJRSRrDeszCkYq/rni2b88F+4SjvzEJM+npRMX2zZ/9Ra/M/
	cyebrebTWyqjQmU+rjUrQt2+Tm2O471tB1ISJfB05oglgr91lWolHgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOKsWRmVeSWpSXmKPExsVy+t9jAd27EkXBBkf8Lf5OOsZusXHGelaL
	SesOMFlc3q9tcf3Lc1aL+UfOsVr0v1nIavH5Qwu7xblXKxktJt2fwGJx41cbq0XvgqtsFmeb
	3rBbbHp8jdXi8q45bBYzzu9jsrh9mdfi751/bBZLr19ksjh1/TObxYTpa1ksWvceYbc4+aeX
	0eLJ4Y+sFjMmv2SzWD/jNYvFsRlLGC3a/+5ls9i7czKjg6zHmnlrGD1amnvYPH7/msTocbmv
	l8nj76oXzB47Z91l91i5/Aubx6ZVnWwed67tYfPYvKTe48qJJlaPvi2rGD0+b5IL4I1qYLTJ
	SE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAYaMkkJZYk4p
	UCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwhjHjyJunLAWntjJW/Gidy9LAOLmbsYuR
	g0NCwETi9O6wLkZOIFNM4sK99WxdjFwcQgKLGCUOrbrJDuE0MUnc2riLDaSKTUBLYv+LG2C2
	iICuxJSZd1hBipgFlrBJXFq/jgVkqrCAu8Sp2X4gNSwCqhKtX+6C1fMKuEr03JnPCLFNTuLD
	nkfsIDangJvEr9stYLYQUM2ys3eZJjDyLmBkWMUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kR
	nGyeSe1gXNlgcYhRgINRiYf3p3FhsBBrYllxZe4hRgkOZiURXvdPQCHelMTKqtSi/Pii0pzU
	4kOMyUBXTWSWEk3OBybCvJJ4Q2MTMyNLI3NDCyNjc9KElcR5D7RaBwoJpCeWpGanphakFsFs
	YeLglGpg1Bd5LH3FoOTC55klk+OPPczz+KcwT/Xfn+mrZZ9V5V8LtVYT7E6bc1hSgD31u+Yc
	Aaden3jXSbX6zF//s5+Y+UyTOXFxzqG2T0/49dY8ZL2SNElY476Au8HCurtntvhWdyw5Oens
	cY730UtuP65fVVO6WHXZrKhVLHaHc5lc/KZ/5/rVbik+Q4mlOCPRUIu5qDgRAL6mwod6AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tomasz Figa <t.figa@samsung.com>

This patch add new exynos3250.dtsi to support Exynos3250 SoC based on Cortex-A7
dual core and includes following dt nodes:

- GIC interrupt controller
- Pinctrl to control GPIOs
- Clock controller
- CPU information (Cortex-A7 dual core)
- UART to support serial port
- MCT (Multi Core Timer)
- ADC (Analog Digital Converter)
- I2C/SPI bus
- Power domain
- PMU (Performance Monitoring Unit)
- MSHC (Mobile Storage Host Controller)
- PWM (Pluse Width Modulation)
- AMBA bus
- sysram node for SYSRAM memory mapping

Signed-off-by: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Inki Dae <inki.dae@samsung.com>
Signed-off-by: Hyunhee Kim <hyunhee.kim@samsung.com>
Signed-off-by: Jaehoon Chung <jh80.chung@samsung.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Kumar Gala <galak@codeaurora.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: devicetree@vger.kernel.org
---
 arch/arm/boot/dts/exynos3250-pinctrl.dtsi | 475 ++++++++++++++++++++++++++++++
 arch/arm/boot/dts/exynos3250.dtsi         | 439 +++++++++++++++++++++++++++
 2 files changed, 914 insertions(+)
 create mode 100644 arch/arm/boot/dts/exynos3250-pinctrl.dtsi
 create mode 100644 arch/arm/boot/dts/exynos3250.dtsi

diff --git a/arch/arm/boot/dts/exynos3250-pinctrl.dtsi b/arch/arm/boot/dts/exynos3250-pinctrl.dtsi
new file mode 100644
index 0000000..47b92c1
--- /dev/null
+++ b/arch/arm/boot/dts/exynos3250-pinctrl.dtsi
@@ -0,0 +1,475 @@
+/*
+ * Samsung's Exynos3250 SoCs pin-mux and pin-config device tree source
+ *
+ * Copyright (c) 2014 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ *
+ * Samsung's Exynos3250 SoCs pin-mux and pin-config optiosn are listed as device
+ * tree nodes are listed in this file.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+&pinctrl_0 {
+	gpa0: gpa0 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpa1: gpa1 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpb: gpb {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpc0: gpc0 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpc1: gpc1 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpd0: gpd0 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpd1: gpd1 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	uart0_data: uart0-data {
+		samsung,pins = "gpa0-0", "gpa0-1";
+		samsung,pin-function = <0x2>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+
+	uart0_fctl: uart0-fctl {
+		samsung,pins = "gpa0-2", "gpa0-3";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+
+	uart1_data: uart1-data {
+		samsung,pins = "gpa0-4", "gpa0-5";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+
+	uart1_fctl: uart1-fctl {
+		samsung,pins = "gpa0-6", "gpa0-7";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+
+	i2c2_bus: i2c2-bus {
+		samsung,pins = "gpa0-6", "gpa0-7";
+		samsung,pin-function = <3>;
+		samsung,pin-pud = <3>;
+		samsung,pin-drv = <0>;
+	};
+
+	i2c3_bus: i2c3-bus {
+		samsung,pins = "gpa1-2", "gpa1-3";
+		samsung,pin-function = <3>;
+		samsung,pin-pud = <3>;
+		samsung,pin-drv = <0>;
+	};
+
+	spi0_bus: spi0-bus {
+		samsung,pins = "gpb-0", "gpb-2", "gpb-3";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <3>;
+		samsung,pin-drv = <0>;
+	};
+
+	i2c4_bus: i2c4-bus {
+		samsung,pins = "gpb-0", "gpb-1";
+		samsung,pin-function = <3>;
+		samsung,pin-pud = <3>;
+		samsung,pin-drv = <0>;
+	};
+
+	spi1_bus: spi1-bus {
+		samsung,pins = "gpb-4", "gpb-6", "gpb-7";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <3>;
+		samsung,pin-drv = <0>;
+	};
+
+	i2c5_bus: i2c5-bus {
+		samsung,pins = "gpb-2", "gpb-3";
+		samsung,pin-function = <3>;
+		samsung,pin-pud = <3>;
+		samsung,pin-drv = <0>;
+	};
+
+	i2s2_bus: i2s2-bus {
+		samsung,pins = "gpc1-0", "gpc1-1", "gpc1-2", "gpc1-3",
+				"gpc1-4";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+
+	pcm2_bus: pcm2-bus {
+		samsung,pins = "gpc1-0", "gpc1-1", "gpc1-2", "gpc1-3",
+				"gpc1-4";
+		samsung,pin-function = <3>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+
+	i2c6_bus: i2c6-bus {
+		samsung,pins = "gpc1-3", "gpc1-4";
+		samsung,pin-function = <4>;
+		samsung,pin-pud = <3>;
+		samsung,pin-drv = <0>;
+	};
+
+	pwm0_out: pwm0-out {
+		samsung,pins = "gpd0-0";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+
+	pwm1_out: pwm1-out {
+		samsung,pins = "gpd0-1";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+
+	i2c7_bus: i2c7-bus {
+		samsung,pins = "gpd0-2", "gpd0-3";
+		samsung,pin-function = <3>;
+		samsung,pin-pud = <3>;
+		samsung,pin-drv = <0>;
+	};
+
+	pwm2_out: pwm2-out {
+		samsung,pins = "gpd0-2";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+
+	pwm3_out: pwm3-out {
+		samsung,pins = "gpd0-3";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+
+	i2c0_bus: i2c0-bus {
+		samsung,pins = "gpd1-0", "gpd1-1";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <3>;
+		samsung,pin-drv = <0>;
+	};
+
+	mipi0_clk: mipi0-clk {
+		samsung,pins = "gpd1-0", "gpd1-1";
+		samsung,pin-function = <3>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+
+	i2c1_bus: i2c1-bus {
+		samsung,pins = "gpd1-2", "gpd1-3";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <3>;
+		samsung,pin-drv = <0>;
+	};
+};
+
+&pinctrl_1 {
+	gpe0: gpe0 {
+		gpio-controller;
+		#gpio-cells = <2>;
+	};
+
+	gpe1: gpe1 {
+		gpio-controller;
+		#gpio-cells = <2>;
+	};
+
+	gpe2: gpe2 {
+		gpio-controller;
+		#gpio-cells = <2>;
+	};
+
+	gpk0: gpk0 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpk1: gpk1 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpk2: gpk2 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpl0: gpl0 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpm0: gpm0 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpm1: gpm1 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpm2: gpm2 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpm3: gpm3 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpm4: gpm4 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpx0: gpx0 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		interrupt-parent = <&gic>;
+		interrupts = <0 32 0>, <0 33 0>, <0 34 0>, <0 35 0>,
+				<0 36 0>, <0 37 0>, <0 38 0>, <0 39 0>;
+		#interrupt-cells = <2>;
+	};
+
+	gpx1: gpx1 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		interrupt-parent = <&gic>;
+		interrupts = <0 40 0>, <0 41 0>, <0 42 0>, <0 43 0>,
+				<0 44 0>, <0 45 0>, <0 46 0>, <0 47 0>;
+		#interrupt-cells = <2>;
+	};
+
+	gpx2: gpx2 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpx3: gpx3 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	sd0_clk: sd0-clk {
+		samsung,pins = "gpk0-0";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <3>;
+	};
+
+	sd0_cmd: sd0-cmd {
+		samsung,pins = "gpk0-1";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <3>;
+	};
+
+	sd0_cd: sd0-cd {
+		samsung,pins = "gpk0-2";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <3>;
+		samsung,pin-drv = <3>;
+	};
+
+	sd0_rdqs: sd0-rdqs {
+		samsung,pins = "gpk0-7";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <3>;
+	};
+
+	sd0_bus1: sd0-bus-width1 {
+		samsung,pins = "gpk0-3";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <3>;
+		samsung,pin-drv = <3>;
+	};
+
+	sd0_bus4: sd0-bus-width4 {
+		samsung,pins = "gpk0-4", "gpk0-5", "gpk0-6";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <3>;
+		samsung,pin-drv = <3>;
+	};
+
+	sd0_bus8: sd0-bus-width8 {
+		samsung,pins = "gpl0-0", "gpl0-1", "gpl0-2", "gpl0-3";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <3>;
+		samsung,pin-drv = <3>;
+	};
+
+	sd1_clk: sd1-clk {
+		samsung,pins = "gpk1-0";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <3>;
+	};
+
+	sd1_cmd: sd1-cmd {
+		samsung,pins = "gpk1-1";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <3>;
+	};
+
+	sd1_cd: sd1-cd {
+		samsung,pins = "gpk1-2";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <3>;
+		samsung,pin-drv = <3>;
+	};
+
+	sd1_bus1: sd1-bus-width1 {
+		samsung,pins = "gpk1-3";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <3>;
+		samsung,pin-drv = <3>;
+	};
+
+	sd1_bus4: sd1-bus-width4 {
+		samsung,pins = "gpk1-4", "gpk1-5", "gpk1-6";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <3>;
+		samsung,pin-drv = <3>;
+	};
+
+	cam_port_b_io: cam-port-b-io {
+		samsung,pins = "gpm0-0", "gpm0-1", "gpm0-2", "gpm0-3",
+				"gpm0-4", "gpm0-5", "gpm0-6", "gpm0-7",
+				"gpm1-0", "gpm1-1", "gpm2-0", "gpm2-1";
+		samsung,pin-function = <3>;
+		samsung,pin-pud = <3>;
+		samsung,pin-drv = <0>;
+	};
+
+	cam_port_b_clk_active: cam-port-b-clk-active {
+		samsung,pins = "gpm2-2";
+		samsung,pin-function = <3>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <3>;
+	};
+
+	cam_port_b_clk_idle: cam-port-b-clk-idle {
+		samsung,pins = "gpm2-2";
+		samsung,pin-function = <0>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+
+	fimc_is_i2c0: fimc-is-i2c0 {
+		samsung,pins = "gpm4-0", "gpm4-1";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+
+	fimc_is_i2c1: fimc-is-i2c1 {
+		samsung,pins = "gpm4-2", "gpm4-3";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+
+	fimc_is_uart: fimc-is-uart {
+		samsung,pins = "gpm3-5", "gpm3-7";
+		samsung,pin-function = <3>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+};
diff --git a/arch/arm/boot/dts/exynos3250.dtsi b/arch/arm/boot/dts/exynos3250.dtsi
new file mode 100644
index 0000000..16430f8
--- /dev/null
+++ b/arch/arm/boot/dts/exynos3250.dtsi
@@ -0,0 +1,439 @@
+/*
+ * Samsung's Exynos3250 SoC device tree source
+ *
+ * Copyright (c) 2014 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ *
+ * Samsung's Exynos3250 SoC device nodes are listed in this file. Exynos3250
+ * based board files can include this file and provide values for board specfic
+ * bindings.
+ *
+ * Note: This file does not include device nodes for all the controllers in
+ * Exynos3250 SoC. As device tree coverage for Exynos3250 increases, additional
+ * nodes can be added to this file.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include "skeleton.dtsi"
+#include <dt-bindings/clock/exynos3250.h>
+
+/ {
+	compatible = "samsung,exynos3250";
+	interrupt-parent = <&gic>;
+
+	aliases {
+		pinctrl0 = &pinctrl_0;
+		pinctrl1 = &pinctrl_1;
+		mshc0 = &mshc_0;
+		mshc1 = &mshc_1;
+		spi0 = &spi_0;
+		spi1 = &spi_1;
+		i2c0 = &i2c_0;
+		i2c1 = &i2c_1;
+		i2c2 = &i2c_2;
+		i2c3 = &i2c_3;
+		i2c4 = &i2c_4;
+		i2c5 = &i2c_5;
+		i2c6 = &i2c_6;
+		i2c7 = &i2c_7;
+	};
+
+	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		cpu0: cpu@0 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a7";
+			reg = <0>;
+			clock-frequency = <1000000000>;
+		};
+
+		cpu1: cpu@1 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a7";
+			reg = <1>;
+			clock-frequency = <1000000000>;
+		};
+	};
+
+	soc: soc {
+		compatible = "simple-bus";
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+
+		fixed-rate-clocks {
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			xusbxti: clock@0 {
+				compatible = "fixed-clock";
+				#address-cells = <1>;
+				#size-cells = <0>;
+				reg = <0>;
+				clock-frequency = <0>;
+				#clock-cells = <0>;
+				clock-output-names = "xusbxti";
+			};
+
+			xxti: clock@1 {
+				compatible = "fixed-clock";
+				reg = <1>;
+				clock-frequency = <0>;
+				#clock-cells = <0>;
+				clock-output-names = "xxti";
+			};
+
+			xtcxo: clock@2 {
+				compatible = "fixed-clock";
+				reg = <2>;
+				clock-frequency = <0>;
+				#clock-cells = <0>;
+				clock-output-names = "xtcxo";
+			};
+		};
+
+		sysram@02020000 {
+			compatible = "mmio-sysram";
+			reg = <0x02020000 0x40000>;
+			#address-cells = <1>;
+			#size-cells = <1>;
+			ranges = <0 0x02020000 0x40000>;
+
+			smp-sysram@0 {
+				compatible = "samsung,exynos4210-sysram";
+				reg = <0x0 0x1000>;
+			};
+
+			smp-sysram@3f000 {
+				compatible = "samsung,exynos4210-sysram-ns";
+				reg = <0x3f000 0x1000>;
+			};
+		};
+
+		chipid@10000000 {
+			compatible = "samsung,exynos4210-chipid";
+			reg = <0x10000000 0x100>;
+		};
+
+		sys_reg: syscon@10010000 {
+			compatible = "samsung,exynos3-sysreg", "syscon";
+			reg = <0x10010000 0x400>;
+		};
+
+		pd_cam: cam-power-domain@10023C00 {
+			compatible = "samsung,exynos4210-pd";
+			reg = <0x10023C00 0x20>;
+		};
+
+		pd_mfc: mfc-power-domain@10023C40 {
+			compatible = "samsung,exynos4210-pd";
+			reg = <0x10023C40 0x20>;
+		};
+
+		pd_g3d: g3d-power-domain@10023C60 {
+			compatible = "samsung,exynos4210-pd";
+			reg = <0x10023C60 0x20>;
+		};
+
+		pd_lcd0: lcd0-power-domain@10023C80 {
+			compatible = "samsung,exynos4210-pd";
+			reg = <0x10023C80 0x20>;
+		};
+
+		pd_isp: isp-power-domain@10023CA0 {
+			compatible = "samsung,exynos4210-pd";
+			reg = <0x10023CA0 0x20>;
+		};
+
+		cmu: clock-controller@10030000 {
+			compatible = "samsung,exynos3250-cmu";
+			reg = <0x10030000 0x20000>;
+			#clock-cells = <1>;
+		};
+
+		rtc: rtc@10070000 {
+			compatible = "samsung,s3c6410-rtc";
+			reg = <0x10070000 0x100>;
+			interrupts = <0 73 0>, <0 74 0>;
+			status = "disabled";
+		};
+
+		gic: interrupt-controller@10481000 {
+			compatible = "arm,cortex-a15-gic";
+			#interrupt-cells = <3>;
+			interrupt-controller;
+			reg = <0x10481000 0x1000>,
+			      <0x10482000 0x1000>,
+			      <0x10484000 0x2000>,
+			      <0x10486000 0x2000>;
+			interrupts = <1 9 0xf04>;
+		};
+
+		mct@10050000 {
+			compatible = "samsung,exynos4210-mct";
+			reg = <0x10050000 0x800>;
+			interrupts = <0 218 0>, <0 219 0>, <0 220 0>, <0 221 0>,
+				     <0 223 0>, <0 226 0>, <0 227 0>, <0 228 0>;
+			clocks = <&cmu CLK_FIN_PLL>, <&cmu CLK_MCT>;
+			clock-names = "fin_pll", "mct";
+		};
+
+		pinctrl_1: pinctrl@11000000 {
+			compatible = "samsung,exynos3250-pinctrl";
+			reg = <0x11000000 0x1000>;
+			interrupts = <0 225 0>;
+
+			wakeup-interrupt-controller {
+				compatible = "samsung,exynos4210-wakeup-eint";
+				interrupt-parent = <&gic>;
+				interrupts = <0 48 0>;
+			};
+		};
+
+		pinctrl_0: pinctrl@11400000 {
+			compatible = "samsung,exynos3250-pinctrl";
+			reg = <0x11400000 0x1000>;
+			interrupts = <0 240 0>;
+		};
+
+		mshc_0: mshc@12510000 {
+			compatible = "samsung,exynos5250-dw-mshc";
+			reg = <0x12510000 0x1000>;
+			interrupts = <0 142 0>;
+			clocks = <&cmu CLK_SDMMC0>, <&cmu CLK_SCLK_MMC0>;
+			clock-names = "biu", "ciu";
+			fifo-depth = <0x80>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+			status = "disabled";
+		};
+
+		mshc_1: mshc@12520000 {
+			compatible = "samsung,exynos5250-dw-mshc";
+			reg = <0x12520000 0x1000>;
+			interrupts = <0 143 0>;
+			clocks = <&cmu CLK_SDMMC1>, <&cmu CLK_SCLK_MMC1>;
+			clock-names = "biu", "ciu";
+			fifo-depth = <0x80>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+			status = "disabled";
+		};
+
+		amba {
+			compatible = "arm,amba-bus";
+			#address-cells = <1>;
+			#size-cells = <1>;
+			interrupt-parent = <&gic>;
+			ranges;
+
+			pdma0: pdma@12680000 {
+				compatible = "arm,pl330", "arm,primecell";
+				reg = <0x12680000 0x1000>;
+				interrupts = <0 138 0>;
+				clocks = <&cmu CLK_PDMA0>;
+				clock-names = "apb_pclk";
+				#dma-cells = <1>;
+				#dma-channels = <8>;
+				#dma-requests = <32>;
+			};
+
+			pdma1: pdma@12690000 {
+				compatible = "arm,pl330", "arm,primecell";
+				reg = <0x12690000 0x1000>;
+				interrupts = <0 139 0>;
+				clocks = <&cmu CLK_PDMA1>;
+				clock-names = "apb_pclk";
+				#dma-cells = <1>;
+				#dma-channels = <8>;
+				#dma-requests = <32>;
+			};
+		};
+
+		adc: adc@126C0000 {
+			compatible = "samsung,exynos-adc-v3";
+			reg = <0x126C0000 0x100>, <0x10020718 0x4>;
+			interrupts = <0 137 0>;
+			clock-names = "adc", "sclk_tsadc";
+			clocks = <&cmu CLK_TSADC>, <&cmu CLK_SCLK_TSADC>;
+			#io-channel-cells = <1>;
+			io-channel-ranges;
+			status = "disabled";
+		};
+
+		serial_0: serial@13800000 {
+			compatible = "samsung,exynos4210-uart";
+			reg = <0x13800000 0x100>;
+			interrupts = <0 109 0>;
+			clocks = <&cmu CLK_UART0>, <&cmu CLK_SCLK_UART0>;
+			clock-names = "uart", "clk_uart_baud0";
+			status = "disabled";
+		};
+
+		serial_1: serial@13810000 {
+			compatible = "samsung,exynos4210-uart";
+			reg = <0x13810000 0x100>;
+			interrupts = <0 110 0>;
+			clocks = <&cmu CLK_UART1>, <&cmu CLK_SCLK_UART1>;
+			clock-names = "uart", "clk_uart_baud0";
+			status = "disabled";
+		};
+
+		i2c_0: i2c@13860000 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			compatible = "samsung,s3c2440-i2c";
+			reg = <0x13860000 0x100>;
+			interrupts = <0 113 0>;
+			clocks = <&cmu CLK_I2C0>;
+			clock-names = "i2c";
+			pinctrl-names = "default";
+			pinctrl-0 = <&i2c0_bus>;
+			status = "disabled";
+		};
+
+		i2c_1: i2c@13870000 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			compatible = "samsung,s3c2440-i2c";
+			reg = <0x13870000 0x100>;
+			interrupts = <0 114 0>;
+			clocks = <&cmu CLK_I2C1>;
+			clock-names = "i2c";
+			pinctrl-names = "default";
+			pinctrl-0 = <&i2c1_bus>;
+			status = "disabled";
+		};
+
+		i2c_2: i2c@13880000 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			compatible = "samsung,s3c2440-i2c";
+			reg = <0x13880000 0x100>;
+			interrupts = <0 115 0>;
+			clocks = <&cmu CLK_I2C2>;
+			clock-names = "i2c";
+			pinctrl-names = "default";
+			pinctrl-0 = <&i2c2_bus>;
+			status = "disabled";
+		};
+
+		i2c_3: i2c@13890000 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			compatible = "samsung,s3c2440-i2c";
+			reg = <0x13890000 0x100>;
+			interrupts = <0 116 0>;
+			clocks = <&cmu CLK_I2C3>;
+			clock-names = "i2c";
+			pinctrl-names = "default";
+			pinctrl-0 = <&i2c3_bus>;
+			status = "disabled";
+		};
+
+		i2c_4: i2c@138A0000 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			compatible = "samsung,s3c2440-i2c";
+			reg = <0x138A0000 0x100>;
+			interrupts = <0 117 0>;
+			clocks = <&cmu CLK_I2C4>;
+			clock-names = "i2c";
+			pinctrl-names = "default";
+			pinctrl-0 = <&i2c4_bus>;
+			status = "disabled";
+		};
+
+		i2c_5: i2c@138B0000 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			compatible = "samsung,s3c2440-i2c";
+			reg = <0x138B0000 0x100>;
+			interrupts = <0 118 0>;
+			clocks = <&cmu CLK_I2C5>;
+			clock-names = "i2c";
+			pinctrl-names = "default";
+			pinctrl-0 = <&i2c5_bus>;
+			status = "disabled";
+		};
+
+		i2c_6: i2c@138C0000 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			compatible = "samsung,s3c2440-i2c";
+			reg = <0x138C0000 0x100>;
+			interrupts = <0 119 0>;
+			clocks = <&cmu CLK_I2C6>;
+			clock-names = "i2c";
+			pinctrl-names = "default";
+			pinctrl-0 = <&i2c6_bus>;
+			status = "disabled";
+		};
+
+		i2c_7: i2c@138D0000 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			compatible = "samsung,s3c2440-i2c";
+			reg = <0x138D0000 0x100>;
+			interrupts = <0 120 0>;
+			clocks = <&cmu CLK_I2C7>;
+			clock-names = "i2c";
+			pinctrl-names = "default";
+			pinctrl-0 = <&i2c7_bus>;
+			status = "disabled";
+		};
+
+		spi_0: spi@13920000 {
+			compatible = "samsung,exynos4210-spi";
+			reg = <0x13920000 0x100>;
+			interrupts = <0 121 0>;
+			dmas = <&pdma0 7>, <&pdma0 6>;
+			dma-names = "tx", "rx";
+			#address-cells = <1>;
+			#size-cells = <0>;
+			clocks = <&cmu CLK_SPI0>, <&cmu CLK_SCLK_SPI0>;
+			clock-names = "spi", "spi_busclk0";
+			samsung,spi-src-clk = <0>;
+			pinctrl-names = "default";
+			pinctrl-0 = <&spi0_bus>;
+			status = "disabled";
+		};
+
+		spi_1: spi@13930000 {
+			compatible = "samsung,exynos4210-spi";
+			reg = <0x13930000 0x100>;
+			interrupts = <0 122 0>;
+			dmas = <&pdma1 7>, <&pdma1 6>;
+			dma-names = "tx", "rx";
+			#address-cells = <1>;
+			#size-cells = <0>;
+			clocks = <&cmu CLK_SPI1>, <&cmu CLK_SCLK_SPI1>;
+			clock-names = "spi", "spi_busclk0";
+			samsung,spi-src-clk = <0>;
+			pinctrl-names = "default";
+			pinctrl-0 = <&spi1_bus>;
+			status = "disabled";
+		};
+
+		pwm: pwm@139D0000 {
+			compatible = "samsung,exynos4210-pwm";
+			reg = <0x139D0000 0x1000>;
+			interrupts = <0 104 0>, <0 105 0>, <0 106 0>,
+				     <0 107 0>, <0 108 0>;
+			#pwm-cells = <3>;
+			status = "disabled";
+		};
+
+		pmu {
+			compatible = "arm,cortex-a7-pmu";
+			interrupts = <0 18 0>, <0 19 0>;
+		};
+	};
+};
+
+#include "exynos3250-pinctrl.dtsi"
-- 
1.8.0

