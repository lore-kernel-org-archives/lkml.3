Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490Ab3IRMWe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 08:22:34 -0400
Received: from mail-ea0-f181.google.com ([209.85.215.181]:58095 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752669Ab3IRMPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 08:15:01 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@linaro.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 12/41] ARM: ux500: Supply the UART clocks lookup to the DBX500 DT
Date: Wed, 18 Sep 2013 13:14:09 +0100
Message-Id: <1379506478-16625-13-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379506478-16625-1-git-send-email-lee.jones@linaro.org>
References: <1379506478-16625-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/dbx5x0.dtsi | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm/boot/dts/dbx5x0.dtsi b/arch/arm/boot/dts/dbx5x0.dtsi
index 0742e55..13ea13e 100644
--- a/arch/arm/boot/dts/dbx5x0.dtsi
+++ b/arch/arm/boot/dts/dbx5x0.dtsi
@@ -663,6 +663,9 @@
 			       <&dma 13 0 0x0>; /* Logical - MemToDev */
 			dma-names = "rx", "tx";
 
+			clocks = <&prcc_kclk 1 0>, <&prcc_pclk 1 0>;
+			clock-names = "uart", "apb_pclk";
+
 			status = "disabled";
 		};
 
@@ -675,6 +678,9 @@
 			       <&dma 12 0 0x0>; /* Logical - MemToDev */
 			dma-names = "rx", "tx";
 
+			clocks = <&prcc_kclk 1 1>, <&prcc_pclk 1 1>;
+			clock-names = "uart", "apb_pclk";
+
 			status = "disabled";
 		};
 
@@ -687,6 +693,9 @@
 			       <&dma 11 0 0x0>; /* Logical - MemToDev */
 			dma-names = "rx", "tx";
 
+			clocks = <&prcc_kclk 3 6>, <&prcc_pclk 3 6>;
+			clock-names = "uart", "apb_pclk";
+
 			status = "disabled";
 		};
 
-- 
1.8.1.2

