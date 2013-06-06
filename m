Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933424Ab3FFM0e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 08:26:34 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:36596 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933317Ab3FFMRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 08:17:40 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 05/33] ARM: ux500: Supply the GPIO clocks lookup to the DBX500 DT
Date: Thu,  6 Jun 2013 13:16:53 +0100
Message-Id: <1370521041-32318-6-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1370521041-32318-1-git-send-email-lee.jones@linaro.org>
References: <1370521041-32318-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/dbx5x0.dtsi |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/arm/boot/dts/dbx5x0.dtsi b/arch/arm/boot/dts/dbx5x0.dtsi
index 18c5c27..928ef56 100644
--- a/arch/arm/boot/dts/dbx5x0.dtsi
+++ b/arch/arm/boot/dts/dbx5x0.dtsi
@@ -78,6 +78,8 @@
 			gpio-controller;
 			#gpio-cells = <2>;
 			gpio-bank = <0>;
+
+			clocks = <&prcc_pclk 1 9>;
 		};
 
 		gpio1: gpio@8012e080 {
@@ -91,6 +93,8 @@
 			gpio-controller;
 			#gpio-cells = <2>;
 			gpio-bank = <1>;
+
+			clocks = <&prcc_pclk 1 9>;
 		};
 
 		gpio2: gpio@8000e000 {
@@ -104,6 +108,8 @@
 			gpio-controller;
 			#gpio-cells = <2>;
 			gpio-bank = <2>;
+
+			clocks = <&prcc_pclk 3 8>;
 		};
 
 		gpio3: gpio@8000e080 {
@@ -117,6 +123,8 @@
 			gpio-controller;
 			#gpio-cells = <2>;
 			gpio-bank = <3>;
+
+			clocks = <&prcc_pclk 3 8>;
 		};
 
 		gpio4: gpio@8000e100 {
@@ -130,6 +138,8 @@
 			gpio-controller;
 			#gpio-cells = <2>;
 			gpio-bank = <4>;
+
+			clocks = <&prcc_pclk 3 8>;
 		};
 
 		gpio5: gpio@8000e180 {
@@ -143,6 +153,8 @@
 			gpio-controller;
 			#gpio-cells = <2>;
 			gpio-bank = <5>;
+
+			clocks = <&prcc_pclk 3 8>;
 		};
 
 		gpio6: gpio@8011e000 {
@@ -156,6 +168,8 @@
 			gpio-controller;
 			#gpio-cells = <2>;
 			gpio-bank = <6>;
+
+			clocks = <&prcc_pclk 2 1>;
 		};
 
 		gpio7: gpio@8011e080 {
@@ -169,6 +183,8 @@
 			gpio-controller;
 			#gpio-cells = <2>;
 			gpio-bank = <7>;
+
+			clocks = <&prcc_pclk 2 1>;
 		};
 
 		gpio8: gpio@a03fe000 {
@@ -182,6 +198,8 @@
 			gpio-controller;
 			#gpio-cells = <2>;
 			gpio-bank = <8>;
+
+			clocks = <&prcc_pclk 6 1>;
 		};
 
 		pinctrl {
-- 
1.7.10.4

