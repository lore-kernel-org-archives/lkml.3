Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752453AbaDRBQk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 21:16:40 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:61310 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516AbaDRBPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 21:15:33 -0400
X-AuditID: cbfee68e-b7f566d000002344-f7-53507cb36cd7
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: linux@arm.linux.org.uk, ben-linux@fluff.org, kgene.kim@samsung.com,
        t.figa@samsung.com, arnd@arndb.de, olof@lixom.net,
        marc.zyngier@arm.com, thomas.abraham@linaro.org,
        kyungmin.park@samsung.com, cw00.choi@samsung.com,
        sw0312.kim@samsung.com, hyunhee.kim@samsung.com, yj44.cho@samsung.com,
        chanho61.park@samsung.com, sajjan.linux@gmail.com,
        tushar.behera@linaro.org, sachin.kamat@linaro.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Inki Dae <inki.dae@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: [PATCHv3 7/7] ARM: dts: Add device tree sources for Exynos3250
Date: Fri, 18 Apr 2014 10:15:28 +0900
Message-id: <1397783728-6193-8-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1397783728-6193-1-git-send-email-cw00.choi@samsung.com>
References: <1397783728-6193-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupileLIzCtJLcpLzFFi42JZI2JSpLu5JiDY4P9OPYu/k46xW2ycsZ7V
	YtK6A0wWl/drW1z/8pzVYv6Rc6wW/W8Wslp8/tDCbnHu1UpGi0n3J7BY3PjVxmrRu+Aqm8XZ
	pjfsFpseX2O1uLxrDpvFjPP7mCxuX+a1+HvnH5vF0usXmSxOXf/MZjFh+loWi9a9R9gtTv7p
	ZbR4cvgjq8WMyS/ZLNbPeM1icWzGEkaL9r972Sz27pzM6CDrsWbeGkaPluYeNo/fvyYxelzu
	62Xy+LvqBbPHzll32T1WLv/C5rFpVSebx51re9g8Ni+p97hyoonVo2/LKkaPz5vkAnijuGxS
	UnMyy1KL9O0SuDKOz7ArOLmFseLw20fsDYxTuxi7GDk5JARMJObcu80GYYtJXLi3Hsjm4hAS
	WMoocfXiNHaYoi1L9jFBJBYxSizqeAjlNDFJrH4wG6ydTUBLYv+LG2C2iICCxObeZ6wgRcwC
	e9gk3mw/BJYQFnCX2HhwKyuIzSKgKnFvykKWLkYODl4BF4mZVwUhtslJfNjzCGwzp4CrxPnH
	R1hAbCGgkoffp7NA1PznkNhxlx9ijIDEt8mHwMZICMhKbDrADFEiKXFwxQ2WCYzCCxgZVjGK
	phYkFxQnpRcZ6RUn5haX5qXrJefnbmIEpoPT/5717WC8ecD6EGMy0LiJzFKiyfnAdJJXEm9o
	bGZkYWpiamxkbmlGmrCSOO+ih0lBQgLpiSWp2ampBalF8UWlOanFhxiZODilGhhFdkqEP7j3
	a7dTScr0Lp/s0C7bk93nb8+7JZL6wLWr4o3tddHZbltP5f5a+aiAefu3jMaaeevqzk7qsStc
	4s3458SGiVsXcGdER5fMVg7dvbYlk/fz2grmRbuXPky8+HnmhUgPpq1bpmryrPu2vffucdlF
	fn4Si+QY17z5Ev7/smFE3M6Uj4rnlViKMxINtZiLihMBkLmizB0DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBKsWRmVeSWpSXmKPExsVy+t9jAd3NNQHBBk8XyVn8nXSM3WLjjPWs
	FpPWHWCyuLxf2+L6l+esFvOPnGO16H+zkNXi84cWdotzr1YyWky6P4HF4savNlaL3gVX2SzO
	Nr1ht9j0+BqrxeVdc9gsZpzfx2Rx+zKvxd87/9gsll6/yGRx6vpnNosJ09eyWLTuPcJucfJP
	L6PFk8MfWS1mTH7JZrF+xmsWi2MzljBatP/dy2axd+dkRgdZjzXz1jB6tDT3sHn8/jWJ0eNy
	Xy+Tx99VL5g9ds66y+6xcvkXNo9NqzrZPO5c28PmsXlJvceVE02sHn1bVjF6fN4kF8Ab1cBo
	k5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQMMGiWFssSc
	UqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYQ1jxvEZdgUntzBWHH77iL2BcWoXYxcj
	J4eEgInEliX7mCBsMYkL99azdTFycQgJLGKUWNTxkAnCaWKSWP1gNhtIFZuAlsT+FzfAbBEB
	BYnNvc9YQYqYBfawSbzZfggsISzgLrHx4FZWEJtFQFXi3pSFLF2MHBy8Ai4SM68KQmyTk/iw
	5xE7iM0p4Cpx/vERFhBbCKjk4ffpLBMYeRcwMqxiFE0tSC4oTkrPNdIrTswtLs1L10vOz93E
	CE43z6R3MK5qsDjEKMDBqMTDe+Grf7AQa2JZcWXuIUYJDmYlEV7l0oBgId6UxMqq1KL8+KLS
	nNTiQ4zJQEdNZJYSTc4HpsK8knhDYxMzI0sjc0MLI2Nz0oSVxHkPtloHCgmkJ5akZqemFqQW
	wWxh4uCUamAUbmB+/DJt4xt2kdeLJnRN/FoetPXRxqCEZ2pnU1Yv+DI/YGqc+LvHP6Wieze1
	zFzl7pFwUn+3+JINPSuOuNe7mPZ1M5+Y1XH7v/rrJXGJT3eX/P4v0tS8XlCeWWbmV4mvn6aX
	O4nyCK64k8eYetf7t7V00+dPrlVvD3qdFd+zLunExoDTjx9vV2Ipzkg01GIuKk4EAMS5Yyp7	AwAA
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
- pmu node for PMU memory mapping

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
 arch/arm/boot/dts/exynos3250-pinctrl.dtsi | 477 ++++++++++++++++++++++++++++++
 arch/arm/boot/dts/exynos3250.dtsi         | 427 ++++++++++++++++++++++++++
 2 files changed, 904 insertions(+)
 create mode 100644 arch/arm/boot/dts/exynos3250-pinctrl.dtsi
 create mode 100644 arch/arm/boot/dts/exynos3250.dtsi

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
index 0000000..879c3eb
--- /dev/null
+++ b/arch/arm/boot/dts/exynos3250.dtsi
@@ -0,0 +1,427 @@
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
+
+		cpu@1 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a7";
+			reg = <1>;
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
+	sysram@02020000 {
+		compatible = "samsung,exynos4210-sysram";
+		reg = <0x02020000 0x1000>;
+	};
+
+	sysram-ns@0x0205F000 {
+		compatible = "samsung,exynos4210-sysram-ns";
+		reg = <0x0205F000 0x1000>;
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
+	pmu@10020000 {
+		compatible = "samsung,exynos4210-pmu";
+		reg = <0x10020000 0x1000>;
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
-- 
1.8.0

