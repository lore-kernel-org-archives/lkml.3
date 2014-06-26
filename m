Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757891AbaFZMX1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 08:23:27 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:49454 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757415AbaFZMXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 08:23:24 -0400
X-AuditID: cbfee68e-b7fb96d000004bfc-18-53ac10b9a5a1
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org
Cc: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        dianders@chromium.org, gregkh@linuxfoundation.org,
        naveenkrishna.ch@gmail.com, cpgs@samsung.com
Subject: [PATCH 3/3] ARM: DTS: Add common dts file for Peach PIT and PI along
 with ADC nodes
Date: Thu, 26 Jun 2014 17:49:08 +0530
Message-id: <1403785148-20792-4-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1403785148-20792-1-git-send-email-ch.naveen@samsung.com>
References: <1403785148-20792-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOLMWRmVeSWpSXmKPExsWyRsSkRneXwJpgg1UcFi8PaVrMP3KO1eLs
	soNsFs2L17NZzDvyjsXi8q45bBYzzu9jsli07T+zA4fH7IaLLB47Z91l99g/dw27R9+WVYwe
	nzfJBbBGcdmkpOZklqUW6dslcGV8u76ZueC0bMXxbQfYGxiXSHQxcnBICJhIvDzq18XICWSK
	SVy4t56ti5GLQ0hgKaPEw2VXWCASJhIXlkxjB7GFBKYzSsz8VA9R1M8kcfjJSbAiNgEziYOL
	VoMViQg4SuyY848JpIhZYAGjROuu1UwgCWGBOIlPLzaBFbEIqEr8+7UQrJlXwFXi4tUZbBAX
	KUjMmWQDEuYUcJNo+XCABSQsBFRy7aI8yEgJgWXsEv9mnGeFGCMg8W3yIRaIVlmJTQeYIW6W
	lDi44gbLBEbhBYwMqxhFUwuSC4qT0ouM9IoTc4tL89L1kvNzNzECA/30v2d9OxhvHrA+xJgM
	NG4is5Rocj4wUvJK4g2NzYwsTE1MjY3MLc1IE1YS5130MClISCA9sSQ1OzW1ILUovqg0J7X4
	ECMTB6dUA+PG8HINhqSTD2Uf/9Z5I6S8YXaMscA1/h26Ch8SnGY6cX/yaQ1hmWW5xmutuwKD
	2P6mi8GlumtvqPyZ7zGRV3zWLIkVczeadZin8L/a28+xi12YfQbfUbPYP2dLJolrN+ctbcrb
	fWXm1M2+nSaH/PSPC2eu38LRE8n+PeHL7i3/rd15v69y26HEUpyRaKjFXFScCABtsW80igIA	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBIsWRmVeSWpSXmKPExsVy+t9jQd2dAmuCDeb95LJ4eUjTYv6Rc6wW
	Z5cdZLNoXryezWLekXcsFpd3zWGzmHF+H5PFom3/mR04PGY3XGTx2DnrLrvH/rlr2D36tqxi
	9Pi8SS6ANaqB0SYjNTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DX
	LTMH6BYlhbLEnFKgUEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGENY8a365uZC07LVhzf
	doC9gXGJRBcjJ4eEgInEhSXT2CFsMYkL99azgdhCAtMZJWZ+qu9i5AKy+5kkDj85yQKSYBMw
	kzi4aDVYg4iAo8SOOf+YQIqYBRYwSrTuWs0EkhAWiJP49GITWBGLgKrEv18LwZp5BVwlLl6d
	AbSBA2ibgsScSTYgYU4BN4mWDwdYQMJCQCXXLspPYORdwMiwilE0tSC5oDgpPddIrzgxt7g0
	L10vOT93EyM4lp5J72Bc1WBxiFGAg1GJh/fD41XBQqyJZcWVuYcYJTiYlUR47/OvCRbiTUms
	rEotyo8vKs1JLT7EaAp000RmKdHkfGCc55XEGxqbmJsam1qaWJiYWSqJ8x5stQ4UEkhPLEnN
	Tk0tSC2C6WPi4JRqYDTnDtTt2vJYUCP99y7z4KVNy91OZ/Ut2JewedfO5edur5gYP2d93Z6n
	95pLI4r+nZEVb0jRLGVp9P35Z/KMu0dFHxW7C5+6I2t2Zg+v1JNwwxoL9iV1CzZPrXTnfrur
	JnX7x/ATMzT+pPO+OlgbuqTc8r/WrrUX57f0l4lwTvlnXXZspkHG5TAlluKMREMt5qLiRACu
	CIXGuwIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DTS files exynos5420-peach-pit.dts and exynos5800-peach-pi.dts
have lots of device tree nodes in common.

This patch creates a cros-exynos-peach.dts file, which can carry the
device tree nodes common across exynos5420-peach-pit.dts and
exynos5800-peach-pi.dts. Starting with ADC based Thermistor nodes.

Also, enables ADC based thermistors for peach_pi and peach_pit.

Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
---
This patchset needs
"[PATCH v4 00/14] Add Maxim 77802 PMIC support" by "Javier Martinez Canillas"
Posted  https://lkml.org/lkml/2014/6/25/668

Intention is to slowly move the common DT nodes across exynos5420-peach-pit.dts
and exynos5800-peach-pi.dts into cros-exynos-peach.dts

I'm unsure of the naming conventions for dts files
   Named it "cros-exynos-peach.dts" as below.
   used for "cros" + based on "exynos" + boards named "peach" in common.

cat sysfs entries exported by hwmon for 4 thermistors
and verified the values on peach pit.

 arch/arm/boot/dts/cros-exynos-peach.dtsi   |   41 ++++++++++++++++++++++++++++
 arch/arm/boot/dts/exynos5420-peach-pit.dts |    6 ++++
 arch/arm/boot/dts/exynos5800-peach-pi.dts  |    6 ++++
 3 files changed, 53 insertions(+)
 create mode 100644 arch/arm/boot/dts/cros-exynos-peach.dtsi

diff --git a/arch/arm/boot/dts/cros-exynos-peach.dtsi b/arch/arm/boot/dts/cros-exynos-peach.dtsi
new file mode 100644
index 0000000..86135bd
--- /dev/null
+++ b/arch/arm/boot/dts/cros-exynos-peach.dtsi
@@ -0,0 +1,41 @@
+/*
+ * Common device tree include for Exynos5420 based Peach PIT and
+ * Exynos5800 based Peach PI.
+ *
+ * Copyright (c) 2014 Samsung Electronics Co., Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+&adc {
+	ncp15wb473@3 {
+		compatible = "murata,ncp15wb473";
+		pullup-uv = <1800000>;
+		pullup-ohm = <47000>;
+		pulldown-ohm = <0>;
+		io-channels = <&adc 3>;
+	};
+	ncp15wb473@4 {
+		compatible = "murata,ncp15wb473";
+		pullup-uv = <1800000>;
+		pullup-ohm = <47000>;
+		pulldown-ohm = <0>;
+		io-channels = <&adc 4>;
+	};
+	ncp15wb473@5 {
+		compatible = "murata,ncp15wb473";
+		pullup-uv = <1800000>;
+		pullup-ohm = <47000>;
+		pulldown-ohm = <0>;
+		io-channels = <&adc 5>;
+	};
+	ncp15wb473@6 {
+		compatible = "murata,ncp15wb473";
+		pullup-uv = <1800000>;
+		pullup-ohm = <47000>;
+		pulldown-ohm = <0>;
+		io-channels = <&adc 6>;
+	};
+};
diff --git a/arch/arm/boot/dts/exynos5420-peach-pit.dts b/arch/arm/boot/dts/exynos5420-peach-pit.dts
index d124394..682b9c2 100644
--- a/arch/arm/boot/dts/exynos5420-peach-pit.dts
+++ b/arch/arm/boot/dts/exynos5420-peach-pit.dts
@@ -12,6 +12,7 @@
 #include <dt-bindings/input/input.h>
 #include <dt-bindings/gpio/gpio.h>
 #include "exynos5420.dtsi"
+#include "cros-exynos-peach.dtsi"
 
 / {
 	model = "Google Peach Pit Rev 6+";
@@ -101,6 +102,11 @@
 	};
 };
 
+&adc {
+	status = "okay";
+	vdd-supply = <&ldo9_reg>;
+};
+
 &dp {
 	status = "okay";
 	pinctrl-names = "default";
diff --git a/arch/arm/boot/dts/exynos5800-peach-pi.dts b/arch/arm/boot/dts/exynos5800-peach-pi.dts
index c36c9ce..7552173 100644
--- a/arch/arm/boot/dts/exynos5800-peach-pi.dts
+++ b/arch/arm/boot/dts/exynos5800-peach-pi.dts
@@ -12,6 +12,7 @@
 #include <dt-bindings/input/input.h>
 #include <dt-bindings/gpio/gpio.h>
 #include "exynos5800.dtsi"
+#include "cros-exynos-peach.dtsi"
 
 / {
 	model = "Google Peach Pi Rev 10+";
@@ -99,6 +100,11 @@
 	};
 };
 
+&adc {
+	status = "okay";
+	vdd-supply = <&ldo9_reg>;
+};
+
 &dp {
 	status = "okay";
 	pinctrl-names = "default";
-- 
1.7.9.5

