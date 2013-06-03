Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758182Ab3FCNn0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 09:43:26 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:63643 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758110Ab3FCNnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 09:43:19 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, ulf.hansson@linaro.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 11/21] ARM: ux500: Supply the MSP (Audio) clocks lookup to the DBX500 DT
Date: Mon,  3 Jun 2013 14:42:35 +0100
Message-Id: <1370266965-7901-12-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1370266965-7901-1-git-send-email-lee.jones@linaro.org>
References: <1370266965-7901-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/dbx5x0.dtsi |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/arm/boot/dts/dbx5x0.dtsi b/arch/arm/boot/dts/dbx5x0.dtsi
index e5a5e9f..4701e75 100644
--- a/arch/arm/boot/dts/dbx5x0.dtsi
+++ b/arch/arm/boot/dts/dbx5x0.dtsi
@@ -773,6 +773,10 @@
 			reg = <0x80123000 0x1000>;
 			interrupts = <0 31 0x4>;
 			v-ape-supply = <&db8500_vape_reg>;
+
+			clocks = <&clk 86>, <&clk 43>;
+			clock-names = "msp0", "apb_pclk";
+
 			status = "disabled";
 		};
 
@@ -781,6 +785,10 @@
 			reg = <0x80124000 0x1000>;
 			interrupts = <0 62 0x4>;
 			v-ape-supply = <&db8500_vape_reg>;
+
+			clocks = <&clk 87>, <&clk 44>;
+			clock-names = "msp1", "apb_pclk";
+
 			status = "disabled";
 		};
 
@@ -790,6 +798,10 @@
 			reg = <0x80117000 0x1000>;
 			interrupts = <0 98 0x4>;
 			v-ape-supply = <&db8500_vape_reg>;
+
+			clocks = <&clk 95>, <&clk 57>;
+			clock-names = "msp2", "apb_pclk";
+
 			status = "disabled";
 		};
 
@@ -798,6 +810,10 @@
 			reg = <0x80125000 0x1000>;
 			interrupts = <0 62 0x4>;
 			v-ape-supply = <&db8500_vape_reg>;
+
+			clocks = <&clk 92>, <&clk 51>;
+			clock-names = "msp3", "apb_pclk";
+
 			status = "disabled";
 		};
 
-- 
1.7.10.4

