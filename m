Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933404Ab3FFMRw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 08:17:52 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:40139 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933364Ab3FFMRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 08:17:47 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 09/33] ARM: ux500: Supply the I2C clocks lookup to the DBX500 DT
Date: Thu,  6 Jun 2013 13:16:57 +0100
Message-Id: <1370521041-32318-10-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1370521041-32318-1-git-send-email-lee.jones@linaro.org>
References: <1370521041-32318-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/dbx5x0.dtsi |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/arm/boot/dts/dbx5x0.dtsi b/arch/arm/boot/dts/dbx5x0.dtsi
index d682ea0..e49c679 100644
--- a/arch/arm/boot/dts/dbx5x0.dtsi
+++ b/arch/arm/boot/dts/dbx5x0.dtsi
@@ -572,6 +572,8 @@
 			v-i2c-supply = <&db8500_vape_reg>;
 
 			clock-frequency = <400000>;
+			clocks = <&prcc_kclk 3 3>, <&prcc_pclk 3 3>;
+			clock-names = "nmk-i2c.0", "apb_pclk";
 		};
 
 		i2c@80122000 {
@@ -585,6 +587,9 @@
 			v-i2c-supply = <&db8500_vape_reg>;
 
 			clock-frequency = <400000>;
+
+			clocks = <&prcc_kclk 1 2>, <&prcc_pclk 1 2>;
+			clock-names = "nmk-i2c.1", "apb_pclk";
 		};
 
 		i2c@80128000 {
@@ -598,6 +603,9 @@
 			v-i2c-supply = <&db8500_vape_reg>;
 
 			clock-frequency = <400000>;
+
+			clocks = <&prcc_kclk 1 6>, <&prcc_pclk 1 6>;
+			clock-names = "nmk-i2c.2", "apb_pclk";
 		};
 
 		i2c@80110000 {
@@ -611,6 +619,9 @@
 			v-i2c-supply = <&db8500_vape_reg>;
 
 			clock-frequency = <400000>;
+
+			clocks = <&prcc_kclk 2 0>, <&prcc_pclk 2 0>;
+			clock-names = "nmk-i2c.3", "apb_pclk";
 		};
 
 		i2c@8012a000 {
@@ -624,6 +635,9 @@
 			v-i2c-supply = <&db8500_vape_reg>;
 
 			clock-frequency = <400000>;
+
+			clocks = <&prcc_kclk 1 9>, <&prcc_pclk 1 9>;
+			clock-names = "nmk-i2c.4", "apb_pclk";
 		};
 
 		ssp@80002000 {
-- 
1.7.10.4

