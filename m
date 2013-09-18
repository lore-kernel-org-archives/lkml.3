Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495Ab3IRMXI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 08:23:08 -0400
Received: from mail-ea0-f175.google.com ([209.85.215.175]:52402 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577Ab3IRMPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 08:15:00 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@linaro.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 11/41] ARM: ux500: Supply the I2C clocks lookup to the DBX500 DT
Date: Wed, 18 Sep 2013 13:14:08 +0100
Message-Id: <1379506478-16625-12-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379506478-16625-1-git-send-email-lee.jones@linaro.org>
References: <1379506478-16625-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/dbx5x0.dtsi | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/arm/boot/dts/dbx5x0.dtsi b/arch/arm/boot/dts/dbx5x0.dtsi
index 5e91063..0742e55 100644
--- a/arch/arm/boot/dts/dbx5x0.dtsi
+++ b/arch/arm/boot/dts/dbx5x0.dtsi
@@ -577,6 +577,8 @@
 			v-i2c-supply = <&db8500_vape_reg>;
 
 			clock-frequency = <400000>;
+			clocks = <&prcc_kclk 3 3>, <&prcc_pclk 3 3>;
+			clock-names = "i2cclk", "apb_pclk";
 		};
 
 		i2c@80122000 {
@@ -590,6 +592,9 @@
 			v-i2c-supply = <&db8500_vape_reg>;
 
 			clock-frequency = <400000>;
+
+			clocks = <&prcc_kclk 1 2>, <&prcc_pclk 1 2>;
+			clock-names = "i2cclk", "apb_pclk";
 		};
 
 		i2c@80128000 {
@@ -603,6 +608,9 @@
 			v-i2c-supply = <&db8500_vape_reg>;
 
 			clock-frequency = <400000>;
+
+			clocks = <&prcc_kclk 1 6>, <&prcc_pclk 1 6>;
+			clock-names = "i2cclk", "apb_pclk";
 		};
 
 		i2c@80110000 {
@@ -616,6 +624,9 @@
 			v-i2c-supply = <&db8500_vape_reg>;
 
 			clock-frequency = <400000>;
+
+			clocks = <&prcc_kclk 2 0>, <&prcc_pclk 2 0>;
+			clock-names = "i2cclk", "apb_pclk";
 		};
 
 		i2c@8012a000 {
@@ -629,6 +640,9 @@
 			v-i2c-supply = <&db8500_vape_reg>;
 
 			clock-frequency = <400000>;
+
+			clocks = <&prcc_kclk 1 9>, <&prcc_pclk 1 9>;
+			clock-names = "i2cclk", "apb_pclk";
 		};
 
 		ssp@80002000 {
-- 
1.8.1.2

