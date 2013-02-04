Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756272Ab3BDPm3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 10:42:29 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:63766 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755853Ab3BDPm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 10:42:26 -0500
From: Haojian Zhuang <haojian.zhuang@linaro.org>
To: sameo@linux.intel.com, qingx@marvell.com, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, cxie4@marvell.com,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Cc: patches@linaro.org, Haojian Zhuang <haojian.zhuang@gmail.com>
Subject: [PATCH 5/6] mfd: max8925: add dts
Date: Mon,  4 Feb 2013 23:40:46 +0800
Message-Id: <1359992448-22229-5-git-send-email-haojian.zhuang@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1359992448-22229-1-git-send-email-haojian.zhuang@linaro.org>
References: <1359992448-22229-1-git-send-email-haojian.zhuang@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Qing Xu <qingx@marvell.com>

Add max8925 dts support into mmp2 brownstone platform

Signed-off-by: Qing Xu <qingx@marvell.com>
Signed-off-by: Haojian Zhuang <haojian.zhuang@gmail.com>
---
 arch/arm/boot/dts/mmp2-brownstone.dts |  158 +++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/mmp2.dtsi           |    4 +-
 2 files changed, 161 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/mmp2-brownstone.dts b/arch/arm/boot/dts/mmp2-brownstone.dts
index c9b4f27..7f70a39 100644
--- a/arch/arm/boot/dts/mmp2-brownstone.dts
+++ b/arch/arm/boot/dts/mmp2-brownstone.dts
@@ -29,6 +29,164 @@
 			};
 			twsi1: i2c@d4011000 {
 				status = "okay";
+				pmic: max8925@3c {
+					compatible = "maxium,max8925";
+					reg = <0x3c>;
+					interrupts = <1>;
+					interrupt-parent = <&intcmux4>;
+					interrupt-controller;
+					#interrupt-cells = <1>;
+					maxim,tsc-irq = <0>;
+
+					regulators {
+						SDV1 {
+							regulator-min-microvolt = <637500>;
+							regulator-max-microvolt = <1425000>;
+							regulator-boot-on;
+							regulator-always-on;
+						};
+						SDV2 {
+							regulator-min-microvolt = <650000>;
+							regulator-max-microvolt = <2225000>;
+							regulator-boot-on;
+							regulator-always-on;
+						};
+						SDV3 {
+							regulator-min-microvolt = <750000>;
+							regulator-max-microvolt = <3900000>;
+							regulator-boot-on;
+							regulator-always-on;
+						};
+						LDO1 {
+							regulator-min-microvolt = <750000>;
+							regulator-max-microvolt = <3900000>;
+							regulator-boot-on;
+							regulator-always-on;
+						};
+						LDO2 {
+							regulator-min-microvolt = <650000>;
+							regulator-max-microvolt = <2250000>;
+							regulator-boot-on;
+							regulator-always-on;
+						};
+						LDO3 {
+							regulator-min-microvolt = <650000>;
+							regulator-max-microvolt = <2250000>;
+							regulator-boot-on;
+							regulator-always-on;
+						};
+						LDO4 {
+							regulator-min-microvolt = <750000>;
+							regulator-max-microvolt = <3900000>;
+							regulator-boot-on;
+							regulator-always-on;
+						};
+						LDO5 {
+							regulator-min-microvolt = <750000>;
+							regulator-max-microvolt = <3900000>;
+							regulator-boot-on;
+							regulator-always-on;
+						};
+						LDO6 {
+							regulator-min-microvolt = <750000>;
+							regulator-max-microvolt = <3900000>;
+							regulator-boot-on;
+							regulator-always-on;
+						};
+						LDO7 {
+							regulator-min-microvolt = <750000>;
+							regulator-max-microvolt = <3900000>;
+							regulator-boot-on;
+							regulator-always-on;
+						};
+						LDO8 {
+							regulator-min-microvolt = <750000>;
+							regulator-max-microvolt = <3900000>;
+							regulator-boot-on;
+							regulator-always-on;
+						};
+						LDO9 {
+							regulator-min-microvolt = <750000>;
+							regulator-max-microvolt = <3900000>;
+							regulator-boot-on;
+							regulator-always-on;
+						};
+						LDO10 {
+							regulator-min-microvolt = <750000>;
+							regulator-max-microvolt = <3900000>;
+						};
+						LDO11 {
+							regulator-min-microvolt = <750000>;
+							regulator-max-microvolt = <3900000>;
+							regulator-boot-on;
+							regulator-always-on;
+						};
+						LDO12 {
+							regulator-min-microvolt = <750000>;
+							regulator-max-microvolt = <3900000>;
+							regulator-boot-on;
+							regulator-always-on;
+						};
+						LDO13 {
+							regulator-min-microvolt = <750000>;
+							regulator-max-microvolt = <3900000>;
+							regulator-boot-on;
+							regulator-always-on;
+						};
+						LDO14 {
+							regulator-min-microvolt = <750000>;
+							regulator-max-microvolt = <3900000>;
+							regulator-boot-on;
+							regulator-always-on;
+						};
+						LDO15 {
+							regulator-min-microvolt = <750000>;
+							regulator-max-microvolt = <3900000>;
+							regulator-boot-on;
+							regulator-always-on;
+						};
+						LDO16 {
+							regulator-min-microvolt = <750000>;
+							regulator-max-microvolt = <3900000>;
+							regulator-boot-on;
+							regulator-always-on;
+						};
+						LDO17 {
+							regulator-min-microvolt = <650000>;
+							regulator-max-microvolt = <2250000>;
+							regulator-boot-on;
+							regulator-always-on;
+						};
+						LDO18 {
+							regulator-min-microvolt = <650000>;
+							regulator-max-microvolt = <2250000>;
+							regulator-boot-on;
+							regulator-always-on;
+						};
+						LDO19 {
+							regulator-min-microvolt = <750000>;
+							regulator-max-microvolt = <3900000>;
+							regulator-boot-on;
+							regulator-always-on;
+						};
+						LDO20 {
+							regulator-min-microvolt = <750000>;
+							regulator-max-microvolt = <3900000>;
+							regulator-boot-on;
+							regulator-always-on;
+						};
+					};
+					backlight {
+						maxim,max8925-dual-string = <0>;
+					};
+					charger {
+						batt-detect = <0>;
+						topoff-threshold = <1>;
+						fast-charge = <7>;
+						no-temp-support = <0>;
+						no-insert-detect = <0>;
+					};
+				};
 			};
 			rtc: rtc@d4010000 {
 				status = "okay";
diff --git a/arch/arm/boot/dts/mmp2.dtsi b/arch/arm/boot/dts/mmp2.dtsi
index 0514fb4..1429ac0 100644
--- a/arch/arm/boot/dts/mmp2.dtsi
+++ b/arch/arm/boot/dts/mmp2.dtsi
@@ -46,7 +46,7 @@
 				mrvl,intc-nr-irqs = <64>;
 			};
 
-			intcmux4@d4282150 {
+			intcmux4: interrupt-controller@d4282150 {
 				compatible = "mrvl,mmp2-mux-intc";
 				interrupts = <4>;
 				interrupt-controller;
@@ -201,6 +201,8 @@
 				compatible = "mrvl,mmp-twsi";
 				reg = <0xd4011000 0x1000>;
 				interrupts = <7>;
+				#address-cells = <1>;
+				#size-cells = <0>;
 				mrvl,i2c-fast-mode;
 				status = "disabled";
 			};
-- 
1.7.10.4

