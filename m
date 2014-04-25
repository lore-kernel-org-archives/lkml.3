Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751493AbaDYBRT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 21:17:19 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:16892 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215AbaDYBQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 21:16:23 -0400
X-AuditID: cbfee690-b7fcd6d0000026e0-91-5359b7634c62
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
Subject: [PATCHv4 7/7] ARM: dts: Add device tree sources for Exynos3250
Date: Fri, 25 Apr 2014 10:16:12 +0900
Message-id: <1398388572-30239-8-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1398388572-30239-1-git-send-email-cw00.choi@samsung.com>
References: <1398388572-30239-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmleLIzCtJLcpLzFFi42JZI2JSoJuyPTLYYPEZXou/k46xW2ycsZ7V
	YtK6A0wWl/drW1z/8pzVYv6Rc6wW/W8Wslp8/tDCbnHu1UpGi0n3J7BY3PjVxmrRu+Aqm8XZ
	pjfsFpseX2O1uLxrDpvFjPP7mCxuXwYaeecfm8XS6xeZLE5d/8xmMWH6WhaL1r1H2C1O/ull
	tHhy+COrxYzJL9ks1s94zWJxbMYSRov2v3vZLPbunMzoIOuxZt4aRo+W5h42j9+/JjF6XO7r
	ZfL4u+oFs8fOWXfZPVYu/8LmsWlVJ5vHnWt72Dw2L6n3uHKiidWjb8sqRo/Pm+QCeKO4bFJS
	czLLUov07RK4Mg40f2YvmP6SqeLnzf3MDYyLJzB1MXJySAiYSGxY+YAVwhaTuHBvPVsXIxeH
	kMBSRok/k/+wwBS9PryUESIxnVFi/vSJjCAJIYEmJokNmwNBbDYBLYn9L26wgdgiAroSU2be
	YQVpYBZYwiZxaf06sEnCAu4Se/fvAmtmEVCV+LSuG2w1r4CrxILeJqhtchIf9jxiB7E5Bdwk
	du56BXQqB9AyV4mlfzxAZkoI/OeQuLNxHSvEHAGJb5MPsYDUSAjISmw6wAwxRlLi4IobLBMY
	hRcwMqxiFE0tSC4oTkovMtErTswtLs1L10vOz93ECEwIp/89m7CD8d4B60OMyUDjJjJLiSbn
	AxNKXkm8obGZkYWpiamxkbmlGWnCSuK8ao+SgoQE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUw
	VlZduPPrz/zZJwpajzkGTOcxd956dG6K29yKZ5r25bu9k9ysPx8+rPjkoVbH3It1JaukV+v6
	yNunr8jO++POpurRmqI4zeLhWvmd5zTPrPbWCf5z+HhOVX6z6P4vwVW3X5x7peH0YYbo4fIn
	Pst9Z55eruJ3/GmFRXT6JZ2Lp2YeUVF/zZeVocRSnJFoqMVcVJwIAA0R1TgeAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBKsWRmVeSWpSXmKPExsVy+t9jQd3k7ZHBBh+vGFr8nXSM3WLjjPWs
	FpPWHWCyuLxf2+L6l+esFvOPnGO16H+zkNXi84cWdotzr1YyWky6P4HF4savNlaL3gVX2SzO
	Nr1ht9j0+BqrxeVdc9gsZpzfx2Rx+zKvxd87/9gsll6/yGRx6vpnNosJ09eyWLTuPcJucfJP
	L6PFk8MfWS1mTH7JZrF+xmsWi2MzljBatP/dy2axd+dkRgdZjzXz1jB6tDT3sHn8/jWJ0eNy
	Xy+Tx99VL5g9ds66y+6xcvkXNo9NqzrZPO5c28PmsXlJvceVE02sHn1bVjF6fN4kF8Ab1cBo
	k5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQMMGiWFssSc
	UqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYQ1jxoHmz+wF018yVfy8uZ+5gXHxBKYu
	Rk4OCQETideHlzJC2GISF+6tZ+ti5OIQEpjOKDF/+kSwhJBAE5PEhs2BIDabgJbE/hc32EBs
	EQFdiSkz77CCNDALLGGTuLR+HQtIQljAXWLv/l1gzSwCqhKf1nWzgti8Aq4SC3qbWCC2yUl8
	2POIHcTmFHCT2LnrFdBFHEDLXCWW/vGYwMi7gJFhFaNoakFyQXFSeq6RXnFibnFpXrpecn7u
	JkZwunkmvYNxVYPFIUYBDkYlHt4JspHBQqyJZcWVuYcYJTiYlUR4lVcBhXhTEiurUovy44tK
	c1KLDzEmAx01kVlKNDkfmArzSuINjU3MjCyNzA0tjIzNSRNWEuc92GodKCSQnliSmp2aWpBa
	BLOFiYNTqoExyf2yROenkhz5eQLJ19ZnWpc8VjxRdO90ruy/HY7PTlQ5FJ65JJK99/LCo0dF
	rlu2hnQKhJ1IXvb9Rb3j+Xsv/rzLT768Z+HZiKU24Vpv0kIdrjnERK3bzT/Z90D9b1bL21/X
	vbexX3ov0LbauN/Xc7EQe9uZnCLxpyUSX3ZZ/D5wz8CWNyZDiaU4I9FQi7moOBEA3ar73HsD	AAA=
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
 arch/arm/boot/dts/exynos3250-pinctrl.dtsi | 477 +++++++++++++++
 arch/arm/boot/dts/exynos3250.dtsi         | 405 +++++++++++++
 arch/arm/boot/dts/exynos4212-tizenw.dts   | 926 ++++++++++++++++++++++++++++++
 3 files changed, 1808 insertions(+)
 create mode 100644 arch/arm/boot/dts/exynos3250-pinctrl.dtsi
 create mode 100644 arch/arm/boot/dts/exynos3250.dtsi
 create mode 100644 arch/arm/boot/dts/exynos4212-tizenw.dts

diff --git a/arch/arm/boot/dts/exynos3250-pinctrl.dtsi b/arch/arm/boot/dts/exynos3250-pinctrl.dtsi
new file mode 100644
index 0000000..976490b
--- /dev/null
+++ b/arch/arm/boot/dts/exynos3250-pinctrl.dtsi
@@ -0,0 +1,477 @@
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
+/ {
+	pinctrl@11400000 {
+		gpa0: gpa0 {
+			gpio-controller;
+			#gpio-cells = <2>;
+
+			interrupt-controller;
+			#interrupt-cells = <2>;
+		};
+
+		gpa1: gpa1 {
+			gpio-controller;
+			#gpio-cells = <2>;
+
+			interrupt-controller;
+			#interrupt-cells = <2>;
+		};
+
+		gpb: gpb {
+			gpio-controller;
+			#gpio-cells = <2>;
+
+			interrupt-controller;
+			#interrupt-cells = <2>;
+		};
+
+		gpc0: gpc0 {
+			gpio-controller;
+			#gpio-cells = <2>;
+
+			interrupt-controller;
+			#interrupt-cells = <2>;
+		};
+
+		gpc1: gpc1 {
+			gpio-controller;
+			#gpio-cells = <2>;
+
+			interrupt-controller;
+			#interrupt-cells = <2>;
+		};
+
+		gpd0: gpd0 {
+			gpio-controller;
+			#gpio-cells = <2>;
+
+			interrupt-controller;
+			#interrupt-cells = <2>;
+		};
+
+		gpd1: gpd1 {
+			gpio-controller;
+			#gpio-cells = <2>;
+
+			interrupt-controller;
+			#interrupt-cells = <2>;
+		};
+
+		uart0_data: uart0-data {
+			samsung,pins = "gpa0-0", "gpa0-1";
+			samsung,pin-function = <0x2>;
+			samsung,pin-pud = <0>;
+			samsung,pin-drv = <0>;
+		};
+
+		uart0_fctl: uart0-fctl {
+			samsung,pins = "gpa0-2", "gpa0-3";
+			samsung,pin-function = <2>;
+			samsung,pin-pud = <0>;
+			samsung,pin-drv = <0>;
+		};
+
+		uart1_data: uart1-data {
+			samsung,pins = "gpa0-4", "gpa0-5";
+			samsung,pin-function = <2>;
+			samsung,pin-pud = <0>;
+			samsung,pin-drv = <0>;
+		};
+
+		uart1_fctl: uart1-fctl {
+			samsung,pins = "gpa0-6", "gpa0-7";
+			samsung,pin-function = <2>;
+			samsung,pin-pud = <0>;
+			samsung,pin-drv = <0>;
+		};
+
+		i2c2_bus: i2c2-bus {
+			samsung,pins = "gpa0-6", "gpa0-7";
+			samsung,pin-function = <3>;
+			samsung,pin-pud = <3>;
+			samsung,pin-drv = <0>;
+		};
+
+		i2c3_bus: i2c3-bus {
+			samsung,pins = "gpa1-2", "gpa1-3";
+			samsung,pin-function = <3>;
+			samsung,pin-pud = <3>;
+			samsung,pin-drv = <0>;
+		};
+
+		spi0_bus: spi0-bus {
+			samsung,pins = "gpb-0", "gpb-2", "gpb-3";
+			samsung,pin-function = <2>;
+			samsung,pin-pud = <3>;
+			samsung,pin-drv = <0>;
+		};
+
+		i2c4_bus: i2c4-bus {
+			samsung,pins = "gpb-0", "gpb-1";
+			samsung,pin-function = <3>;
+			samsung,pin-pud = <3>;
+			samsung,pin-drv = <0>;
+		};
+
+		spi1_bus: spi1-bus {
+			samsung,pins = "gpb-4", "gpb-6", "gpb-7";
+			samsung,pin-function = <2>;
+			samsung,pin-pud = <3>;
+			samsung,pin-drv = <0>;
+		};
+
+		i2c5_bus: i2c5-bus {
+			samsung,pins = "gpb-2", "gpb-3";
+			samsung,pin-function = <3>;
+			samsung,pin-pud = <3>;
+			samsung,pin-drv = <0>;
+		};
+
+		i2s2_bus: i2s2-bus {
+			samsung,pins = "gpc1-0", "gpc1-1", "gpc1-2", "gpc1-3",
+					"gpc1-4";
+			samsung,pin-function = <2>;
+			samsung,pin-pud = <0>;
+			samsung,pin-drv = <0>;
+		};
+
+		pcm2_bus: pcm2-bus {
+			samsung,pins = "gpc1-0", "gpc1-1", "gpc1-2", "gpc1-3",
+					"gpc1-4";
+			samsung,pin-function = <3>;
+			samsung,pin-pud = <0>;
+			samsung,pin-drv = <0>;
+		};
+
+		i2c6_bus: i2c6-bus {
+			samsung,pins = "gpc1-3", "gpc1-4";
+			samsung,pin-function = <4>;
+			samsung,pin-pud = <3>;
+			samsung,pin-drv = <0>;
+		};
+
+		pwm0_out: pwm0-out {
+			samsung,pins = "gpd0-0";
+			samsung,pin-function = <2>;
+			samsung,pin-pud = <0>;
+			samsung,pin-drv = <0>;
+		};
+
+		pwm1_out: pwm1-out {
+			samsung,pins = "gpd0-1";
+			samsung,pin-function = <2>;
+			samsung,pin-pud = <0>;
+			samsung,pin-drv = <0>;
+		};
+
+		i2c7_bus: i2c7-bus {
+			samsung,pins = "gpd0-2", "gpd0-3";
+			samsung,pin-function = <3>;
+			samsung,pin-pud = <3>;
+			samsung,pin-drv = <0>;
+		};
+
+		pwm2_out: pwm2-out {
+			samsung,pins = "gpd0-2";
+			samsung,pin-function = <2>;
+			samsung,pin-pud = <0>;
+			samsung,pin-drv = <0>;
+		};
+
+		pwm3_out: pwm3-out {
+			samsung,pins = "gpd0-3";
+			samsung,pin-function = <2>;
+			samsung,pin-pud = <0>;
+			samsung,pin-drv = <0>;
+		};
+
+		i2c0_bus: i2c0-bus {
+			samsung,pins = "gpd1-0", "gpd1-1";
+			samsung,pin-function = <2>;
+			samsung,pin-pud = <3>;
+			samsung,pin-drv = <0>;
+		};
+
+		mipi0_clk: mipi0-clk {
+			samsung,pins = "gpd1-0", "gpd1-1";
+			samsung,pin-function = <3>;
+			samsung,pin-pud = <0>;
+			samsung,pin-drv = <0>;
+		};
+
+		i2c1_bus: i2c1-bus {
+			samsung,pins = "gpd1-2", "gpd1-3";
+			samsung,pin-function = <2>;
+			samsung,pin-pud = <3>;
+			samsung,pin-drv = <0>;
+		};
+	};
+
+	pinctrl@11000000 {
+		gpe0: gpe0 {
+			gpio-controller;
+			#gpio-cells = <2>;
+		};
+
+		gpe1: gpe1 {
+			gpio-controller;
+			#gpio-cells = <2>;
+		};
+
+		gpe2: gpe2 {
+			gpio-controller;
+			#gpio-cells = <2>;
+		};
+
+		gpk0: gpk0 {
+			gpio-controller;
+			#gpio-cells = <2>;
+
+			interrupt-controller;
+			#interrupt-cells = <2>;
+		};
+
+		gpk1: gpk1 {
+			gpio-controller;
+			#gpio-cells = <2>;
+
+			interrupt-controller;
+			#interrupt-cells = <2>;
+		};
+
+		gpk2: gpk2 {
+			gpio-controller;
+			#gpio-cells = <2>;
+
+			interrupt-controller;
+			#interrupt-cells = <2>;
+		};
+
+		gpl0: gpl0 {
+			gpio-controller;
+			#gpio-cells = <2>;
+
+			interrupt-controller;
+			#interrupt-cells = <2>;
+		};
+
+		gpm0: gpm0 {
+			gpio-controller;
+			#gpio-cells = <2>;
+
+			interrupt-controller;
+			#interrupt-cells = <2>;
+		};
+
+		gpm1: gpm1 {
+			gpio-controller;
+			#gpio-cells = <2>;
+
+			interrupt-controller;
+			#interrupt-cells = <2>;
+		};
+
+		gpm2: gpm2 {
+			gpio-controller;
+			#gpio-cells = <2>;
+
+			interrupt-controller;
+			#interrupt-cells = <2>;
+		};
+
+		gpm3: gpm3 {
+			gpio-controller;
+			#gpio-cells = <2>;
+
+			interrupt-controller;
+			#interrupt-cells = <2>;
+		};
+
+		gpm4: gpm4 {
+			gpio-controller;
+			#gpio-cells = <2>;
+
+			interrupt-controller;
+			#interrupt-cells = <2>;
+		};
+
+		gpx0: gpx0 {
+			gpio-controller;
+			#gpio-cells = <2>;
+
+			interrupt-controller;
+			interrupt-parent = <&gic>;
+			interrupts = <0 32 0>, <0 33 0>, <0 34 0>, <0 35 0>,
+					<0 36 0>, <0 37 0>, <0 38 0>, <0 39 0>;
+			#interrupt-cells = <2>;
+		};
+
+		gpx1: gpx1 {
+			gpio-controller;
+			#gpio-cells = <2>;
+
+			interrupt-controller;
+			interrupt-parent = <&gic>;
+			interrupts = <0 40 0>, <0 41 0>, <0 42 0>, <0 43 0>,
+					<0 44 0>, <0 45 0>, <0 46 0>, <0 47 0>;
+			#interrupt-cells = <2>;
+		};
+
+		gpx2: gpx2 {
+			gpio-controller;
+			#gpio-cells = <2>;
+
+			interrupt-controller;
+			#interrupt-cells = <2>;
+		};
+
+		gpx3: gpx3 {
+			gpio-controller;
+			#gpio-cells = <2>;
+
+			interrupt-controller;
+			#interrupt-cells = <2>;
+		};
+
+		sd0_clk: sd0-clk {
+			samsung,pins = "gpk0-0";
+			samsung,pin-function = <2>;
+			samsung,pin-pud = <0>;
+			samsung,pin-drv = <3>;
+		};
+
+		sd0_cmd: sd0-cmd {
+			samsung,pins = "gpk0-1";
+			samsung,pin-function = <2>;
+			samsung,pin-pud = <0>;
+			samsung,pin-drv = <3>;
+		};
+
+		sd0_cd: sd0-cd {
+			samsung,pins = "gpk0-2";
+			samsung,pin-function = <2>;
+			samsung,pin-pud = <3>;
+			samsung,pin-drv = <3>;
+		};
+
+		sd0_rdqs: sd0-rdqs {
+			samsung,pins = "gpk0-7";
+			samsung,pin-function = <2>;
+			samsung,pin-pud = <0>;
+			samsung,pin-drv = <3>;
+		};
+
+		sd0_bus1: sd0-bus-width1 {
+			samsung,pins = "gpk0-3";
+			samsung,pin-function = <2>;
+			samsung,pin-pud = <3>;
+			samsung,pin-drv = <3>;
+		};
+
+		sd0_bus4: sd0-bus-width4 {
+			samsung,pins = "gpk0-4", "gpk0-5", "gpk0-6";
+			samsung,pin-function = <2>;
+			samsung,pin-pud = <3>;
+			samsung,pin-drv = <3>;
+		};
+
+		sd0_bus8: sd0-bus-width8 {
+			samsung,pins = "gpl0-0", "gpl0-1", "gpl0-2", "gpl0-3";
+			samsung,pin-function = <2>;
+			samsung,pin-pud = <3>;
+			samsung,pin-drv = <3>;
+		};
+
+		sd1_clk: sd1-clk {
+			samsung,pins = "gpk1-0";
+			samsung,pin-function = <2>;
+			samsung,pin-pud = <0>;
+			samsung,pin-drv = <3>;
+		};
+
+		sd1_cmd: sd1-cmd {
+			samsung,pins = "gpk1-1";
+			samsung,pin-function = <2>;
+			samsung,pin-pud = <0>;
+			samsung,pin-drv = <3>;
+		};
+
+		sd1_cd: sd1-cd {
+			samsung,pins = "gpk1-2";
+			samsung,pin-function = <2>;
+			samsung,pin-pud = <3>;
+			samsung,pin-drv = <3>;
+		};
+
+		sd1_bus1: sd1-bus-width1 {
+			samsung,pins = "gpk1-3";
+			samsung,pin-function = <2>;
+			samsung,pin-pud = <3>;
+			samsung,pin-drv = <3>;
+		};
+
+		sd1_bus4: sd1-bus-width4 {
+			samsung,pins = "gpk1-4", "gpk1-5", "gpk1-6";
+			samsung,pin-function = <2>;
+			samsung,pin-pud = <3>;
+			samsung,pin-drv = <3>;
+		};
+
+		cam_port_b_io: cam-port-b-io {
+			samsung,pins = "gpm0-0", "gpm0-1", "gpm0-2", "gpm0-3",
+					"gpm0-4", "gpm0-5", "gpm0-6", "gpm0-7",
+					"gpm1-0", "gpm1-1", "gpm2-0", "gpm2-1";
+			samsung,pin-function = <3>;
+			samsung,pin-pud = <3>;
+			samsung,pin-drv = <0>;
+		};
+
+		cam_port_b_clk_active: cam-port-b-clk-active {
+			samsung,pins = "gpm2-2";
+			samsung,pin-function = <3>;
+			samsung,pin-pud = <0>;
+			samsung,pin-drv = <3>;
+		};
+
+		cam_port_b_clk_idle: cam-port-b-clk-idle {
+			samsung,pins = "gpm2-2";
+			samsung,pin-function = <0>;
+			samsung,pin-pud = <0>;
+			samsung,pin-drv = <0>;
+		};
+
+		fimc_is_i2c0: fimc-is-i2c0 {
+			samsung,pins = "gpm4-0", "gpm4-1";
+			samsung,pin-function = <2>;
+			samsung,pin-pud = <0>;
+			samsung,pin-drv = <0>;
+		};
+
+		fimc_is_i2c1: fimc-is-i2c1 {
+			samsung,pins = "gpm4-2", "gpm4-3";
+			samsung,pin-function = <2>;
+			samsung,pin-pud = <0>;
+			samsung,pin-drv = <0>;
+		};
+
+		fimc_is_uart: fimc-is-uart {
+			samsung,pins = "gpm3-5", "gpm3-7";
+			samsung,pin-function = <3>;
+			samsung,pin-pud = <0>;
+			samsung,pin-drv = <0>;
+		};
+	};
+};
diff --git a/arch/arm/boot/dts/exynos3250.dtsi b/arch/arm/boot/dts/exynos3250.dtsi
new file mode 100644
index 0000000..5be3dd3
--- /dev/null
+++ b/arch/arm/boot/dts/exynos3250.dtsi
@@ -0,0 +1,405 @@
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
+#include "exynos3250-pinctrl.dtsi"
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
+		cpu@0 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a7";
+			reg = <0>;
+			clock-frequency = <1000000000>;
+		};
+	};
+
+	fixed-rate-clocks {
+		compatible = "simple-bus";
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		xusbxti: clock@0 {
+			compatible = "fixed-clock";
+			reg = <0>;
+			clock-frequency = <0>;
+			#clock-cells = <0>;
+			clock-output-names = "xusbxti";
+		};
+
+		xxti: clock@1 {
+			compatible = "fixed-clock";
+			reg = <1>;
+			clock-frequency = <0>;
+			#clock-cells = <0>;
+			clock-output-names = "xxti";
+		};
+
+		xtcxo: clock@2 {
+			compatible = "fixed-clock";
+			reg = <2>;
+			clock-frequency = <0>;
+			#clock-cells = <0>;
+			clock-output-names = "xtcxo";
+		};
+	};
+
+	chipid@10000000 {
+		compatible = "samsung,exynos4210-chipid";
+		reg = <0x10000000 0x100>;
+	};
+
+	sys_reg: syscon@10010000 {
+		compatible = "samsung,exynos3-sysreg", "syscon";
+		reg = <0x10010000 0x400>;
+	};
+
+	pd_cam: cam-power-domain@10023C00 {
+		compatible = "samsung,exynos4210-pd";
+		reg = <0x10023C00 0x20>;
+	};
+
+	pd_mfc: mfc-power-domain@10023C40 {
+		compatible = "samsung,exynos4210-pd";
+		reg = <0x10023C40 0x20>;
+	};
+
+	pd_g3d: g3d-power-domain@10023C60 {
+		compatible = "samsung,exynos4210-pd";
+		reg = <0x10023C60 0x20>;
+	};
+
+	pd_lcd0: lcd0-power-domain@10023C80 {
+		compatible = "samsung,exynos4210-pd";
+		reg = <0x10023C80 0x20>;
+	};
+
+	pd_isp: isp-power-domain@10023CA0 {
+		compatible = "samsung,exynos4210-pd";
+		reg = <0x10023CA0 0x20>;
+	};
+
+	cmu: clock-controller@10030000 {
+		compatible = "samsung,exynos3250-cmu";
+		reg = <0x10030000 0x20000>;
+		#clock-cells = <1>;
+	};
+
+	rtc@10070000 {
+		compatible = "samsung,s3c6410-rtc";
+		reg = <0x10070000 0x100>;
+		interrupts = <0 73 0>, <0 74 0>;
+		status = "disabled";
+	};
+
+	gic: interrupt-controller@10481000 {
+		compatible = "arm,cortex-a15-gic";
+		#interrupt-cells = <3>;
+		interrupt-controller;
+		reg = <0x10481000 0x1000>,
+		      <0x10482000 0x1000>,
+		      <0x10484000 0x2000>,
+		      <0x10486000 0x2000>;
+		      interrupts = <1 9 0xf04>;
+	};
+
+	mct@10050000 {
+		compatible = "samsung,exynos4210-mct";
+		reg = <0x10050000 0x800>;
+		interrupts = <0 218 0>, <0 219 0>, <0 220 0>, <0 221 0>,
+			     <0 223 0>, <0 226 0>, <0 227 0>, <0 228 0>;
+		clocks = <&cmu CLK_FIN_PLL>, <&cmu CLK_MCT>;
+		clock-names = "fin_pll", "mct";
+	};
+
+	pinctrl_1: pinctrl@11000000 {
+		compatible = "samsung,exynos3250-pinctrl";
+		reg = <0x11000000 0x1000>;
+		interrupts = <0 225 0>;
+
+		wakeup-interrupt-controller {
+			compatible = "samsung,exynos4210-wakeup-eint";
+			interrupt-parent = <&gic>;
+			interrupts = <0 48 0>;
+		};
+	};
+
+	pinctrl_0: pinctrl@11400000 {
+		compatible = "samsung,exynos3250-pinctrl";
+		reg = <0x11400000 0x1000>;
+		interrupts = <0 240 0>;
+	};
+
+	mshc_0: mshc@12510000 {
+		compatible = "samsung,exynos5250-dw-mshc";
+		reg = <0x12510000 0x1000>;
+		interrupts = <0 142 0>;
+		clocks = <&cmu CLK_SDMMC0>, <&cmu CLK_SCLK_MMC0>;
+		clock-names = "biu", "ciu";
+		fifo-depth = <0x80>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		status = "disabled";
+	};
+
+	mshc_1: mshc@12520000 {
+		compatible = "samsung,exynos5250-dw-mshc";
+		reg = <0x12520000 0x1000>;
+		interrupts = <0 143 0>;
+		clocks = <&cmu CLK_SDMMC1>, <&cmu CLK_SCLK_MMC1>;
+		clock-names = "biu", "ciu";
+		fifo-depth = <0x80>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		status = "disabled";
+	};
+
+	amba {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		compatible = "arm,amba-bus";
+		interrupt-parent = <&gic>;
+		ranges;
+
+		pdma0: pdma@12680000 {
+			compatible = "arm,pl330", "arm,primecell";
+			reg = <0x12680000 0x1000>;
+			interrupts = <0 138 0>;
+			clocks = <&cmu CLK_PDMA0>;
+			clock-names = "apb_pclk";
+			#dma-cells = <1>;
+			#dma-channels = <8>;
+			#dma-requests = <32>;
+		};
+
+		pdma1: pdma@12690000 {
+			compatible = "arm,pl330", "arm,primecell";
+			reg = <0x12690000 0x1000>;
+			interrupts = <0 139 0>;
+			clocks = <&cmu CLK_PDMA1>;
+			clock-names = "apb_pclk";
+			#dma-cells = <1>;
+			#dma-channels = <8>;
+			#dma-requests = <32>;
+		};
+	};
+
+	adc: adc@126C0000 {
+		compatible = "samsung,exynos-adc-v3";
+		reg = <0x126C0000 0x100>, <0x10020718 0x4>;
+		interrupts = <0 137 0>;
+		clock-names = "adc", "sclk_tsadc";
+		clocks = <&cmu CLK_TSADC>, <&cmu CLK_SCLK_TSADC>;
+		#io-channel-cells = <1>;
+		io-channel-ranges;
+		status = "disabled";
+	};
+
+	serial@13800000 {
+		compatible = "samsung,exynos4210-uart";
+		reg = <0x13800000 0x100>;
+		interrupts = <0 109 0>;
+		clocks = <&cmu CLK_UART0>, <&cmu CLK_SCLK_UART0>;
+		clock-names = "uart", "clk_uart_baud0";
+		status = "disabled";
+	};
+
+	serial@13810000 {
+		compatible = "samsung,exynos4210-uart";
+		reg = <0x13810000 0x100>;
+		interrupts = <0 110 0>;
+		clocks = <&cmu CLK_UART1>, <&cmu CLK_SCLK_UART1>;
+		clock-names = "uart", "clk_uart_baud0";
+		status = "disabled";
+	};
+
+	i2c_0: i2c@13860000 {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		compatible = "samsung,s3c2440-i2c";
+		reg = <0x13860000 0x100>;
+		interrupts = <0 113 0>;
+		clocks = <&cmu CLK_I2C0>;
+		clock-names = "i2c";
+		pinctrl-names = "default";
+		pinctrl-0 = <&i2c0_bus>;
+		status = "disabled";
+	};
+
+	i2c_1: i2c@13870000 {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		compatible = "samsung,s3c2440-i2c";
+		reg = <0x13870000 0x100>;
+		interrupts = <0 114 0>;
+		clocks = <&cmu CLK_I2C1>;
+		clock-names = "i2c";
+		pinctrl-names = "default";
+		pinctrl-0 = <&i2c1_bus>;
+		status = "disabled";
+	};
+
+	i2c_2: i2c@13880000 {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		compatible = "samsung,s3c2440-i2c";
+		reg = <0x13880000 0x100>;
+		interrupts = <0 115 0>;
+		clocks = <&cmu CLK_I2C2>;
+		clock-names = "i2c";
+		pinctrl-names = "default";
+		pinctrl-0 = <&i2c2_bus>;
+		status = "disabled";
+	};
+
+	i2c_3: i2c@13890000 {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		compatible = "samsung,s3c2440-i2c";
+		reg = <0x13890000 0x100>;
+		interrupts = <0 116 0>;
+		clocks = <&cmu CLK_I2C3>;
+		clock-names = "i2c";
+		pinctrl-names = "default";
+		pinctrl-0 = <&i2c3_bus>;
+		status = "disabled";
+	};
+
+	i2c_4: i2c@138A0000 {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		compatible = "samsung,s3c2440-i2c";
+		reg = <0x138A0000 0x100>;
+		interrupts = <0 117 0>;
+		clocks = <&cmu CLK_I2C4>;
+		clock-names = "i2c";
+		pinctrl-names = "default";
+		pinctrl-0 = <&i2c4_bus>;
+		status = "disabled";
+	};
+
+	i2c_5: i2c@138B0000 {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		compatible = "samsung,s3c2440-i2c";
+		reg = <0x138B0000 0x100>;
+		interrupts = <0 118 0>;
+		clocks = <&cmu CLK_I2C5>;
+		clock-names = "i2c";
+		pinctrl-names = "default";
+		pinctrl-0 = <&i2c5_bus>;
+		status = "disabled";
+	};
+
+	i2c_6: i2c@138C0000 {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		compatible = "samsung,s3c2440-i2c";
+		reg = <0x138C0000 0x100>;
+		interrupts = <0 119 0>;
+		clocks = <&cmu CLK_I2C6>;
+		clock-names = "i2c";
+		pinctrl-names = "default";
+		pinctrl-0 = <&i2c6_bus>;
+		status = "disabled";
+	};
+
+	i2c_7: i2c@138D0000 {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		compatible = "samsung,s3c2440-i2c";
+		reg = <0x138D0000 0x100>;
+		interrupts = <0 120 0>;
+		clocks = <&cmu CLK_I2C7>;
+		clock-names = "i2c";
+		pinctrl-names = "default";
+		pinctrl-0 = <&i2c7_bus>;
+		status = "disabled";
+	};
+
+	spi_0: spi@13920000 {
+		compatible = "samsung,exynos4210-spi";
+		reg = <0x13920000 0x100>;
+		interrupts = <0 121 0>;
+		dmas = <&pdma0 7>, <&pdma0 6>;
+		dma-names = "tx", "rx";
+		#address-cells = <1>;
+		#size-cells = <0>;
+		clocks = <&cmu CLK_SPI0>, <&cmu CLK_SCLK_SPI0>;
+		clock-names = "spi", "spi_busclk0";
+		samsung,spi-src-clk = <0>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&spi0_bus>;
+		status = "disabled";
+	};
+
+	spi_1: spi@13930000 {
+		compatible = "samsung,exynos4210-spi";
+		reg = <0x13930000 0x100>;
+		interrupts = <0 122 0>;
+		dmas = <&pdma1 7>, <&pdma1 6>;
+		dma-names = "tx", "rx";
+		#address-cells = <1>;
+		#size-cells = <0>;
+		clocks = <&cmu CLK_SPI1>, <&cmu CLK_SCLK_SPI1>;
+		clock-names = "spi", "spi_busclk0";
+		samsung,spi-src-clk = <0>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&spi1_bus>;
+		status = "disabled";
+	};
+
+	pwm: pwm@139D0000 {
+		compatible = "samsung,exynos4210-pwm";
+		reg = <0x139D0000 0x1000>;
+		interrupts = <0 104 0>, <0 105 0>, <0 106 0>,
+			     <0 107 0>, <0 108 0>;
+		#pwm-cells = <3>;
+		status = "disabled";
+	};
+
+	pmu {
+		compatible = "arm,cortex-a7-pmu";
+		interrupts = <0 18 0>, <0 19 0>;
+	};
+};
diff --git a/arch/arm/boot/dts/exynos4212-tizenw.dts b/arch/arm/boot/dts/exynos4212-tizenw.dts
new file mode 100644
index 0000000..aed7060
--- /dev/null
+++ b/arch/arm/boot/dts/exynos4212-tizenw.dts
@@ -0,0 +1,926 @@
+/*
+ * Samsung's Exynos4212 based Tizen-W board device tree source
+ *
+ * Copyright (c) 2013 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ *
+ * Device tree source file for Samsung's Tizen-W board which is based on
+ * Samsung's Exynos4212 SoC.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+/dts-v1/;
+/include/ "exynos4212.dtsi"
+
+/ {
+	model = "Samsung Tizen-W board based on Exynos4212";
+	compatible = "samsung,tizen-w";
+
+	aliases {
+		/* 15...16 reserved for i2c0_isp, i2c1_isp */
+		i2c16 = &i2c1_isp;
+	};
+
+	memory {
+		reg =  <0x40000000 0x08000000
+			0x48000000 0x08000000
+			0x50000000 0x08000000
+			0x58000000 0x07F00000>;
+
+			reserved-memory {
+				#address-cells = <1>;
+				#size-cells = <1>;
+
+				contig_mem: region@48000000 {
+					compatible = "linux,contiguous-memory-region";
+					reg = <0x48000000 0x1000000>;
+					linux,default-contiguous-region;
+				};
+			};
+	};
+
+	chosen {
+		bootargs = "console=ttySAC1,115200N8 root=/dev/mmcblk0p5 rootwait earlyprintk panic=5";
+	};
+
+	pinctrl@11000000 {
+		cam-port-b-clk-active {
+			samsung,pin-drv = <2>;
+		};
+	};
+
+	firmware@0204F000 {
+		compatible = "samsung,secure-firmware";
+		reg = <0x0204F000 0x1000>;
+	};
+
+	vemmc_reg: voltage-regulator@0 {
+	        compatible = "regulator-fixed";
+		regulator-name = "VMEM_VDD_2.8V";
+		regulator-min-microvolt = <2800000>;
+		regulator-max-microvolt = <2800000>;
+		gpio = <&gpk0 2 0>;
+		enable-active-high;
+	};
+
+	rtc@10070000 {
+		status = "okay";
+	};
+
+	mshc@12550000 {
+		num-slots = <1>;
+		supports-highspeed;
+		broken-cd;
+		non-removable;
+		caps-mmc-erase;
+		fifo-depth = <0x80>;
+		card-detect-delay = <200>;
+		clocks = <&clock 301>, <&clock 149>;
+		clock-names = "biu", "ciu";
+		vmmc-supply = <&vemmc_reg>;
+		clock-frequency = <400000000>;
+		samsung,dw-mshc-ciu-div = <0>;
+		samsung,dw-mshc-sdr-timing = <2 3>;
+		samsung,dw-mshc-ddr-timing = <1 2>;
+		pinctrl-0 = <&sd4_clk &sd4_cmd &sd4_bus4 &sd4_bus8>;
+		pinctrl-names = "default";
+		status = "okay";
+
+		slot@0 {
+			reg = <0>;
+			bus-width = <8>;
+		};
+	};
+
+	adc: adc@126C0000 {
+		vdd-supply = <&ldo3_reg>;
+		status = "okay";
+
+		ncp15wb473@0 {
+			compatible = "ntc,ncp15wb473";
+			pullup-uv = <1800000>;	 /* VCC_1.8V_AP */
+			pullup-ohm = <100000>;	 /* 100K */
+			pulldown-ohm = <100000>; /* 100K */
+			io-channels = <&adc 1>;  /* AP temperature */
+		};
+
+		ncp15wb473@1 {
+			compatible = "ntc,ncp15wb473";
+			pullup-uv = <1800000>;	 /* VCC_1.8V_AP */
+			pullup-ohm = <100000>;	 /* 100K */
+			pulldown-ohm = <100000>; /* 100K */
+			io-channels = <&adc 2>;  /* Battery temperature */
+		};
+	};
+
+	serial@13800000 {
+		pinctrl-names = "default";
+		pinctrl-0 = <&uart0_data &uart0_fctl>;
+		status = "okay";
+	};
+
+	serial@13810000 {
+		pinctrl-names = "default";
+		pinctrl-0 = <&uart1_data>;
+		status = "okay";
+	};
+
+	fixed-rate-clocks {
+		xxti {
+			compatible = "samsung,clock-xxti", "fixed-clock";
+			clock-frequency = <0>;
+		};
+
+		xusbxti {
+			compatible = "samsung,clock-xusbxti", "fixed-clock";
+			clock-frequency = <24000000>;
+		};
+	};
+
+	cpufreq {
+		freq_table = <0xFFFFFFFF 0xFFFFFFFF 0xFFFFFFFF 0xFFFFFFFF
+			      0xFFFFFFFF 0xFFFFFFFF 800000 700000  600000
+			      500000 400000 300000 200000 100000>;
+		vdd_arm-supply = <&buck2_reg>;
+		status = "okay";
+	};
+
+	busfreq {
+		compatible = "samsung,exynos4x12-busfreq";
+		vdd_int-supply = <&buck3_reg>;
+		vdd_mif-supply = <&buck1_reg>;
+		user-max-freq = <133000>;
+		status = "okay";
+	};
+
+	gpio-keys@0 {
+		compatible = "gpio-keys";
+
+		key@116 {
+			interrupt-parent = <&gpx2>;
+			interrupts = <7 0>;
+			gpios = <&gpx2 7 1>;
+			linux,code = <116>;
+			label = "power";
+			debounce-interval = <10>;
+			gpio-key,wakeup;
+		};
+	};
+
+	haptic {
+		compatible = "linux,regulator-haptic";
+		haptic-supply = <&ldo20_reg>;
+		min-microvolt = <1100000>;
+		max-microvolt = <2000000>;
+	};
+
+	sec_reboot@ {
+		compatible = "samsung,sec-reboot";
+		power-gpio = <&gpx2 7 0>;
+		extcon = <&muic>;
+	};
+
+	charger-manager@ {
+		compatible = "charger-manager";
+
+		psy-name = "battery";
+
+		polling-mode = <1>;		/* Polling external power */
+		polling-interval-ms = <30000>;	/* Polling period */
+
+		fullbatt-uV = <4300>;
+		fullbatt-soc = <100>;
+		fullbatt-full-capacity = <0>;
+		fullbatt-vchkdrop-ms = <30000>;
+		fullbatt-vchkdrop-uV = <500>;
+
+		battery-present = <3>;		/* CM_CHARGER_STAT */
+
+		charging-max-duration-minute = <360>;
+		discharging-max-duration-minute = <90>;
+
+		psy-fuelgauge-name = "max17040";
+
+		measure-battery-temp;
+		measure-battery-temp-type = <2>; /* Read temp from hwmon */
+
+		io-channels = <&adc 2>;
+		iio-adc-overheat = <2500>;
+		iio-adc-cold = <0>;
+
+		hwmon-name = "ncp15wb473.13";	/* Battery temperature*/
+		hwmon-property = "temp1_input";
+		hwmon-milli-centigrade-overheat = <45000>;
+		hwmon-milli-centigrade-cold = <5000>; /* minus value */
+		vinchg1-supply = <&charger_reg>;
+
+		psy-chargers {
+			psy-charger-max14577 {
+				psy-charger-name = "max14577-charger";
+			};
+		};
+
+		charger-regulators {
+			charger-vinchg1 {
+				regulator-name = "vinchg1";
+				charger-cables {
+					cable-USB {
+						cable-name = "USB";
+						extcon-name = "max14577-muic";
+						min-current-uA = <475000>;
+						max-current-uA = <500000>;
+					};
+
+					cable-TA {
+						cable-name = "TA";
+						extcon-name = "max14577-muic";
+						min-current-uA = <475000>;
+						max-current-uA = <500000>;
+					};
+				};
+			};
+		};
+	};
+
+	i2c@13870000 {
+		samsung,i2c-sda-delay = <100>;
+		samsung,i2c-slave-addr = <0x10>;
+		samsung,i2c-max-bus-freq = <400000>;
+		pinctrl-0 = <&i2c1_bus>;
+		pinctrl-names = "default";
+		status = "okay";
+
+		fuel-gauge@36 {
+			compatible = "maxim,max17048";
+			reg = <0x36>;
+			interrupt-parent = <&gpx1>;
+			interrupts = <2 8>;
+		};
+	};
+
+	i2c@13880000 {
+		samsung,i2c-sda-delay = <100>;
+		samsung,i2c-slave-addr = <0x10>;
+		samsung,i2c-max-bus-freq = <400000>;
+		pinctrl-0 = <&i2c2_bus>;
+		pinctrl-names = "default";
+		status = "okay";
+
+		max14577@25 {
+			compatible = "maxim,max14577";
+			reg = <0x25>;
+			interrupt-parent = <&gpx1>;
+			interrupts = <5 0>;
+
+			muic: max14577-muic {
+				compatible = "maxim,max14577-muic";
+			};
+			regulators {
+				compatible = "maxim,max14577-regulator";
+				safeout_reg: SAFEOUT@1 {
+					regulator-name = "SAFEOUT";
+				};
+				charger_reg: CHARGER@0 {
+					regulator-name = "CHARGER";
+					regulator-min-microamp = <90000>;
+					regulator-max-microamp = <950000>;
+					regulator-boot-on;
+				};
+			};
+		};
+	};
+
+	i2c@13890000 {
+		samsung,i2c-sda-delay = <100>;
+		samsung,i2c-slave-addr = <0x10>;
+		samsung,i2c-max-bus-freq = <400000>;
+		pinctrl-0 = <&i2c3_bus>;
+		pinctrl-names = "default";
+		status = "okay";
+
+		touchscreen-mms128@48 {
+			compatible = "melfas,mms128";
+			reg = <0x48>;
+			interrupt-parent = <&gpm2>;
+			interrupts = <3 2>;
+			max_x = <320>;
+			max_y = <320>;
+			invert_x = <0>;
+			invert_y = <0>;
+			gpios = <&gpm2 3 2>,
+				<&gpa1 2 0>,
+				<&gpa1 3 0>;
+			tsp_vendor = "MELFAS";
+			tsp_ic = "MMS128S";
+			tsp_tx = <7>;
+			tsp_rx = <7>;
+			config_fw_version = "V700_ME_0910";
+			tsp_avdd_3.3v-supply = <&ldo21_reg>;
+			tsp_vdd_1.8v-supply = <&ldo25_reg>;
+		};
+	};
+
+	i2c@138D0000 {
+		samsung,i2c-sda-delay = <100>;
+		samsung,i2c-slave-addr = <0x10>;
+		samsung,i2c-max-bus-freq = <100000>;
+		pinctrl-0 = <&i2c7_bus>;
+		pinctrl-names = "default";
+		status = "okay";
+
+		s5m8767_pmic@66 {
+			compatible = "samsung,s5m8767-pmic";
+			interrupt-parent = <&gpx0>;
+			interrupts = <7 0>;
+			reg = <0x66>;
+
+			s5m8767,pmic-buck2-ramp-enable;
+			s5m8767,pmic-buck3-ramp-enable;
+			s5m8767,pmic-buck4-ramp-enable;
+			s5m8767,pmic-buck-ramp-delay = <25>;
+
+			s5m8767,pmic-buck-ds-gpios = <&gpf0 5 0>,
+						      <&gpx2 0 0>,
+						      <&gpx2 1 0>;
+			wakeup;
+
+			s5m8767_osc: clocks {
+				compatible = "samsung,s5m8767-clk";
+				#clock-cells = <1>;
+				clock-output-names = "s5m8767_ap",
+						"s5m8767_cp", "s5m8767_bt";
+			};
+
+			regulators {
+				ldo1_reg: LDO1 {
+					regulator-name = "VALIVE_1.0V_AP";
+					regulator-min-microvolt = <1000000>;
+					regulator-max-microvolt = <1000000>;
+					regulator-always-on;
+					op_mode = <1>; /* Normal Mode */
+				};
+
+				ldo2_reg: LDO2 {
+					regulator-name = "VM1M2_1.2V_AP";
+					regulator-min-microvolt = <1200000>;
+					regulator-max-microvolt = <1200000>;
+					op_mode = <1>; /* Normal Mode */
+				};
+
+				ldo3_reg: LDO3 {
+					regulator-name = "VCC_1.8V_AP";
+					regulator-min-microvolt = <1800000>;
+					regulator-max-microvolt = <1800000>;
+					regulator-always-on;
+					op_mode = <1>; /* Normal Mode */
+				};
+
+				ldo4_reg: LDO4 {
+					regulator-name = "VDDQ_PRE_1.8V";
+					regulator-min-microvolt = <1800000>;
+					regulator-max-microvolt = <1800000>;
+					regulator-always-on;
+					op_mode = <1>; /* Normal Mode */
+				};
+
+				ldo5_reg: LDO5 {
+					regulator-name = "UNUSED_LDO5";
+					regulator-min-microvolt = <2800000>;
+					regulator-max-microvolt = <2800000>;
+					op_mode = <0>; /* Always OFF */
+				};
+
+				ldo6_reg: LDO6 {
+					regulator-name = "VMPLL_1.1V_AP";
+					regulator-min-microvolt = <1000000>;
+					regulator-max-microvolt = <1000000>;
+					regulator-always-on;
+					op_mode = <1>; /* Normal Mode */
+				};
+
+				ldo7_reg: LDO7 {
+					regulator-name = "VPLL_1.1V_AP";
+					regulator-min-microvolt = <1000000>;
+					regulator-max-microvolt = <1000000>;
+					regulator-always-on;
+					op_mode = <3>; /* Standby Mode */
+				};
+
+				ldo8_reg: LDO8 {
+					regulator-name = "VMIPI_1.0V_AP";
+					regulator-min-microvolt = <1000000>;
+					regulator-max-microvolt = <1000000>;
+					op_mode = <3>; /* Standby Mode */
+				};
+
+				ldo9_reg: LDO9 {
+					regulator-name = "UNUSED_LDO9";
+					regulator-min-microvolt = <2800000>;
+					regulator-max-microvolt = <2800000>;
+					op_mode = <0>; /* Always OFF */
+				};
+
+				ldo10_reg: LDO10 {
+					regulator-name = "VMIPI_1.8V_AP";
+					regulator-min-microvolt = <1800000>;
+					regulator-max-microvolt = <1800000>;
+					op_mode = <3>; /* Standby Mode */
+				};
+
+				ldo11_reg: LDO11 {
+					regulator-name = "VABB1_1.95V_AP";
+					regulator-min-microvolt = <1950000>;
+					regulator-max-microvolt = <1950000>;
+					op_mode = <3>; /* Standby Mode */
+				};
+
+				ldo12_reg: LDO12 {
+					regulator-name = "VUOTG_3.0V_AP";
+					regulator-min-microvolt = <3000000>;
+					regulator-max-microvolt = <3000000>;
+					op_mode = <1>; /* Normal Mode */
+				};
+
+				ldo13_reg: LDO13 {
+					regulator-name = "UNUSED_LDO13";
+					regulator-min-microvolt = <2800000>;
+					regulator-max-microvolt = <2800000>;
+					op_mode = <0>; /* Always OFF */
+				};
+
+				ldo14_reg: LDO14 {
+					regulator-name = "VABB02_1.95V_AP";
+					regulator-min-microvolt = <1950000>;
+					regulator-max-microvolt = <1950000>;
+					op_mode = <3>; /* Standby Mode */
+				};
+
+				ldo15_reg: LDO15 {
+					regulator-name = "VHSIC_1.0V_AP";
+					regulator-min-microvolt = <1000000>;
+					regulator-max-microvolt = <1000000>;
+					op_mode = <1>; /* Normal Mode */
+				};
+
+				ldo16_reg: LDO16 {
+					regulator-name = "VHSIC_1.8V_AP";
+					regulator-min-microvolt = <1800000>;
+					regulator-max-microvolt = <1800000>;
+					op_mode = <1>; /* Normal Mode */
+				};
+
+				ldo17_reg: LDO17 {
+					regulator-name = "VCC_AP_2.8V";
+					regulator-min-microvolt = <2800000>;
+					regulator-max-microvolt = <2800000>;
+					regulator-always-on;
+					op_mode = <1>; /* Normal Mode */
+				};
+
+				ldo19_reg: LDO19 {
+					regulator-name = "CAM_AF_2.8V";
+					regulator-min-microvolt = <2800000>;
+					regulator-max-microvolt = <2800000>;
+					op_mode = <3>; /* Standby Mode */
+				};
+
+				ldo20_reg: LDO20 {
+					regulator-name = "VDD_MOT_2.7V";
+					regulator-min-microvolt = <1100000>;
+					regulator-max-microvolt = <2700000>;
+					op_mode = <3>; /* Standby Mode */
+				};
+
+				ldo21_reg: LDO21 {
+					regulator-name = "TSP_AVDD_3.3V";
+					regulator-min-microvolt = <3300000>;
+					regulator-max-microvolt = <3300000>;
+					op_mode = <1>; /* Normal Mode */
+				};
+
+				ldo22_reg: LDO22 {
+					regulator-name = "VCC_3.3V_LCD";
+					regulator-min-microvolt = <3300000>;
+					regulator-max-microvolt = <3300000>;
+					op_mode = <1>; /* Normal Mode */
+				};
+
+				ldo24_reg: LDO24 {
+					regulator-name = "CAM_SENSOR_A2.8V";
+					regulator-min-microvolt = <2800000>;
+					regulator-max-microvolt = <2800000>;
+					op_mode = <3>; /* Standby Mode */
+				};
+
+				ldo25_reg: LDO25 {
+					regulator-name = "TSP_VDD_1.8V";
+					regulator-min-microvolt = <1800000>;
+					regulator-max-microvolt = <1800000>;
+					op_mode = <1>; /* Normal Mode */
+				};
+
+				ldo26_reg: LDO26 {
+					regulator-name = "VCC_1.8V_LCD";
+					regulator-min-microvolt = <1800000>;
+					regulator-max-microvolt = <1800000>;
+					op_mode = <1>; /* Normal Mode */
+				};
+
+				ldo27_reg: LDO27 {
+					regulator-name = "CAM_1.8V";
+					regulator-min-microvolt = <1800000>;
+					regulator-max-microvolt = <1800000>;
+					op_mode = <3>; /* Standby Mode */
+				};
+
+				buck1_reg: BUCK1 {
+					regulator-name = "vdd_mif";
+					regulator-min-microvolt = <850000>;
+					regulator-max-microvolt	= <1100000>;
+					regulator-always-on;
+					op_mode = <3>; /* Standby Mode */
+				};
+
+				buck2_reg: BUCK2 {
+					regulator-name = "vdd_arm";
+					regulator-min-microvolt = <850000>;
+					regulator-max-microvolt	= <1500000>;
+					regulator-always-on;
+					op_mode = <3>; /* Standby Mode */
+				};
+
+				buck3_reg: BUCK3 {
+					regulator-name = "vdd_int";
+					regulator-min-microvolt = <850000>;
+					regulator-max-microvolt	= <1100000>;
+					regulator-always-on;
+					op_mode = <3>; /* Standby Mode */
+				};
+
+				buck4_reg: BUCK4 {
+					regulator-name = "vdd_g3d";
+					regulator-min-microvolt = <600000>;
+					regulator-max-microvolt	= <1075000>;
+					op_mode = <3>; /* Standby Mode */
+				};
+
+				buck5_reg: BUCK5 {
+					regulator-name = "VMEM_1.2V_AP";
+					regulator-min-microvolt = <1200000>;
+					regulator-max-microvolt	= <1200000>;
+					regulator-always-on;
+					op_mode = <1>; /* Normal Mode */
+				};
+
+				buck6_reg: BUCK6 {
+					regulator-name = "UNUSED_BUCK6";
+					regulator-min-microvolt = <1000000>;
+					regulator-max-microvolt	= <1200000>;
+					op_mode = <0>; /* Always OFF */
+				};
+
+				buck7_reg: BUCK7 {
+					regulator-name = "VCC_SUB_2.0V";
+					regulator-min-microvolt = <2000000>;
+					regulator-max-microvolt	= <2000000>;
+					op_mode = <3>; /* Standby Mode */
+				};
+
+				buck8_reg: BUCK8 {
+					regulator-name = "VCC_SUB_1.35V";
+					regulator-min-microvolt = <1350000>;
+					regulator-max-microvolt	= <1350000>;
+					op_mode = <3>; /* Standby Mode */
+				};
+			};
+		};
+
+		s5m8767_rtc@ {
+			compatible = "samsung,s5m8767-rtc";
+		};
+	};
+
+	spi_0: spi@13920000 {
+		pinctrl-names = "default";
+		pinctrl-0 = <&spi0_bus>;
+		status = "okay";
+
+		ymu831: ymu831-spi {
+			compatible = "yamaha,ymu831";
+			spi-max-frequency = <10000000>;
+			interrupt-parent = <&gpx1>;
+			interrupts = <4 0>;
+			reg = <0x0>;
+			codec-en-gpios = <&gpx3 6 0>;
+			controller-data {
+				cs-gpio = <&gpb 1 0>;
+				samsung,spi-feedback-delay = <2>;
+			};
+		};
+	};
+
+	spi_1: spi@13930000 {
+		pinctrl-names = "default";
+		pinctrl-0 = <&spi1_bus>;
+		status = "okay";
+		spi-cpha;
+
+		shub_spi: shub {
+			compatible = "samsung,ssp-spi";
+			spi-max-frequency = <5000000>;
+			interrupt-parent = <&gpx0>;
+                        interrupts = <2 0>;
+			ap-mcu-int = <&gpx0 0 0>;
+			mcu-ap-int1 = <&gpx0 2 0>;
+			mcu-ap-int2 = <&gpx0 4 0>;
+			mcu-reset = <&gpx0 5 0>;
+			reg = <0>;
+			controller-data {
+				cs-gpio = <&gpb 5 0>;
+				samsung,spi-feedback-dealy = <0>;
+			};
+		};
+	};
+
+	mipi_lcd: mipi_panel {
+		compatible = "samsung,s6e63j0x03";
+		lcd-panel-name = "s6e63j0x03";
+		reset-gpio = <&gpf2 1 0>;	/* mux function : output */
+		te-gpio = <&gpx0 6 0>;		/* mux function : input */
+		det-gpio = <&gpx1 7 0>;		/* mux function : input */
+		reset-delay = <5>;
+		power-on-delay = <30>;
+		power-off-delay = <120>;
+		was-enabled;
+		vdd3-supply = <&ldo26_reg>;
+		vci-supply = <&ldo22_reg>;
+		samsung,panel-width-mm = <29>;
+		samsung,panel-height-mm = <29>;
+		samsung,panel-frame-freq = <30>;	/* Hz */
+
+		display-timings {
+			native-mode = <&timing0>;
+
+			timing0: timing-0 {
+				clock-frequency = <0>;
+				hactive = <320>;
+				vactive = <320>;
+				hfront-porch = <1>;
+				hback-porch = <1>;
+				hsync-len = <1>;
+				vfront-porch = <150>;
+				vback-porch = <1>;
+				vsync-len = <2>;
+			};
+		};
+
+		cpu-timings {
+			cs_setup = <0>;
+			wr_setup = <0>;
+			wr_act = <1>;
+			wr_hold = <0>;
+		};
+	};
+
+	dsi@11C80000 {
+		client = <&mipi_lcd>;
+		source = <&fimd>;
+		vdd11-supply = <&ldo8_reg>;
+		vdd18-supply = <&ldo10_reg>;
+		status = "okay";
+
+		mipi-dsi-config {
+			interface = <0>;	/* command mode */
+			pixel_format = <7>;	/* RGB 24BPP */
+			auto_flush = <0>;
+			eot_disable = <0>;
+			auto_vertical_cnt = <0>;
+			hse = <0>;
+			hfp = <0>;
+			hbp = <0>;
+			hsa = <0>;
+			no_data_lane = <0>;	/* use 1 lane */
+			byte_clk = <0>;
+			burst_mode = <3>;
+			p = <3>;		/* p m s : 250Mbps */
+			m = <125>;
+			s = <2>;
+			pll_stable_time = <500>;
+			esc_clk = <20000000>;
+			stop_holding_cnt = <0xf>;
+			bta_timeout = <0xff>;
+			rx_timeout = <0xffff>;
+			virtual_ch = <0>;
+			cmd_allow = <0xf>;
+		};
+	};
+
+	fimd@11c00000 {
+		display = <&mipi_lcd>;
+		display-bus = <&dsi_0>;
+		dsi-enable;
+		vidout-i80-ldi0;
+		vidout-pnrmode-rgb;
+		default_win = <3>;
+		gamma-tbl = <0x000C0000 0x005C002C 0x00EC009C 0x01B00148
+				0x02940228 0x032402E4 0x038C035C 0x03DC03B8
+				0x000003FC 0x00100000 0x00680034 0x00F800A8
+				0x01C00154 0x02980230 0x032802E8 0x03900360
+				0x03DC03B8 0x000003FC 0x00100000 0x00680034
+				0x00F800A8 0x01C00154 0x02980230 0x032802E8
+				0x03900360 0x03DC03B8 0x000003FC 0x00000000
+				0x00000000 0x00000000 0x00000000 0x00000000
+				0x00000000>;
+		status = "okay";
+	};
+
+	gpu@13000000 {
+		status = "okay";
+		clock-names = "pll", "mux1", "mux2", "sclk", "block", "g3d";
+		clocks = <&clock 17>, <&clock 392>, <&clock 394>,
+				<&clock 172>, <&clock 483>, <&clock 276>;
+		vdd_g3d-supply = <&buck4_reg>;
+		control-regulator;
+		dvfs {
+			step@0 {
+				rate = <80000000>;
+				min_uv = <600000>;
+				max_uv = <600000>;
+				downthreshold = <0>;
+				upthreshold = <255>;
+			};
+			step@1 {
+				rate = <80000000>;
+				min_uv = <900000>;
+				max_uv = <900000>;
+				downthreshold = <0>;
+				upthreshold = <255>;
+			};
+		};
+	};
+
+	hsotg@12480000 {
+		status = "okay";
+		vusb_core-supply = <&safeout_reg>;
+		vusb_d-supply = <&ldo15_reg>;
+		vusb_a-supply = <&ldo12_reg>;
+		extcon = <&muic>;
+	};
+
+	exynos-usbphy@125B0000 {
+		status = "okay";
+	};
+
+	rfkill-gpio {
+		compatible = "rfkill-gpio";
+		clocks = <&s5m8767_osc 2 /*S2MPS11_CLK_BT*/>;
+		clock-names = "bt_clk32k";
+
+		bt {
+			label = "bluetooth";
+			type = <2>;
+			reset-gpio = <&gpx3 0 0>;
+			shutdown-gpio = <&gpl0 6 0>;
+			wake-gpio = <&gpx3 1 0>;
+			host-wake-gpio = <&gpx2 6 0>;
+			clock = "bt_clk32k";
+		};
+	};
+
+	codec@13400000 {
+		status = "okay";
+	};
+
+	i2s0: i2s@03830000 {
+		pinctrl-0 = <&i2s0_bus>;
+		pinctrl-names = "default";
+		status = "okay";
+		assigned-clock-parents = <&clock_audss 3 &clock_audss 0>,
+			<&clock_audss 0 &clock 6>;
+		assigned-clock-rates = <&clock_audss 1 96000000>,
+			<&clock_audss 2 96000000>;
+	};
+
+	sound {
+		compatible = "tizenw,ymu831";
+		clocks = <&clock 2>, <&clock 396>, <&clock 21>, <&clock 6>,
+		       <&s5m8767_osc 2 /*S2MPS11_CLK_BT*/>; 
+		clock-names = "parent", "out-mux", "out", "pll", "clk_32k";
+		/* EPLL */
+		samsung,i2s-controller = <&i2s0>;
+		samsung,audio-codec = <&ymu831>;
+		samsung,model = "ymu831";
+	};
+
+	camera {
+		status = "okay";
+
+		pinctrl-names = "default";
+		pinctrl-0 = <&cam_port_b_clk_active>;
+
+		fimc_0: fimc@11800000 {
+			clock-frequency = <80000000>;
+			status = "okay";
+		};
+
+		fimc_1: fimc@11810000 {
+			clock-frequency = <80000000>;
+			status = "okay";
+		};
+
+		fimc_2: fimc@11820000 {
+			clock-frequency = <80000000>;
+			status = "okay";
+		};
+
+		fimc_3: fimc@11830000 {
+			clock-frequency = <80000000>;
+			status = "okay";
+		};
+
+		csis_1: csis@11890000 {
+			status = "okay";
+			vddcore-supply = <&ldo8_reg>;
+			vddio-supply = <&ldo10_reg>;
+			clock-frequency = <80000000>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			/* Camera D (4) MIPI CSI-2 (CSIS1) */
+			port@4 {
+				reg = <4>;
+				csis1_ep: endpoint {
+					remote-endpoint = <&is_s5k6a3_ep>;
+					data-lanes = <1>;
+					samsung,csis-hs-settle = <18>;
+					samsung,csis-wclk;
+				};
+			};
+		};
+
+		fimc-is@12000000 {
+			samsung,aclk-frequency = <80000000>;
+			samsung,aclk-axi-frequency = <80000000>;
+			samsung,mcuisp-frequency = <400000000>;
+			status = "okay";
+
+			fimc-isp@12000000 {
+				status = "okay";
+			};
+
+			fimc_lite_1: fimc-lite@123A0000 {
+				status = "okay";
+			};
+
+			i2c1_isp: i2c-isp@12140000 {
+				pinctrl-0 = <&fimc_is_i2c1>;
+				pinctrl-names = "default";
+
+				s5k6a3@10 {
+					compatible = "samsung,s5k6a3";
+					reg = <0x10>;
+					svdda-supply = <&ldo24_reg>;
+					svddio-supply = <&ldo27_reg>;
+					afvdd-supply = <&ldo19_reg>;
+					gpios = <&gpj1 0 0>;
+					clocks = <&camera 1>; /* CAM_B_CLKOUT */
+					clock-names = "extclk";
+					clock-frequency = <24000000>;
+					port {
+						is_s5k6a3_ep: endpoint {
+							remote-endpoint = <&csis1_ep>;
+							data-lanes = <1>;
+						};
+					};
+				};
+			};
+		};
+	};
+
+	jack {
+		compatible = "samsung,extcon-port";
+		extcon = <&muic>;
+
+		samsung,extcon-online-usb;
+		samsung,extcon-online-charger;
+	};
+
+	tmu@100C0000 {
+		vtmu-supply = <&ldo10_reg>;
+		sampling-interval = <5000>;
+		t0_on = <0x1e0>;
+		t0_off = <0x960>;
+		t1_on = <0x960>;
+		t1_off = <0x30>;
+		status = "okay";
+	};
+
+	exynos-drm {
+		compatible = "samsung,exynos-drm";
+		crtcs = <&fimd>;
+		connectors = <&dsi_0>;
+	};
+};
-- 
1.8.0

