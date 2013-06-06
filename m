Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933656Ab3FFMZ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 08:25:26 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:34295 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933388Ab3FFMRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 08:17:50 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 11/33] ARM: ux500: Supply the SDI (MMC) clocks lookup to the DBX500 DT
Date: Thu,  6 Jun 2013 13:16:59 +0100
Message-Id: <1370521041-32318-12-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1370521041-32318-1-git-send-email-lee.jones@linaro.org>
References: <1370521041-32318-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/dbx5x0.dtsi |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/arch/arm/boot/dts/dbx5x0.dtsi b/arch/arm/boot/dts/dbx5x0.dtsi
index 8cfe5f1..6b9c3a4 100644
--- a/arch/arm/boot/dts/dbx5x0.dtsi
+++ b/arch/arm/boot/dts/dbx5x0.dtsi
@@ -703,6 +703,9 @@
 			       <&dma 29 0 0x0>; /* Logical - MemToDev */
 			dma-names = "rx", "tx";
 
+			clocks = <&prcc_kclk 1 5>, <&prcc_pclk 1 5>;
+			clock-names = "sdi0", "apb_pclk";
+
 			status = "disabled";
 		};
 
@@ -715,6 +718,9 @@
 			       <&dma 32 0 0x0>; /* Logical - MemToDev */
 			dma-names = "rx", "tx";
 
+			clocks = <&prcc_kclk 2 4>, <&prcc_pclk 2 6>;
+			clock-names = "sdi1", "apb_pclk";
+
 			status = "disabled";
 		};
 
@@ -727,6 +733,9 @@
 			       <&dma 28 0 0x0>; /* Logical - MemToDev */
 			dma-names = "rx", "tx";
 
+			clocks = <&prcc_kclk 3 4>, <&prcc_pclk 3 4>;
+			clock-names = "sdi2", "apb_pclk";
+
 			status = "disabled";
 		};
 
@@ -734,6 +743,10 @@
 			compatible = "arm,pl18x", "arm,primecell";
 			reg = <0x80119000 0x1000>;
 			interrupts = <0 59 IRQ_TYPE_LEVEL_HIGH>;
+
+			clocks = <&prcc_kclk 2 5>, <&prcc_pclk 2 7>;
+			clock-names = "sdi3", "apb_pclk";
+
 			status = "disabled";
 		};
 
@@ -746,6 +759,9 @@
 			       <&dma 42 0 0x0>; /* Logical - MemToDev */
 			dma-names = "rx", "tx";
 
+			clocks = <&prcc_kclk 2 2>, <&prcc_pclk 2 4>;
+			clock-names = "sdi4", "apb_pclk";
+
 			status = "disabled";
 		};
 
@@ -753,6 +769,10 @@
 			compatible = "arm,pl18x", "arm,primecell";
 			reg = <0x80008000 0x1000>;
 			interrupts = <0 100 IRQ_TYPE_LEVEL_HIGH>;
+
+			clocks = <&prcc_kclk 3 7>, <&prcc_pclk 3 7>;
+			clock-names = "sdi5", "apb_pclk";
+
 			status = "disabled";
 		};
 
-- 
1.7.10.4

