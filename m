Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758334Ab3FCNqH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 09:46:07 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:57589 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757733Ab3FCNnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 09:43:18 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, ulf.hansson@linaro.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 10/21] ARM: ux500: Supply the SDI (MMC) clocks lookup to the DBX500 DT
Date: Mon,  3 Jun 2013 14:42:34 +0100
Message-Id: <1370266965-7901-11-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1370266965-7901-1-git-send-email-lee.jones@linaro.org>
References: <1370266965-7901-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/dbx5x0.dtsi |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/arch/arm/boot/dts/dbx5x0.dtsi b/arch/arm/boot/dts/dbx5x0.dtsi
index f2fe7d9..e5a5e9f 100644
--- a/arch/arm/boot/dts/dbx5x0.dtsi
+++ b/arch/arm/boot/dts/dbx5x0.dtsi
@@ -710,6 +710,9 @@
 			       <&dma 32 0 0x0>; /* Logical - MemToDev */
 			dma-names = "rx", "tx";
 
+			clocks = <&clk 96>, <&clk 58>;
+			clock-names = "sdi1", "apb_pclk";
+
 			status = "disabled";
 		};
 
@@ -722,6 +725,9 @@
 			       <&dma 28 0 0x0>; /* Logical - MemToDev */
 			dma-names = "rx", "tx";
 
+			clocks = <&clk 101>, <&clk 68>;
+			clock-names = "sdi2", "apb_pclk";
+
 			status = "disabled";
 		};
 
@@ -729,6 +735,10 @@
 			compatible = "arm,pl18x", "arm,primecell";
 			reg = <0x80119000 0x1000>;
 			interrupts = <0 59 0x4>;
+
+			clocks = <&clk 97>, <&clk 59>;
+			clock-names = "sdi3", "apb_pclk";
+
 			status = "disabled";
 		};
 
@@ -741,6 +751,9 @@
 			       <&dma 42 0 0x0>; /* Logical - MemToDev */
 			dma-names = "rx", "tx";
 
+			clocks = <&clk 94>, <&clk 56>;
+			clock-names = "sdi4", "apb_pclk";
+
 			status = "disabled";
 		};
 
@@ -748,6 +761,10 @@
 			compatible = "arm,pl18x", "arm,primecell";
 			reg = <0x80008000 0x1000>;
 			interrupts = <0 100 0x4>;
+
+			clocks = <&clk 104>, <&clk 71>;
+			clock-names = "sdi5", "apb_pclk";
+
 			status = "disabled";
 		};
 
-- 
1.7.10.4

