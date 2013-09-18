Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794Ab3IRMPM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 08:15:12 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:49957 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752697Ab3IRMPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 08:15:03 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@linaro.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 14/41] ARM: ux500: Supply the MSP (Audio) clocks lookup to the DBX500 DT
Date: Wed, 18 Sep 2013 13:14:11 +0100
Message-Id: <1379506478-16625-15-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379506478-16625-1-git-send-email-lee.jones@linaro.org>
References: <1379506478-16625-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/dbx5x0.dtsi | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/arm/boot/dts/dbx5x0.dtsi b/arch/arm/boot/dts/dbx5x0.dtsi
index 75c0646..8857dd1 100644
--- a/arch/arm/boot/dts/dbx5x0.dtsi
+++ b/arch/arm/boot/dts/dbx5x0.dtsi
@@ -786,6 +786,10 @@
 			reg = <0x80123000 0x1000>;
 			interrupts = <0 31 IRQ_TYPE_LEVEL_HIGH>;
 			v-ape-supply = <&db8500_vape_reg>;
+
+			clocks = <&prcc_kclk 1 3>, <&prcc_pclk 1 3>;
+			clock-names = "msp", "apb_pclk";
+
 			status = "disabled";
 		};
 
@@ -794,6 +798,10 @@
 			reg = <0x80124000 0x1000>;
 			interrupts = <0 62 IRQ_TYPE_LEVEL_HIGH>;
 			v-ape-supply = <&db8500_vape_reg>;
+
+			clocks = <&prcc_kclk 1 4>, <&prcc_pclk 1 4>;
+			clock-names = "msp", "apb_pclk";
+
 			status = "disabled";
 		};
 
@@ -803,6 +811,10 @@
 			reg = <0x80117000 0x1000>;
 			interrupts = <0 98 IRQ_TYPE_LEVEL_HIGH>;
 			v-ape-supply = <&db8500_vape_reg>;
+
+			clocks = <&prcc_kclk 2 3>, <&prcc_pclk 2 5>;
+			clock-names = "msp", "apb_pclk";
+
 			status = "disabled";
 		};
 
@@ -811,6 +823,10 @@
 			reg = <0x80125000 0x1000>;
 			interrupts = <0 62 IRQ_TYPE_LEVEL_HIGH>;
 			v-ape-supply = <&db8500_vape_reg>;
+
+			clocks = <&prcc_kclk 1 10>, <&prcc_pclk 1 11>;
+			clock-names = "msp", "apb_pclk";
+
 			status = "disabled";
 		};
 
-- 
1.8.1.2

