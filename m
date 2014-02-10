Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751696AbaBJKLe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 05:11:34 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:32854 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772AbaBJKL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 05:11:27 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-56-52f8a5cd21a4
From: Tarek Dakhran <t.dakhran@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Mike Turquette <mturquette@linaro.org>,
        Vyacheslav Tyrtov <v.tyrtov@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Romain Naour <romain.naour@openwide.fr>,
        Chander Kashyap <chander.kashyap@linaro.org>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, Tarek Dakhran <t.dakhran@gmail.com>,
        Tarek Dakhran <t.dakhran@samsung.com>
Subject: [PATCH v6 3/3] ARM: dts: Add initial device tree support for EXYNOS5410
Date: Mon, 10 Feb 2014 19:08:31 +0900
Message-id: <1392026911-21308-4-git-send-email-t.dakhran@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1392026911-21308-1-git-send-email-t.dakhran@samsung.com>
References: <1392026911-21308-1-git-send-email-t.dakhran@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCLMWRmVeSWpSXmKPExsVy+t/xK7pnl/4IMni5lM1i0roDTBYP199k
	sZh/5ByrRf+bhawW/x+9ZrU492olo0XvgqtsFmeb3rBbbHp8jdViYdsSFovLu+awWcw4v4/J
	4vZlXoul1y8yWTydcJHNYsL0tSwW615OZ7Fo3XuE3WLLzw5Gi989n5gt1j8/xWixfsZrFotj
	M5YwWkyd8YPdQcJjzbw1jB4tzT1sHpf7epk8/q56weyxc9Zddo+Vy7+weWxa1cnm8Wr1TFaP
	O9f2sHlsXlLv8eoai0ffllWMHtuvzWP2+LxJLoAvissmJTUnsyy1SN8ugSuj4ZlRwRnjilnr
	N7I0MK7T6GLk5JAQMJG4NPcSC4QtJnHh3nq2LkYuDiGBpYwSD/eeZYRwepkk/r+dCpTh4GAT
	0JbYssMLpEFEQEFic+8zVpAaZoFPbBI/VjUxgSSEBQIkVu9pA7NZBFQl9l+eyQhi8wq4Sqzv
	mskEsU1RovvZBDYQm1PATeLTqn4wWwioZvG7aYwTGHkXMDKsYhRNLU0uKE5KzzXUK07MLS7N
	S9dLzs/dxAiJqS87GBcfszrEKMDBqMTDu/PP9yAh1sSy4srcQ4wSHMxKIrxz5/0IEuJNSays
	Si3Kjy8qzUktPsTIxMEp1cDo9TF4wov/O7XuBT9x6J5+OCMls9SoLEN28oEyc+EzBWGtb26J
	GrQG9/1YfO5ajYD6p2PGHmb/rKMWnfvQOpH7QI7wtVcvpa+1XI9XSbq3cmZYrdrfBPXGcFkx
	PVmz6+mP/i1vUWlxsZowzeTxvVN3X7qGsZT+P/PLZ9ebBfaHn+k/ex5Z5eClxFKckWioxVxU
	nAgAnKjALocCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add initial device tree nodes for EXYNOS5410 SoC and SMDK5410 board.

Signed-off-by: Tarek Dakhran <t.dakhran@samsung.com>
Signed-off-by: Vyacheslav Tyrtov <v.tyrtov@samsung.com>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>
---
 arch/arm/boot/dts/Makefile                |    1 +
 arch/arm/boot/dts/exynos5410-smdk5410.dts |   72 +++++++++++++++
 arch/arm/boot/dts/exynos5410.dtsi         |  140 +++++++++++++++++++++++++++++
 3 files changed, 213 insertions(+)
 create mode 100644 arch/arm/boot/dts/exynos5410-smdk5410.dts
 create mode 100644 arch/arm/boot/dts/exynos5410.dtsi

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index b9d6a8b..693dcdc 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -73,6 +73,7 @@ dtb-$(CONFIG_ARCH_EXYNOS) += exynos4210-origen.dtb \
 	exynos5250-smdk5250.dtb \
 	exynos5250-snow.dtb \
 	exynos5420-arndale-octa.dtb \
+	exynos5410-smdk5410.dtb \
 	exynos5420-smdk5420.dtb \
 	exynos5440-sd5v1.dtb \
 	exynos5440-ssdk5440.dtb
diff --git a/arch/arm/boot/dts/exynos5410-smdk5410.dts b/arch/arm/boot/dts/exynos5410-smdk5410.dts
new file mode 100644
index 0000000..7ffd351
--- /dev/null
+++ b/arch/arm/boot/dts/exynos5410-smdk5410.dts
@@ -0,0 +1,72 @@
+/*
+ * SAMSUNG SMDK5410 board device tree source
+ *
+ * Copyright (c) 2013 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+/dts-v1/;
+#include "exynos5410.dtsi"
+/ {
+	model = "Samsung SMDK5410 board based on EXYNOS5410";
+	compatible = "samsung,smdk5410", "samsung,exynos5410";
+
+	memory {
+		reg = <0x40000000 0x80000000>;
+	};
+
+	chosen {
+		bootargs = "console=ttySAC2,115200";
+	};
+
+	clocks {
+		compatible = "simple-bus";
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		fin_pll: clock-fin-pll {
+			compatible = "fixed-clock";
+			reg = <0>;
+			#clock-cells = <0>;
+			clock-frequency = <24000000>;
+			clock-output-names = "fin_pll";
+		};
+	};
+
+	mmc@12200000 {
+		status = "okay";
+		num-slots = <1>;
+		supports-highspeed;
+		broken-cd;
+		card-detect-delay = <200>;
+		samsung,dw-mshc-ciu-div = <3>;
+		samsung,dw-mshc-sdr-timing = <2 3>;
+		samsung,dw-mshc-ddr-timing = <1 2>;
+
+		slot@0 {
+			reg = <0>;
+			bus-width = <8>;
+		};
+	};
+
+	mmc@12220000 {
+		status = "okay";
+		num-slots = <1>;
+		supports-highspeed;
+		card-detect-delay = <200>;
+		samsung,dw-mshc-ciu-div = <3>;
+		samsung,dw-mshc-sdr-timing = <2 3>;
+		samsung,dw-mshc-ddr-timing = <1 2>;
+
+		slot@0 {
+			reg = <0>;
+			bus-width = <4>;
+			disable-wp;
+		};
+	};
+
+};
diff --git a/arch/arm/boot/dts/exynos5410.dtsi b/arch/arm/boot/dts/exynos5410.dtsi
new file mode 100644
index 0000000..56b44d1
--- /dev/null
+++ b/arch/arm/boot/dts/exynos5410.dtsi
@@ -0,0 +1,140 @@
+/*
+ * SAMSUNG EXYNOS5410 SoC device tree source
+ *
+ * Copyright (c) 2013 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ *
+ * SAMSUNG EXYNOS5410 SoC device nodes are listed in this file.
+ * EXYNOS5410 based board files can include this file and provide
+ * values for board specfic bindings.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <dt-bindings/clock/exynos5410.h>
+#include "exynos5.dtsi"
+/ {
+	compatible = "samsung,exynos5410";
+
+	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		CPU0: cpu@0 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a15";
+			reg = <0>;
+			clock-frequency = <1600000000>;
+		};
+
+		CPU1: cpu@1 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a15";
+			reg = <1>;
+			clock-frequency = <1600000000>;
+		};
+
+		CPU2: cpu@2 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a15";
+			reg = <2>;
+			clock-frequency = <1600000000>;
+		};
+
+		CPU3: cpu@3 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a15";
+			reg = <3>;
+			clock-frequency = <1600000000>;
+		};
+	};
+
+	clock: clock-controller@10010000 {
+		compatible = "samsung,exynos5410-clock";
+		reg = <0x10010000 0x30000>;
+		#clock-cells = <1>;
+	};
+
+	timer@101C0000 {
+		compatible = "samsung,exynos4210-mct";
+		reg = <0x101C0000 0xB00>;
+		interrupt-parent = <&interrupt_map>;
+		interrupts = <0>, <1>, <2>, <3>,
+			<4>, <5>, <6>, <7>,
+			<8>, <9>, <10>, <11>;
+		clocks = <&fin_pll>, <&clock CLK_MCT>;
+		clock-names = "fin_pll", "mct";
+
+		interrupt_map: interrupt-map {
+			#interrupt-cells = <1>;
+			#address-cells = <0>;
+			#size-cells = <0>;
+			interrupt-map = <0 &combiner 23 3>,
+					<1 &combiner 23 4>,
+					<2 &combiner 25 2>,
+					<3 &combiner 25 3>,
+					<4 &gic 0 120 0>,
+					<5 &gic 0 121 0>,
+					<6 &gic 0 122 0>,
+					<7 &gic 0 123 0>,
+					<8 &gic 0 128 0>,
+					<9 &gic 0 129 0>,
+					<10 &gic 0 130 0>,
+					<11 &gic 0 131 0>;
+		};
+	};
+
+	mmc_0: mmc@12200000 {
+		compatible = "samsung,exynos5250-dw-mshc";
+		interrupts = <0 75 0>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		reg = <0x12200000 0x1000>;
+		clocks = <&clock CLK_MMC0>, <&clock CLK_SCLK_MMC0>;
+		clock-names = "biu", "ciu";
+		fifo-depth = <0x80>;
+		status = "disabled";
+	};
+
+	mmc_1: mmc@12210000 {
+		compatible = "samsung,exynos5250-dw-mshc";
+		interrupts = <0 76 0>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		reg = <0x12210000 0x1000>;
+		clocks = <&clock CLK_MMC1>, <&clock CLK_SCLK_MMC1>;
+		clock-names = "biu", "ciu";
+		fifo-depth = <0x80>;
+		status = "disabled";
+	};
+
+	mmc_2: mmc@12220000 {
+		compatible = "samsung,exynos5250-dw-mshc";
+		interrupts = <0 77 0>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		reg = <0x12220000 0x1000>;
+		clocks = <&clock CLK_MMC2>, <&clock CLK_SCLK_MMC2>;
+		clock-names = "biu", "ciu";
+		fifo-depth = <0x80>;
+		status = "disabled";
+	};
+
+	serial@12C00000 {
+		clocks = <&clock CLK_UART0>, <&clock CLK_SCLK_UART0>;
+		clock-names = "uart", "clk_uart_baud0";
+	};
+
+	serial@12C10000 {
+		clocks = <&clock CLK_UART1>, <&clock CLK_SCLK_UART1>;
+		clock-names = "uart", "clk_uart_baud0";
+	};
+
+	serial@12C20000 {
+		clocks = <&clock CLK_UART2>, <&clock CLK_SCLK_UART2>;
+		clock-names = "uart", "clk_uart_baud0";
+	};
+
+};
-- 
1.7.10.4

