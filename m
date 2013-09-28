Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755070Ab3I1Q0Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 12:26:25 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:31693 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754536Ab3I1Q0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 12:26:03 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-82-5247031953d2
From: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
To: kgene.kim@samsung.com
Cc: linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        rob.herring@calxeda.com, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ijc+devicetree@hellion.org.uk,
        devicetree@vger.kernel.org, m.szyprowski@samsung.com,
        t.figa@samsung.com, b.zolnierkie@samsung.com, k.debski@samsung.com,
        s.nawrocki@samsung.com,
        Mateusz Krawczuk <m.krawczuk@partner.samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 3/3] ARM: Samsung: DT: Add Device tree for S5PC110/S5PV210
 Boards
Date: Sat, 28 Sep 2013 18:25:30 +0200
Message-id: <1380385530-28522-4-git-send-email-m.krawczuk@partner.samsung.com>
X-Mailer: git-send-email 1.8.1.2
In-reply-to: <1380385530-28522-1-git-send-email-m.krawczuk@partner.samsung.com>
References: <1380385530-28522-1-git-send-email-m.krawczuk@partner.samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHLMWRmVeSWpSXmKPExsVy+t9jQV1JZvcgg7XNYhYbZ6xntZh/5Byr
	xblXKxktfry+wGbRu+Aqm8XZpjfsFpseX2O1uLxrDpvFjPP7mCxuX+a1OL3mFLPF2iN32S2W
	Xr/IZDFh+loWi8MrDjBZHH7Tzmrx6mAbi8X6Ga9ZHIQ81sxbw+jR0tzD5rHg8xV2j5XLv7B5
	bF5S73Hw3R4mj74tqxg9Pm+S89g4NzSAM4rLJiU1J7MstUjfLoEr4+Mf14Knp5gqfs7+zdzA
	+OcPYxcjJ4eEgInE73dvWCFsMYkL99azdTFycQgJTGeU6Pw8gRXCaWeSeP/oDjtIFZuAucTE
	Z5tYQGwRAUmJpoY/zCBFzAI/mCWmPZsCNkpYIFhiwtanYA0sAqoSjatOsIHYvAJ+Ekf2PWaC
	WKcg8fMyRJxTwF/i64I5YHEhoJpD9/vYJzDyLmBkWMUomlqQXFCclJ5rpFecmFtcmpeul5yf
	u4kRHOrPpHcwrmqwOMQowMGoxMN7YIZrkBBrYllxZe4hRgkOZiURXv8ZbkFCvCmJlVWpRfnx
	RaU5qcWHGKU5WJTEeQ+2WgcKCaQnlqRmp6YWpBbBZJk4OKUaGFMnfXeseXnsXGd4S+ibdCuJ
	Rd3sCUFt2p5/TcTj4zdacvxc8jhIa0PU7gMuDw/9DcrMUuXKFS5w2ZotbJYWGr/++dFfN1yM
	3G2eXDaPXHLe/8zDVafmXZnNwD67g098RZbdaoUD5w/ECE73Of51/Zuz6xPsNszODJm9x/HS
	F9ZuRsFt8r/4ZiixFGckGmoxFxUnAgDXQ9x+cQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add DTS for s5pc110 boards: goni, aquila, smdkc110
s5pv210: smdkv210, tiny210, torbreck

Signed-off-by: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/boot/dts/Makefile             |   6 +
 arch/arm/boot/dts/s5pv210-aquila.dts   | 407 +++++++++++++++++++++++++++
 arch/arm/boot/dts/s5pv210-goni.dts     | 486 +++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/s5pv210-smdkc110.dts | 165 +++++++++++
 arch/arm/boot/dts/s5pv210-smdkv210.dts | 273 ++++++++++++++++++
 arch/arm/boot/dts/s5pv210-tiny210.dts  | 262 ++++++++++++++++++
 arch/arm/boot/dts/s5pv210-torbreck.dts | 157 +++++++++++
 7 files changed, 1756 insertions(+)
 create mode 100644 arch/arm/boot/dts/s5pv210-aquila.dts
 create mode 100644 arch/arm/boot/dts/s5pv210-goni.dts
 create mode 100644 arch/arm/boot/dts/s5pv210-smdkc110.dts
 create mode 100644 arch/arm/boot/dts/s5pv210-smdkv210.dts
 create mode 100644 arch/arm/boot/dts/s5pv210-tiny210.dts
 create mode 100644 arch/arm/boot/dts/s5pv210-torbreck.dts

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index cf75889..759205b 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -199,6 +199,12 @@ dtb-$(CONFIG_ARCH_U8500) += ste-snowball.dtb \
 dtb-$(CONFIG_ARCH_S3C24XX) += s3c2416-smdk2416.dtb
 dtb-$(CONFIG_ARCH_S3C64XX) += s3c6410-mini6410.dtb \
 	s3c6410-smdk6410.dtb
+dtb-$(CONFIG_ARCH_S5PV210) += s5pv210-aquila.dtb \
+	s5pv210-tiny210.dtb \
+	s5pv210-goni.dtb \
+	s5pv210-smdkc110.dtb \
+	s5pv210-smdkv210.dtb \
+	s5pv210-torbreck.dtb
 dtb-$(CONFIG_ARCH_SHMOBILE) += emev2-kzm9d.dtb \
 	emev2-kzm9d-reference.dtb \
 	r8a7740-armadillo800eva.dtb \
diff --git a/arch/arm/boot/dts/s5pv210-aquila.dts b/arch/arm/boot/dts/s5pv210-aquila.dts
new file mode 100644
index 0000000..f12d407
--- /dev/null
+++ b/arch/arm/boot/dts/s5pv210-aquila.dts
@@ -0,0 +1,407 @@
+/*
+ * Samsung's S5PV210 SoC device tree source
+ *
+ * Copyright (c) 2013 Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
+ *
+ * Samsung's S5PV210 SoC device nodes are listed in this file. S5PV210
+ * based board files can include this file and provide values for board specfic
+ * bindings.
+ *
+ * Note: This file does not include device nodes for all the controllers in
+ * S5PV210 SoC. As device tree coverage for S5PV210 increases, additional
+ * nodes can be added to this file.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+/dts-v1/;
+#include <dt-bindings/input/input.h>
+#include "s5pv210.dtsi"
+
+/ {
+	model = "S5PC110 Aquila";
+	compatible = "samsung,aquila", "samsung,s5pv210";
+
+	chosen {
+		bootargs = "console=ttySAC2,115200n8 root=/dev/mmcblk1p5 rw rootwait ignore_loglevel earlyprintk";
+	};
+
+	memory {
+		device_type = "memory";
+		reg = <0x30000000 0x05000000
+			0x40000000 0x18000000>;
+	};
+
+	xusbxti: oscillator {
+		compatible = "fixed-clock";
+		clock-frequency = <24000000>;
+		clock-output-names = "xusbxti";
+		#clock-cells = <0>;
+	};
+
+	regulators {
+		compatible = "simple-bus";
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		vtf_reg: fixed-regulator@0 {
+			compatible = "regulator-fixed";
+			reg = <0>;
+			regulator-name = "V_TF_2.8V";
+			regulator-min-microvolt = <2800000>;
+			regulator-max-microvolt = <2800000>;
+			gpios = <&mp05 4 0>;
+			enable-active-high;
+		};
+
+		pda_reg: fixed-regulator@1 {
+			compatible = "regulator-fixed";
+			regulator-name = "VCC_1.8V_PDA";
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <1800000>;
+			reg = <1>;
+		};
+
+		bat_reg: fixed-regulator@2 {
+			compatible = "regulator-fixed";
+			regulator-name = "V_BAT";
+			regulator-min-microvolt = <3700000>;
+			regulator-max-microvolt = <3700000>;
+			reg = <2>;
+		};
+	};
+
+	i2c-pmic {
+		compatible = "i2c-gpio";
+		gpios = <&gpj4 0 0>, /* sda */
+			<&gpj4 3 0>; /* scl */
+		i2c-gpio,delay-us = <2>;        /* ~100 kHz */
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		pmic@66 {
+			compatible = "national,lp3974";
+			reg = <0x66>;
+
+			max8998,pmic-buck1-default-dvs-idx = <0>;
+			max8998,pmic-buck1-dvs-gpios = <&gph0 3 0>,
+							<&gph0 4 0>;
+			max8998,pmic-buck1-dvs-voltage = <1200000>, <1200000>,
+							<1200000>, <1200000>;
+
+			max8998,pmic-buck2-default-dvs-idx = <0>;
+			max8998,pmic-buck2-dvs-gpio = <&gph0 5 0>;
+			max8998,pmic-buck2-dvs-voltage = <1200000>, <1200000>;
+
+			regulators {
+				ldo2_reg: LDO2 {
+					regulator-name = "VALIVE_1.1V";
+					regulator-min-microvolt = <1100000>;
+					regulator-max-microvolt = <1100000>;
+					regulator-always-on;
+				};
+
+				ldo3_reg: LDO3 {
+					regulator-name = "VUSB+MIPI_1.1V";
+					regulator-min-microvolt = <1100000>;
+					regulator-max-microvolt = <1100000>;
+					regulator-always-on;
+				};
+
+				ldo4_reg: LDO4 {
+					regulator-name = "VADC_3.3V";
+					regulator-min-microvolt = <3300000>;
+					regulator-max-microvolt = <3300000>;
+				};
+
+				ldo5_reg: LDO5 {
+					regulator-name = "VTF_2.8V";
+					regulator-min-microvolt = <2800000>;
+					regulator-max-microvolt = <2800000>;
+					regulator-always-on;
+				};
+
+				ldo6_reg: LDO6 {
+					regulator-name = "VCC_3.3V";
+					regulator-min-microvolt = <3300000>;
+					regulator-max-microvolt = <3300000>;
+					regulator-always-on;
+				};
+
+				ldo7_reg: LDO7 {
+					regulator-name = "VCC_3.0V";
+					regulator-min-microvolt = <3000000>;
+					regulator-max-microvolt = <3000000>;
+					regulator-always-on;
+					regulator-boot-on;
+				};
+
+				ldo8_reg: LDO8 {
+					regulator-name = "VUSB+VDAC_3.3V";
+					regulator-min-microvolt = <3300000>;
+					regulator-max-microvolt = <3300000>;
+					regulator-always-on;
+				};
+
+				ldo9_reg: LDO9 {
+					regulator-name = "VCC+VCAM_2.8V";
+					regulator-min-microvolt = <2800000>;
+					regulator-max-microvolt = <2800000>;
+					regulator-always-on;
+				};
+
+				ldo10_reg: LDO10 {
+					regulator-name = "VPLL_1.1V";
+					regulator-min-microvolt = <1100000>;
+					regulator-max-microvolt = <1100000>;
+					regulator-always-on;
+					regulator-boot-on;
+				};
+
+				ldo11_reg: LDO11 {
+					regulator-name = "CAM_IO_2.8V";
+					regulator-min-microvolt = <2800000>;
+					regulator-max-microvolt = <2800000>;
+					regulator-always-on;
+				};
+
+				ldo12_reg: LDO12 {
+					regulator-name = "CAM_ISP_1.2V";
+					regulator-min-microvolt = <1200000>;
+					regulator-max-microvolt = <1200000>;
+					regulator-always-on;
+				};
+
+				ldo13_reg: LDO13 {
+					regulator-name = "CAM_A_2.8V";
+					regulator-min-microvolt = <2800000>;
+					regulator-max-microvolt = <2800000>;
+					regulator-always-on;
+				};
+
+				ldo14_reg: LDO14 {
+					regulator-name = "CAM_CIF_1.8V";
+					regulator-min-microvolt = <1800000>;
+					regulator-max-microvolt = <1800000>;
+					regulator-always-on;
+				};
+
+				ldo15_reg: LDO15 {
+					regulator-name = "CAM_AF_3.3V";
+					regulator-min-microvolt = <3300000>;
+					regulator-max-microvolt = <3300000>;
+					regulator-always-on;
+				};
+
+				ldo16_reg: LDO16 {
+					regulator-name = "VMIPI_1.8V";
+					regulator-min-microvolt = <1800000>;
+					regulator-max-microvolt = <1800000>;
+					regulator-always-on;
+				};
+
+				ldo17_reg: LDO17 {
+					regulator-name = "CAM_8M_1.8V";
+					regulator-min-microvolt = <1800000>;
+					regulator-max-microvolt = <1800000>;
+					regulator-always-on;
+				};
+
+				buck1_reg: BUCK1 {
+					regulator-name = "VARM_1.2V";
+					regulator-min-microvolt = <1200000>;
+					regulator-max-microvolt = <1200000>;
+					regulator-always-on;
+				};
+
+				buck2_reg: BUCK2 {
+					regulator-name = "VINT_1.2V";
+					regulator-min-microvolt = <1200000>;
+					regulator-max-microvolt = <1200000>;
+					regulator-always-on;
+				};
+
+				buck3_reg: BUCK3 {
+					regulator-name = "VCC_1.8V";
+					regulator-min-microvolt = <1800000>;
+					regulator-max-microvolt = <1800000>;
+					regulator-always-on;
+				};
+
+				buck4_reg: BUCK4 {
+					regulator-name = "CAM_CORE_1.2V";
+					regulator-min-microvolt = <1200000>;
+					regulator-max-microvolt = <1200000>;
+					regulator-always-on;
+				};
+
+				vichg_reg: ENVICHG {
+					regulator-name = "VICHG";
+				};
+
+				safeout1_reg: ESAFEOUT1 {
+					regulator-name = "SAFEOUT1";
+					regulator-always-on;
+				};
+
+				safeout2_reg: ESAFEOUT2 {
+					regulator-name = "SAFEOUT2";
+					regulator-boot-on;
+				};
+			};
+		};
+
+	};
+
+	i2c-ac {
+		compatible = "i2c-gpio";
+		gpios = <&mp05 3 0>, /* sda */
+			<&mp05 2 0>; /* scl */
+		i2c-gpio,delay-us = <2>;        /* ~100 kHz */
+		#address-cells = <1>;
+		#size-cells = <0>;
+	};
+
+	gpio-keys {
+		compatible = "gpio-keys";
+
+		power-key {
+			gpios = <&gph2 6 1>;
+			linux,code = <KEY_POWER>;
+			label = "power";
+			debounce-interval = <1>;
+			gpio-key,wakeup;
+		};
+	};
+
+	keypad: keypad@e1600000 {
+		compatible = "samsung,s5pv210-keypad";
+		reg = <0xe1600000 0x100>;
+		interrupt-parent = <&vic2>;
+		interrupts = <25>;
+		clocks = <&clocks KEYIF>;
+		clock-names = "keypad";
+		status = "okay";
+		linux,input-no-autorepeat;
+		linux,input-wakeup;
+		samsung,keypad-num-rows = <3>;
+		samsung,keypad-num-columns = <3>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&keypad_row0>, <&keypad_row1>, <&keypad_row2>,
+				<&keypad_col0>, <&keypad_col1>, <&keypad_col2>;
+
+		key_1 {
+			keypad,row = <0>;
+			keypad,column = <1>;
+			linux,code = <KEY_CONNECT>;
+		};
+
+		key_2 {
+			keypad,row = <0>;
+			keypad,column = <2>;
+			linux,code = <KEY_BACK>;
+		};
+
+		key_3 {
+			keypad,row = <1>;
+			keypad,column = <1>;
+			linux,code = <KEY_CAMERA_FOCUS>;
+		};
+
+		key_4 {
+			keypad,row = <1>;
+			keypad,column = <2>;
+			linux,code = <KEY_VOLUMEUP>;
+		};
+
+		key_5 {
+			keypad,row = <2>;
+			keypad,column = <1>;
+			linux,code = <KEY_CAMERA>;
+		};
+
+		key_6 {
+			keypad,row = <2>;
+			keypad,column = <2>;
+			linux,code = <KEY_VOLUMEDOWN>;
+		};
+	};
+};
+
+
+&uart0 {
+	status = "okay";
+};
+
+&uart1 {
+	status = "okay";
+};
+
+&uart2 {
+	status = "okay";
+};
+
+&sdhci0 {
+	bus-width = <4>;
+	non-removable;
+	status = "okay";
+	vmmc-supply = <&ldo5_reg>;
+	pinctrl-0 = <&sd0_clk &sd0_cmd &sd0_bus4>;
+	pinctrl-names = "default";
+};
+
+&sdhci2 {
+	bus-width = <4>;
+	cd-gpios = <&gph3 4 1>;
+	vmmc-supply = <&vtf_reg>;
+	cd-inverted;
+	pinctrl-0 = <&sd2_clk &sd2_cmd &sd2_bus4 &t_flash_detect>;
+	pinctrl-names = "default";
+	status = "okay";
+};
+
+&onenand {
+	status = "okay";
+};
+
+&hsotg {
+	vusb_a-supply = <&ldo3_reg>;
+	vusb_d-supply = <&ldo8_reg>;
+	status = "okay";
+};
+
+&usbphy {
+	clocks = <&clocks USB_OTG>, <&xusbxti>, <&clocks SCLK_USBPHY1>;
+	clock-names = "phy", "device", "host";
+};
+
+&fimd {
+	pinctrl-0 = <&lcd_clk &lcd_data24 &pwm1_out>;
+	pinctrl-names = "default";
+	status = "okay";
+
+	display-timings {
+		native-mode = <&timing0>;
+		timing0: timing {
+			clock-frequency = <0>;
+			hactive = <800>;
+			vactive = <480>;
+			hfront-porch = <16>;
+			hback-porch = <16>;
+			hsync-len = <2>;
+			vback-porch = <3>;
+			vfront-porch = <28>;
+			vsync-len = <1>;
+		};
+	};
+};
+
+&pinctrl0 {
+	t_flash_detect: t-flash-detect {
+		samsung,pins = "gph3-4";
+		samsung,pin-function = <0>;
+		samsung,pin-pud = <0>;
+	};
+};
\ No newline at end of file
diff --git a/arch/arm/boot/dts/s5pv210-goni.dts b/arch/arm/boot/dts/s5pv210-goni.dts
new file mode 100644
index 0000000..e7c371e
--- /dev/null
+++ b/arch/arm/boot/dts/s5pv210-goni.dts
@@ -0,0 +1,486 @@
+/*
+ * Samsung's S5PV210 SoC device tree source
+ *
+ * Copyright (c) 2013 Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
+ *
+ * Samsung's S5PV210 SoC device nodes are listed in this file. S5PV210
+ * based board files can include this file and provide values for board specfic
+ * bindings.
+ *
+ * Note: This file does not include device nodes for all the controllers in
+ * S5PV210 SoC. As device tree coverage for S5PV210 increases, additional
+ * nodes can be added to this file.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+/dts-v1/;
+#include <dt-bindings/input/input.h>
+#include "s5pv210.dtsi"
+
+/ {
+	model = "S5PC110 Goni";
+	compatible = "samsung,goni", "samsung,s5pv210";
+
+	chosen {
+		bootargs = "console=ttySAC0,115200n8 root=/dev/mmcblk0p5 rw rootwait ignore_loglevel earlyprintk";
+	};
+
+	memory {
+		device_type = "memory";
+		reg = <0x30000000 0x1c000000>;
+	};
+
+	fixed-clocks {
+		compatible = "simple-bus";
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		xxti: oscillator@0 {
+			compatible = "fixed-clock";
+			reg = <0>;
+			clock-output-names = "xxti";
+			clock-frequency = <0>;
+			#clock-cells = <0>;
+		};
+
+		xusbxti: oscillator@1 {
+			compatible = "fixed-clock";
+			reg = <1>;
+			clock-output-names = "xusbxti";
+			clock-frequency = <24000000>;
+			#clock-cells = <0>;
+		};
+	};
+
+	gpio-keys {
+		compatible = "gpio-keys";
+
+		power-key {
+			gpios = <&gph2 6 1>;
+			linux,code = <KEY_POWER>;
+			label = "power";
+			debounce-interval = <1>;
+			gpio-key,wakeup;
+		};
+	};
+
+	keypad: keypad@e1600000 {
+		compatible = "samsung,s5pv210-keypad";
+		reg = <0xe1600000 0x100>;
+		interrupt-parent = <&vic2>;
+		interrupts = <25>;
+		clocks = <&clocks KEYIF>;
+		clock-names = "keypad";
+		status = "okay";
+		linux,input-no-autorepeat;
+		linux,input-wakeup;
+		samsung,keypad-num-rows = <3>;
+		samsung,keypad-num-columns = <3>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&keypad_row0>, <&keypad_row1>, <&keypad_row2>,
+				<&keypad_col0>, <&keypad_col1>, <&keypad_col2>;
+
+		key_1 {
+			keypad,row = <0>;
+			keypad,column = <1>;
+			linux,code = <KEY_CONNECT>;
+		};
+
+		key_2 {
+			keypad,row = <0>;
+			keypad,column = <2>;
+			linux,code = <KEY_BACK>;
+		};
+
+		key_3 {
+			keypad,row = <1>;
+			keypad,column = <1>;
+			linux,code = <KEY_CAMERA_FOCUS>;
+		};
+
+		key_4 {
+			keypad,row = <1>;
+			keypad,column = <2>;
+			linux,code = <KEY_VOLUMEUP>;
+		};
+
+		key_5 {
+			keypad,row = <2>;
+			keypad,column = <1>;
+			linux,code = <KEY_CAMERA>;
+		};
+
+		key_6 {
+			keypad,row = <2>;
+			keypad,column = <2>;
+			linux,code = <KEY_VOLUMEDOWN>;
+		};
+	};
+
+	regulators {
+		compatible = "simple-bus";
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		vtf_reg: fixed-regulator@0 {
+			compatible = "regulator-fixed";
+			regulator-name = "V_TF_2.8V";
+			regulator-min-microvolt = <2800000>;
+			regulator-max-microvolt = <2800000>;
+			reg = <0>;
+			gpios = <&mp05 4 0>;
+		};
+
+		pda_reg: fixed-regulator@1 {
+			compatible = "regulator-fixed";
+			regulator-name = "VCC_1.8V_PDA";
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <1800000>;
+			reg = <1>;
+		};
+
+		bat_reg: fixed-regulator@2 {
+			compatible = "regulator-fixed";
+			regulator-name = "V_BAT";
+			regulator-min-microvolt = <3700000>;
+			regulator-max-microvolt = <3700000>;
+			reg = <2>;
+		};
+
+		tsp_reg: fixed-regulator@3 {
+			compatible = "regulator-fixed";
+			regulator-name = "TSP_VDD";
+			regulator-min-microvolt = <2800000>;
+			regulator-max-microvolt = <2800000>;
+			reg = <3>;
+			gpios = <&gpj1 3 0>;
+			enable-active-high;
+		};
+	};
+
+	i2c@0 {
+		compatible = "i2c-gpio";
+		gpios = <&gpj4 0 0>, /* sda */
+			<&gpj4 3 0>; /* scl */
+		i2c-gpio,delay-us = <2>;        /* ~100 kHz */
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		pmic@66 {
+			compatible = "national,lp3974";
+			reg = <0x66>;
+
+			max8998,pmic-buck1-default-dvs-idx = <0>;
+			max8998,pmic-buck1-dvs-gpios = <&gph0 3 0>,
+							<&gph0 4 0>;
+			max8998,pmic-buck1-dvs-voltage = <1200000>, <1200000>,
+							<1200000>, <1200000>;
+
+			max8998,pmic-buck2-default-dvs-idx = <0>;
+			max8998,pmic-buck2-dvs-gpio = <&gph0 5 0>;
+			max8998,pmic-buck2-dvs-voltage = <1200000>, <1200000>;
+
+			regulators {
+				ldo2_reg: LDO2 {
+					regulator-name = "VALIVE_1.1V";
+					regulator-min-microvolt = <1100000>;
+					regulator-max-microvolt = <1100000>;
+					regulator-always-on;
+				};
+
+				ldo3_reg: LDO3 {
+					regulator-name = "VUSB+MIPI_1.1V";
+					regulator-min-microvolt = <1100000>;
+					regulator-max-microvolt = <1100000>;
+					regulator-always-on;
+				};
+
+				ldo4_reg: LDO4 {
+					regulator-name = "VADC_3.3V";
+					regulator-min-microvolt = <3300000>;
+					regulator-max-microvolt = <3300000>;
+				};
+
+				ldo5_reg: LDO5 {
+					regulator-name = "VTF_2.8V";
+					regulator-min-microvolt = <2800000>;
+					regulator-max-microvolt = <2800000>;
+				};
+
+				ldo6_reg: LDO6 {
+					regulator-name = "VCC_3.3V";
+					regulator-min-microvolt = <3300000>;
+					regulator-max-microvolt = <3300000>;
+				};
+
+				ldo7_reg: LDO7 {
+					regulator-name = "VLCD_1.8V";
+					regulator-min-microvolt = <1800000>;
+					regulator-max-microvolt = <1800000>;
+					regulator-always-on;
+				};
+
+				ldo8_reg: LDO8 {
+					regulator-name = "VUSB+VDAC_3.3V";
+					regulator-min-microvolt = <3300000>;
+					regulator-max-microvolt = <3300000>;
+				};
+
+				ldo9_reg: LDO9 {
+					regulator-name = "VCC+VCAM_2.8V";
+					regulator-min-microvolt = <2800000>;
+					regulator-max-microvolt = <2800000>;
+				};
+
+				ldo10_reg: LDO10 {
+					regulator-name = "VPLL_1.1V";
+					regulator-min-microvolt = <1100000>;
+					regulator-max-microvolt = <1100000>;
+					regulator-boot-on;
+				};
+
+				ldo11_reg: LDO11 {
+					regulator-name = "CAM_IO_2.8V";
+					regulator-min-microvolt = <2800000>;
+					regulator-max-microvolt = <2800000>;
+				};
+
+				ldo12_reg: LDO12 {
+					regulator-name = "CAM_ISP_1.2V";
+					regulator-min-microvolt = <1200000>;
+					regulator-max-microvolt = <1200000>;
+				};
+
+				ldo13_reg: LDO13 {
+					regulator-name = "CAM_A_2.8V";
+					regulator-min-microvolt = <2800000>;
+					regulator-max-microvolt = <2800000>;
+				};
+
+				ldo14_reg: LDO14 {
+					regulator-name = "CAM_CIF_1.8V";
+					regulator-min-microvolt = <1800000>;
+					regulator-max-microvolt = <1800000>;
+				};
+
+				ldo15_reg: LDO15 {
+					regulator-name = "CAM_AF_3.3V";
+					regulator-min-microvolt = <3300000>;
+					regulator-max-microvolt = <3300000>;
+				};
+
+				ldo16_reg: LDO16 {
+					regulator-name = "VMIPI_1.8V";
+					regulator-min-microvolt = <1800000>;
+					regulator-max-microvolt = <1800000>;
+				};
+
+				ldo17_reg: LDO17 {
+					regulator-name = "CAM_8M_1.8V";
+					regulator-min-microvolt = <1800000>;
+					regulator-max-microvolt = <1800000>;
+					regulator-always-on;
+				};
+
+				buck1_reg: BUCK1 {
+					regulator-name = "VARM_1.2V";
+					regulator-min-microvolt = <1200000>;
+					regulator-max-microvolt = <1200000>;
+				};
+
+				buck2_reg: BUCK2 {
+					regulator-name = "VINT_1.2V";
+					regulator-min-microvolt = <1200000>;
+					regulator-max-microvolt = <1200000>;
+				};
+
+				buck3_reg: BUCK3 {
+					regulator-name = "VCC_1.8V";
+					regulator-min-microvolt = <1800000>;
+					regulator-max-microvolt = <1800000>;
+					regulator-always-on;
+				};
+
+				buck4_reg: BUCK4 {
+					regulator-name = "CAM_CORE_1.2V";
+					regulator-min-microvolt = <1200000>;
+					regulator-max-microvolt = <1200000>;
+					regulator-always-on;
+				};
+			};
+		};
+	};
+};
+
+&uart0 {
+	status = "okay";
+};
+
+&uart1 {
+	status = "okay";
+};
+
+&uart2 {
+	status = "okay";
+};
+
+&sdhci0 {
+	bus-width = <8>;
+	non-removable;
+	vmmc-supply = <&ldo5_reg>;
+	status = "okay";
+};
+
+&sdhci1 {
+	bus-width = <4>;
+	pinctrl-0 = <&sd1_clk &sd1_cmd &sd1_cd &sd1_bus4>;
+	pinctrl-names = "default";
+	status = "okay";
+};
+
+&sdhci2 {
+	bus-width = <4>;
+	cd-gpios = <&gph3 4 1>;
+	vmmc-supply = <&vtf_reg>;
+	cd-inverted;
+	pinctrl-0 = <&sd2_clk &sd2_cmd &sd2_bus4>;
+	pinctrl-names = "default";
+	status = "okay";
+};
+
+&sdhci3 {
+	bus-width = <4>;
+	pinctrl-0 = <&sd3_clk &sd3_cmd &sd3_cd &sd3_bus4>;
+	status = "okay";
+};
+
+&hsotg {
+	vusb_a-supply = <&ldo3_reg>;
+	vusb_d-supply = <&ldo8_reg>;
+	status = "okay";
+};
+
+&usbphy {
+	clocks = <&clocks USB_OTG>, <&xusbxti>, <&clocks SCLK_USBPHY1>;
+	clock-names = "phy", "device", "host";
+};
+
+&spi_0 {
+	status = "okay";
+};
+
+&spi_1 {
+	status = "okay";
+};
+
+&i2c_2 {
+	status = "okay";
+	samsung,i2c-sda-delay = <100>;
+	samsung,i2c-max-bus-freq = <400000>;
+	samsung,i2c-slave-addr = <0x10>;
+
+	tsp@4a {
+		compatible = "atmel,maxtouch";
+		reg = <0x4a>;
+		interrupt-parent = <&gpj0>;
+		interrupts = <5 2>;
+
+		atmel,x-line = <17>;
+		atmel,y-line = <11>;
+		atmel,x-size = <800>;
+		atmel,y-size = <480>;
+		atmel,burst-length = <0x21>;
+		atmel,threshold = <0x28>;
+		atmel,orientation = <1>;
+
+		vdd-supply = <&tsp_reg>;
+	};
+};
+
+&i2c_0 {
+	status = "okay";
+	samsung,i2c-slave-addr = <0x10>;
+
+	noon010pc30: sensor@30 {
+		compatible = "siliconfile,noon010pc30";
+		reg = <0x30>;
+		vddio-supply = <&ldo11_reg>;
+		vdda-supply = <&ldo13_reg>;
+		vdd_core-supply = <&ldo14_reg>;
+
+		clock-frequency = <16000000>;
+		clocks = <&clock_cam 0>;
+		clock-names = "mclk";
+		nreset-gpios = <&gpb 2 0>;
+		nstby-gpios = <&gpb 0 0>;
+
+		port {
+			noon010pc30_ep: endpoint {
+				remote-endpoint = <&fimc0_ep>;
+				bus-width = <8>;
+				hsync-active = <0>;
+				vsync-active = <1>;
+				pclk-sample = <1>;
+			};
+		};
+	};
+};
+
+&camera {
+	status = "okay";
+	parallel-ports {
+			#address-cells = <1>;
+			#size-cells = <0>;
+		/* camera A input */
+		port@1 {
+			reg = <1>;
+			fimc0_ep: endpoint {
+				remote-endpoint = <&noon010pc30_ep>;
+				bus-width = <8>;
+				hsync-active = <1>;
+				vsync-active = <1>;
+				pclk-sample = <0>;
+			};
+		};
+	};
+};
+
+&fimc_0 {
+	status = "okay";
+};
+
+&fimc_1 {
+	status = "okay";
+};
+
+&fimc_2 {
+	status = "okay";
+};
+
+&fimd {
+	pinctrl-0 = <&lcd_clk &lcd_data24 &pwm1_out>;
+	pinctrl-names = "default";
+	status = "okay";
+
+	display-timings {
+		native-mode = <&timing0>;
+		timing0: timing {
+			clock-frequency = <0>;
+			hactive = <800>;
+			vactive = <480>;
+			hfront-porch = <16>;
+			hback-porch = <16>;
+			hsync-len = <2>;
+			vback-porch = <2>;
+			vfront-porch = <28>;
+			vsync-len = <1>;
+		};
+	};
+};
+
+&onenand {
+	status = "okay";
+};
diff --git a/arch/arm/boot/dts/s5pv210-smdkc110.dts b/arch/arm/boot/dts/s5pv210-smdkc110.dts
new file mode 100644
index 0000000..a54dbf6
--- /dev/null
+++ b/arch/arm/boot/dts/s5pv210-smdkc110.dts
@@ -0,0 +1,165 @@
+/*
+ * Samsung's S5PV210 SoC device tree source
+ *
+ * Copyright (c) 2013 Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
+ *
+ * Samsung's S5PV210 SoC device nodes are listed in this file. S5PV210
+ * based board files can include this file and provide values for board specfic
+ * bindings.
+ *
+ * Note: This file does not include device nodes for all the controllers in
+ * S5PV210 SoC. As device tree coverage for S5PV210 increases, additional
+ * nodes can be added to this file.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+/dts-v1/;
+#include <dt-bindings/input/input.h>
+#include "s5pv210.dtsi"
+
+/ {
+	model = "S5PC110 SMDK";
+	compatible = "samsung,smdkc110", "samsung,s5pv210";
+
+	chosen {
+		bootargs = "console=ttySAC0,115200n8 root=/dev/mmcblk0p1 rw rootwait ignore_loglevel earlyprintk";
+	};
+
+	memory {
+		device_type = "memory";
+		reg = <>;
+	};
+
+	fixed-clocks {
+		compatible = "simple-bus";
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		xxti: oscillator@0 {
+			compatible = "fixed-clock";
+			reg = <0>;
+			clock-output-names = "xxti";
+			clock-frequency = <0>;
+			#clock-cells = <0>;
+		};
+
+		xusbxti: oscillator@1 {
+			compatible = "fixed-clock";
+			reg = <1>;
+			clock-output-names = "xusbxti";
+			clock-frequency = <24000000>;
+			#clock-cells = <0>;
+		};
+	};
+
+	regulators {
+		compatible = "simple-bus";
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		vtf_reg: fixed-regulator@0 {
+			compatible = "regulator-fixed";
+			regulator-name = "V_TF_2.8V";
+			regulator-min-microvolt = <2800000>;
+			regulator-max-microvolt = <2800000>;
+			reg = <0>;
+			gpios = <&mp05 4 0>;
+		};
+
+		pda_reg: fixed-regulator@1 {
+			compatible = "regulator-fixed";
+			regulator-name = "VCC_1.8V_PDA";
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <1800000>;
+			reg = <1>;
+		};
+
+		bat_reg: fixed-regulator@2 {
+			compatible = "regulator-fixed";
+			regulator-name = "V_BAT";
+			regulator-min-microvolt = <3700000>;
+			regulator-max-microvolt = <3700000>;
+			reg = <2>;
+		};
+	};
+};
+
+&uart0 {
+	status = "okay";
+};
+
+&uart1 {
+	status = "okay";
+};
+
+&uart2 {
+	status = "okay";
+};
+
+&sdhci0 {
+	bus-width = <8>;
+	non-removable;
+	status = "okay";
+};
+
+&sdhci1 {
+	bus-width = <4>;
+	pinctrl-0 = <&sd1_clk &sd1_cmd &sd1_cd &sd1_bus4>;
+	pinctrl-names = "default";
+	status = "okay";
+};
+
+&sdhci2 {
+	bus-width = <4>;
+	cd-gpios = <&gph3 4 1>;
+	vmmc-supply = <&vtf_reg>;
+	cd-inverted;
+	pinctrl-0 = <&sd2_clk &sd2_cmd &sd2_bus4>;
+	pinctrl-names = "default";
+	status = "okay";
+};
+
+&sdhci3 {
+	bus-width = <4>;
+	pinctrl-0 = <&sd3_clk &sd3_cmd &sd3_cd &sd3_bus4>;
+	pinctrl-names = "default";
+	status = "okay";
+};
+
+&spi_0 {
+	status = "okay";
+};
+
+&spi_1 {
+	status = "okay";
+};
+
+&hsotg {
+	status = "okay";
+};
+
+&usbphy {
+	clocks = <&clocks USB_OTG>, <&xusbxti>, <&xusbxti>;
+	clock-names = "phy", "device", "host";
+};
+
+&fimd {
+	pinctrl-0 = <&lcd_clk &lcd_data24 &pwm1_out>;
+	pinctrl-names = "default";
+	status = "okay";
+};
+
+&g2d {
+	status = "okay";
+};
+
+&ehci {
+	status = "okay";
+};
+
+&ohci {
+	status = "okay";
+};
\ No newline at end of file
diff --git a/arch/arm/boot/dts/s5pv210-smdkv210.dts b/arch/arm/boot/dts/s5pv210-smdkv210.dts
new file mode 100644
index 0000000..c0388e6
--- /dev/null
+++ b/arch/arm/boot/dts/s5pv210-smdkv210.dts
@@ -0,0 +1,273 @@
+/*
+ * Samsung's S5PV210 SoC device tree source
+ *
+ * Copyright (c) 2013 Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
+ *
+ * Samsung's S5PV210 SoC device nodes are listed in this file. S5PV210
+ * based board files can include this file and provide values for board specfic
+ * bindings.
+ *
+ * Note: This file does not include device nodes for all the controllers in
+ * S5PV210 SoC. As device tree coverage for S5PV210 increases, additional
+ * nodes can be added to this file.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+/dts-v1/;
+#include <dt-bindings/input/input.h>
+#include "s5pv210.dtsi"
+
+/ {
+	model = "S5PV210 SMDK";
+	compatible = "samsung,smdkv210", "samsung,s5pv210";
+
+	chosen {
+		bootargs = "console=ttySAC0,115200n8 root=/dev/mmcblk0p1 rw rootwait ignore_loglevel earlyprintk";
+	};
+
+	memory {
+		device_type = "memory";
+		reg = <>;
+	};
+
+	fixed-clocks {
+		compatible = "simple-bus";
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		xxti: oscillator@0 {
+			compatible = "fixed-clock";
+			reg = <0>;
+			clock-output-names = "xxti";
+			clock-frequency = <0>;
+			#clock-cells = <0>;
+		};
+
+		xusbxti: oscillator@1 {
+			compatible = "fixed-clock";
+			reg = <1>;
+			clock-output-names = "xusbxti";
+			clock-frequency = <24000000>;
+			#clock-cells = <0>;
+		};
+	};
+
+	regulators {
+		compatible = "simple-bus";
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		vtf_reg: fixed-regulator@0 {
+			compatible = "regulator-fixed";
+			regulator-name = "V_TF_2.8V";
+			regulator-min-microvolt = <2800000>;
+			regulator-max-microvolt = <2800000>;
+			reg = <0>;
+			gpios = <&mp05 4 0>;
+		};
+
+		pda_reg: fixed-regulator@1 {
+			compatible = "regulator-fixed";
+			regulator-name = "VCC_1.8V_PDA";
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <1800000>;
+			reg = <1>;
+		};
+
+		bat_reg: fixed-regulator@2 {
+			compatible = "regulator-fixed";
+			regulator-name = "V_BAT";
+			regulator-min-microvolt = <3700000>;
+			regulator-max-microvolt = <3700000>;
+			reg = <2>;
+		};
+	};
+
+	i2c-ac {
+		compatible = "i2c-gpio";
+		gpios = <&mp05 3 0>, /* sda */
+			<&mp05 2 0>; /* scl */
+		i2c-gpio,delay-us = <2>;        /* ~100 kHz */
+		#address-cells = <1>;
+		#size-cells = <0>;
+	};
+
+	keypad: keypad@e1600000 {
+		compatible = "samsung,s5pv210-keypad";
+		reg = <0xe1600000 0x100>;
+		interrupt-parent = <&vic2>;
+		interrupts = <25>;
+		clocks = <&clocks KEYIF>;
+		clock-names = "keypad";
+		status = "okay";
+		linux,input-no-autorepeat;
+		linux,input-wakeup;
+		samsung,keypad-num-rows = <8>;
+		samsung,keypad-num-columns = <8>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&keypad_row0>, <&keypad_row1>, <&keypad_row2>,
+				<&keypad_row3>, <&keypad_row4>, <&keypad_row5>,
+				<&keypad_row6>, <&keypad_row7>,
+				<&keypad_col0>, <&keypad_col1>, <&keypad_col2>,
+				<&keypad_col3>, <&keypad_col4>, <&keypad_col5>,
+				<&keypad_col6>, <&keypad_col7>;
+
+		key_1 {
+			keypad,row = <0>;
+			keypad,column = <3>;
+			linux,code = <KEY_1>;
+		};
+
+		key_2 {
+			keypad,row = <0>;
+			keypad,column = <4>;
+			linux,code = <KEY_2>;
+		};
+
+		key_3 {
+			keypad,row = <0>;
+			keypad,column = <5>;
+			linux,code = <KEY_3>;
+		};
+
+		key_4 {
+			keypad,row = <0>;
+			keypad,column = <6>;
+			linux,code = <KEY_4>;
+		};
+
+		key_5 {
+			keypad,row = <0
+			>;
+			keypad,column = <7>;
+			linux,code = <KEY_5>;
+		};
+
+		key_6 {
+			keypad,row = <1>;
+			keypad,column = <3>;
+			linux,code = <KEY_A>;
+		};
+		key_7 {
+			keypad,row = <1>;
+			keypad,column = <4>;
+			linux,code = <KEY_B>;
+		};
+
+		key_8 {
+			keypad,row = <1>;
+			keypad,column = <5>;
+			linux,code = <KEY_C>;
+		};
+
+		key_9 {
+			keypad,row = <1>;
+			keypad,column = <6>;
+			linux,code = <KEY_D>;
+		};
+
+		key_10 {
+			keypad,row = <1>;
+			keypad,column = <7>;
+			linux,code = <KEY_E>;
+		};
+	};
+
+	ethernet@18000000 {
+		compatible = "davicom,dm9000";
+		reg = <0xA8000000 0x2 0xA8000004 0x2>;
+		interrupt-parent = <&mp01>;
+		interrupts = <5 2>;
+		local-mac-address = [00 00 de ad be ef];
+		davicom,no-eeprom;
+		status = "disable";
+	};
+
+	backlight {
+		compatible = "pwm-backlight";
+		pwms = <&pwm 0 5000000>;
+		brightness-levels = <0 4 8 16 32 64 128 255>;
+		default-brightness-level = <6>;
+	};
+};
+
+
+&uart0 {
+	status = "okay";
+};
+
+&uart1 {
+	status = "okay";
+};
+
+&uart2 {
+	status = "okay";
+};
+
+&sdhci0 {
+	bus-width = <8>;
+	non-removable;
+	status = "okay";
+};
+
+&sdhci1 {
+	bus-width = <4>;
+	pinctrl-0 = <&sd1_clk &sd1_cmd &sd1_cd &sd1_bus4>;
+	pinctrl-names = "default";
+	status = "okay";
+};
+
+&sdhci2 {
+	bus-width = <4>;
+	cd-gpios = <&gph3 4 1>;
+	vmmc-supply = <&vtf_reg>;
+	cd-inverted;
+	pinctrl-0 = <&sd2_clk &sd2_cmd &sd2_bus4>;
+	pinctrl-names = "default";
+	status = "okay";
+};
+
+&sdhci3 {
+	bus-width = <4>;
+	pinctrl-0 = <&sd3_clk &sd3_cmd &sd3_cd &sd3_bus4>;
+	pinctrl-names = "default";
+	status = "okay";
+};
+
+&spi_0 {
+	status = "okay";
+};
+
+&spi_1 {
+	status = "okay";
+};
+
+&hsotg {
+	status = "okay";
+};
+
+&usbphy {
+	clocks = <&clocks USB_OTG>, <&xusbxti>, <&xusbxti>;
+	clock-names = "phy", "device", "host";
+};
+
+&fimd {
+	pinctrl-0 = <&lcd_clk &lcd_data24 &pwm1_out>;
+	pinctrl-names = "default";
+	status = "okay";
+};
+
+&g2d {
+	status = "okay";
+};
+
+&ehci {
+	status = "okay";
+};
+
+&ohci {
+	status = "okay";
+};
\ No newline at end of file
diff --git a/arch/arm/boot/dts/s5pv210-tiny210.dts b/arch/arm/boot/dts/s5pv210-tiny210.dts
new file mode 100644
index 0000000..f5b5095
--- /dev/null
+++ b/arch/arm/boot/dts/s5pv210-tiny210.dts
@@ -0,0 +1,262 @@
+/*
+ * Samsung's S5PV210 SoC device tree source
+ *
+ * Copyright (c) 2013 Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
+ *
+ * Samsung's S5PV210 SoC device nodes are listed in this file. S5PV210
+ * based board files can include this file and provide values for board specfic
+ * bindings.
+ *
+ * Note: This file does not include device nodes for all the controllers in
+ * S5PV210 SoC. As device tree coverage for S5PV210 increases, additional
+ * nodes can be added to this file.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+/dts-v1/;
+#include <dt-bindings/input/input.h>
+#include "s5pv210.dtsi"
+
+/ {
+	model = "S5PC110 TINY210";
+	compatible = "samsung,tiny", "samsung,s5pv210";
+
+	chosen {
+		bootargs = "console=ttySAC0,115200n8 root=/dev/mmcblk0p1 rw rootwait ignore_loglevel earlyprintk";
+	};
+
+	memory {
+		device_type = "memory";
+		reg = <0x20000000 0x20000000>;
+	};
+
+	fixed-clocks {
+		compatible = "simple-bus";
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		xxti: oscillator@0 {
+			compatible = "fixed-clock";
+			reg = <0>;
+			clock-output-names = "xxti";
+			clock-frequency = <0>;
+			#clock-cells = <0>;
+		};
+
+		xusbxti: oscillator@1 {
+			compatible = "fixed-clock";
+			reg = <1>;
+			clock-output-names = "xusbxti";
+			clock-frequency = <24000000>;
+			#clock-cells = <0>;
+		};
+	};
+
+	regulators {
+		compatible = "simple-bus";
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		vtf_reg: fixed-regulator@0 {
+			compatible = "regulator-fixed";
+			regulator-name = "V_TF_2.8V";
+			regulator-min-microvolt = <2800000>;
+			regulator-max-microvolt = <2800000>;
+			reg = <0>;
+			gpios = <&mp05 4 0>;
+		};
+
+		pda_reg: fixed-regulator@1 {
+			compatible = "regulator-fixed";
+			regulator-name = "VCC_1.8V_PDA";
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <1800000>;
+			reg = <1>;
+		};
+
+		bat_reg: fixed-regulator@2 {
+			compatible = "regulator-fixed";
+			regulator-name = "V_BAT";
+			regulator-min-microvolt = <3700000>;
+			regulator-max-microvolt = <3700000>;
+			reg = <2>;
+		};
+
+		mipi_reg: fixed-regulator@3 {
+			compatible = "regulator-fixed";
+			regulator-name = "VUSB+MIPI_1.1V";
+			regulator-min-microvolt = <1100000>;
+			regulator-max-microvolt = <1100000>;
+			reg = <3>;
+		};
+
+		vusb_reg: fixed-regulator@4 {
+			compatible = "regulator-fixed";
+			regulator-name = "VUSB+VDAC_3.3V";
+			regulator-min-microvolt = <3300000>;
+			regulator-max-microvolt = <3300000>;
+			reg = <4>;
+		};
+	};
+
+	i2c-ac {
+		compatible = "i2c-gpio";
+		gpios = <&mp05 3 0>, /* sda */
+			<&mp05 2 0>; /* scl */
+		i2c-gpio,delay-us = <2>;        /* ~100 kHz */
+		#address-cells = <1>;
+		#size-cells = <0>;
+	};
+
+	gpio-keys {
+		compatible = "gpio-keys";
+
+		back-key {
+			gpios = <&gph2 0 1>;
+			linux,code = <158>;
+			label = "HOME";
+			debounce-interval = <1>;
+		};
+
+		home-key {
+			gpios = <&gph2 1 1>;
+			linux,code = <102>;
+			label = "MENU";
+			debounce-interval = <1>;
+			gpio-key,wakeup;
+		};
+
+		menu-key {
+			gpios = <&gph2 2 1>;
+			linux,code = <139>;
+			label = "BACK";
+			debounce-interval = <1>;
+		};
+
+		dpad-center-key {
+			gpios = <&gph2 3 1>;
+			linux,code = <139>;
+			label = "DPAD_CENTER";
+			debounce-interval = <1>;
+		};
+
+		dpad-left-key {
+			gpios = <&gph3 0 1>;
+			linux,code = <232>;
+			label = "DPAD_LEFT";
+			debounce-interval = <1>;
+		};
+
+		dpad-down-key {
+			gpios = <&gph3 1 1>;
+			linux,code = <158>;
+			label = "DPAD_DOWN";
+			debounce-interval = <1>;
+		};
+
+		dpad-up-key {
+			gpios = <&gph3 2 1>;
+			linux,code = <102>;
+			label = "DPAD_UP";
+			debounce-interval = <1>;
+		};
+
+		dpad-right-key {
+			gpios = <&gph3 3 1>;
+			linux,code = <106>;
+			label = "DPAD_RIGHT";
+			debounce-interval = <1>;
+		};
+
+		ok-key {
+			gpios = <&gph1 7 1>;
+			linux,code = <102>;
+			label = "OK";
+			debounce-interval = <1>;
+			gpio-key,wakeup;
+		};
+	};
+};
+
+
+&uart0 {
+	status = "okay";
+};
+
+&uart1 {
+	status = "okay";
+};
+
+&uart2 {
+	status = "okay";
+};
+
+&sdhci0 {
+	bus-width = <8>;
+	non-removable;
+	status = "okay";
+};
+
+&sdhci1 {
+	bus-width = <4>;
+	pinctrl-0 = <&sd1_clk &sd1_cmd &sd1_cd &sd1_bus4>;
+	pinctrl-names = "default";
+	status = "okay";
+};
+
+&sdhci2 {
+	bus-width = <4>;
+	cd-gpios = <&gph3 4 1>;
+	vmmc-supply = <&vtf_reg>;
+	cd-inverted;
+	pinctrl-0 = <&sd2_clk &sd2_cmd &sd2_bus4>;
+	pinctrl-names = "default";
+	status = "okay";
+};
+
+&sdhci3 {
+	bus-width = <4>;
+	pinctrl-0 = <&sd3_clk &sd3_cmd &sd3_cd &sd3_bus4>;
+	pinctrl-names = "default";
+	status = "okay";
+};
+
+&spi_0 {
+	status = "okay";
+};
+
+&spi_1 {
+	status = "okay";
+};
+
+&hsotg {
+	vusb_a-supply = <&mipi_reg>;
+	vusb_d-supply = <&vusb_reg>;
+	status = "okay";
+};
+
+&usbphy {
+	clocks = <&clocks USB_OTG>, <&xusbxti>, <&xusbxti>;
+	clock-names = "phy", "device", "host";
+};
+
+&fimd {
+	pinctrl-0 = <&lcd_clk &lcd_data24 &pwm1_out>;
+	pinctrl-names = "default";
+	status = "okay";
+};
+
+&g2d {
+	status = "okay";
+};
+
+&ehci {
+	status = "okay";
+};
+
+&ohci {
+	status = "okay";
+};
\ No newline at end of file
diff --git a/arch/arm/boot/dts/s5pv210-torbreck.dts b/arch/arm/boot/dts/s5pv210-torbreck.dts
new file mode 100644
index 0000000..a51f1dc
--- /dev/null
+++ b/arch/arm/boot/dts/s5pv210-torbreck.dts
@@ -0,0 +1,157 @@
+/*
+ * Samsung's S5PV210 SoC device tree source
+ *
+ * Copyright (c) 2013 Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
+ *
+ * Samsung's S5PV210 SoC device nodes are listed in this file. S5PV210
+ * based board files can include this file and provide values for board specfic
+ * bindings.
+ *
+ * Note: This file does not include device nodes for all the controllers in
+ * S5PV210 SoC. As device tree coverage for S5PV210 increases, additional
+ * nodes can be added to this file.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+/dts-v1/;
+#include <dt-bindings/input/input.h>
+#include "s5pv210.dtsi"
+
+/ {
+	model = "S5PV210 TORBRECK";
+	compatible = "samsung,torbreck", "samsung,s5pv210";
+
+	chosen {
+		bootargs = "console=ttySAC0,115200n8 root=/dev/mmcblk0p1 rw rootwait ignore_loglevel earlyprintk";
+	};
+
+	memory {
+		device_type = "memory";
+		reg = <>;
+	};
+
+	fixed-clocks {
+		compatible = "simple-bus";
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		xxti: oscillator@0 {
+			compatible = "fixed-clock";
+			reg = <0>;
+			clock-output-names = "xxti";
+			clock-frequency = <24000000>;
+			#clock-cells = <0>;
+		};
+
+		xusbxti: oscillator@1 {
+			compatible = "fixed-clock";
+			reg = <1>;
+			clock-output-names = "xusbxti";
+			clock-frequency = <24000000>;
+			#clock-cells = <0>;
+		};
+	};
+
+	regulators {
+		compatible = "simple-bus";
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		vtf_reg: fixed-regulator@0 {
+			compatible = "regulator-fixed";
+			regulator-name = "V_TF_2.8V";
+			regulator-min-microvolt = <2800000>;
+			regulator-max-microvolt = <2800000>;
+			reg = <0>;
+			gpios = <&mp05 4 0>;
+		};
+
+		pda_reg: fixed-regulator@1 {
+			compatible = "regulator-fixed";
+			regulator-name = "VCC_1.8V_PDA";
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <1800000>;
+			reg = <1>;
+		};
+
+		bat_reg: fixed-regulator@2 {
+			compatible = "regulator-fixed";
+			regulator-name = "V_BAT";
+			regulator-min-microvolt = <3700000>;
+			regulator-max-microvolt = <3700000>;
+			reg = <2>;
+		};
+	};
+};
+
+&uart0 {
+	status = "okay";
+};
+
+&uart1 {
+	status = "okay";
+};
+
+&uart2 {
+	status = "okay";
+};
+
+&sdhci0 {
+	bus-width = <8>;
+	non-removable;
+	status = "okay";
+};
+
+&sdhci1 {
+	bus-width = <4>;
+	pinctrl-0 = <&sd1_clk &sd1_cmd &sd1_cd &sd1_bus4>;
+	pinctrl-names = "default";
+	status = "okay";
+};
+
+&sdhci2 {
+	bus-width = <4>;
+	cd-gpios = <&gph3 4 1>;
+	vmmc-supply = <&vtf_reg>;
+	cd-inverted;
+	pinctrl-0 = <&sd2_clk &sd2_cmd &sd2_bus4>;
+	pinctrl-names = "default";
+	status = "okay";
+};
+
+&sdhci3 {
+	bus-width = <4>;
+	pinctrl-0 = <&sd3_clk &sd3_cmd &sd3_cd &sd3_bus4>;
+	pinctrl-names = "default";
+	status = "okay";
+};
+
+&hsotg {
+	status = "okay";
+};
+
+&usbphy {
+	clocks = <&clocks USB_OTG>, <&xusbxti>, <&xusbxti>;
+	clock-names = "phy", "device", "host";
+};
+
+&fimd {
+	pinctrl-0 = <&lcd_clk &lcd_data24 &pwm1_out>;
+	pinctrl-names = "default";
+	status = "okay";
+};
+
+&g2d {
+	status = "okay";
+};
+
+&ehci {
+	status = "okay";
+};
+
+&ohci {
+	status = "okay";
+};
\ No newline at end of file
-- 
1.8.1.2

