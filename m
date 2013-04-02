Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760185Ab3DBElG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 00:41:06 -0400
Received: from server.prisktech.co.nz ([115.188.14.127]:54152 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760129Ab3DBElC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 00:41:02 -0400
From: Tony Prisk <linux@prisktech.co.nz>
To: linus.walleij@linaro.org
Cc: swarren@wwwdotorg.org, linux-arm-kernel@lists.infradead.org,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        linux-kernel@vger.kernel.org, Tony Prisk <linux@prisktech.co.nz>
Subject: [PATCHv4 4/6] arm: dts: vt8500: Update Wondermedia SoC dtsi files for pinctrl driver
Date: Tue,  2 Apr 2013 17:40:59 +1300
Message-Id: <1364877661-26086-5-git-send-email-linux@prisktech.co.nz>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1364877661-26086-1-git-send-email-linux@prisktech.co.nz>
References: <1364877661-26086-1-git-send-email-linux@prisktech.co.nz>
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

