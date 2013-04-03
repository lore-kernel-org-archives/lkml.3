Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762544Ab3DCGY6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 02:24:58 -0400
Received: from server.prisktech.co.nz ([115.188.14.127]:60012 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762493Ab3DCGY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 02:24:56 -0400
From: Tony Prisk <linux@prisktech.co.nz>
To: linus.walleij@linaro.org
Cc: robherring2@gmail.com, swarren@wwwdotorg.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        Tony Prisk <linux@prisktech.co.nz>
Subject: [PATCHv5 5/7] arm: dts: vt8500: Update Wondermedia SoC dtsi files for pinctrl driver
Date: Wed,  3 Apr 2013 19:24:49 +1300
Message-Id: <1364970291-17721-6-git-send-email-linux@prisktech.co.nz>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1364970291-17721-1-git-send-email-linux@prisktech.co.nz>
References: <1364970291-17721-1-git-send-email-linux@prisktech.co.nz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds pinctrl nodes to the VIA VT8500 and Wondermedia SoC dtsi
files to support the pinctrl driver.

Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
---
 arch/arm/boot/dts/vt8500.dtsi |    9 +++++++++
 arch/arm/boot/dts/wm8505.dtsi |    9 +++++++++
 arch/arm/boot/dts/wm8650.dtsi |    9 +++++++++
 arch/arm/boot/dts/wm8850.dtsi |    9 +++++++++
 4 files changed, 36 insertions(+)

diff --git a/arch/arm/boot/dts/vt8500.dtsi b/arch/arm/boot/dts/vt8500.dtsi
index cf31ced..8e87aa9 100644
--- a/arch/arm/boot/dts/vt8500.dtsi
+++ b/arch/arm/boot/dts/vt8500.dtsi
@@ -32,6 +32,15 @@
 			#gpio-cells = <3>;
 		};
 
+		pinctrl: pinctrl@d8110000 {
+			compatible = "via,vt8500-pinctrl";
+			reg = <0xd8110000 0x10000>;
+			interrupt-controller;
+			#interrupt-cells = <2>;
+			gpio-controller;
+			#gpio-cells = <2>;
+		};
+
 		pmc@d8130000 {
 			compatible = "via,vt8500-pmc";
 			reg = <0xd8130000 0x1000>;
diff --git a/arch/arm/boot/dts/wm8505.dtsi b/arch/arm/boot/dts/wm8505.dtsi
index e74a1c0..e4f768a 100644
--- a/arch/arm/boot/dts/wm8505.dtsi
+++ b/arch/arm/boot/dts/wm8505.dtsi
@@ -47,6 +47,15 @@
 			#gpio-cells = <3>;
 		};
 
+		pinctrl: pinctrl@d8110000 {
+			compatible = "wm,wm8505-pinctrl";
+			reg = <0xd8110000 0x10000>;
+			interrupt-controller;
+			#interrupt-cells = <2>;
+			gpio-controller;
+			#gpio-cells = <2>;
+		};
+
 		pmc@d8130000 {
 			compatible = "via,vt8500-pmc";
 			reg = <0xd8130000 0x1000>;
diff --git a/arch/arm/boot/dts/wm8650.dtsi b/arch/arm/boot/dts/wm8650.dtsi
index db3c0a1..01b6a8d 100644
--- a/arch/arm/boot/dts/wm8650.dtsi
+++ b/arch/arm/boot/dts/wm8650.dtsi
@@ -41,6 +41,15 @@
 			#gpio-cells = <3>;
 		};
 
+		pinctrl: pinctrl@d8110000 {
+			compatible = "wm,wm8650-pinctrl";
+			reg = <0xd8110000 0x10000>;
+			interrupt-controller;
+			#interrupt-cells = <2>;
+			gpio-controller;
+			#gpio-cells = <2>;
+		};
+
 		pmc@d8130000 {
 			compatible = "via,vt8500-pmc";
 			reg = <0xd8130000 0x1000>;
diff --git a/arch/arm/boot/dts/wm8850.dtsi b/arch/arm/boot/dts/wm8850.dtsi
index e8cbfdc..297aa05 100644
--- a/arch/arm/boot/dts/wm8850.dtsi
+++ b/arch/arm/boot/dts/wm8850.dtsi
@@ -48,6 +48,15 @@
 			#gpio-cells = <3>;
 		};
 
+		pinctrl: pinctrl@d8110000 {
+			compatible = "wm,wm8850-pinctrl";
+			reg = <0xd8110000 0x10000>;
+			interrupt-controller;
+			#interrupt-cells = <2>;
+			gpio-controller;
+			#gpio-cells = <2>;
+		};
+
 		pmc@d8130000 {
 			compatible = "via,vt8500-pmc";
 			reg = <0xd8130000 0x1000>;
-- 
1.7.9.5

