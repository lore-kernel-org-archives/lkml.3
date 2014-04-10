Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030253AbaDJKR6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 06:17:58 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:24362 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935154AbaDJKGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 06:06:22 -0400
X-AuditID: cbfee68f-b7f156d00000276c-3b-53466d1d133e
From: Chanwoo Choi <cw00.choi@samsung.com>
To: kgene.kim@samsung.com, t.figa@samsung.com,
        linux-samsung-soc@vger.kernel.org
Cc: kyungmin.park@samsung.com, cw00.choi@samsung.com, inki.dae@samsung.com,
        sw0312.kim@samsung.com, hyunhee.kim@samsung.com, yj44.cho@samsung.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Jaehoon Chung <jh80.chung@samsung.com>
Subject: [PATCH 13/27] ARM: dts: exynos3250: Add pin control device tree data
Date: Thu, 10 Apr 2014 19:06:03 +0900
Message-id: <1397124377-16969-5-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1397122658-16013-1-git-send-email-cw00.choi@samsung.com>
References: <1397122658-16013-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphkeLIzCtJLcpLzFFi42JZI2JSoCub6xZssG4Pj8X1L89ZLT5/aGG3
	mHR/AovFjV9trBa9C66yWZxtesNusenxNVaLy7vmsFnMOL+PyWLG5JdsFutnvGax2LtzMqMD
	j8fmJfUefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAldG22q7gVULF8yNXmBoY2zy7GDk5JARM
	JO5/WcQIYYtJXLi3nq2LkYtDSGApo8SbBRNZYIrOvj7DApFYxCixY8IBVginiUnixNtt7CBV
	bAJaEvtf3GADsUUEAiR+HH8HNopZoJlJYu/KLawgCWEBX4lre+YygdgsAqoSx6f2g63gFXCV
	mP90GjPEOjmJD3segQ3lFHCTmLnoJNhQIaCankcXoWo2sUssbXCGmCMg8W3yIaA5HEBxWYlN
	B6BKJCUOrrjBMoFReAEjwypG0dSC5ILipPQiY73ixNzi0rx0veT83E2MwBg4/e9Z/w7Guwes
	DzEmA42byCwlmpwPjKG8knhDYzMjC1MTU2Mjc0sz0oSVxHnvP0wKEhJITyxJzU5NLUgtii8q
	zUktPsTIxMEp1cAopMl79qhqbf+bHQfin76YlBB04dbdjMMXzLXaglYu9uTomCchpc4+QTuS
	o9RK6Gp0asp0FcGdqtKsKxez+SarODC8/+/xLm3Bp+exbeff7f1wJKc3oyQlMDlsa07Wphmb
	7xZpOOU2yx15+q7SN/DNs8y8T+7KC24+TFgk+XHNhMPniv5NlZyjxFKckWioxVxUnAgAoY1H
	upcCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEIsWRmVeSWpSXmKPExsVy+t9jAV2ZXLdgg47VNhbXvzxntfj8oYXd
	YtL9CSwWN361sVr0LrjKZnG26Q27xabH11gtLu+aw2Yx4/w+JosZk1+yWayf8ZrFYu/OyYwO
	PB6bl9R79G1ZxejxeZNcAHNUA6NNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJC
	XmJuqq2Si0+ArltmDtBVSgpliTmlQKGAxOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDCGsaM
	ttV2Ba8SKp4fucLUwNjm2cXIySEhYCJx9vUZFghbTOLCvfVsXYxcHEICixgldkw4wArhNDFJ
	nHi7jR2kik1AS2L/ixtsILaIQIDEj+PvwDqYBZqZJPau3MIKkhAW8JW4tmcuE4jNIqAqcXxq
	P9gKXgFXiflPpzFDrJOT+LDnEdhQTgE3iZmLToINFQKq6Xl0kXkCI+8CRoZVjKKpBckFxUnp
	uUZ6xYm5xaV56XrJ+bmbGMEx9kx6B+OqBotDjAIcjEo8vAeWuQYLsSaWFVfmHmKU4GBWEuHd
	nekWLMSbklhZlVqUH19UmpNafIgxGeiqicxSosn5wPjPK4k3NDYxM7I0Mje0MDI2J01YSZz3
	YKt1oJBAemJJanZqakFqEcwWJg5OqQZGz+mSmRpxnnNdpncrHnR+t0uQ7ZHJ3tDMwIwP5xZv
	8VXk++Cy5vKmu+3zb55iTZkbufPcz3TRPmaBSwcyJwe62e7cGcwgx7BK4Ia6qfs6rmW3szuM
	RMLmXdR+brvqw/y4Zt+tGy5GNps26Ozlv33lwBnpeJ13Mj7Sz2ZqmR55MNd5/cf1zIUflViK
	MxINtZiLihMBOR7xXPUCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tomasz Figa <t.figa@samsung.com>

This patch adds device tree nodes for pin controllers of Exynos3250
along with definitions of pin banks, external interrupt layout and
avaiable functions.

Signed-off-by: Tomasz Figa <t.figa@samsung.com>
[Fix bug about pinctrl lable by Chanwoo Choi]
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
[Fix the sd_bus8 gpio configuration by Jaehoon Chung]
Signed-off-by: Jaehoon Chung <jh80.chung@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/boot/dts/exynos3250-pinctrl.dtsi | 477 ++++++++++++++++++++++++++++++
 arch/arm/boot/dts/exynos3250.dtsi         |  24 ++
 2 files changed, 501 insertions(+)
 create mode 100644 arch/arm/boot/dts/exynos3250-pinctrl.dtsi

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
index 13efdbed..dba3218 100644
--- a/arch/arm/boot/dts/exynos3250.dtsi
+++ b/arch/arm/boot/dts/exynos3250.dtsi
@@ -18,11 +18,17 @@
  */
 
 #include "skeleton.dtsi"
+#include "exynos3250-pinctrl.dtsi"
 
 / {
 	compatible = "samsung,exynos3250";
 	interrupt-parent = <&gic>;
 
+	aliases {
+		pinctrl0 = &pinctrl_0;
+		pinctrl1 = &pinctrl_1;
+	};
+
 	chipid@10000000 {
 		compatible = "samsung,exynos4210-chipid";
 		reg = <0x10000000 0x100>;
@@ -43,4 +49,22 @@
 		      <0x10486000 0x2000>;
 		      interrupts = <1 9 0xf04>;
 	};
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
 };
-- 
1.8.0

