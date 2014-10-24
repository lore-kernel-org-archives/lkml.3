Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756469AbaJXLkl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 07:40:41 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:18059 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756332AbaJXLkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 07:40:03 -0400
X-AuditID: cbfee691-f79b86d000004a5a-ee-544a3a9159a5
From: Chanwoo Choi <cw00.choi@samsung.com>
To: kgene.kim@samsung.com
Cc: mark.rutland@arm.com, arnd@arndb.de, olof@lixom.net, tomasz.figa@gmail.com,
        geunsik.lim@samsung.com, inki.dae@samsung.com, sw0312.kim@samsung.com,
        kyungmin.park@samsung.com, cw00.choi@samsung.com,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Jaehoon Chung <jh80.chung@samsung.com>
Subject: [PATCHv3 1/3] ARM: dts: Add board dts file for Exynos3250-based Rinato
 board
Date: Fri, 24 Oct 2014 20:39:53 +0900
Message-id: <1414150795-31105-2-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1414150795-31105-1-git-send-email-cw00.choi@samsung.com>
References: <1414150795-31105-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphkeLIzCtJLcpLzFFi42JZI2JSoDvJyivE4Fugxd9Jx9gtrn95zmrx
	Z0Irm8Wk+xNYLG78amO16F1wlc3ibNMbdotNj6+xWlzeNYfNYsb5fUwWS69fZLI4df0zkDv5
	JZvFql1/GB34PNbMW8Po8fvXJEaPnbPusntsXlLvceVEE6tH35ZVjB6fN8kFsEdx2aSk5mSW
	pRbp2yVwZXz4OYW5YHVCxZJXV9gaGKd5dzFycEgImEh86AzoYuQEMsUkLtxbzwZiCwksZZT4
	/CUeIm4isfxpMztEfDqjxIL3Hl2MXEB2E5PE1VP9jCAJNgEtif0vboA1iwhISjQ1/GEGKWIW
	uMckMeFiN1iRsEC4xMnZq8AmsQioSmzeuYcVxOYVcJXo3vSdCWKbgsSy5TNZQY7jFHCTaO/n
	hFjsKvH52FpGkJkSArfYJXb9XsoIMUdA4tvkQywQz8hKbDrADDFGUuLgihssExiFFzAyrGIU
	TS1ILihOSi8y1StOzC0uzUvXS87P3cQIjJzT/55N3MF4/4D1IUYBDkYlHt4bMzxDhFgTy4or
	cw8xmgJtmMgsJZqcD4zPvJJ4Q2MzIwtTE1NjI3NLMyVxXh3pn8FCAumJJanZqakFqUXxRaU5
	qcWHGJk4OKUaGCXu6op/8Li6pSJUcON0XYfP/3meSP/ytbj3vjWgrnq5zL+qmJBvE1+lzVr1
	/JpNrITw0clu+mvL5qsIzw+uTdu7p/Jc/cqA9DSFqcvFUznyT8nkX683tQ1uUtQ47rBYuICz
	fFXJx4MHb8R+mrOxfLEGN9sMr03naxTn+fQ/fxxvVH/EcqP/FyWW4oxEQy3mouJEAI4ZvEaX	AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIIsWRmVeSWpSXmKPExsVy+t9jQd2JVl4hBi//G1r8nXSM3eL6l+es
	Fn8mtLJZTLo/gcXixq82VoveBVfZLM42vWG32PT4GqvF5V1z2CxmnN/HZLH0+kUmi1PXPwO5
	k1+yWaza9YfRgc9jzbw1jB6/f01i9Ng56y67x+Yl9R5XTjSxevRtWcXo8XmTXAB7VAOjTUZq
	YkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QzUoKZYk5pUCh
	gMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwhrGjA8/pzAXrE6oWPLqClsD4zTvLkZODgkB
	E4nlT5vZIWwxiQv31rOB2EIC0xklFrz36GLkArKbmCSunupnBEmwCWhJ7H9xA6xIREBSoqnh
	DzNIEbPAPSaJCRe7wYqEBcIlTs5eBTaVRUBVYvPOPawgNq+Aq0T3pu9MENsUJJYtnwkU5+Dg
	FHCTaO/nhFjsKvH52FrGCYy8CxgZVjGKphYkFxQnpeca6hUn5haX5qXrJefnbmIER+czqR2M
	KxssDjEKcDAq8fDemOEZIsSaWFZcmXuIUYKDWUmE18vEK0SINyWxsiq1KD++qDQntfgQoynQ
	UROZpUST84GJI68k3tDYxMzI0sjc0MLI2FxJnPdAq3WgkEB6YklqdmpqQWoRTB8TB6dUA+P+
	g581ruTsNp9gsPdKWDnrtJc+X85euLXgTH9z+NRu83Uz9fvdL26LUZrF81w8cdqRcwuv3A5O
	DSiO8PVuFN51OmuNRlSiWmeks7iLwQnzXbOCcgTOrUlutZq2oqH1WttTB5HIjHsB9/O+VYVu
	W3FgQ/ym29wr/k3etMLv4NoJ3LIc16JjdRKVWIozEg21mIuKEwE+SiPg5AIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add support for device tree sources for Samsung Rinato baord
(Gear 2) based on Exynos3250 SoC.

This dts file support following features:
- eMMC
- Main PMIC (Samsung S2MPS14)
- Interface PMIC (Maxim MAX77836, MUIC, fuel-gauge, charger)
- RTC of Exynos3250
- ADC of Exynos3250 with NTC thermistor
- I2S of Exynos3250
- TMU of Exynos3250
- MFC of Exynos3250
- Secure firmware for Exynos3250 secondary cpu boot
- Serial ports of Exynos3250
- gpio-key for power key

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Inki Dae <inki.dae@samsung.com>
Signed-off-by: Seung-Woo Kim <sw0312.kim@samsung.com>
Signed-off-by: Jaehoon Chung <jh80.chung@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/boot/dts/Makefile              |   3 +-
 arch/arm/boot/dts/exynos3250-rinato.dts | 433 ++++++++++++++++++++++++++++++++
 2 files changed, 435 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm/boot/dts/exynos3250-rinato.dts

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index 4a75e29..91cd4d0 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -67,7 +67,8 @@ dtb-$(CONFIG_ARCH_BRCMSTB) += \
 dtb-$(CONFIG_ARCH_DAVINCI) += da850-enbw-cmc.dtb \
 	da850-evm.dtb
 dtb-$(CONFIG_ARCH_EFM32) += efm32gg-dk3750.dtb
-dtb-$(CONFIG_ARCH_EXYNOS) += exynos4210-origen.dtb \
+dtb-$(CONFIG_ARCH_EXYNOS) += exynos3250-rinato.dtb \
+	exynos4210-origen.dtb \
 	exynos4210-smdkv310.dtb \
 	exynos4210-trats.dtb \
 	exynos4210-universal_c210.dtb \
diff --git a/arch/arm/boot/dts/exynos3250-rinato.dts b/arch/arm/boot/dts/exynos3250-rinato.dts
new file mode 100644
index 0000000..be0ba8d
--- /dev/null
+++ b/arch/arm/boot/dts/exynos3250-rinato.dts
@@ -0,0 +1,433 @@
+/*
+ * Samsung's Exynos3250 based Rinato board device tree source
+ *
+ * Copyright (c) 2014 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ *
+ * Device tree source file for Samsung's Rinato board which is based on
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
+	model = "Samsung Rinato board";
+	compatible = "samsung,rinato", "samsung,exynos3250", "samsung,exynos3";
+
+	aliases {
+		i2c7 = &i2c_max77836;
+	};
+
+	memory {
+		reg =  <0x40000000 0x1ff00000>;
+	};
+
+	chosen {
+		bootargs = "console=ttySAC1,115200N8 root=/dev/mmcblk0p15 rootwait earlyprintk panic=5";
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
+	        compatible = "regulator-fixed";
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
+				regulator-name = "VAP_VMIPI_1.0V";
+				regulator-min-microvolt = <1000000>;
+				regulator-max-microvolt = <1000000>;
+				regulator-always-on;
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
+				regulator-name = "CAM_AVDD_2.8V";
+				regulator-min-microvolt = <2800000>;
+				regulator-max-microvolt = <2800000>;
+			};
+
+			ldo14_reg: LDO14 {
+				regulator-name = "UNUSED_LDO14";
+				regulator-min-microvolt = <2700000>;
+				regulator-max-microvolt = <2700000>;
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
+				regulator-name = "V_IRLED_3.3V";
+				regulator-min-microvolt = <3300000>;
+				regulator-max-microvolt = <3300000>;
+			};
+
+			ldo18_reg: LDO18 {
+				regulator-name = "CAM_AF_2.8V";
+				regulator-min-microvolt = <2800000>;
+				regulator-max-microvolt = <2800000>;
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
+				regulator-name = "CAM_IO_1.8V";
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <1800000>;
+			};
+
+			ldo22_reg: LDO22 {
+				regulator-name = "CAM_DVDD_1.2V";
+				regulator-min-microvolt = <1200000>;
+				regulator-max-microvolt = <1200000>;
+			};
+
+			ldo23_reg: LDO23 {
+				regulator-name = "HRM_VCC_1.8V";
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <1800000>;
+				regulator-always-on;
+			};
+
+			ldo24_reg: LDO24 {
+				regulator-name = "HRM_VCC_3.3V";
+				regulator-min-microvolt = <3000000>;
+				regulator-max-microvolt = <3000000>;
+			};
+
+			ldo25_reg: LDO25 {
+				regulator-name = "UNUSED_LDO25";
+				regulator-min-microvolt = <3000000>;
+				regulator-max-microvolt = <3000000>;
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
+&mfc {
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
-- 
1.8.5.5

