Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754470AbaLBIua (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 03:50:30 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:52358 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753369AbaLBIuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 03:50:08 -0500
X-AuditID: cbfee691-f79b86d000004a5a-9e-547d7d377902
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, mark.rutland@arm.com, marc.zyngier@arm.com,
        arnd@arndb.de, olof@lixom.net, catalin.marinas@arm.com,
        will.deacon@arm.com, s.nawrocki@samsung.com, tomasz.figa@gmail.com,
        kyungmin.park@samsung.com, inki.dae@samsung.com,
        chanho61.park@samsung.com, geunsik.lim@samsung.com,
        sw0312.kim@samsung.com, jh80.chung@samsung.com, cw00.choi@samsung.com,
        a.kesavan@samsung.com, pankaj.dubey@samsung.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 14/19] arm64: dts: exynos: Add dts files for 64-bit Exynos5433
 SoC
Date: Tue, 02 Dec 2014 17:49:51 +0900
Message-id: <1417510196-6714-15-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1417510196-6714-1-git-send-email-cw00.choi@samsung.com>
References: <1417510196-6714-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIIsWRmVeSWpSXmKPExsWyRsSkQNe8tjbEoHmTtcXjNYuZLP5OOsZu
	8X5ZD6PF5f3aFte/PGe1mH/kHKvFnwmtbBaT7k9gsbjxq43VonfBVTaLs01v2C02Pb7GanF5
	1xw2ixnn9wH13/nHZrH0+kUmi1PXP7NZLNr6hd3i8Jt2VosZk1+yWaza9YfR4uXHEywOYh5r
	5q1h9Pj9axKjx85Zd9k9Ni+p97hyoonVo2/LKkaPz5vkAtijuGxSUnMyy1KL9O0SuDKmzVrD
	VLD9CWPFot7ZTA2M+zYwdjFyckgImEhsW3YPyhaTuHBvPVsXIxeHkMBSRontl1+xwhQdvfyb
	GSIxnVHiyN257BBOE5PEgxsQo9gEtCT2v7jBBmKLCDhLNExtZAIpYhZ4wyyx5/5uFpCEsECI
	xPyjH5lBbBYBVYl1r08DFXFw8Aq4Srx6kQ6xTUFi2fKZYJs5gcJdZ/rYQWwhAReJX60fwRZL
	CMzkkHj65TMLxBwBiW+TD7GAzJEQkJXYdIAZYo6kxMEVN1gmMAovYGRYxSiaWpBcUJyUXmSq
	V5yYW1yal66XnJ+7iREYk6f/PZu4g/H+AetDjAIcjEo8vCfO14QIsSaWFVfmHmI0BdowkVlK
	NDkfGPl5JfGGxmZGFqYmpsZG5pZmSuK8OtI/g4UE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUw
	dkaWtYtHTuwQut1zY35gJnuZZMgekfg5StUhf38E6Io6znzvfnTW1WSxTXfSEgLk5zzokHX2
	W/0z/v3iV+cOCn7vSjaMUKkpjTklO2m//uTrX/9O2LG0Lp33gPkfL9uSqJXn171/+cP55a0N
	egzL7/o3nJgpHeIcNv2nx7G5Szf9Nt9/4cLMe0osxRmJhlrMRcWJAIHe8MDEAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNIsWRmVeSWpSXmKPExsVy+t9jQV3z2toQg2UvtSwer1nMZPF30jF2
	i/fLehgtLu/Xtrj+5Tmrxfwj51gt/kxoZbOYdH8Ci8WNX22sFr0LrrJZnG16w26x6fE1VovL
	u+awWcw4vw+o/84/Noul1y8yWZy6/pnNYtHWL+wWh9+0s1rMmPySzWLVrj+MFi8/nmBxEPNY
	M28No8fvX5MYPXbOusvusXlJvceVE02sHn1bVjF6fN4kF8Ae1cBok5GamJJapJCal5yfkpmX
	bqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQP0mpJCWWJOKVAoILG4WEnfDtOE0BA3
	XQuYxghd35AguB4jAzSQsIYxY9qsNUwF258wVizqnc3UwLhvA2MXIyeHhICJxNHLv5khbDGJ
	C/fWs3UxcnEICUxnlDhydy47hNPEJPHgBkQHm4CWxP4XN9hAbBEBZ4mGqY1MIEXMAm+YJfbc
	380CkhAWCJGYf/Qj2FgWAVWJda9PAxVxcPAKuEq8epEOsU1BYtnymawgNidQuOtMHzuILSTg
	IvGr9SP7BEbeBYwMqxhFUwuSC4qT0nON9IoTc4tL89L1kvNzNzGCI/6Z9A7GVQ0WhxgFOBiV
	eHhPnK8JEWJNLCuuzD3EKMHBrCTC+8u4NkSINyWxsiq1KD++qDQntfgQoynQUROZpUST84HJ
	KK8k3tDYxMzI0sjc0MLI2FxJnPfGzdwQIYH0xJLU7NTUgtQimD4mDk6pBsZa9/dbSv+z28ct
	fdEV6174J+D9h9KPnVErvE1Sk05zLgw6vZPtFFtn0tWDtV9Oy9l0vv35fe4180f71+Qtjzjm
	osC5es68i3e1OZyCmUpsveyP+rrFZW8VjJqX7b7YvW+R+bdpnBw1qYvu9C84aMN8M1N31S6G
	WZGL5y3Lrli09q9Y+1RjphVKLMUZiYZazEXFiQBpd6jVDgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds new Exynos5433 dtsi to support 64-bit Exynos5433 SoC based on
Octal core CPUs (quad Cortex-A57 and quad Cortex-A53). And Exynos5433 supports
PSCI (Power State Coordination Interface) v0.1.

Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Olof Johansson <olof@lixom.net>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Inki Dae <inki.dae@samsung.com>
Acked-by: Geunsik Lim <geunsik.lim@samsung.com>
---
 arch/arm64/boot/dts/exynos/exynos5433-pinctrl.dtsi | 698 +++++++++++++++++++++
 arch/arm64/boot/dts/exynos/exynos5433.dtsi         | 515 +++++++++++++++
 2 files changed, 1213 insertions(+)
 create mode 100644 arch/arm64/boot/dts/exynos/exynos5433-pinctrl.dtsi
 create mode 100644 arch/arm64/boot/dts/exynos/exynos5433.dtsi

diff --git a/arch/arm64/boot/dts/exynos/exynos5433-pinctrl.dtsi b/arch/arm64/boot/dts/exynos/exynos5433-pinctrl.dtsi
new file mode 100644
index 0000000..81fe925
--- /dev/null
+++ b/arch/arm64/boot/dts/exynos/exynos5433-pinctrl.dtsi
@@ -0,0 +1,698 @@
+/*
+ * Samsung's Exynos5433 SoC pin-mux and pin-config device tree source
+ *
+ * Copyright (c) 2013 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ *
+ * Samsung's Exynos5433 SoC pin-mux and pin-config options are listed as device
+ * tree nodes are listed in this file.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+&pinctrl_alive {
+	gpa0: gpa0 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		interrupt-parent = <&gic>;
+		interrupts = <0 0 0>, <0 1 0>, <0 2 0>, <0 3 0>,
+			     <0 4 0>, <0 5 0>, <0 6 0>, <0 7 0>;
+		#interrupt-cells = <2>;
+	};
+
+	gpa1: gpa1 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		interrupt-parent = <&gic>;
+		interrupts = <0 8 0>, <0 9 0>, <0 10 0>, <0 11 0>,
+			     <0 12 0>, <0 13 0>, <0 14 0>, <0 15 0>;
+		#interrupt-cells = <2>;
+	};
+
+	gpa2: gpa2 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpa3: gpa3 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+};
+
+&pinctrl_aud {
+	gpz0: gpz0 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpz1: gpz1 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	i2s0_bus: i2s0-bus {
+		samsung,pins = "gpz0-0", "gpz0-1", "gpz0-2", "gpz0-3",
+				"gpz0-4", "gpz0-5", "gpz0-6";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <1>;
+		samsung,pin-drv = <0>;
+	};
+
+	pcm0_bus: pcm0-bus {
+		samsung,pins = "gpz1-0", "gpz1-1", "gpz1-2", "gpz1-3";
+		samsung,pin-function = <3>;
+		samsung,pin-pud = <1>;
+		samsung,pin-drv = <0>;
+	};
+};
+
+&pinctrl_cpif {
+	gpv6: gpv6 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+};
+
+&pinctrl_ese {
+	gpj2: gpj2 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+};
+
+&pinctrl_finger {
+	gpd5: gpd5 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	spi2_bus: spi2-bus {
+		samsung,pins = "gpd5-0", "gpd5-2", "gpd5-3";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <3>;
+		samsung,pin-drv = <0>;
+	};
+
+	hs_i2c6_bus: hs-i2c6-bus {
+		samsung,pins = "gpd5-3", "gpd5-2";
+		samsung,pin-function = <4>;
+		samsung,pin-pud = <3>;
+		samsung,pin-drv = <0>;
+	};
+
+};
+
+&pinctrl_fsys {
+	gph1: gph1 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpr4: gpr4 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpr0: gpr0 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpr1: gpr1 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpr2: gpr2 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpr3: gpr3 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+	sd0_clk: sd0-clk {
+		samsung,pins = "gpr0-0";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <3>;
+	};
+
+	sd0_cmd: sd0-cmd {
+		samsung,pins = "gpr0-1";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <3>;
+	};
+
+	sd0_rdqs: sd0-rdqs {
+		samsung,pins = "gpr0-2";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <1>;
+		samsung,pin-drv = <3>;
+	};
+
+	sd0_qrdy: sd0-qrdy {
+		samsung,pins = "gpr0-3";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <1>;
+		samsung,pin-drv = <3>;
+	};
+
+	sd0_bus1: sd0-bus-width1 {
+		samsung,pins = "gpr1-0";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <3>;
+		samsung,pin-drv = <3>;
+	};
+
+	sd0_bus4: sd0-bus-width4 {
+		samsung,pins = "gpr1-1", "gpr1-2", "gpr1-3";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <3>;
+		samsung,pin-drv = <3>;
+	};
+
+	sd0_bus8: sd0-bus-width8 {
+		samsung,pins = "gpr1-4", "gpr1-5", "gpr1-6", "gpr1-7";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <3>;
+		samsung,pin-drv = <3>;
+	};
+
+	sd1_clk: sd1-clk {
+		samsung,pins = "gpr2-0";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <3>;
+	};
+
+	sd1_cmd: sd1-cmd {
+		samsung,pins = "gpr2-1";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <3>;
+	};
+
+	sd1_bus1: sd1-bus-width1 {
+		samsung,pins = "gpr3-0";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <3>;
+		samsung,pin-drv = <3>;
+	};
+
+	sd1_bus4: sd1-bus-width4 {
+		samsung,pins = "gpr3-1", "gpr3-2", "gpr3-3";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <3>;
+		samsung,pin-drv = <3>;
+	};
+
+	sd1_bus8: sd1-bus-width8 {
+		samsung,pins = "gpr3-4", "gpr3-5", "gpr3-6", "gpr3-7";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <3>;
+		samsung,pin-drv = <3>;
+	};
+
+	pcie_bus: pcie_bus {
+		samsung,pins = "gpr3-4", "gpr3-5", "gpr3-6", "gpr3-7";
+		samsung,pin-function = <3>;
+		samsung,pin-pud = <3>;
+	};
+
+	sd2_clk: sd2-clk {
+		samsung,pins = "gpr4-0";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <3>;
+	};
+
+	sd2_cmd: sd2-cmd {
+		samsung,pins = "gpr4-1";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <3>;
+	};
+
+	sd2_cd: sd2-cd {
+		samsung,pins = "gpr4-2";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <3>;
+		samsung,pin-drv = <3>;
+	};
+
+	sd2_bus1: sd2-bus-width1 {
+		samsung,pins = "gpr4-3";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <3>;
+		samsung,pin-drv = <3>;
+	};
+
+	sd2_bus4: sd2-bus-width4 {
+		samsung,pins = "gpr4-4", "gpr4-5", "gpr4-6";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <3>;
+		samsung,pin-drv = <3>;
+	};
+
+	sd2_clk_output: sd2-clk-output {
+		samsung,pins = "gpr4-0";
+		samsung,pin-function = <1>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <2>;
+	};
+
+	sd2_cmd_output: sd2-cmd-output {
+		samsung,pins = "gpr4-1";
+		samsung,pin-function = <1>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <2>;
+	};
+};
+
+&pinctrl_imem {
+	gpf0: gpf0 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+};
+
+&pinctrl_nfc {
+	gpj0: gpj0 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	hs_i2c4_bus: hs-i2c4-bus {
+		samsung,pins = "gpj0-1", "gpj0-0";
+		samsung,pin-function = <4>;
+		samsung,pin-pud = <3>;
+		samsung,pin-drv = <0>;
+	};
+
+};
+
+&pinctrl_peric {
+	gpv7: gpv7 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpb0: gpb0 {
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
+	gpc2: gpc2 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpc3: gpc3 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpg0: gpg0 {
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
+	gpd2: gpd2 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpd4: gpd4 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpd8: gpd8 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpd6: gpd6 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpd7: gpd7 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpg1: gpg1 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpg2: gpg2 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpg3: gpg3 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	hs_i2c8_bus: hs-i2c8-bus {
+		samsung,pins = "gpb0-1", "gpb0-0";
+		samsung,pin-function = <4>;
+		samsung,pin-pud = <3>;
+		samsung,pin-drv = <0>;
+	};
+
+	hs_i2c9_bus: hs-i2c9-bus {
+		samsung,pins = "gpb0-3", "gpb0-2";
+		samsung,pin-function = <4>;
+		samsung,pin-pud = <3>;
+		samsung,pin-drv = <0>;
+	};
+
+	i2s1_bus: i2s1-bus {
+		samsung,pins = "gpd4-0", "gpd4-1", "gpd4-2",
+				"gpd4-3", "gpd4-4";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <1>;
+		samsung,pin-drv = <0>;
+	};
+
+	pcm1_bus: pcm1-bus {
+		samsung,pins = "gpd4-0", "gpd4-1", "gpd4-2",
+				"gpd4-3", "gpd4-4";
+		samsung,pin-function = <3>;
+		samsung,pin-pud = <1>;
+		samsung,pin-drv = <0>;
+	};
+
+	spdif_bus: spdif-bus {
+		samsung,pins = "gpd4-3", "gpd4-4";
+		samsung,pin-function = <4>;
+		samsung,pin-pud = <1>;
+		samsung,pin-drv = <0>;
+	};
+
+	fimc_is_spi_pin0: fimc-is-spi-pin0 {
+		samsung,pins = "gpc3-3", "gpc3-2", "gpc3-1", "gpc3-0";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+
+	fimc_is_spi_pin1: fimc-is-spi-pin1 {
+		samsung,pins = "gpc3-7", "gpc3-6", "gpc3-5", "gpc3-4";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+
+	uart0_bus: uart0-bus {
+		samsung,pins = "gpd0-3", "gpd0-2", "gpd0-1", "gpd0-0";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <0>;
+	};
+
+	hs_i2c2_bus: hs-i2c2-bus {
+		samsung,pins = "gpd0-3", "gpd0-2";
+		samsung,pin-function = <3>;
+		samsung,pin-pud = <3>;
+		samsung,pin-drv = <0>;
+	};
+
+	uart2_bus: uart2-bus {
+		samsung,pins = "gpd1-5", "gpd1-4";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <0>;
+	};
+
+	uart1_bus: uart1-bus {
+		samsung,pins = "gpd1-3", "gpd1-2", "gpd1-1", "gpd1-0";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <0>;
+	};
+
+	hs_i2c3_bus: hs-i2c3-bus {
+		samsung,pins = "gpd1-3", "gpd1-2";
+		samsung,pin-function = <3>;
+		samsung,pin-pud = <3>;
+		samsung,pin-drv = <0>;
+	};
+
+
+	hs_i2c0_bus: hs-i2c0-bus {
+		samsung,pins = "gpd2-1", "gpd2-0";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <3>;
+		samsung,pin-drv = <0>;
+	};
+
+	hs_i2c1_bus: hs-i2c1-bus {
+		samsung,pins = "gpd2-3", "gpd2-2";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <3>;
+		samsung,pin-drv = <0>;
+	};
+
+	spi1_bus: spi1-bus {
+		samsung,pins = "gpd6-2", "gpd6-4", "gpd6-5";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <3>;
+		samsung,pin-drv = <0>;
+	};
+
+	hs_i2c7_bus: hs-i2c7-bus {
+		samsung,pins = "gpd2-7", "gpd2-6";
+		samsung,pin-function = <4>;
+		samsung,pin-pud = <3>;
+		samsung,pin-drv = <0>;
+	};
+
+	spi0_bus: spi0-bus {
+		samsung,pins = "gpd8-0", "gpd6-0", "gpd6-1";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <3>;
+		samsung,pin-drv = <0>;
+	};
+
+	hs_i2c10_bus: hs-i2c10-bus {
+		samsung,pins = "gpg3-1", "gpg3-0";
+		samsung,pin-function = <4>;
+		samsung,pin-pud = <3>;
+		samsung,pin-drv = <0>;
+	};
+
+	hs_i2c11_bus: hs-i2c11-bus {
+		samsung,pins = "gpg3-3", "gpg3-2";
+		samsung,pin-function = <4>;
+		samsung,pin-pud = <3>;
+		samsung,pin-drv = <0>;
+	};
+
+	spi3_bus: spi3-bus {
+		samsung,pins = "gpg3-4", "gpg3-6", "gpg3-7";
+		samsung,pin-function = <3>;
+		samsung,pin-pud = <3>;
+		samsung,pin-drv = <0>;
+	};
+
+	spi4_bus: spi4-bus {
+		samsung,pins = "gpv7-1", "gpv7-3", "gpv7-4";
+		samsung,pin-function = <3>;
+		samsung,pin-pud = <3>;
+		samsung,pin-drv = <0>;
+	};
+
+	fimc_is_uart: fimc-is-uart {
+		samsung,pins = "gpc1-1", "gpc0-7";
+		samsung,pin-function = <3>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+
+	fimc_is_ch0_i2c: fimc-is-ch0_i2c {
+		samsung,pins = "gpc2-1", "gpc2-0";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+
+	fimc_is_ch0_mclk: fimc-is-ch0_mclk {
+		samsung,pins = "gpd7-0";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+
+	fimc_is_ch1_i2c: fimc-is-ch1-i2c {
+		samsung,pins = "gpc2-3", "gpc2-2";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+
+	fimc_is_ch1_mclk: fimc-is-ch1-mclk {
+		samsung,pins = "gpd7-1";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+
+	fimc_is_ch2_i2c: fimc-is-ch2-i2c {
+		samsung,pins = "gpc2-5", "gpc2-4";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+
+	fimc_is_ch2_mclk: fimc-is-ch2-mclk {
+		samsung,pins = "gpd7-2";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+};
+
+&pinctrl_touch {
+	gpj1: gpj1 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	hs_i2c5_bus: hs-i2c5-bus {
+		samsung,pins = "gpj1-1", "gpj1-0";
+		samsung,pin-function = <4>;
+		samsung,pin-pud = <3>;
+		samsung,pin-drv = <0>;
+	};
+};
diff --git a/arch/arm64/boot/dts/exynos/exynos5433.dtsi b/arch/arm64/boot/dts/exynos/exynos5433.dtsi
new file mode 100644
index 0000000..5637086
--- /dev/null
+++ b/arch/arm64/boot/dts/exynos/exynos5433.dtsi
@@ -0,0 +1,515 @@
+/*
+ * Samsung's Exynos5433 SoC device tree source
+ *
+ * Copyright (c) 2014 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ *
+ * Samsung's Exynos5433 SoC device nodes are listed in this file. Exynos5433
+ * based board files can include this file and provide values for board specfic
+ * bindings.
+ *
+ * Note: This file does not include device nodes for all the controllers in
+ * Exynos5433 SoC. As device tree coverage for Exynos5433 increases, additional
+ * nodes can be added to this file.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <dt-bindings/clock/exynos5433.h>
+
+/ {
+	compatible = "samsung,exynos5433";
+	#address-cells = <2>;
+	#size-cells = <2>;
+
+	interrupt-parent = <&gic>;
+
+	aliases {
+		pinctrl0 = &pinctrl_alive;
+		pinctrl1 = &pinctrl_aud;
+		pinctrl2 = &pinctrl_cpif;
+		pinctrl3 = &pinctrl_ese;
+		pinctrl4 = &pinctrl_finger;
+		pinctrl5 = &pinctrl_fsys;
+		pinctrl6 = &pinctrl_imem;
+		pinctrl7 = &pinctrl_nfc;
+		pinctrl8 = &pinctrl_peric;
+		pinctrl9 = &pinctrl_touch;
+		serial0 = &serial_0;
+		serial1 = &serial_1;
+		serial2 = &serial_2;
+		i2c0 = &hsi2c_0;
+		i2c1 = &hsi2c_1;
+		i2c2 = &hsi2c_2;
+		i2c3 = &hsi2c_3;
+		i2c4 = &hsi2c_4;
+		i2c5 = &hsi2c_5;
+		i2c6 = &hsi2c_6;
+		i2c7 = &hsi2c_7;
+		i2c8 = &hsi2c_8;
+		i2c9 = &hsi2c_9;
+		i2c10 = &hsi2c_10;
+		i2c11 = &hsi2c_11;
+	};
+
+	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		cpu0: cpu@100 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a53", "arm,armv8";
+			enable-method = "psci";
+			reg = <0x100>;
+		};
+
+		cpu1: cpu@101 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a53", "arm,armv8";
+			enable-method = "psci";
+			reg = <0x101>;
+		};
+
+		cpu2: cpu@102 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a53", "arm,armv8";
+			enable-method = "psci";
+			reg = <0x0 0x102>;
+		};
+
+		cpu3: cpu@103 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a53", "arm,armv8";
+			enable-method = "psci";
+			reg = <0x103>;
+		};
+
+		cpu4: cpu@0 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a57", "arm,armv8";
+			enable-method = "psci";
+			reg = <0x0>;
+		};
+
+		cpu5: cpu@1 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a57", "arm,armv8";
+			enable-method = "psci";
+			reg = <0x1>;
+		};
+
+		cpu6: cpu@2 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a57", "arm,armv8";
+			enable-method = "psci";
+			reg = <0x2>;
+		};
+
+		cpu7: cpu@3 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a57", "arm,armv8";
+			enable-method = "psci";
+			reg = <0x3>;
+		};
+	};
+
+	psci {
+		compatible = "arm,psci";
+		method = "smc";
+		cpu_off = <0x84000002>;
+		cpu_on = <0xC4000003>;
+	};
+
+	soc: soc {
+		compatible = "simple-bus";
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+
+		chipid@10000000 {
+			compatible = "samsung,exynos4210-chipid";
+			reg = <0x10000000 0x100>;
+		};
+
+		fin_pll: xxti {
+			compatible = "fixed-clock";
+			clock-output-names = "fin_pll";
+			#clock-cells = <0>;
+		};
+
+		cmu_top: clock-controller@10030000{
+			compatible = "samsung,exynos5433-cmu-top";
+			reg = <0x10030000 0x0c04>;
+			#clock-cells = <1>;
+		};
+
+		cmu_cpif: clock-controller@10fc0000{
+			compatible = "samsung,exynos5433-cmu-cpif";
+			reg = <0x10fc0000 0x0c04>;
+			#clock-cells = <1>;
+		};
+
+		cmu_mif: clock-controller@105b0000{
+			compatible = "samsung,exynos5433-cmu-mif";
+			reg = <0x105b0000 0x100c>;
+			#clock-cells = <1>;
+		};
+
+		cmu_peric: clock-controller@14c80000{
+			compatible = "samsung,exynos5433-cmu-peric";
+			reg = <0x14c80000 0x0b08>;
+			#clock-cells = <1>;
+		};
+
+		cmu_peris: clock-controller@10040000{
+			compatible = "samsung,exynos5433-cmu-peris";
+			reg = <0x10040000 0x0b20>;
+			#clock-cells = <1>;
+		};
+
+		cmu_fsys: clock-controller@156e0000{
+			compatible = "samsung,exynos5433-cmu-fsys";
+			reg = <0x156e0000 0x0b04>;
+			#clock-cells = <1>;
+		};
+
+		cmu_g2d: clock-controller@12460000{
+			compatible = "samsung,exynos5433-cmu-g2d";
+			reg = <0x12460000 0x0b08>;
+			#clock-cells = <1>;
+		};
+
+		cmu_disp: clock-controller@13b90000{
+			compatible = "samsung,exynos5433-cmu-disp";
+			reg = <0x13b90000 0x0c04>;
+			#clock-cells = <1>;
+		};
+
+		cmu_aud: clock-controller@114c0000{
+			compatible = "samsung,exynos5433-cmu-aud";
+			reg = <0x114c0000 0x0b04>;
+			#clock-cells = <1>;
+		};
+
+		cmu_bus0: clock-controller@13600000 {
+			compatible = "samsung,exynos5433-cmu-bus0";
+			reg = <0x13600000 0x0b04>;
+			#clock-cells = <1>;
+		};
+
+		cmu_bus1: clock-controller@14800000 {
+			compatible = "samsung,exynos5433-cmu-bus1";
+			reg = <0x14800000 0x0b04>;
+			#clock-cells = <1>;
+		};
+
+		cmu_bus2: clock-controller@13400000 {
+			compatible = "samsung,exynos5433-cmu-bus2";
+			reg = <0x13400000 0x0b04>;
+			#clock-cells = <1>;
+		};
+
+		cmu_g3d: clock-controller@14aa0000 {
+			compatible = "samsung,exynos5433-cmu-g3d";
+			reg = <0x14aa0000 0x1000>;
+			#clock-cells = <1>;
+		};
+
+		cmu_gscl: clock-controller@13cf0000 {
+			compatible = "samsung,exynos5433-cmu-gscl";
+			reg = <0x13cf0000 0x0b10>;
+			#clock-cells = <1>;
+		};
+
+		mct@101c0000 {
+			compatible = "samsung,exynos5433-mct",
+				     "samsung,exynos4210-mct";
+			reg = <0x101c0000 0x800>;
+			interrupts = <0 102 0>, <0 103 0>, <0 104 0>, <0 105 0>,
+				<0 106 0>, <0 107 0>, <0 108 0>, <0 109 0>,
+				<0 110 0>, <0 111 0>, <0 112 0>, <0 113 0>;
+			clocks = <&fin_pll>,
+			         <&cmu_peris CLK_PCLK_MCT>;
+			clock-names = "fin_pll", "mct";
+		};
+
+		gic:interrupt-controller@11001000 {
+			compatible = "arm,gic-400";
+			#interrupt-cells = <3>;
+			interrupt-controller;
+			reg =	<0x11001000 0x1000>,
+				<0x11002000 0x1000>,
+				<0x11004000 0x2000>,
+				<0x11006000 0x2000>;
+			interrupts = <1 9 0xf04>;
+		};
+
+		serial_0: serial@14c10000 {
+			compatible = "samsung,exynos5433-uart";
+			reg = <0x14c10000 0x100>;
+			interrupts = <0 421 0>;
+			clocks = <&cmu_peric CLK_PCLK_UART0>,
+				 <&cmu_peric CLK_SCLK_UART0>;
+			clock-names = "uart", "clk_uart_baud0";
+			pinctrl-names = "default";
+			pinctrl-0 = <&uart0_bus>;
+			status = "disabled";
+		};
+
+		serial_1: serial@14c20000 {
+			compatible = "samsung,exynos5433-uart";
+			reg = <0x14c20000 0x100>;
+			interrupts = <0 422 0>;
+			clocks = <&cmu_peric CLK_PCLK_UART1>,
+				 <&cmu_peric CLK_SCLK_UART1>;
+			clock-names = "uart", "clk_uart_baud0";
+			pinctrl-names = "default";
+			pinctrl-0 = <&uart1_bus>;
+			status = "disabled";
+		};
+
+		serial_2: serial@14c30000 {
+			compatible = "samsung,exynos5433-uart";
+			reg = <0x14c30000 0x100>;
+			interrupts = <0 423 0>;
+			clocks = <&cmu_peric CLK_PCLK_UART2>,
+				 <&cmu_peric CLK_SCLK_UART2>;
+			clock-names = "uart", "clk_uart_baud0";
+			pinctrl-names = "default";
+			pinctrl-0 = <&uart2_bus>;
+			status = "disabled";
+		};
+
+		pinctrl_alive: pinctrl@10580000 {
+			compatible = "samsung,exynos5433-pinctrl";
+			reg = <0x10580000 0x1000>;
+
+			wakeup-interrupt-controller {
+				compatible = "samsung,exynos7-wakeup-eint";
+				interrupts = <0 16 0>;
+			};
+		};
+
+		pinctrl_aud: pinctrl@114b0000 {
+			compatible = "samsung,exynos5433-pinctrl";
+			reg = <0x114b0000 0x1000>;
+			interrupts = <0 68 0>;
+		};
+
+		pinctrl_cpif: pinctrl@10fe0000 {
+			compatible = "samsung,exynos5433-pinctrl";
+			reg = <0x10fe0000 0x1000>;
+			interrupts = <0 179 0>;
+		};
+
+		pinctrl_ese: pinctrl@14ca0000 {
+			compatible = "samsung,exynos5433-pinctrl";
+			reg = <0x14ca0000 0x1000>;
+			interrupts = <0 413 0>;
+		};
+
+		pinctrl_finger: pinctrl@14cb0000 {
+			compatible = "samsung,exynos5433-pinctrl";
+			reg = <0x14cb0000 0x1000>;
+			interrupts = <0 414 0>;
+		};
+
+		pinctrl_fsys: pinctrl@15690000 {
+			compatible = "samsung,exynos5433-pinctrl";
+			reg = <0x15690000 0x1000>;
+			interrupts = <0 229 0>;
+		};
+
+		pinctrl_imem: pinctrl@11090000 {
+			compatible = "samsung,exynos5433-pinctrl";
+			reg = <0x11090000 0x1000>;
+			interrupts = <0 325 0>;
+		};
+
+		pinctrl_nfc: pinctrl@14cd0000 {
+			compatible = "samsung,exynos5433-pinctrl";
+			reg = <0x14cd0000 0x1000>;
+			interrupts = <0 441 0>;
+		};
+
+		pinctrl_peric: pinctrl@14cc0000 {
+			compatible = "samsung,exynos5433-pinctrl";
+			reg = <0x14cc0000 0x1100>;
+			interrupts = <0 440 0>;
+		};
+
+		pinctrl_touch: pinctrl@14ce0000 {
+			compatible = "samsung,exynos5433-pinctrl";
+			reg = <0x14ce0000 0x1100>;
+			interrupts = <0 442 0>;
+		};
+
+		hsi2c_0: hsi2c@14e40000 {
+			compatible = "samsung,exynos7-hsi2c";
+			reg = <0x14e40000 0x1000>;
+			interrupts = <0 428 0>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+			pinctrl-names = "default";
+			pinctrl-0 = <&hs_i2c0_bus>;
+			clocks = <&cmu_peric CLK_PCLK_HSI2C0>;
+			clock-names = "hsi2c";
+			status = "disabled";
+		};
+
+		hsi2c_1: hsi2c@14e50000 {
+			compatible = "samsung,exynos7-hsi2c";
+			reg = <0x14e50000 0x1000>;
+			interrupts = <0 429 0>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+			pinctrl-names = "default";
+			pinctrl-0 = <&hs_i2c1_bus>;
+			clocks = <&cmu_peric CLK_PCLK_HSI2C1>;
+			clock-names = "hsi2c";
+			status = "disabled";
+		};
+
+		hsi2c_2: hsi2c@14e60000 {
+			compatible = "samsung,exynos7-hsi2c";
+			reg = <0x14e60000 0x1000>;
+			interrupts = <0 430 0>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+			pinctrl-names = "default";
+			pinctrl-0 = <&hs_i2c2_bus>;
+			clocks = <&cmu_peric CLK_PCLK_HSI2C2>;
+			clock-names = "hsi2c";
+			status = "disabled";
+		};
+
+		hsi2c_3: hsi2c@14e70000 {
+			compatible = "samsung,exynos7-hsi2c";
+			reg = <0x14e70000 0x1000>;
+			interrupts = <0 431 0>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+			pinctrl-names = "default";
+			pinctrl-0 = <&hs_i2c3_bus>;
+			clocks = <&cmu_peric CLK_PCLK_HSI2C3>;
+			clock-names = "hsi2c";
+			status = "disabled";
+		};
+
+		hsi2c_4: hsi2c@14ec0000 {
+			compatible = "samsung,exynos7-hsi2c";
+			reg = <0x14ec0000 0x1000>;
+			interrupts = <0 424 0>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+			pinctrl-names = "default";
+			pinctrl-0 = <&hs_i2c4_bus>;
+			clocks = <&cmu_peric CLK_PCLK_HSI2C4>;
+			clock-names = "hsi2c";
+			status = "disabled";
+		};
+
+		hsi2c_5: hsi2c@14ed0000 {
+			compatible = "samsung,exynos7-hsi2c";
+			reg = <0x14ed0000 0x1000>;
+			interrupts = <0 425 0>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+			pinctrl-names = "default";
+			pinctrl-0 = <&hs_i2c5_bus>;
+			clocks = <&cmu_peric CLK_PCLK_HSI2C5>;
+			clock-names = "hsi2c";
+			status = "disabled";
+		};
+
+		hsi2c_6: hsi2c@14ee0000 {
+			compatible = "samsung,exynos7-hsi2c";
+			reg = <0x14ee0000 0x1000>;
+			interrupts = <0 426 0>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+			pinctrl-names = "default";
+			pinctrl-0 = <&hs_i2c6_bus>;
+			clocks = <&cmu_peric CLK_PCLK_HSI2C6>;
+			clock-names = "hsi2c";
+			status = "disabled";
+		};
+
+		hsi2c_7: hsi2c@14ef0000 {
+			compatible = "samsung,exynos7-hsi2c";
+			reg = <0x14ef0000 0x1000>;
+			interrupts = <0 427 0>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+			pinctrl-names = "default";
+			pinctrl-0 = <&hs_i2c7_bus>;
+			clocks = <&cmu_peric CLK_PCLK_HSI2C7>;
+			clock-names = "hsi2c";
+			status = "disabled";
+		};
+
+		hsi2c_8: hsi2c@14d90000 {
+			compatible = "samsung,exynos7-hsi2c";
+			reg = <0x14d90000 0x1000>;
+			interrupts = <0 443 0>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+			pinctrl-names = "default";
+			pinctrl-0 = <&hs_i2c8_bus>;
+			clocks = <&cmu_peric CLK_PCLK_HSI2C8>;
+			clock-names = "hsi2c";
+			status = "disabled";
+		};
+
+		hsi2c_9: hsi2c@14da0000 {
+			compatible = "samsung,exynos7-hsi2c";
+			reg = <0x14da0000 0x1000>;
+			interrupts = <0 444 0>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+			pinctrl-names = "default";
+			pinctrl-0 = <&hs_i2c9_bus>;
+			clocks = <&cmu_peric CLK_PCLK_HSI2C9>;
+			clock-names = "hsi2c";
+			status = "disabled";
+		};
+
+		hsi2c_10: hsi2c@14de0000 {
+			compatible = "samsung,exynos7-hsi2c";
+			reg = <0x14de0000 0x1000>;
+			interrupts = <0 445 0>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+			pinctrl-names = "default";
+			pinctrl-0 = <&hs_i2c10_bus>;
+			clocks = <&cmu_peric CLK_PCLK_HSI2C10>;
+			clock-names = "hsi2c";
+			status = "disabled";
+		};
+
+		hsi2c_11: hsi2c@14df0000 {
+			compatible = "samsung,exynos7-hsi2c";
+			reg = <0x14df0000 0x1000>;
+			interrupts = <0 446 0>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+			pinctrl-names = "default";
+			pinctrl-0 = <&hs_i2c11_bus>;
+			clocks = <&cmu_peric CLK_PCLK_HSI2C11>;
+			clock-names = "hsi2c";
+			status = "disabled";
+		};
+
+		timer {
+			compatible = "arm,armv8-timer";
+			interrupts = <4 13 0xff01>,
+				     <4 14 0xff01>,
+				     <4 11 0xff01>,
+				     <4 10 0xff01>;
+		};
+	};
+};
+
+#include "exynos5433-pinctrl.dtsi"
-- 
1.8.5.5

