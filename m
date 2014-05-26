Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751595AbaEZDXz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 23:23:55 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:18914 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487AbaEZDXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 23:23:50 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-a5-5382b3c307af
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
Subject: [PATCH v11 3/3] ARM: dts: Add initial device tree support for
 EXYNOS5410
Date: Mon, 26 May 2014 07:23:33 +0400
Message-id: <1401074613-29227-4-git-send-email-t.dakhran@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1401074613-29227-1-git-send-email-t.dakhran@samsung.com>
References: <1401074613-29227-1-git-send-email-t.dakhran@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMLMWRmVeSWpSXmKPExsVy+t/xq7qHNzcFG1y7w2cxad0BJouH62+y
	WMw/co7Vov/NQlaL/49es1qce7WS0aJ3wVU2i7NNb9gtNj2+xmqxsG0Ji8XlXXPYLGac38dk
	cfsyr8XS6xeZLJ5OuMhmMWH6WhaLdS+ns1i07j3CbrHlZwejxe+eT8wW65+fYrRYP+M1i8Wx
	GUsYLabO+MHuIOGxZt4aRo+W5h42j8t9vUwef1e9YPbYOesuu8fK5V/YPDat6mTzeLV6JqvH
	nWt72Dw2L6n3eHWNxaNvyypGj+3X5jF7fN4kF8AXxWWTkpqTWZZapG+XwJUxt72ftWCLc8XK
	Nz8YGxhvGHcxcnJICJhInHt8kxnCFpO4cG89WxcjF4eQwFJGiUenv7NAOB1MEgv/tDJ2MXJw
	sAloS2zZ4QXSICKgILG59xkrSA2zwCc2iR+rmphAEsICwRJfX2xkBLFZBFQlXj68xQTSyyvg
	KjF5ST6IKQHUO2eSDUgFp4CbxLoD58CqhYAq7h1YxjqBkXcBI8MqRtHU0uSC4qT0XCO94sTc
	4tK8dL3k/NxNjJCI+rqDcekxq0OMAhyMSjy8L/KagoVYE8uKK3MPMUpwMCuJ8F7IBQrxpiRW
	VqUW5ccXleakFh9iZOLglGpgFInYWtv5ZKPRUcE92xvncKWsMv7cP9P8+lSn+termks+n2/b
	xya8vrXOof2Z2tXSJeIr0qbLeu/KF362s1yybW/TAVnVoJMmyVOF905JfXAmo0P30rN5N0VU
	1kYcNX3q+2hLu5HO9aRklUOqV57EZJ6fcVLke8fC/XP6mJj3PAy1ZDDxdXgRocRSnJFoqMVc
	VJwIAA3kZYCGAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add initial device tree nodes for EXYNOS5410 SoC and SMDK5410 board.

Signed-off-by: Tarek Dakhran <t.dakhran@samsung.com>
Signed-off-by: Vyacheslav Tyrtov <v.tyrtov@samsung.com>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>
---
 arch/arm/boot/dts/Makefile                |    1 +
 arch/arm/boot/dts/exynos5410-smdk5410.dts |   82 ++++++++++++
 arch/arm/boot/dts/exynos5410.dtsi         |  206 +++++++++++++++++++++++++++++
 3 files changed, 289 insertions(+)
 create mode 100644 arch/arm/boot/dts/exynos5410-smdk5410.dts
 create mode 100644 arch/arm/boot/dts/exynos5410.dtsi

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index cd399a2..709f862 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -73,6 +73,7 @@ dtb-$(CONFIG_ARCH_EXYNOS) += exynos4210-origen.dtb \
 	exynos5250-smdk5250.dtb \
 	exynos5250-snow.dtb \
 	exynos5260-xyref5260.dtb \
+	exynos5410-smdk5410.dtb \
 	exynos5420-arndale-octa.dtb \
 	exynos5420-peach-pit.dtb \
 	exynos5420-smdk5420.dtb \
diff --git a/arch/arm/boot/dts/exynos5410-smdk5410.dts b/arch/arm/boot/dts/exynos5410-smdk5410.dts
new file mode 100644
index 0000000..7275bbd
--- /dev/null
+++ b/arch/arm/boot/dts/exynos5410-smdk5410.dts
@@ -0,0 +1,82 @@
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
+	compatible = "samsung,smdk5410", "samsung,exynos5410", "samsung,exynos5";
+
+	memory {
+		reg = <0x40000000 0x80000000>;
+	};
+
+	chosen {
+		bootargs = "console=ttySAC2,115200";
+	};
+
+	fin_pll: xxti {
+		compatible = "fixed-clock";
+		clock-frequency = <24000000>;
+		clock-output-names = "fin_pll";
+		#clock-cells = <0>;
+	};
+
+	firmware@02037000 {
+		compatible = "samsung,secure-firmware";
+		reg = <0x02037000 0x1000>;
+	};
+
+};
+
+&mmc_0 {
+	status = "okay";
+	num-slots = <1>;
+	supports-highspeed;
+	broken-cd;
+	card-detect-delay = <200>;
+	samsung,dw-mshc-ciu-div = <3>;
+	samsung,dw-mshc-sdr-timing = <2 3>;
+	samsung,dw-mshc-ddr-timing = <1 2>;
+
+	slot@0 {
+		reg = <0>;
+		bus-width = <8>;
+	};
+};
+
+&mmc_2 {
+	status = "okay";
+	num-slots = <1>;
+	supports-highspeed;
+	card-detect-delay = <200>;
+	samsung,dw-mshc-ciu-div = <3>;
+	samsung,dw-mshc-sdr-timing = <2 3>;
+	samsung,dw-mshc-ddr-timing = <1 2>;
+
+	slot@0 {
+		reg = <0>;
+		bus-width = <4>;
+		disable-wp;
+	};
+};
+
+&uart0 {
+		status = "okay";
+};
+
+&uart1 {
+		status = "okay";
+};
+
+&uart2 {
+		status = "okay";
+};
diff --git a/arch/arm/boot/dts/exynos5410.dtsi b/arch/arm/boot/dts/exynos5410.dtsi
new file mode 100644
index 0000000..3839c26
--- /dev/null
+++ b/arch/arm/boot/dts/exynos5410.dtsi
@@ -0,0 +1,206 @@
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
+#include "skeleton.dtsi"
+#include <dt-bindings/clock/exynos5410.h>
+
+/ {
+	compatible = "samsung,exynos5410", "samsung,exynos5";
+	interrupt-parent = <&gic>;
+
+	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		CPU0: cpu@0 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a15";
+			reg = <0x0>;
+		};
+
+		CPU1: cpu@1 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a15";
+			reg = <0x1>;
+		};
+
+		CPU2: cpu@2 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a15";
+			reg = <0x2>;
+		};
+
+		CPU3: cpu@3 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a15";
+			reg = <0x3>;
+		};
+	};
+
+	soc: soc {
+		compatible = "simple-bus";
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+
+		combiner: interrupt-controller@10440000 {
+			compatible = "samsung,exynos4210-combiner";
+			#interrupt-cells = <2>;
+			interrupt-controller;
+			samsung,combiner-nr = <32>;
+			reg = <0x10440000 0x1000>;
+			interrupts =	<0 0 0>, <0 1 0>, <0 2 0>, <0 3 0>,
+					<0 4 0>, <0 5 0>, <0 6 0>, <0 7 0>,
+					<0 8 0>, <0 9 0>, <0 10 0>, <0 11 0>,
+					<0 12 0>, <0 13 0>, <0 14 0>, <0 15 0>,
+					<0 16 0>, <0 17 0>, <0 18 0>, <0 19 0>,
+					<0 20 0>, <0 21 0>, <0 22 0>, <0 23 0>,
+					<0 24 0>, <0 25 0>, <0 26 0>, <0 27 0>,
+					<0 28 0>, <0 29 0>, <0 30 0>, <0 31 0>;
+		};
+
+		gic: interrupt-controller@10481000 {
+			compatible = "arm,cortex-a15-gic", "arm,cortex-a9-gic";
+			#interrupt-cells = <3>;
+			interrupt-controller;
+			reg =	<0x10481000 0x1000>,
+				<0x10482000 0x1000>,
+				<0x10484000 0x2000>,
+				<0x10486000 0x2000>;
+			interrupts = <1 9 0xf04>;
+		};
+
+		chipid@10000000 {
+			compatible = "samsung,exynos4210-chipid";
+			reg = <0x10000000 0x100>;
+		};
+
+		mct: mct@101C0000 {
+			compatible = "samsung,exynos4210-mct";
+			reg = <0x101C0000 0xB00>;
+			interrupt-parent = <&interrupt_map>;
+			interrupts = <0>, <1>, <2>, <3>,
+				<4>, <5>, <6>, <7>,
+				<8>, <9>, <10>, <11>;
+			clocks = <&fin_pll>, <&clock CLK_MCT>;
+			clock-names = "fin_pll", "mct";
+
+			interrupt_map: interrupt-map {
+				#interrupt-cells = <1>;
+				#address-cells = <0>;
+				#size-cells = <0>;
+				interrupt-map = <0 &combiner 23 3>,
+						<1 &combiner 23 4>,
+						<2 &combiner 25 2>,
+						<3 &combiner 25 3>,
+						<4 &gic 0 120 0>,
+						<5 &gic 0 121 0>,
+						<6 &gic 0 122 0>,
+						<7 &gic 0 123 0>,
+						<8 &gic 0 128 0>,
+						<9 &gic 0 129 0>,
+						<10 &gic 0 130 0>,
+						<11 &gic 0 131 0>;
+			};
+		};
+
+		sysram@02020000 {
+			compatible = "mmio-sram";
+			reg = <0x02020000 0x54000>;
+			#address-cells = <1>;
+			#size-cells = <1>;
+			ranges = <0 0x02020000 0x54000>;
+
+			smp-sysram@0 {
+				compatible = "samsung,exynos4210-sysram";
+				reg = <0x0 0x1000>;
+			};
+
+			smp-sysram@53000 {
+				compatible = "samsung,exynos4210-sysram-ns";
+				reg = <0x53000 0x1000>;
+			};
+		};
+
+		clock: clock-controller@10010000 {
+			compatible = "samsung,exynos5410-clock";
+			reg = <0x10010000 0x30000>;
+			#clock-cells = <1>;
+		};
+
+		mmc_0: mmc@12200000 {
+			compatible = "samsung,exynos5250-dw-mshc";
+			reg = <0x12200000 0x1000>;
+			interrupts = <0 75 0>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+			clocks = <&clock CLK_MMC0>, <&clock CLK_SCLK_MMC0>;
+			clock-names = "biu", "ciu";
+			fifo-depth = <0x80>;
+			status = "disabled";
+		};
+
+		mmc_1: mmc@12210000 {
+			compatible = "samsung,exynos5250-dw-mshc";
+			reg = <0x12210000 0x1000>;
+			interrupts = <0 76 0>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+			clocks = <&clock CLK_MMC1>, <&clock CLK_SCLK_MMC1>;
+			clock-names = "biu", "ciu";
+			fifo-depth = <0x80>;
+			status = "disabled";
+		};
+
+		mmc_2: mmc@12220000 {
+			compatible = "samsung,exynos5250-dw-mshc";
+			reg = <0x12220000 0x1000>;
+			interrupts = <0 77 0>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+			clocks = <&clock CLK_MMC2>, <&clock CLK_SCLK_MMC2>;
+			clock-names = "biu", "ciu";
+			fifo-depth = <0x80>;
+			status = "disabled";
+		};
+
+		uart0: serial@12C00000 {
+			compatible = "samsung,exynos4210-uart";
+			reg = <0x12C00000 0x100>;
+			interrupts = <0 51 0>;
+			clocks = <&clock CLK_UART0>, <&clock CLK_SCLK_UART0>;
+			clock-names = "uart", "clk_uart_baud0";
+			status = "disabled";
+		};
+
+		uart1: serial@12C10000 {
+			compatible = "samsung,exynos4210-uart";
+			reg = <0x12C10000 0x100>;
+			interrupts = <0 52 0>;
+			clocks = <&clock CLK_UART1>, <&clock CLK_SCLK_UART1>;
+			clock-names = "uart", "clk_uart_baud0";
+			status = "disabled";
+		};
+
+		uart2: serial@12C20000 {
+			compatible = "samsung,exynos4210-uart";
+			reg = <0x12C20000 0x100>;
+			interrupts = <0 53 0>;
+			clocks = <&clock CLK_UART2>, <&clock CLK_SCLK_UART2>;
+			clock-names = "uart", "clk_uart_baud0";
+			status = "disabled";
+		};
+	};
+};
-- 
1.7.9.5

