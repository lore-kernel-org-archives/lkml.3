Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877Ab3KGNUb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 08:20:31 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:15426 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121Ab3KGNU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 08:20:27 -0500
X-AuditID: cbfee68f-b7f836d000001b39-11-527b9399b8b7
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: kgene.kim@samsung.com, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: naveenkrishna.ch@gmail.com
Subject: [PATCH] ARM: dts: Exynos5420: Add device nodes for HSI2C blocks
Date: Thu, 07 Nov 2013 18:52:03 +0530
Message-id: <1383830523-1767-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.10.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKLMWRmVeSWpSXmKPExsWyRsSkWnfm5Oogg887lCzmHznHatG74Cqb
	xabH11gtLu+aw2Yx4/w+JotF2/4zO7B57Jx1l91j85J6j74tqxg9Pm+SC2CJ4rJJSc3JLEst
	0rdL4Mq4fGEne8EjyYpDZ/4zNTBOFuli5OSQEDCRmN2+khnCFpO4cG89WxcjF4eQwFJGiQ9z
	zjDDFD3YuB8qsYhRoudWMyuE08MksfL+JbAqNgEziYOLVrODJEQEFjBKzJ29hQ0kwSwgJ/H4
	4wdGEFtYwEPixdJZ7CA2i4CqxLZnf8DivAIuErN2d7FArFOU6H42AWydhMB3NollO45DNQhI
	fJt8CKiIAyghK7HpANR5khIHV9xgmcAouICRYRWjaGpBckFxUnqRsV5xYm5xaV66XnJ+7iZG
	YJCe/vesfwfj3QPWhxiTgcZNZJYSTc4HBnleSbyhsZmRhamJqbGRuaUZacJK4rz3HyYFCQmk
	J5akZqemFqQWxReV5qQWH2Jk4uCUamB0X5ImtejkCauFp8/t1Tf5d2Hnsr6YiPqflg7nXthl
	sIScX1Z1NfajqMA7NvcGnyVv783tvsX0XTna2+e0XkiKy//LNz5bb/mW5VpzRcN6dmRs7Y1v
	Xy3Tdh7+LLWC6VSm6sltMatZ9db1FrwJthXuPbdjP2dW+IPbvzaGXN89TdW+PmaDSWuVEktx
	RqKhFnNRcSIAaq69KGgCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEIsWRmVeSWpSXmKPExsVy+t9jAd2Zk6uDDPa0SFrMP3KO1aJ3wVU2
	i02Pr7FaXN41h81ixvl9TBaLtv1ndmDz2DnrLrvH5iX1Hn1bVjF6fN4kF8AS1cBok5GamJJa
	pJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQO0XEmhLDGnFCgUkFhc
	rKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMOYcfnCTvaCR5IVh878Z2pgnCzSxcjJISFgIvFg
	4342CFtM4sK99UA2F4eQwCJGiZ5bzawQTg+TxMr7l5hBqtgEzCQOLlrNDpIQEVjAKDF39haw
	dmYBOYnHHz8wgtjCAh4SL5bOYgexWQRUJbY9+wMW5xVwkZi1u4sFYp2iRPezCWwTGLkXMDKs
	YhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAiOgWdSOxhXNlgcYhTgYFTi4Z1RUxUkxJpYVlyZ
	e4hRgoNZSYR3f191kBBvSmJlVWpRfnxRaU5q8SHGZKDtE5mlRJPzgfGZVxJvaGxibmpsamli
	YWJmSZqwkjjvgVbrQCGB9MSS1OzU1ILUIpgtTBycUg2M9g8aPCwmtXi92TnpnWa68tlnm248
	O5X8Yk7ORcX3hfP3HVNhPtp8zeDus6YHDCcqX28pWtb+Uibo6suPu1Ilg/vvX+Xa/Utd/sS1
	XdOPpfL9Vv7x3cL88VLxrxwpx5eE7Hd9bXlBdZHKlLPMy42cJqr3lenla2/9vPNC8QvJgO6P
	d+tSLLfGpCmxFGckGmoxFxUnAgDJ/ah/xQIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Exynos5420 SoC has 7 High speed I2C channels, This patch adds
the device tree nodes to the DT device list.

Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
 arch/arm/boot/dts/exynos5420.dtsi |   98 +++++++++++++++++++++++++++++++++++++
 1 file changed, 98 insertions(+)

diff --git a/arch/arm/boot/dts/exynos5420.dtsi b/arch/arm/boot/dts/exynos5420.dtsi
index 6ffefd1..12f612d 100644
--- a/arch/arm/boot/dts/exynos5420.dtsi
+++ b/arch/arm/boot/dts/exynos5420.dtsi
@@ -34,6 +34,13 @@
 		i2c1 = &i2c_1;
 		i2c2 = &i2c_2;
 		i2c3 = &i2c_3;
+		i2c4 = &hsi2c_4;
+		i2c5 = &hsi2c_5;
+		i2c6 = &hsi2c_6;
+		i2c7 = &hsi2c_7;
+		i2c8 = &hsi2c_8;
+		i2c9 = &hsi2c_9;
+		i2c10 = &hsi2c_10;
 		gsc0 = &gsc_0;
 		gsc1 = &gsc_1;
 	};
@@ -333,6 +340,97 @@
 		status = "disabled";
 	};
 
+	hsi2c_4: hsi2c@12CA0000 {
+		compatible = "samsung,exynos5-hsi2c";
+		reg = <0x12CA0000 0x1000>;
+		interrupts = <0 60 0>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&i2c4_hs_bus>;
+		clocks = <&clock 265>;
+		clock-names = "hsi2c";
+		status = "disabled";
+	};
+
+	hsi2c_5: hsi2c@12CB0000 {
+		compatible = "samsung,exynos5-hsi2c";
+		reg = <0x12CB0000 0x1000>;
+		interrupts = <0 61 0>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&i2c5_hs_bus>;
+		clocks = <&clock 266>;
+		clock-names = "hsi2c";
+		status = "disabled";
+	};
+
+	hsi2c_6: hsi2c@12CC0000 {
+		compatible = "samsung,exynos5-hsi2c";
+		reg = <0x12CC0000 0x1000>;
+		interrupts = <0 62 0>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&i2c6_hs_bus>;
+		clocks = <&clock 267>;
+		clock-names = "hsi2c";
+		status = "disabled";
+	};
+
+	hsi2c_7: hsi2c@12CD0000 {
+		compatible = "samsung,exynos5-hsi2c";
+		reg = <0x12CD0000 0x1000>;
+		interrupts = <0 63 0>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&i2c7_hs_bus>;
+		clocks = <&clock 268>;
+		clock-names = "hsi2c";
+		status = "disabled";
+	};
+
+	hsi2c_8: hsi2c@12E00000 {
+		compatible = "samsung,exynos5-hsi2c";
+		reg = <0x12E00000 0x1000>;
+		interrupts = <0 87 0>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&i2c8_hs_bus>;
+		clocks = <&clock 281>;
+		clock-names = "hsi2c";
+		status = "disabled";
+	};
+
+	hsi2c_9: hsi2c@12E10000 {
+		compatible = "samsung,exynos5-hsi2c";
+		reg = <0x12E10000 0x1000>;
+		interrupts = <0 88 0>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&i2c9_hs_bus>;
+		clocks = <&clock 282>;
+		clock-names = "hsi2c";
+		status = "disabled";
+	};
+
+	hsi2c_10: hsi2c@12E20000 {
+		compatible = "samsung,exynos5-hsi2c";
+		reg = <0x12E20000 0x1000>;
+		interrupts = <0 203 0>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&i2c10_hs_bus>;
+		clocks = <&clock 283>;
+		clock-names = "hsi2c";
+		status = "disabled";
+	};
+
 	hdmi@14530000 {
 		compatible = "samsung,exynos4212-hdmi";
 		reg = <0x14530000 0x70000>;
-- 
1.7.10.4

