Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758422Ab3FCNqa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 09:46:30 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:43635 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757979Ab3FCNnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 09:43:16 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, ulf.hansson@linaro.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 09/21] ARM: ux500: Supply the UART clocks lookup to the DBX500 DT
Date: Mon,  3 Jun 2013 14:42:33 +0100
Message-Id: <1370266965-7901-10-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1370266965-7901-1-git-send-email-lee.jones@linaro.org>
References: <1370266965-7901-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/dbx5x0.dtsi |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm/boot/dts/dbx5x0.dtsi b/arch/arm/boot/dts/dbx5x0.dtsi
index 659865d..f2fe7d9 100644
--- a/arch/arm/boot/dts/dbx5x0.dtsi
+++ b/arch/arm/boot/dts/dbx5x0.dtsi
@@ -650,6 +650,9 @@
 			       <&dma 13 0 0x0>; /* Logical - MemToDev */
 			dma-names = "rx", "tx";
 
+			clocks = <&clk 83>, <&clk 40>;
+			clock-names = "uart0", "apb_pclk";
+
 			status = "disabled";
 		};
 
@@ -662,6 +665,9 @@
 			       <&dma 12 0 0x0>; /* Logical - MemToDev */
 			dma-names = "rx", "tx";
 
+			clocks = <&clk 84>, <&clk 41>;
+			clock-names = "uart1", "apb_pclk";
+
 			status = "disabled";
 		};
 
@@ -674,6 +680,9 @@
 			       <&dma 11 0 0x0>; /* Logical - MemToDev */
 			dma-names = "rx", "tx";
 
+			clocks = <&clk 103>, <&clk 70>;
+			clock-names = "uart2", "apb_pclk";
+
 			status = "disabled";
 		};
 
@@ -686,6 +695,9 @@
 			       <&dma 29 0 0x0>; /* Logical - MemToDev */
 			dma-names = "rx", "tx";
 
+			clocks = <&clk 88>, <&clk 45>;
+			clock-names = "uart3", "apb_pclk";
+
 			status = "disabled";
 		};
 
-- 
1.7.10.4

