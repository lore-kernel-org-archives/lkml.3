Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635AbaJXNNm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 09:13:42 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:10676 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756279AbaJXNMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 09:12:49 -0400
X-AuditID: cbfee68e-f79b46d000002b74-51-544a504fa09a
From: Chanwoo Choi <cw00.choi@samsung.com>
To: kgene.kim@samsung.com
Cc: mark.rutland@arm.com, arnd@arndb.de, olof@lixom.net, tomasz.figa@gmail.com,
        geunsik.lim@samsung.com, inki.dae@samsung.com, sw0312.kim@samsung.com,
        kyungmin.park@samsung.com, cw00.choi@samsung.com,
        k.kozlowski@samsung.com, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Jaehoon Chung <jh80.chung@samsung.com>
Subject: [PATCHv4 1/3] ARM: dts: Add board dts file for Exynos3250-based Rinato
 board
Date: Fri, 24 Oct 2014 22:12:40 +0900
Message-id: <1414156362-5752-2-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1414156362-5752-1-git-send-email-cw00.choi@samsung.com>
References: <1414156362-5752-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupikeLIzCtJLcpLzFFi42JZI2JSousf4BVi0LJKzeLvpGPsFte/PGe1
	+DOhlc1i0v0JLBY3frWxWrx+YWjRu+Aqm8XZpjfsFpseX2O1uLxrDpvFjPP7mCyWXr/IZHHq
	+mcgd/JLNotVu/4wOvB7rJm3htHj969JjB47Z91l99i8pN7jyokmVo++LasYPT5vkgtgj+Ky
	SUnNySxLLdK3S+DKOPP2GWPB8riKud/bWBsYj3t2MXJySAiYSLxdMIcRwhaTuHBvPRuILSSw
	lFHi2oLELkYOsJrp56u7GLmAwosYJZq3L2eCcJqYJH5+mgzWwCagJbH/xQ0wW0RAUqKp4Q8z
	SBGzwHcmia0r7zODJIQFwiV6j/9hB7FZBFQlbv69wQiygVfABciOhzhCQWLZ8pmsIDangKvE
	8ncboQ5ykdj+dR/YYgmBR+wSm5YuYYKYIyDxbfIhFohLZSU2HWCGmCMpcXDFDZYJjMILGBlW
	MYqmFiQXFCelFxnpFSfmFpfmpesl5+duYgRG0el/z/p2MN48YH2IUYCDUYmH98YMzxAh1sSy
	4srcQ4ymQBsmMkuJJucDYzWvJN7Q2MzIwtTE1NjI3NJMSZw3QepnsJBAemJJanZqakFqUXxR
	aU5q8SFGJg5OqQbG+EUFSZdT7OcvCrlz27qPO5L3eLJQtdoH089xwa8eri9u4deRXXb9mKNm
	aP0Dg0wThwjP+U1Z8Z/WqfBf+JJ/Z+ZXtajrE44+VRRO7pvkr9Hev2yupvtb+bj/ORcmdxvG
	ZvwybFvzx8FdaMv3tZf3Zc3Y9MP5jEqbt+6uaR/+r332SsThXO9xJZbijERDLeai4kQAJYtm
	/50CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKIsWRmVeSWpSXmKPExsVy+t9jAV3/AK8Qg3/NUhZ/Jx1jt7j+5Tmr
	xZ8JrWwWk+5PYLG48auN1eL1C0OL3gVX2SzONr1ht9j0+BqrxeVdc9gsZpzfx2Sx9PpFJotT
	1z8DuZNfslms2vWH0YHfY828NYwev39NYvTYOesuu8fmJfUeV040sXr0bVnF6PF5k1wAe1QD
	o01GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0N1KCmWJ
	OaVAoYDE4mIlfTtME0JD3HQtYBojdH1DguB6jAzQQMIaxowzb58xFiyPq5j7vY21gfG4Zxcj
	B4eEgInE9PPVXYycQKaYxIV769m6GLk4hAQWMUo0b1/OBOE0MUn8/DSZDaSKTUBLYv+LG2C2
	iICkRFPDH2aQImaB70wSW1feZwZJCAuES/Qe/8MOYrMIqErc/HuDEWQbr4ALkB0PsU1BYtny
	mawgNqeAq8TydxvBZgoBlWz/uo9pAiPvAkaGVYyiqQXJBcVJ6blGesWJucWleel6yfm5mxjB
	UfpMegfjqgaLQ4wCHIxKPLw3ZniGCLEmlhVX5h5ilOBgVhLh9ff3ChHiTUmsrEotyo8vKs1J
	LT7EaAp01ERmKdHkfGACySuJNzQ2MTOyNDI3tDAyNlcS5z3Yah0oJJCeWJKanZpakFoE08fE
	wSnVwLiA6ckHKYvp99oP7Ym7fYVN5saMQ8V2p89Iph67qqZo0a6wWyb7RdujhcvunLR3ai47
	z3tptvOjCXGXDn/evpitodDERb1lHWPqbJfFa55OuL5232KPzpAH0o9Xn5y87eK/ho/ubCcW
	mfnGM0gYvnlhE73XZ41mg27Qb+eLnY2z4x7GW9+awN2ixFKckWioxVxUnAgAAfPgLugCAAA=
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
 arch/arm/boot/dts/exynos3250-rinato.dts | 424 ++++++++++++++++++++++++++++++++
 2 files changed, 426 insertions(+), 1 deletion(-)
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
index 0000000..8a18e68
--- /dev/null
+++ b/arch/arm/boot/dts/exynos3250-rinato.dts
@@ -0,0 +1,424 @@
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
+	vmmc-supply = <&ldo12_reg>;
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

