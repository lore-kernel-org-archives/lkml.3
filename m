Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933729AbaDIOCn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 10:02:43 -0400
Received: from top.free-electrons.com ([176.31.233.9]:60838 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933339AbaDINva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 09:51:30 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Randy Dunlap <rdunlap@infradead.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        =?UTF-8?q?Emilio=20L=C3=B3pez?= <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH 03/15] ARM: sunxi: dt: add pinctrl clock-names properties
Date: Wed,  9 Apr 2014 15:51:06 +0200
Message-Id: <1397051478-4113-4-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1397051478-4113-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1397051478-4113-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add clock-names property to pinctrl node definitions.

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
---
 arch/arm/boot/dts/sun4i-a10.dtsi  | 1 +
 arch/arm/boot/dts/sun5i-a10s.dtsi | 1 +
 arch/arm/boot/dts/sun5i-a13.dtsi  | 1 +
 arch/arm/boot/dts/sun6i-a31.dtsi  | 1 +
 arch/arm/boot/dts/sun7i-a20.dtsi  | 1 +
 5 files changed, 5 insertions(+)

diff --git a/arch/arm/boot/dts/sun4i-a10.dtsi b/arch/arm/boot/dts/sun4i-a10.dtsi
index 7753be0..4e33447 100644
--- a/arch/arm/boot/dts/sun4i-a10.dtsi
+++ b/arch/arm/boot/dts/sun4i-a10.dtsi
@@ -342,6 +342,7 @@
 			reg = <0x01c20800 0x400>;
 			interrupts = <28>;
 			clocks = <&apb0_gates 5>;
+			clock-names = "pio_clk";
 			gpio-controller;
 			interrupt-controller;
 			#address-cells = <1>;
diff --git a/arch/arm/boot/dts/sun5i-a10s.dtsi b/arch/arm/boot/dts/sun5i-a10s.dtsi
index ee17b1c..b823bc1 100644
--- a/arch/arm/boot/dts/sun5i-a10s.dtsi
+++ b/arch/arm/boot/dts/sun5i-a10s.dtsi
@@ -305,6 +305,7 @@
 			reg = <0x01c20800 0x400>;
 			interrupts = <28>;
 			clocks = <&apb0_gates 5>;
+			clock-names = "pio_clk";
 			gpio-controller;
 			interrupt-controller;
 			#address-cells = <1>;
diff --git a/arch/arm/boot/dts/sun5i-a13.dtsi b/arch/arm/boot/dts/sun5i-a13.dtsi
index 3490ef9..914e3c2 100644
--- a/arch/arm/boot/dts/sun5i-a13.dtsi
+++ b/arch/arm/boot/dts/sun5i-a13.dtsi
@@ -286,6 +286,7 @@
 			reg = <0x01c20800 0x400>;
 			interrupts = <28>;
 			clocks = <&apb0_gates 5>;
+			clock-names = "pio_clk";
 			gpio-controller;
 			interrupt-controller;
 			#address-cells = <1>;
diff --git a/arch/arm/boot/dts/sun6i-a31.dtsi b/arch/arm/boot/dts/sun6i-a31.dtsi
index 38d43fe..3858424 100644
--- a/arch/arm/boot/dts/sun6i-a31.dtsi
+++ b/arch/arm/boot/dts/sun6i-a31.dtsi
@@ -206,6 +206,7 @@
 				     <0 16 4>,
 				     <0 17 4>;
 			clocks = <&apb1_gates 5>;
+			clock-names = "pio_clk";
 			gpio-controller;
 			interrupt-controller;
 			#address-cells = <1>;
diff --git a/arch/arm/boot/dts/sun7i-a20.dtsi b/arch/arm/boot/dts/sun7i-a20.dtsi
index cadcf2f..38ab782 100644
--- a/arch/arm/boot/dts/sun7i-a20.dtsi
+++ b/arch/arm/boot/dts/sun7i-a20.dtsi
@@ -368,6 +368,7 @@
 			reg = <0x01c20800 0x400>;
 			interrupts = <0 28 4>;
 			clocks = <&apb0_gates 5>;
+			clock-names = "pio_clk";
 			gpio-controller;
 			interrupt-controller;
 			#address-cells = <1>;
-- 
1.8.3.2

