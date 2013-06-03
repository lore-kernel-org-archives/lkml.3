Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758444Ab3FCNr2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 09:47:28 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:48983 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758006Ab3FCNnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 09:43:09 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, ulf.hansson@linaro.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 05/21] ARM: ux500: Supply the GPIO clocks lookup to the DBX500 DT
Date: Mon,  3 Jun 2013 14:42:29 +0100
Message-Id: <1370266965-7901-6-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1370266965-7901-1-git-send-email-lee.jones@linaro.org>
References: <1370266965-7901-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/dbx5x0.dtsi |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/arm/boot/dts/dbx5x0.dtsi b/arch/arm/boot/dts/dbx5x0.dtsi
index fe7cb84..fa3fd41 100644
--- a/arch/arm/boot/dts/dbx5x0.dtsi
+++ b/arch/arm/boot/dts/dbx5x0.dtsi
@@ -69,6 +69,8 @@
 			gpio-controller;
 			#gpio-cells = <2>;
 			gpio-bank = <0>;
+
+			clocks = <&clk 49>;
 		};
 
 		gpio1: gpio@8012e080 {
@@ -82,6 +84,8 @@
 			gpio-controller;
 			#gpio-cells = <2>;
 			gpio-bank = <1>;
+
+			clocks = <&clk 49>;
 		};
 
 		gpio2: gpio@8000e000 {
@@ -95,6 +99,8 @@
 			gpio-controller;
 			#gpio-cells = <2>;
 			gpio-bank = <2>;
+
+			clocks = <&clk 72>;
 		};
 
 		gpio3: gpio@8000e080 {
@@ -108,6 +114,8 @@
 			gpio-controller;
 			#gpio-cells = <2>;
 			gpio-bank = <3>;
+
+			clocks = <&clk 72>;
 		};
 
 		gpio4: gpio@8000e100 {
@@ -121,6 +129,8 @@
 			gpio-controller;
 			#gpio-cells = <2>;
 			gpio-bank = <4>;
+
+			clocks = <&clk 72>;
 		};
 
 		gpio5: gpio@8000e180 {
@@ -134,6 +144,8 @@
 			gpio-controller;
 			#gpio-cells = <2>;
 			gpio-bank = <5>;
+
+			clocks = <&clk 72>;
 		};
 
 		gpio6: gpio@8011e000 {
@@ -147,6 +159,8 @@
 			gpio-controller;
 			#gpio-cells = <2>;
 			gpio-bank = <6>;
+
+			clocks = <&clk 63>;
 		};
 
 		gpio7: gpio@8011e080 {
@@ -160,6 +174,8 @@
 			gpio-controller;
 			#gpio-cells = <2>;
 			gpio-bank = <7>;
+
+			clocks = <&clk 63>;
 		};
 
 		gpio8: gpio@a03fe000 {
@@ -173,6 +189,8 @@
 			gpio-controller;
 			#gpio-cells = <2>;
 			gpio-bank = <8>;
+
+			clocks = <&clk 74>;
 		};
 
 		pinctrl {
-- 
1.7.10.4

