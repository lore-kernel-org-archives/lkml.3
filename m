Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762AbaF0GLi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 02:11:38 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:16990 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652AbaF0GL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 02:11:27 -0400
X-AuditID: cbfee68d-b7fd46d000005f36-a1-53ad0b0c1576
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org
Cc: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        dianders@chromium.org, gregkh@linuxfoundation.org,
        naveenkrishna.ch@gmail.com, cpgs@samsung.com
Subject: [PATCH v2 2/2] ARM: DTS: Add thermistor dts fragment used by exynos
 based Peach boards
Date: Fri, 27 Jun 2014 11:38:15 +0530
Message-id: <1403849295-29538-3-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1403849295-29538-1-git-send-email-ch.naveen@samsung.com>
References: <1403849295-29538-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOLMWRmVeSWpSXmKPExsWyRsSkRpeHe22wwdOTehYvD2lazD9yjtXi
	7LKDbBbNi9ezWcw78o7F4vKuOWwWM87vY7JYtO0/swOHx+yGiyweO2fdZffYP3cNu0ffllWM
	Hp83yQWwRnHZpKTmZJalFunbJXBl/N7wiL3ggWRFz6rVrA2MXaJdjJwcEgImEn9mfWGHsMUk
	Ltxbz9bFyMUhJLCUUWLfnG9ACQ6wojOrpUFqhASmM0q8mVQEUdPPJDFr1T4mkASbgJnEwUWr
	wQaJCDhK7JjzjwmkiFlgAaNE667VYEXCAokSz5qOgA1lEVCVaPyiAGLyCrhKXFwfCrFKQWLO
	JBuQYk4BN4l3bR+YIda6Svx8v5MFZKKEwCJ2iR/v2sEmsggISHybfIgFoldWYtMBZohXJCUO
	rrjBMoFReAEjwypG0dSC5ILipPQiQ73ixNzi0rx0veT83E2MwEA//e9Z7w7G2wesDzEmA42b
	yCwlmpwPjJS8knhDYzMjC1MTU2Mjc0sz0oSVxHmTHiYFCQmkJ5akZqemFqQWxReV5qQWH2Jk
	4uCUamBkcbQzNvx3NaDnwcV3Mhd/qQWft+v5L1mhs7XOJvPl4fV9GY0r1T0Xq8tWXP9gH3l9
	aqbozS2q4RrrJ1Q9M1h2VV3/vVjO9rtuNx5nZp7ZseL2TLUFP7KD9oqJp7WoLjhic/KlZcMp
	48KIx8r+bjFZjrnn+Yx4HUNmp9r/3fq82X3qRqn4lReUWIozEg21mIuKEwHtlu3yigIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGIsWRmVeSWpSXmKPExsVy+t9jQV0e7rXBBs/Xq1m8PKRpMf/IOVaL
	s8sOslk0L17PZjHvyDsWi8u75rBZzDi/j8li0bb/zA4cHrMbLrJ47Jx1l91j/9w17B59W1Yx
	enzeJBfAGtXAaJORmpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6Dr
	lpkDdIuSQlliTilQKCCxuFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCGMeP3hkfsBQ8kK3pW
	rWZtYOwS7WLk4JAQMJE4s1q6i5ETyBSTuHBvPRuILSQwnVHizaSiLkYuILufSWLWqn1MIAk2
	ATOJg4tWs4PYIgKOEjvm/GMCKWIWWMAo0bprNViRsECixLOmI+wgC1gEVCUavyiAmLwCrhIX
	14dCrFWQmDPJBqSYU8BN4l3bB2aIta4SP9/vZJnAyLuAkWEVo2hqQXJBcVJ6rqFecWJucWle
	ul5yfu4mRnAcPZPawbiyweIQowAHoxIPr4HHmmAh1sSy4srcQ4wSHMxKIrwv7wGFeFMSK6tS
	i/Lji0pzUosPMZoCnTSRWUo0OR8Y43kl8YbGJuamxqaWJhYmZpZK4rwHWq0DhQTSE0tSs1NT
	C1KLYPqYODilGhhP/g56dnpB9YPUw/+Mzrb4/a/xvune8mXnrOPfxeerGATzxBeo8G8L+7n2
	/JTD/X4r7BJ7/gcefikmlBp+4HG1wNnb6u+1pieEcfzPWJEy8RbrjryaF284Z9pVz7XWmak7
	S2UCp0vrHfOkOqe8i7pxi2vVs09Y7il7yTThsukkmyZtUxE5M08lluKMREMt5qLiRAC0JQUh
	uQIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch creates a thermistor fragment carrying the NTC Thermistor
nodes as children of the IIO based ADC.

This fragment is included in exynos5420-peach-pit.dts and
exynos5800-peach-pi.dts.

Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
---
Changes since v1:
As per the comments https://lkml.org/lkml/2014/6/26/271
and discussion about fragments vs common dtsi
@ http://patchwork.ozlabs.org/patch/362633/.

Created a thermistors fragment instead of a common dtsi file

cat sysfs entries exported by hwmon for 4 thermistors
and verified the values on Peach pit and pi boards.

 arch/arm/boot/dts/cros-adc-thermistors.dtsi |   44 +++++++++++++++++++++++++++
 arch/arm/boot/dts/exynos5420-peach-pit.dts  |    6 ++++
 arch/arm/boot/dts/exynos5800-peach-pi.dts   |    6 ++++
 3 files changed, 56 insertions(+)
 create mode 100644 arch/arm/boot/dts/cros-adc-thermistors.dtsi

diff --git a/arch/arm/boot/dts/cros-adc-thermistors.dtsi b/arch/arm/boot/dts/cros-adc-thermistors.dtsi
new file mode 100644
index 0000000..17fce72
--- /dev/null
+++ b/arch/arm/boot/dts/cros-adc-thermistors.dtsi
@@ -0,0 +1,44 @@
+/*
+ * Thermistor dts fragment for devices that use Thermistors as
+ * children of the IIO based ADC.
+ *
+ * Currently, used by Exynos5420 based Peach PIT and
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
index d124394..7c64009 100644
--- a/arch/arm/boot/dts/exynos5420-peach-pit.dts
+++ b/arch/arm/boot/dts/exynos5420-peach-pit.dts
@@ -101,6 +101,11 @@
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
@@ -775,3 +780,4 @@
 };
 
 #include "cros-ec-keyboard.dtsi"
+#include "cros-adc-thermistors.dtsi"
diff --git a/arch/arm/boot/dts/exynos5800-peach-pi.dts b/arch/arm/boot/dts/exynos5800-peach-pi.dts
index c36c9ce..4fd48b9 100644
--- a/arch/arm/boot/dts/exynos5800-peach-pi.dts
+++ b/arch/arm/boot/dts/exynos5800-peach-pi.dts
@@ -99,6 +99,11 @@
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
@@ -773,3 +778,4 @@
 };
 
 #include "cros-ec-keyboard.dtsi"
+#include "cros-adc-thermistors.dtsi"
-- 
1.7.9.5

