Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760723Ab3DBEmf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 00:42:35 -0400
Received: from server.prisktech.co.nz ([115.188.14.127]:54858 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760143Ab3DBElD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 00:41:03 -0400
From: Tony Prisk <linux@prisktech.co.nz>
To: linus.walleij@linaro.org
Cc: swarren@wwwdotorg.org, linux-arm-kernel@lists.infradead.org,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        linux-kernel@vger.kernel.org, Tony Prisk <linux@prisktech.co.nz>
Subject: [PATCHv4 5/6] arm: vt8500: Remove gpio devicetree nodes
Date: Tue,  2 Apr 2013 17:41:00 +1300
Message-Id: <1364877661-26086-6-git-send-email-linux@prisktech.co.nz>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1364877661-26086-1-git-send-email-linux@prisktech.co.nz>
References: <1364877661-26086-1-git-send-email-linux@prisktech.co.nz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the gpio related devicetree nodes as these are no longer required
with the move to a combined pinctrl/gpio driver.

Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
---
 arch/arm/boot/dts/vt8500.dtsi |    7 -------
 arch/arm/boot/dts/wm8505.dtsi |    7 -------
 arch/arm/boot/dts/wm8650.dtsi |    7 -------
 arch/arm/boot/dts/wm8850.dtsi |    7 -------
 4 files changed, 28 deletions(-)

diff --git a/arch/arm/boot/dts/vt8500.dtsi b/arch/arm/boot/dts/vt8500.dtsi
index 8e87aa9..e1c3926 100644
--- a/arch/arm/boot/dts/vt8500.dtsi
+++ b/arch/arm/boot/dts/vt8500.dtsi
@@ -25,13 +25,6 @@
 			#interrupt-cells = <1>;
 		};
 
-		gpio: gpio-controller@d8110000 {
-			compatible = "via,vt8500-gpio";
-			gpio-controller;
-			reg = <0xd8110000 0x10000>;
-			#gpio-cells = <3>;
-		};
-
 		pinctrl: pinctrl@d8110000 {
 			compatible = "via,vt8500-pinctrl";
 			reg = <0xd8110000 0x10000>;
diff --git a/arch/arm/boot/dts/wm8505.dtsi b/arch/arm/boot/dts/wm8505.dtsi
index e4f768a..bb92ef8 100644
--- a/arch/arm/boot/dts/wm8505.dtsi
+++ b/arch/arm/boot/dts/wm8505.dtsi
@@ -40,13 +40,6 @@
 			interrupts = <56 57 58 59 60 61 62 63>;
 		};
 
-		gpio: gpio-controller@d8110000 {
-			compatible = "wm,wm8505-gpio";
-			gpio-controller;
-			reg = <0xd8110000 0x10000>;
-			#gpio-cells = <3>;
-		};
-
 		pinctrl: pinctrl@d8110000 {
 			compatible = "wm,wm8505-pinctrl";
 			reg = <0xd8110000 0x10000>;
diff --git a/arch/arm/boot/dts/wm8650.dtsi b/arch/arm/boot/dts/wm8650.dtsi
index 01b6a8d..bb4af58 100644
--- a/arch/arm/boot/dts/wm8650.dtsi
+++ b/arch/arm/boot/dts/wm8650.dtsi
@@ -34,13 +34,6 @@
 			interrupts = <56 57 58 59 60 61 62 63>;
 		};
 
-		gpio: gpio-controller@d8110000 {
-			compatible = "wm,wm8650-gpio";
-			gpio-controller;
-			reg = <0xd8110000 0x10000>;
-			#gpio-cells = <3>;
-		};
-
 		pinctrl: pinctrl@d8110000 {
 			compatible = "wm,wm8650-pinctrl";
 			reg = <0xd8110000 0x10000>;
diff --git a/arch/arm/boot/dts/wm8850.dtsi b/arch/arm/boot/dts/wm8850.dtsi
index 297aa05..11cd180 100644
--- a/arch/arm/boot/dts/wm8850.dtsi
+++ b/arch/arm/boot/dts/wm8850.dtsi
@@ -41,13 +41,6 @@
 			interrupts = <56 57 58 59 60 61 62 63>;
 		};
 
-		gpio: gpio-controller@d8110000 {
-			compatible = "wm,wm8650-gpio";
-			gpio-controller;
-			reg = <0xd8110000 0x10000>;
-			#gpio-cells = <3>;
-		};
-
 		pinctrl: pinctrl@d8110000 {
 			compatible = "wm,wm8850-pinctrl";
 			reg = <0xd8110000 0x10000>;
-- 
1.7.9.5

