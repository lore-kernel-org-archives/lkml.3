Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933710Ab3FFMYa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 08:24:30 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:48260 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933394Ab3FFMRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 08:17:51 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 12/33] ARM: ux500: Supply the MSP (Audio) clocks lookup to the DBX500 DT
Date: Thu,  6 Jun 2013 13:17:00 +0100
Message-Id: <1370521041-32318-13-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1370521041-32318-1-git-send-email-lee.jones@linaro.org>
References: <1370521041-32318-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/dbx5x0.dtsi |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/arm/boot/dts/dbx5x0.dtsi b/arch/arm/boot/dts/dbx5x0.dtsi
index 6b9c3a4..e4ce16b 100644
--- a/arch/arm/boot/dts/dbx5x0.dtsi
+++ b/arch/arm/boot/dts/dbx5x0.dtsi
@@ -781,6 +781,10 @@
 			reg = <0x80123000 0x1000>;
 			interrupts = <0 31 IRQ_TYPE_LEVEL_HIGH>;
 			v-ape-supply = <&db8500_vape_reg>;
+
+			clocks = <&prcc_kclk 1 3>, <&prcc_pclk 1 3>;
+			clock-names = "msp0", "apb_pclk";
+
 			status = "disabled";
 		};
 
@@ -789,6 +793,10 @@
 			reg = <0x80124000 0x1000>;
 			interrupts = <0 62 IRQ_TYPE_LEVEL_HIGH>;
 			v-ape-supply = <&db8500_vape_reg>;
+
+			clocks = <&prcc_kclk 1 4>, <&prcc_pclk 1 4>;
+			clock-names = "msp1", "apb_pclk";
+
 			status = "disabled";
 		};
 
@@ -798,6 +806,10 @@
 			reg = <0x80117000 0x1000>;
 			interrupts = <0 98 IRQ_TYPE_LEVEL_HIGH>;
 			v-ape-supply = <&db8500_vape_reg>;
+
+			clocks = <&prcc_kclk 2 3>, <&prcc_pclk 2 5>;
+			clock-names = "msp2", "apb_pclk";
+
 			status = "disabled";
 		};
 
@@ -806,6 +818,10 @@
 			reg = <0x80125000 0x1000>;
 			interrupts = <0 62 IRQ_TYPE_LEVEL_HIGH>;
 			v-ape-supply = <&db8500_vape_reg>;
+
+			clocks = <&prcc_kclk 1 10>, <&prcc_pclk 1 11>;
+			clock-names = "msp3", "apb_pclk";
+
 			status = "disabled";
 		};
 
-- 
1.7.10.4

