Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148AbaCKWqD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 18:46:03 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:55824 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755966AbaCKWk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 18:40:57 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: tglx@linutronix.de, mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, dan.carpenter@oracle.com,
        ezequiel.garcia@free-electrons.com, ivan.khoronzhuk@ti.com,
        linus.walleij@linaro.org, magnus.damm@gmail.com,
        matthias.bgg@gmail.com, soren.brinkmann@xilinx.com,
        sboyd@codeaurora.org
Subject: [PATCH 04/17] ARM: sunxi: dt: Convert to the new clocksource compatible
Date: Tue, 11 Mar 2014 23:40:40 +0100
Message-Id: <1394577653-8615-4-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1394577653-8615-1-git-send-email-daniel.lezcano@linaro.org>
References: <531F8FAC.2040902@linaro.org>
 <1394577653-8615-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Maxime Ripard <maxime.ripard@free-electrons.com>

Switch the device tree to the new compatibles introduced in the timer driver
to have a common pattern accross all Allwinner SoCs.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 arch/arm/boot/dts/sun4i-a10.dtsi  |    2 +-
 arch/arm/boot/dts/sun5i-a10s.dtsi |    2 +-
 arch/arm/boot/dts/sun5i-a13.dtsi  |    2 +-
 arch/arm/boot/dts/sun6i-a31.dtsi  |    2 +-
 arch/arm/boot/dts/sun7i-a20.dtsi  |    2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm/boot/dts/sun4i-a10.dtsi b/arch/arm/boot/dts/sun4i-a10.dtsi
index 040bb0e..dd64cc0 100644
--- a/arch/arm/boot/dts/sun4i-a10.dtsi
+++ b/arch/arm/boot/dts/sun4i-a10.dtsi
@@ -403,7 +403,7 @@
 		};
 
 		timer@01c20c00 {
-			compatible = "allwinner,sun4i-timer";
+			compatible = "allwinner,sun4i-a10-timer";
 			reg = <0x01c20c00 0x90>;
 			interrupts = <22>;
 			clocks = <&osc24M>;
diff --git a/arch/arm/boot/dts/sun5i-a10s.dtsi b/arch/arm/boot/dts/sun5i-a10s.dtsi
index ea16054..9cee110 100644
--- a/arch/arm/boot/dts/sun5i-a10s.dtsi
+++ b/arch/arm/boot/dts/sun5i-a10s.dtsi
@@ -366,7 +366,7 @@
 		};
 
 		timer@01c20c00 {
-			compatible = "allwinner,sun4i-timer";
+			compatible = "allwinner,sun4i-a10-timer";
 			reg = <0x01c20c00 0x90>;
 			interrupts = <22>;
 			clocks = <&osc24M>;
diff --git a/arch/arm/boot/dts/sun5i-a13.dtsi b/arch/arm/boot/dts/sun5i-a13.dtsi
index 320335a..f5cba63 100644
--- a/arch/arm/boot/dts/sun5i-a13.dtsi
+++ b/arch/arm/boot/dts/sun5i-a13.dtsi
@@ -329,7 +329,7 @@
 		};
 
 		timer@01c20c00 {
-			compatible = "allwinner,sun4i-timer";
+			compatible = "allwinner,sun4i-a10-timer";
 			reg = <0x01c20c00 0x90>;
 			interrupts = <22>;
 			clocks = <&osc24M>;
diff --git a/arch/arm/boot/dts/sun6i-a31.dtsi b/arch/arm/boot/dts/sun6i-a31.dtsi
index 5256ad9..996fff5 100644
--- a/arch/arm/boot/dts/sun6i-a31.dtsi
+++ b/arch/arm/boot/dts/sun6i-a31.dtsi
@@ -231,7 +231,7 @@
 		};
 
 		timer@01c20c00 {
-			compatible = "allwinner,sun4i-timer";
+			compatible = "allwinner,sun4i-a10-timer";
 			reg = <0x01c20c00 0xa0>;
 			interrupts = <0 18 4>,
 				     <0 19 4>,
diff --git a/arch/arm/boot/dts/sun7i-a20.dtsi b/arch/arm/boot/dts/sun7i-a20.dtsi
index 119f066..4bc5c6f 100644
--- a/arch/arm/boot/dts/sun7i-a20.dtsi
+++ b/arch/arm/boot/dts/sun7i-a20.dtsi
@@ -435,7 +435,7 @@
 		};
 
 		timer@01c20c00 {
-			compatible = "allwinner,sun4i-timer";
+			compatible = "allwinner,sun4i-a10-timer";
 			reg = <0x01c20c00 0x90>;
 			interrupts = <0 22 4>,
 				     <0 23 4>,
-- 
1.7.9.5

