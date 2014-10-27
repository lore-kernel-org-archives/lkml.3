Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054AbaJ0BgP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 21:36:15 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:36540 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988AbaJ0BgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 21:36:09 -0400
X-AuditID: cbfee68d-f79296d000004278-3f-544da180cb36
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: kgene.kim@samsung.com, mark.rutland@arm.com, arnd@arndb.de, olof@lixom.net,
        tomasz.figa@gmail.com, inki.dae@samsung.com, sw0312.kim@samsung.com,
        kyungmin.park@samsung.com, cw00.choi@samsung.com,
        m.szyprowski@samsung.com, yj44.cho@samsung.com,
        jaewon02.kim@samsung.com, ideal.song@samsung.com,
        Ben Dooks <ben-linux@fluff.org>, Russell King <linux@arm.linux.org.uk>
Subject: [PATCHv2 2/2] ARM: dts: Add dts files for Exynos4415 SoC
Date: Mon, 27 Oct 2014 10:35:59 +0900
Message-id: <1414373759-4362-3-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1414373759-4362-1-git-send-email-cw00.choi@samsung.com>
References: <1414373759-4362-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGIsWRmVeSWpSXmKPExsWyRsSkQLdhoW+IwfF5BhZ/Jx1jt5i07gCT
	xfUvz1ktdv29z2gx6f4EFosdDUdYLXoXXGWzONv0ht1i0+NrrBaXd81hs5hxfh+Txe3LvBZr
	j9xlt1h6/SKTxanrn4Hik1+yWaza9YfRYu/OyYwOQh5r5q1h9Ghp7mHz+P1rEqPH31UvmD12
	zrrL7rF5Sb3HlRNNrB59W1YxenzeJBfAGcVlk5Kak1mWWqRvl8CVceRPccGFr4wVj99cYWxg
	bN/D2MXIySEhYCIxr+sEG4QtJnHh3nogm4tDSGApo8Tvp91MMEW9q6YxQiQWMUp0NrxgBUkI
	CTQxSTQ9qwex2QS0JPa/uAE2SUQgW+JK431mkAZmge9MEg/v9IOtExZwlDjf/wTMZhFQlfh1
	7jRYA6+Ai0TX6qVQJylILFs+E2wBp4CrxKqrv5gglrlI3L7awAoyVEKgkUNi0qIzUIMEJL5N
	PsTSxcgBlJCV2HSAGWKOpMTBFTdYJjAKL2BkWMUomlqQXFCclF5kqFecmFtcmpeul5yfu4kR
	GH2n/z3r3cF4+4D1IUYBDkYlHl6LQt8QIdbEsuLK3EOMpkAbJjJLiSbnA2M8ryTe0NjMyMLU
	xNTYyNzSTEmcV1HqZ7CQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGxluK3Al7zjGW936o5b3R
	v7fxdUirx7e/b/+b/C+7biV88k4T378pJ69oJ13coZK0weTPYeH9dcph+wVvnrC/IuY+/dTd
	mpX6rs9YTaV33Vlwo/GLUnHjdpt7Mh55px47aJ6t2Lj/+iUbjTaWzwt6t/C4/zPrODrvikXK
	y4Jwgel5x47WaTuEmyixFGckGmoxFxUnAgBRGxMYuQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrAIsWRmVeSWpSXmKPExsVy+t9jAd2Ghb4hBttaFC3+TjrGbjFp3QEm
	i+tfnrNa7Pp7n9Fi0v0JLBY7Go6wWvQuuMpmcbbpDbvFpsfXWC0u75rDZjHj/D4mi9uXeS3W
	HrnLbrH0+kUmi1PXPwPFJ79ks1i16w+jxd6dkxkdhDzWzFvD6NHS3MPm8fvXJEaPv6teMHvs
	nHWX3WPzknqPKyeaWD36tqxi9Pi8SS6AM6qB0SYjNTEltUghNS85PyUzL91WyTs43jne1MzA
	UNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6CElhbLEnFKgUEBicbGSvh2mCaEhbroWMI0Rur4hQXA9
	RgZoIGENY8aRP8UFF74yVjx+c4WxgbF9D2MXIyeHhICJRO+qaVC2mMSFe+vZuhi5OIQEFjFK
	dDa8YAVJCAk0MUk0PasHsdkEtCT2v7jBBmKLCGRLXGm8zwzSwCzwnUni4Z1+sEnCAo4S5/uf
	gNksAqoSv86dBmvgFXCR6Fq9FGqbgsSy5TPBFnAKuEqsuvqLCWKZi8Ttqw2sExh5FzAyrGIU
	TS1ILihOSs810itOzC0uzUvXS87P3cQIju1n0jsYVzVYHGIU4GBU4uG1KPQNEWJNLCuuzD3E
	KMHBrCTCK5oPFOJNSaysSi3Kjy8qzUktPsRoCnTVRGYp0eR8YNrJK4k3NDYxM7I0Mje0MDI2
	VxLnPdhqHSgkkJ5YkpqdmlqQWgTTx8TBKdXAWFcrreQWck9IUMvpn9xb10iRruXOhvfCd8j+
	Ef0UnSHp9/0v/5wDD7pUz4ofyj3Ltjc4r2/x9bm33PtvcrAr71eJF2x5Mf8wR7x8X3dC/qvl
	c29df/We76ZyXnxHGKfL1OWalUyzl82Yzqpl+fOb2ku++sBnixWNH9jdnBi+3lTw1fKWpwu9
	lFiKMxINtZiLihMBDFi7AQMDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds new exynos4415.dtsi to support Exynos4415 SoC
based on Cortex-A9 quad cores and includes following dt nodes:

- GIC interrupt controller (GIC-400)
- Pinctrl to control three GPIO parts
- CMU (Clock Management Unit) for CMU/CMU_DMC/AUDSS
- CPU information (Cortex-A9 quad cores)
- UART to support serial port
- MCT (Multi Core Timer)
- ADC (Analog Digital Converter)
- RTC (Real Time Clock)
- I2C/SPI busses
- Power domains (CAM, TV, MFC, G3D, LCD0, ISP0/1)
- PMU (Performance Monitoring Unit)
- MSHC (Mobile Storage Host Controller)
- EHCI (Enhanced Host Controller Interface)
- OHIC (Open Host Controller Interface)
- USB 2.0 device with hsotg
- PWM (Pluse Width Modulation) Timer
- AMBA bus for PDMA0/1
- SYSRAM node for memory mapping
- SYSREG node for memory mapping
- PMU (Power Management Unit) node for memory mapping

Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Olof Johansson <olof@lixom.net>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Seung-Woo Kim <sw0312.kim@samsung.com>
[m.szyprowski: Add OHCI node and correct EHCI node]
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
[yj44.cho: Add mipi-phy node]
Signed-off-by: YoungJun Cho <yj44.cho@samsung.com>
[jaewon02: Add EHCI and SPI_2 node]
Signed-off-by: Jaewon Kim <jaewon02.kim@samsung.com>
[ideal.song: Add I2S0 node for audio interface]
Signed-off-by: Inha Song <ideal.song@samsung.com>
[tomasz.figa: Add L2 cache node]
Signed-off-by: Tomasz Figa <tomasz.figa@gmail.com>
Acked-by: Kyungmin Park <Kyungmin Park@samsung.com>
---
 arch/arm/boot/dts/exynos4415-pinctrl.dtsi | 613 +++++++++++++++++++++++++++++
 arch/arm/boot/dts/exynos4415.dtsi         | 627 ++++++++++++++++++++++++++++++
 2 files changed, 1240 insertions(+)
 create mode 100644 arch/arm/boot/dts/exynos4415-pinctrl.dtsi
 create mode 100644 arch/arm/boot/dts/exynos4415.dtsi

diff --git a/arch/arm/boot/dts/exynos4415-pinctrl.dtsi b/arch/arm/boot/dts/exynos4415-pinctrl.dtsi
new file mode 100644
index 0000000..5ce4314
--- /dev/null
+++ b/arch/arm/boot/dts/exynos4415-pinctrl.dtsi
@@ -0,0 +1,613 @@
+/*
+ * Samsung's Exynos4415 SoCs pin-mux and pin-config device tree source
+ *
+ * Copyright (c) 2014 Samsung Electronics Co., Ltd.
+ *
+ * Samsung's Exynos4415 SoCs pin-mux and pin-config optiosn are listed as device
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
+	gpf0: gpf0 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpf1: gpf1 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpf2: gpf2 {
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
+	uart2_data: uart2-data {
+		samsung,pins = "gpa1-0", "gpa1-1";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+
+	uart2_fctl: uart2-fctl {
+		samsung,pins = "gpa1-2", "gpa1-3";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+
+	uart3_data: uart3-data {
+		samsung,pins = "gpa1-4", "gpa1-5";
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
+	i2s1_bus: i2s1-bus {
+		samsung,pins = "gpc0-0", "gpc0-1", "gpc0-2", "gpc0-3",
+				"gpc0-4";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <0>;
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
+	spi2_bus: spi2-bus {
+		samsung,pins = "gpc1-1", "gpc1-3", "gpc1-4";
+		samsung,pin-function = <5>;
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
+	i2c7_bus: i2c7-bus {
+		samsung,pins = "gpd0-2", "gpd0-3";
+		samsung,pin-function = <3>;
+		samsung,pin-pud = <3>;
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
+	i2c1_bus: i2c1-bus {
+		samsung,pins = "gpd1-2", "gpd1-3";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <3>;
+		samsung,pin-drv = <0>;
+	};
+};
+
+&pinctrl_1 {
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
+	gpk3: gpk3 {
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
+	mp00: mp00 {
+		gpio-controller;
+		#gpio-cells = <2>;
+	};
+
+	mp01: mp01 {
+		gpio-controller;
+		#gpio-cells = <2>;
+	};
+	
+	mp02: mp02 {
+		gpio-controller;
+		#gpio-cells = <2>;
+	};
+
+	mp03: mp03 {
+		gpio-controller;
+		#gpio-cells = <2>;
+	};
+
+	mp04: mp04 {
+		gpio-controller;
+		#gpio-cells = <2>;
+	};
+
+	mp05: mp05 {
+		gpio-controller;
+		#gpio-cells = <2>;
+	};
+
+	mp06: mp06 {
+		gpio-controller;
+		#gpio-cells = <2>;
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
+	sd2_clk: sd2-clk {
+		samsung,pins = "gpk2-0";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <4>;
+	};
+
+	sd2_cmd: sd2-cmd {
+		samsung,pins = "gpk2-1";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <4>;
+	};
+
+	sd2_cd: sd2-cd {
+		samsung,pins = "gpk2-2";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <3>;
+		samsung,pin-drv = <3>;
+	};
+
+	sd2_bus1: sd2-bus-width1 {
+		samsung,pins = "gpk2-3";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <3>;
+		samsung,pin-drv = <4>;
+	};
+
+	sd2_bus4: sd2-bus-width4 {
+		samsung,pins = "gpk2-4", "gpk2-5", "gpk2-6";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <3>;
+		samsung,pin-drv = <4>;
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
+
+&pinctrl_2 {
+	gpz: gpz {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	i2s0_bus: i2s0-bus {
+		samsung,pins = "gpz-0", "gpz-1", "gpz-2", "gpz-3",
+				"gpz-4", "gpz-5", "gpz-6";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+
+	etc: etc {
+		gpio-controller;
+		#gpio-cells = <2>;
+	};
+};
diff --git a/arch/arm/boot/dts/exynos4415.dtsi b/arch/arm/boot/dts/exynos4415.dtsi
new file mode 100644
index 0000000..078b1b8
--- /dev/null
+++ b/arch/arm/boot/dts/exynos4415.dtsi
@@ -0,0 +1,627 @@
+/*
+ * Samsung's Exynos4415 SoC device tree source
+ *
+ * Copyright (c) 2014 Samsung Electronics Co., Ltd.
+ *
+ * Samsung's Exynos4415 SoC device nodes are listed in this file. Exynos4415
+ * based board files can include this file and provide values for board specfic
+ * bindings.
+ *
+ * Note: This file does not include device nodes for all the controllers in
+ * Exynos4415 SoC. As device tree coverage for Exynos4415 increases, additional
+ * nodes can be added to this file.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include "skeleton.dtsi"
+#include <dt-bindings/clock/exynos4415.h>
+#include <dt-bindings/clock/exynos-audss-clk.h>
+
+/ {
+	compatible = "samsung,exynos4415";
+	interrupt-parent = <&gic>;
+
+	aliases {
+		pinctrl0 = &pinctrl_0;
+		pinctrl1 = &pinctrl_1;
+		pinctrl2 = &pinctrl_2;
+		mshc0 = &mshc_0;
+		mshc1 = &mshc_1;
+		mshc2 = &mshc_2;
+		spi0 = &spi_0;
+		spi1 = &spi_1;
+		spi2 = &spi_2;
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
+			compatible = "arm,cortex-a9";
+			reg = <0xa00>;
+			clock-frequency = <1600000000>;
+		};
+
+		cpu1: cpu@1 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a9";
+			reg = <0xa01>;
+			clock-frequency = <1600000000>;
+		};
+
+		cpu2: cpu@2 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a9";
+			reg = <0xa02>;
+			clock-frequency = <1600000000>;
+		};
+
+		cpu3: cpu@3 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a9";
+			reg = <0xa03>;
+			clock-frequency = <1600000000>;
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
+		};
+
+		sysram@02020000 {
+			compatible = "mmio-sram";
+			reg = <0x02020000 0x50000>;
+			#address-cells = <1>;
+			#size-cells = <1>;
+			ranges = <0 0x02020000 0x50000>;
+
+			smp-sysram@0 {
+				compatible = "samsung,exynos4210-sysram";
+				reg = <0x0 0x1000>;
+			};
+
+			smp-sysram@4f000 {
+				compatible = "samsung,exynos4210-sysram-ns";
+				reg = <0x4f000 0x1000>;
+			};
+		};
+
+		pinctrl_2: pinctrl@03860000 {
+			compatible = "samsung,exynos4415-pinctrl";
+			reg = <0x03860000 0x1000>;
+			interrupts = <0 242 0>;
+		};
+
+		chipid@10000000 {
+			compatible = "samsung,exynos4210-chipid";
+			reg = <0x10000000 0x100>;
+		};
+
+		sysreg_system_controller: syscon@10010000 {
+			compatible = "samsung,exynos4-sysreg", "syscon";
+			reg = <0x10010000 0x400>;
+		};
+
+		pmu_system_controller: system-controller@10020000 {
+			compatible = "samsung,exynos4415-pmu", "syscon";
+			reg = <0x10020000 0x4000>;
+		};
+
+		mipi_phy: video-phy@10020710 {
+			compatible = "samsung,s5pv210-mipi-video-phy";
+			reg = <0x10020710 8>;
+			#phy-cells = <1>;
+		};
+
+		pd_cam: cam-power-domain@10024000 {
+			compatible = "samsung,exynos4210-pd";
+			reg = <0x10024000 0x20>;
+		};
+
+		pd_tv: tv-power-domain@10024020 {
+			compatible = "samsung,exynos4210-pd";
+			reg = <0x10024020 0x20>;
+		};
+
+		pd_mfc: mfc-power-domain@10024040 {
+			compatible = "samsung,exynos4210-pd";
+			reg = <0x10024040 0x20>;
+		};
+
+		pd_g3d: g3d-power-domain@10024060 {
+			compatible = "samsung,exynos4210-pd";
+			reg = <0x10024060 0x20>;
+		};
+
+		pd_lcd0: lcd0-power-domain@10024080 {
+			compatible = "samsung,exynos4210-pd";
+			reg = <0x10024080 0x20>;
+		};
+	
+		pd_isp0: isp0-power-domain@100240A0 {
+			compatible = "samsung,exynos4210-pd";
+			reg = <0x100240A0 0x20>;
+		};
+
+		pd_isp1: isp1-power-domain@100240E0 {
+			compatible = "samsung,exynos4210-pd";
+			reg = <0x100240E0 0x20>;
+		};
+
+		cmu: clock-controller@10030000 {
+			compatible = "samsung,exynos4415-cmu";
+			reg = <0x10030000 0x18000>;
+			#clock-cells = <1>;
+		};
+
+		rtc: rtc@10070000 {
+			compatible = "samsung,exynos3250-rtc";
+			reg = <0x10070000 0x100>;
+			interrupts = <0 73 0>, <0 74 0>;
+			status = "disabled";
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
+		gic: interrupt-controller@10481000 {
+			compatible = "arm,cortex-a9-gic";
+			#interrupt-cells = <3>;
+			interrupt-controller;
+			reg = <0x10481000 0x1000>,
+			      <0x10482000 0x1000>,
+			      <0x10484000 0x2000>,
+			      <0x10486000 0x2000>;
+			interrupts = <1 9 0xf04>;
+		};
+
+		l2c: l2-cache-controller@10502000 {
+			compatible = "arm,pl310-cache";
+			reg = <0x10502000 0x1000>;
+			cache-unified;
+			cache-level = <2>;
+			arm,tag-latency = <2 2 1>;
+			arm,data-latency = <3 2 1>;
+			arm,double-linefill = <1>;
+			arm,double-linefill-incr = <0>;
+			arm,double-linefill-wrap = <1>;
+			arm,prefetch-drop = <1>;
+			arm,prefetch-offset = <7>;
+		};
+
+		cmu_dmc: clock-controller@105C0000 {
+			compatible = "samsung,exynos4415-cmu-dmc";
+			reg = <0x105C0000 0x3000>;
+			#clock-cells = <1>;
+		};
+
+		pinctrl_1: pinctrl@11000000 {
+			compatible = "samsung,exynos4415-pinctrl";
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
+			compatible = "samsung,exynos4415-pinctrl";
+			reg = <0x11400000 0x1000>;
+			interrupts = <0 240 0>;
+		};
+
+		hsotg: hsotg@12480000 {
+			compatible = "samsung,s3c6400-hsotg";
+			reg = <0x12480000 0x20000>;
+			interrupts = <0 141 0>;
+			clocks = <&cmu CLK_USBDEVICE>;
+			clock-names = "otg";
+			phys = <&exynos_usbphy 0>;
+			phy-names = "usb2-phy";
+			status = "disabled";
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
+		mshc_2: mshc@12530000 {
+			compatible = "samsung,exynos5250-dw-mshc";
+			reg = <0x12530000 0x1000>;
+			interrupts = <0 144 0>;
+			clocks = <&cmu CLK_SDMMC2>, <&cmu CLK_SCLK_MMC2>;
+			clock-names = "biu", "ciu";
+			fifo-depth = <0x80>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+			status = "disabled";
+		};
+
+		ehci: ehci@12580000 {
+			compatible = "samsung,exynos4210-ehci";
+			reg = <0x12580000 0x100>;
+			interrupts = <0 140 0>;
+			clocks = <&cmu CLK_USBHOST>;
+			clock-names = "usbhost";
+			status = "disabled";
+			#address-cells = <1>;
+			#size-cells = <0>;
+			port@0 {
+				reg = <0>;
+				phys = <&exynos_usbphy 1>;
+				status = "disabled";
+			};
+			port@1 {
+				reg = <1>;
+				phys = <&exynos_usbphy 2>;
+				status = "disabled";
+			};
+			port@2 {
+				reg = <2>;
+				phys = <&exynos_usbphy 3>;
+				status = "disabled";
+			};
+		};
+
+		ohci: ohci@12590000 {
+			compatible = "samsung,exynos4210-ohci";
+			reg = <0x12590000 0x100>;
+			interrupts = <0 140 0>;
+			clocks = <&cmu CLK_USBHOST>;
+			clock-names = "usbhost";
+			status = "disabled";
+			#address-cells = <1>;
+			#size-cells = <0>;
+			port@0 {
+				reg = <0>;
+				phys = <&exynos_usbphy 1>;
+				status = "disabled";
+			};
+		};
+
+		exynos_usbphy: exynos-usbphy@125B0000 {
+			compatible = "samsung,exynos4x12-usb2-phy";
+			reg = <0x125B0000 0x100>;
+			samsung,pmureg-phandle = <&pmu_system_controller>;
+			samsung,sysreg-phandle = <&sysreg_system_controller>;
+			clocks = <&cmu CLK_USBDEVICE>, <&xusbxti>;
+			clock-names = "phy", "ref";
+			#phy-cells = <1>;
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
+			compatible = "samsung,exynos3250-adc",
+				     "samsung,exynos-adc-v2";
+			reg = <0x126C0000 0x100>, <0x10020718 0x4>;
+			interrupts = <0 137 0>;
+			clock-names = "adc", "sclk";
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
+		serial_2: serial@13820000 {
+			compatible = "samsung,exynos4210-uart";
+			reg = <0x13820000 0x100>;
+			interrupts = <0 111 0>;
+			clocks = <&cmu CLK_UART2>, <&cmu CLK_SCLK_UART2>;
+			clock-names = "uart", "clk_uart_baud0";
+			status = "disabled";
+		};
+
+		serial_3: serial@13830000 {
+			compatible = "samsung,exynos4210-uart";
+			reg = <0x13830000 0x100>;
+			interrupts = <0 112 0>;
+			clocks = <&cmu CLK_UART3>, <&cmu CLK_SCLK_UART3>;
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
+		spi_2: spi@13940000 {
+			compatible = "samsung,exynos4210-spi";
+			reg = <0x13940000 0x100>;
+			interrupts = <0 123 0>;
+			dmas = <&pdma0 9>, <&pdma0 8>;
+			dma-names = "tx", "rx";
+			#address-cells = <1>;
+			#size-cells = <0>;
+			clocks = <&cmu CLK_SPI2>, <&cmu CLK_SCLK_SPI2>;
+			clock-names = "spi", "spi_busclk0";
+			samsung,spi-src-clk = <0>;
+			pinctrl-names = "default";
+			pinctrl-0 = <&spi2_bus>;
+			status = "disabled";
+		};
+
+		clock_audss: clock-controller@03810000 {
+			compatible = "samsung,exynos4210-audss-clock";
+			reg = <0x03810000 0x0C>;
+			#clock-cells = <1>;
+		};
+
+		i2s0: i2s@3830000 {
+			compatible = "samsung,s5pv210-i2s";
+			reg = <0x03830000 0x100>;
+			interrupts = <0 124 0>;
+			clocks = <&clock_audss EXYNOS_I2S_BUS>,
+				<&clock_audss EXYNOS_SCLK_I2S>;
+			clock-names = "iis", "i2s_opclk0";
+			dmas = <&pdma1 10>, <&pdma1 9>, <&pdma1 8>;
+			dma-names = "tx", "rx", "tx-sec";
+			pinctrl-names = "default";
+			pinctrl-0 = <&i2s0_bus>;
+			samsung,idma-addr = <0x03000000>;
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
+			compatible = "arm,cortex-a9-pmu";
+			interrupts = <0 18 0>, <0 19 0>, <0 20 0>, <0 21 0>;
+		};
+	};
+};
+
+#include "exynos4415-pinctrl.dtsi"
-- 
1.8.5.5

