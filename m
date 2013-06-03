Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758083Ab3FCNnR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 09:43:17 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:45186 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757733Ab3FCNnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 09:43:14 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, ulf.hansson@linaro.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 08/21] ARM: ux500: Supply the I2C clocks lookup to the DBX500 DT
Date: Mon,  3 Jun 2013 14:42:32 +0100
Message-Id: <1370266965-7901-9-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1370266965-7901-1-git-send-email-lee.jones@linaro.org>
References: <1370266965-7901-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/dbx5x0.dtsi |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/arm/boot/dts/dbx5x0.dtsi b/arch/arm/boot/dts/dbx5x0.dtsi
index 3acc528..659865d 100644
--- a/arch/arm/boot/dts/dbx5x0.dtsi
+++ b/arch/arm/boot/dts/dbx5x0.dtsi
@@ -559,6 +559,8 @@
 			v-i2c-supply = <&db8500_vape_reg>;
 
 			clock-frequency = <400000>;
+			clocks = <&clk 100>, <&clk 67>;
+			clock-names = "nmk-i2c.0", "apb_pclk";
 		};
 
 		i2c@80122000 {
@@ -572,6 +574,9 @@
 			v-i2c-supply = <&db8500_vape_reg>;
 
 			clock-frequency = <400000>;
+
+			clocks = <&clk 85>, <&clk 42>;
+			clock-names = "nmk-i2c.1", "apb_pclk";
 		};
 
 		i2c@80128000 {
@@ -585,6 +590,9 @@
 			v-i2c-supply = <&db8500_vape_reg>;
 
 			clock-frequency = <400000>;
+
+			clocks = <&clk 89>, <&clk 46>;
+			clock-names = "nmk-i2c.2", "apb_pclk";
 		};
 
 		i2c@80110000 {
@@ -598,6 +606,9 @@
 			v-i2c-supply = <&db8500_vape_reg>;
 
 			clock-frequency = <400000>;
+
+			clocks = <&clk 93>, <&clk 52>;
+			clock-names = "nmk-i2c.3", "apb_pclk";
 		};
 
 		i2c@8012a000 {
@@ -611,6 +622,9 @@
 			v-i2c-supply = <&db8500_vape_reg>;
 
 			clock-frequency = <400000>;
+
+			clocks = <&clk 91>, <&clk 50>;
+			clock-names = "nmk-i2c.4", "apb_pclk";
 		};
 
 		ssp@80002000 {
-- 
1.7.10.4

