Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555AbaKXK6A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 05:58:00 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:27478 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367AbaKXK5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 05:57:55 -0500
X-AuditID: cbfee68f-f791c6d000004834-f2-54730f302311
From: Chanwoo Choi <cw00.choi@samsung.com>
To: kgene.kim@samsung.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com
Cc: jh80.chung@samsung.com, inki.dae@samsung.com, sw0312.kim@samsung.com,
        yj44.cho@samsung.com, geunsik.lim@samsung.com,
        kyungmin.park@samsung.com, cw00.choi@samsung.com,
        devicetree@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCHv3 2/3] ARM: dts: add board dts file for Exynos3250-based Monk
 board
Date: Mon, 24 Nov 2014 19:57:49 +0900
Message-id: <1416826670-29438-3-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1416826670-29438-1-git-send-email-cw00.choi@samsung.com>
References: <1416826670-29438-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplkeLIzCtJLcpLzFFi42JZI2JSqGvIXxxi0PuE2+L6l+esFvOPnGO1
	+DOhlc1i0v0JLBY3frWxWvQuuMpmcbbpDbvFpsfXWC0u75rDZjHj/D4mi6XXLzJZTJi+lsWi
	de8RdosZk1+yWezdOZnRgd9jzbw1jB6bVnWyeWxeUu/Rt2UVo8fnTXIBrFFcNimpOZllqUX6
	dglcGedmLWYvmNDFWPF/YTdjA+P63C5GTg4JAROJ2/9OMUPYYhIX7q1n62Lk4hASWMoo8Xvn
	I3aYojX/JzBCJKYzSrSeuMIE4TQxSbw+0M8KUsUmoCWx/8UNNhBbRCBSYuW6H6wgRcwCW5gk
	Hk38AVYkLBAq8eT0DRYQm0VAVeLqpYNgNq+Aq8TOJTeZINYpSCxbPhOsnlPATWLlzFdgZwgB
	1ey5MIcdZKiEwDV2icOtUxkhBglIfJt8CGgQB1BCVmLTAah/JCUOrrjBMoFReAEjwypG0dSC
	5ILipPQiY73ixNzi0rx0veT83E2MwNg5/e9Z/w7GuwesDzEKcDAq8fDOWF8UIsSaWFZcmXuI
	0RRow0RmKdHkfGCE5pXEGxqbGVmYmpgaG5lbmimJ8y6U+hksJJCeWJKanZpakFoUX1Sak1p8
	iJGJg1OqgVFMOPeafGyN7akL+4ObL+cwPr17xtvhaLuzveekZc2/pPQn332hqG/4XUh/wknh
	09MmL/cy6LoS+Ke1M3J/87vnVklMfTG7y3Y/+9L5IOZnWaVd8IEz2Td+f3F4pelcVLvDdec6
	xRvJAu+SizfGTO5UfrLaaOshWefWh7vF28+6St9IidLZ4qTEUpyRaKjFXFScCADGzDs4mAIA	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPIsWRmVeSWpSXmKPExsVy+t9jQV0D/uIQg/4WS4vrX56zWsw/co7V
	4s+EVjaLSfcnsFjc+NXGatG74CqbxdmmN+wWmx5fY7W4vGsOm8WM8/uYLJZev8hkMWH6WhaL
	1r1H2C1mTH7JZrF352RGB36PNfPWMHpsWtXJ5rF5Sb1H35ZVjB6fN8kFsEY1MNpkpCampBYp
	pOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAJ2rpFCWmFMKFApILC5W
	0rfDNCE0xE3XAqYxQtc3JAiux8gADSSsYcw4N2sxe8GELsaK/wu7GRsY1+d2MXJySAiYSKz5
	P4ERwhaTuHBvPVsXIxeHkMB0RonWE1eYIJwmJonXB/pZQarYBLQk9r+4wQZiiwhESqxc94MV
	pIhZYAuTxKOJP8CKhAVCJZ6cvsECYrMIqEpcvXQQzOYVcJXYueQmE8Q6BYlly2eC1XMKuEms
	nPmKHcQWAqrZc2EO+wRG3gWMDKsYRVMLkguKk9JzDfWKE3OLS/PS9ZLzczcxgiPzmdQOxpUN
	FocYBTgYlXh4P2wsChFiTSwrrsw9xCjBwawkwruPsThEiDclsbIqtSg/vqg0J7X4EKMp0FUT
	maVEk/OBSSOvJN7Q2MTMyNLI3NDCyNhcSZz3xs3cECGB9MSS1OzU1ILUIpg+Jg5OqQbGM3s2
	aElyhQgrT+aela+RLFR9MGzGL82YW47F1WmW6+xTgi8zf94wa9rHnGkK9d8a1/WyL/++yUGg
	z1lebnNX3tIdS5fE7dzy/RCP73eXmX1RT687vtpStZPtH5t3tfP8qQZJXzc+fWPhoe0QPO3h
	9p/8W/ueLDh6W+YFO3PWk0mprkfrqsO+K7EUZyQaajEXFScCAOQylF3iAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Youngjun Cho <yj44.cho@samsung.com>

This patch adds new board dts file to support Samsung Monk board which is
based on Exynos3250 SoC and has different H/W configuration from Rinato.

This patch is based on linux-samsung.git for-next branch and depends on
[PATCHv2 0/2] ARM: dts: Add new board dts file for Exynos3250-based Rinato board

Changes from v1:
- The 'memory' entries coalesce into one entry
- Removes useless space
- Puts voltage-regulator-0 under the root node

This dts file support following features:
- eMMC
- Main PMIC (Samsung S2MPS14)
- Interface PMIC (Maxim MAX77836, MUIC, fuel-gauge, charger)
- RTC of Exynos3250
- ADC of Exynos3250 with NTC thermistor
- I2S of Exynos3250
- TMU of Exynos3250
- Secure firmware for Exynos3250 secondary cpu boot
- Serial ports of Exynos3250
- gpio-key for power key

Signed-off-by: Youngjun Cho <yj44.cho@samsung.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Inki Dae <inki.dae@samsung.com>
Signed-off-by: Seung-Woo Kim <sw0312.kim@samsung.com>
Signed-off-by: Jaehoon Chung <jh80.chung@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 .../devicetree/bindings/arm/samsung-boards.txt     |   1 +
 arch/arm/boot/dts/Makefile                         |   3 +-
 arch/arm/boot/dts/exynos3250-monk.dts              | 579 +++++++++++++++++++++
 3 files changed, 582 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm/boot/dts/exynos3250-monk.dts

diff --git a/Documentation/devicetree/bindings/arm/samsung-boards.txt b/Documentation/devicetree/bindings/arm/samsung-boards.txt
index 1f8287e..43589d2 100644
--- a/Documentation/devicetree/bindings/arm/samsung-boards.txt
+++ b/Documentation/devicetree/bindings/arm/samsung-boards.txt
@@ -2,6 +2,7 @@
 
 Required root node properties:
     - compatible = should be one or more of the following.
+	- "samsung,monk"	- for Exynos3250-based Samsung Simband board.
 	- "samsung,rinato"	- for Exynos3250-based Samsung Gear2 board.
 	- "samsung,smdkv310"	- for Exynos4210-based Samsung SMDKV310 eval board.
 	- "samsung,trats"	- for Exynos4210-based Tizen Reference board.
diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index 91cd4d0..0e4839e 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -67,7 +67,8 @@ dtb-$(CONFIG_ARCH_BRCMSTB) += \
 dtb-$(CONFIG_ARCH_DAVINCI) += da850-enbw-cmc.dtb \
 	da850-evm.dtb
 dtb-$(CONFIG_ARCH_EFM32) += efm32gg-dk3750.dtb
-dtb-$(CONFIG_ARCH_EXYNOS) += exynos3250-rinato.dtb \
+dtb-$(CONFIG_ARCH_EXYNOS) += exynos3250-monk.dtb \
+	exynos3250-rinato.dtb \
 	exynos4210-origen.dtb \
 	exynos4210-smdkv310.dtb \
 	exynos4210-trats.dtb \
diff --git a/arch/arm/boot/dts/exynos3250-monk.dts b/arch/arm/boot/dts/exynos3250-monk.dts
new file mode 100644
index 0000000..24822aa
--- /dev/null
+++ b/arch/arm/boot/dts/exynos3250-monk.dts
@@ -0,0 +1,579 @@
+/*
+ * Samsung's Exynos3250 based Monk board device tree source
+ *
+ * Copyright (c) 2014 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ *
+ * Device tree source file for Samsung's Monk board which is based on
+ * Samsung Exynos3250 SoC.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+/dts-v1/;
+#include "exynos3250.dtsi"
+#include <dt-bindings/input/input.h>
+
+/ {
+	model = "Samsung Monk board";
+	compatible = "samsung,monk", "samsung,exynos3250", "samsung,exynos3";
+
+	aliases {
+		i2c7 = &i2c_max77836;
+	};
+
+	memory {
+		reg =  <0x40000000 0x1ff00000>;
+	};
+
+	firmware@0205F000 {
+		compatible = "samsung,secure-firmware";
+		reg = <0x0205F000 0x1000>;
+	};
+
+	gpio_keys {
+		compatible = "gpio-keys";
+
+		power_key {
+			interrupt-parent = <&gpx2>;
+			interrupts = <7 0>;
+			gpios = <&gpx2 7 1>;
+			linux,code = <KEY_POWER>;
+			label = "power key";
+			debounce-interval = <10>;
+			gpio-key,wakeup;
+		};
+	};
+
+	vemmc_reg: voltage-regulator-0 {
+		compatible = "regulator-fixed";
+		regulator-name = "V_EMMC_2.8V-fixed";
+		regulator-min-microvolt = <2800000>;
+		regulator-max-microvolt = <2800000>;
+		gpio = <&gpk0 2 0>;
+		enable-active-high;
+	};
+
+	i2c_max77836: i2c-gpio-0 {
+		compatible = "i2c-gpio";
+		gpios = <&gpd0 2 0>, <&gpd0 3 0>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		max77836: subpmic@25 {
+			compatible = "maxim,max77836";
+			interrupt-parent = <&gpx1>;
+			interrupts = <5 0>;
+			reg = <0x25>;
+			wakeup;
+
+			muic: max77836-muic {
+				compatible = "maxim,max77836-muic";
+			};
+
+			regulators {
+				compatible = "maxim,max77836-regulator";
+				safeout_reg: SAFEOUT {
+					regulator-name = "SAFEOUT";
+				};
+
+				charger_reg: CHARGER {
+					regulator-name = "CHARGER";
+					regulator-min-microamp = <45000>;
+					regulator-max-microamp = <475000>;
+					regulator-boot-on;
+				};
+
+				motor_reg: LDO1 {
+					regulator-name = "MOT_2.7V";
+					regulator-min-microvolt = <1100000>;
+					regulator-max-microvolt = <2700000>;
+				};
+
+				LDO2 {
+					regulator-name = "UNUSED_LDO2";
+					regulator-min-microvolt = <800000>;
+					regulator-max-microvolt = <3950000>;
+				};
+			};
+
+			charger {
+				compatible = "maxim,max77836-charger";
+
+				maxim,constant-uvolt = <4350000>;
+				maxim,fast-charge-uamp = <225000>;
+				maxim,eoc-uamp = <7500>;
+				maxim,ovp-uvolt = <6500000>;
+			};
+		};
+	};
+};
+
+&adc {
+	vdd-supply = <&ldo3_reg>;
+	status = "okay";
+	assigned-clocks = <&cmu CLK_SCLK_TSADC>;
+	assigned-clock-rates = <6000000>;
+
+	thermistor-ap {
+		compatible = "ntc,ncp15wb473";
+		pullup-uv = <1800000>;
+		pullup-ohm = <100000>;
+		pulldown-ohm = <100000>;
+		io-channels = <&adc 0>;
+	};
+
+	thermistor-battery {
+		compatible = "ntc,ncp15wb473";
+		pullup-uv = <1800000>;
+		pullup-ohm = <100000>;
+		pulldown-ohm = <100000>;
+		io-channels = <&adc 1>;
+	};
+};
+
+&i2c_0 {
+	#address-cells = <1>;
+	#size-cells = <0>;
+	samsung,i2c-sda-delay = <100>;
+	samsung,i2c-slave-addr = <0x10>;
+	samsung,i2c-max-bus-freq = <100000>;
+	status = "okay";
+
+	s2mps14_pmic@66 {
+		compatible = "samsung,s2mps14-pmic";
+		interrupt-parent = <&gpx0>;
+		interrupts = <7 0>;
+		reg = <0x66>;
+		wakeup;
+
+		s2mps14_osc: clocks {
+			compatible = "samsung,s2mps14-clk";
+			#clock-cells = <1>;
+			clock-output-names = "s2mps14_ap", "unused",
+				"s2mps14_bt";
+		};
+
+		regulators {
+			ldo1_reg: LDO1 {
+				regulator-name = "VAP_ALIVE_1.0V";
+				regulator-min-microvolt = <1000000>;
+				regulator-max-microvolt = <1000000>;
+				regulator-always-on;
+			};
+
+			ldo2_reg: LDO2 {
+				regulator-name = "VAP_M1_1.2V";
+				regulator-min-microvolt = <1200000>;
+				regulator-max-microvolt = <1200000>;
+				regulator-always-on;
+			};
+
+			ldo3_reg: LDO3 {
+				regulator-name = "VCC_AP_1.8V";
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <1800000>;
+				regulator-always-on;
+			};
+
+			ldo4_reg: LDO4 {
+				regulator-name = "VAP_AVDD_PLL1";
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <1800000>;
+				regulator-always-on;
+			};
+
+			ldo5_reg: LDO5 {
+				regulator-name = "VAP_PLL_ISO_1.0V";
+				regulator-min-microvolt = <1000000>;
+				regulator-max-microvolt = <1000000>;
+				regulator-always-on;
+			};
+
+			ldo6_reg: LDO6 {
+				regulator-name = "VAP_MIPI_1.0V";
+				regulator-min-microvolt = <1000000>;
+				regulator-max-microvolt = <1000000>;
+			};
+
+			ldo7_reg: LDO7 {
+				regulator-name = "VAP_AVDD_1.8V";
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <1800000>;
+				regulator-always-on;
+			};
+
+			ldo8_reg: LDO8 {
+				regulator-name = "VAP_USB_3.0V";
+				regulator-min-microvolt = <3000000>;
+				regulator-max-microvolt = <3000000>;
+				regulator-always-on;
+			};
+
+			ldo9_reg: LDO9 {
+				regulator-name = "V_LPDDR_1.2V";
+				regulator-min-microvolt = <1200000>;
+				regulator-max-microvolt = <1200000>;
+				regulator-always-on;
+			};
+
+			ldo10_reg: LDO10 {
+				regulator-name = "UNUSED_LDO10";
+				regulator-min-microvolt = <1000000>;
+				regulator-max-microvolt = <1000000>;
+			};
+
+			ldo11_reg: LDO11 {
+				regulator-name = "V_EMMC_1.8V";
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <1800000>;
+				samsung,ext-control-gpios = <&gpk0 2 0>;
+			};
+
+			ldo12_reg: LDO12 {
+				regulator-name = "V_EMMC_2.8V";
+				regulator-min-microvolt = <2800000>;
+				regulator-max-microvolt = <2800000>;
+				samsung,ext-control-gpios = <&gpk0 2 0>;
+			};
+
+			ldo13_reg: LDO13 {
+				regulator-name = "VSENSOR_2.85V";
+				regulator-min-microvolt = <2850000>;
+				regulator-max-microvolt = <2850000>;
+				regulator-always-on;
+			};
+
+			ldo14_reg: LDO14 {
+				regulator-name = "UNUSED_LDO14";
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <1800000>;
+			};
+
+			ldo15_reg: LDO15 {
+				regulator-name = "TSP_AVDD_3.3V";
+				regulator-min-microvolt = <3300000>;
+				regulator-max-microvolt = <3300000>;
+			};
+
+			ldo16_reg: LDO16 {
+				regulator-name = "LCD_VDD_3.3V";
+				regulator-min-microvolt = <3300000>;
+				regulator-max-microvolt = <3300000>;
+			};
+
+			ldo17_reg: LDO17 {
+				regulator-name = "UNUSED_LDO17";
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <1800000>;
+			};
+
+			ldo18_reg: LDO18 {
+				regulator-name = "UNUSED_LDO18";
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <1800000>;
+			};
+
+			ldo19_reg: LDO19 {
+				regulator-name = "TSP_VDD_1.8V";
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <1800000>;
+			};
+
+			ldo20_reg: LDO20 {
+				regulator-name = "LCD_VDD_1.8V";
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <1800000>;
+			};
+
+			ldo21_reg: LDO21 {
+				regulator-name = "UNUSED_LDO21";
+				regulator-min-microvolt = <1000000>;
+				regulator-max-microvolt = <1000000>;
+			};
+
+			ldo22_reg: LDO22 {
+				regulator-name = "UNUSED_LDO22";
+				regulator-min-microvolt = <1000000>;
+				regulator-max-microvolt = <1000000>;
+			};
+
+			ldo23_reg: LDO23 {
+				regulator-name = "UNUSED_LDO23";
+				regulator-min-microvolt = <1000000>;
+				regulator-max-microvolt = <1000000>;
+				regulator-always-on;
+			};
+
+			ldo24_reg: LDO24 {
+				regulator-name = "UNUSED_LDO24";
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <1800000>;
+			};
+
+			ldo25_reg: LDO25 {
+				regulator-name = "UNUSED_LDO25";
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <1800000>;
+			};
+
+			buck1_reg: BUCK1 {
+				regulator-name = "VAP_MIF_1.0V";
+				regulator-min-microvolt = <800000>;
+				regulator-max-microvolt = <900000>;
+				regulator-always-on;
+			};
+
+			buck2_reg: BUCK2 {
+				regulator-name = "VAP_ARM_1.0V";
+				regulator-min-microvolt = <850000>;
+				regulator-max-microvolt = <1150000>;
+				regulator-always-on;
+			};
+
+			buck3_reg: BUCK3 {
+				regulator-name = "VAP_INT3D_1.0V";
+				regulator-min-microvolt = <850000>;
+				regulator-max-microvolt = <1000000>;
+				regulator-always-on;
+			};
+
+			buck4_reg: BUCK4 {
+				regulator-name = "VCC_SUB_1.95V";
+				regulator-min-microvolt = <1950000>;
+				regulator-max-microvolt = <1950000>;
+				regulator-always-on;
+			};
+
+			buck5_reg: BUCK5 {
+				regulator-name = "VCC_SUB_1.35V";
+				regulator-min-microvolt = <1350000>;
+				regulator-max-microvolt = <1350000>;
+				regulator-always-on;
+			};
+		};
+	};
+};
+
+&i2c_1 {
+	#address-cells = <1>;
+	#size-cells = <0>;
+	samsung,i2c-sda-delay = <100>;
+	samsung,i2c-slave-addr = <0x10>;
+	samsung,i2c-max-bus-freq = <400000>;
+	status = "okay";
+
+	fuelgauge@36 {
+		compatible = "maxim,max77836-battery";
+		interrupt-parent = <&gpx1>;
+		interrupts = <2 8>;
+		reg = <0x36>;
+	};
+};
+
+&i2s2 {
+	status = "okay";
+};
+
+&mshc_0 {
+	#address-cells = <1>;
+	#size-cells = <0>;
+	num-slots = <1>;
+	broken-cd;
+	non-removable;
+	cap-mmc-highspeed;
+	desc-num = <4>;
+	mmc-hs200-1_8v;
+	card-detect-delay = <200>;
+	vmmc-supply = <&vemmc_reg>;
+	clock-frequency = <100000000>;
+	clock-freq-min-max = <400000 100000000>;
+	samsung,dw-mshc-ciu-div = <1>;
+	samsung,dw-mshc-sdr-timing = <0 1>;
+	samsung,dw-mshc-ddr-timing = <1 2>;
+	pinctrl-names = "default";
+	pinctrl-0 = <&sd0_cmd &sd0_bus1 &sd0_bus4 &sd0_bus8>;
+	bus-width = <8>;
+	status = "okay";
+};
+
+&serial_0 {
+	assigned-clocks = <&cmu CLK_SCLK_UART0>;
+	assigned-clock-rates = <100000000>;
+	status = "okay";
+};
+
+&serial_1 {
+	status = "okay";
+};
+
+&tmu {
+	vtmu-supply = <&ldo7_reg>;
+	status = "okay";
+};
+
+&rtc {
+	clocks = <&cmu CLK_RTC>, <&s2mps14_osc 0>;
+	clock-names = "rtc", "rtc_src";
+	status = "okay";
+};
+
+&xusbxti {
+	clock-frequency = <24000000>;
+};
+
+&pinctrl_0 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&sleep0>;
+
+	sleep0: sleep-state {
+		PIN_SLP(gpa0-0, INPUT, DOWN);
+		PIN_SLP(gpa0-1, INPUT, DOWN);
+		PIN_SLP(gpa0-2, INPUT, DOWN);
+		PIN_SLP(gpa0-3, INPUT, DOWN);
+		PIN_SLP(gpa0-4, INPUT, DOWN);
+		PIN_SLP(gpa0-5, INPUT, DOWN);
+		PIN_SLP(gpa0-6, INPUT, DOWN);
+		PIN_SLP(gpa0-7, INPUT, DOWN);
+
+		PIN_SLP(gpa1-0, INPUT, DOWN);
+		PIN_SLP(gpa1-1, INPUT, DOWN);
+		PIN_SLP(gpa1-2, INPUT, DOWN);
+		PIN_SLP(gpa1-3, INPUT, DOWN);
+		PIN_SLP(gpa1-4, INPUT, DOWN);
+		PIN_SLP(gpa1-5, INPUT, DOWN);
+
+		PIN_SLP(gpb-0, PREV, NONE);
+		PIN_SLP(gpb-1, PREV, NONE);
+		PIN_SLP(gpb-2, PREV, NONE);
+		PIN_SLP(gpb-3, PREV, NONE);
+		PIN_SLP(gpb-4, INPUT, DOWN);
+		PIN_SLP(gpb-5, INPUT, DOWN);
+		PIN_SLP(gpb-6, INPUT, DOWN);
+		PIN_SLP(gpb-7, INPUT, DOWN);
+
+		PIN_SLP(gpc0-0, INPUT, DOWN);
+		PIN_SLP(gpc0-1, INPUT, DOWN);
+		PIN_SLP(gpc0-2, INPUT, DOWN);
+		PIN_SLP(gpc0-3, INPUT, DOWN);
+		PIN_SLP(gpc0-4, INPUT, DOWN);
+
+		PIN_SLP(gpc1-0, INPUT, DOWN);
+		PIN_SLP(gpc1-1, INPUT, DOWN);
+		PIN_SLP(gpc1-2, INPUT, DOWN);
+		PIN_SLP(gpc1-3, INPUT, DOWN);
+		PIN_SLP(gpc1-4, INPUT, DOWN);
+
+		PIN_SLP(gpd0-0, INPUT, DOWN);
+		PIN_SLP(gpd0-1, INPUT, DOWN);
+		PIN_SLP(gpd0-2, INPUT, NONE);
+		PIN_SLP(gpd0-3, INPUT, NONE);
+
+		PIN_SLP(gpd1-0, INPUT, NONE);
+		PIN_SLP(gpd1-1, INPUT, NONE);
+		PIN_SLP(gpd1-2, INPUT, NONE);
+		PIN_SLP(gpd1-3, INPUT, NONE);
+	};
+};
+
+&pinctrl_1 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&sleep1>;
+
+	sleep1: sleep-state {
+		PIN_SLP(gpe0-0, PREV, NONE);
+		PIN_SLP(gpe0-1, PREV, NONE);
+		PIN_SLP(gpe0-2, INPUT, DOWN);
+		PIN_SLP(gpe0-3, INPUT, DOWN);
+		PIN_SLP(gpe0-4, PREV, NONE);
+		PIN_SLP(gpe0-5, INPUT, DOWN);
+		PIN_SLP(gpe0-6, INPUT, DOWN);
+		PIN_SLP(gpe0-7, INPUT, DOWN);
+
+		PIN_SLP(gpe1-0, INPUT, DOWN);
+		PIN_SLP(gpe1-1, PREV, NONE);
+		PIN_SLP(gpe1-2, INPUT, DOWN);
+		PIN_SLP(gpe1-3, INPUT, DOWN);
+		PIN_SLP(gpe1-4, INPUT, DOWN);
+		PIN_SLP(gpe1-5, INPUT, DOWN);
+		PIN_SLP(gpe1-6, INPUT, DOWN);
+		PIN_SLP(gpe1-7, INPUT, NONE);
+
+		PIN_SLP(gpe2-0, INPUT, NONE);
+		PIN_SLP(gpe2-1, INPUT, NONE);
+		PIN_SLP(gpe2-2, INPUT, NONE);
+
+		PIN_SLP(gpk0-0, INPUT, DOWN);
+		PIN_SLP(gpk0-1, INPUT, DOWN);
+		PIN_SLP(gpk0-2, OUT0, NONE);
+		PIN_SLP(gpk0-3, INPUT, DOWN);
+		PIN_SLP(gpk0-4, INPUT, DOWN);
+		PIN_SLP(gpk0-5, INPUT, DOWN);
+		PIN_SLP(gpk0-6, INPUT, DOWN);
+		PIN_SLP(gpk0-7, INPUT, DOWN);
+
+		PIN_SLP(gpk1-0, PREV, NONE);
+		PIN_SLP(gpk1-1, PREV, NONE);
+		PIN_SLP(gpk1-2, INPUT, DOWN);
+		PIN_SLP(gpk1-3, PREV, NONE);
+		PIN_SLP(gpk1-4, PREV, NONE);
+		PIN_SLP(gpk1-5, PREV, NONE);
+		PIN_SLP(gpk1-6, PREV, NONE);
+
+		PIN_SLP(gpk2-0, INPUT, DOWN);
+		PIN_SLP(gpk2-1, INPUT, DOWN);
+		PIN_SLP(gpk2-2, INPUT, DOWN);
+		PIN_SLP(gpk2-3, INPUT, DOWN);
+		PIN_SLP(gpk2-4, INPUT, DOWN);
+		PIN_SLP(gpk2-5, INPUT, DOWN);
+		PIN_SLP(gpk2-6, INPUT, DOWN);
+
+		PIN_SLP(gpl0-0, INPUT, DOWN);
+		PIN_SLP(gpl0-1, INPUT, DOWN);
+		PIN_SLP(gpl0-2, INPUT, DOWN);
+		PIN_SLP(gpl0-3, INPUT, DOWN);
+
+		PIN_SLP(gpm0-0, INPUT, DOWN);
+		PIN_SLP(gpm0-1, INPUT, DOWN);
+		PIN_SLP(gpm0-2, INPUT, DOWN);
+		PIN_SLP(gpm0-3, INPUT, DOWN);
+		PIN_SLP(gpm0-4, INPUT, DOWN);
+		PIN_SLP(gpm0-5, INPUT, DOWN);
+		PIN_SLP(gpm0-6, INPUT, DOWN);
+		PIN_SLP(gpm0-7, INPUT, DOWN);
+
+		PIN_SLP(gpm1-0, INPUT, DOWN);
+		PIN_SLP(gpm1-1, INPUT, DOWN);
+		PIN_SLP(gpm1-2, INPUT, DOWN);
+		PIN_SLP(gpm1-3, INPUT, DOWN);
+		PIN_SLP(gpm1-4, INPUT, DOWN);
+		PIN_SLP(gpm1-5, INPUT, DOWN);
+		PIN_SLP(gpm1-6, INPUT, DOWN);
+
+		PIN_SLP(gpm2-0, INPUT, DOWN);
+		PIN_SLP(gpm2-1, INPUT, DOWN);
+		PIN_SLP(gpm2-2, INPUT, DOWN);
+		PIN_SLP(gpm2-3, INPUT, DOWN);
+		PIN_SLP(gpm2-4, INPUT, DOWN);
+
+		PIN_SLP(gpm3-0, INPUT, DOWN);
+		PIN_SLP(gpm3-1, INPUT, DOWN);
+		PIN_SLP(gpm3-2, INPUT, DOWN);
+		PIN_SLP(gpm3-3, INPUT, DOWN);
+		PIN_SLP(gpm3-4, INPUT, DOWN);
+		PIN_SLP(gpm3-5, INPUT, DOWN);
+		PIN_SLP(gpm3-6, INPUT, DOWN);
+		PIN_SLP(gpm3-7, INPUT, DOWN);
+
+		PIN_SLP(gpm4-0, INPUT, DOWN);
+		PIN_SLP(gpm4-1, INPUT, DOWN);
+		PIN_SLP(gpm4-2, INPUT, DOWN);
+		PIN_SLP(gpm4-3, INPUT, DOWN);
+		PIN_SLP(gpm4-4, INPUT, DOWN);
+		PIN_SLP(gpm4-5, INPUT, DOWN);
+		PIN_SLP(gpm4-6, INPUT, DOWN);
+		PIN_SLP(gpm4-7, INPUT, DOWN);
+	};
+};
-- 
1.8.5.5

