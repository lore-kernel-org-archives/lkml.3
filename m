Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058AbaG2TB2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 15:01:28 -0400
Received: from www.linutronix.de ([62.245.132.108]:50360 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549AbaG2TAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 15:00:18 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, tony@atomide.com, balbi@ti.com,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [RFC PATCH 6/7] arm: dts: dra7: add DMA properties for UART
Date: Tue, 29 Jul 2014 20:59:03 +0200
Message-Id: <1406660344-25307-7-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1406660344-25307-1-git-send-email-bigeasy@linutronix.de>
References: <1406660344-25307-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 arch/arm/boot/dts/dra7.dtsi | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm/boot/dts/dra7.dtsi b/arch/arm/boot/dts/dra7.dtsi
index 10066f4..a904561 100644
--- a/arch/arm/boot/dts/dra7.dtsi
+++ b/arch/arm/boot/dts/dra7.dtsi
@@ -259,6 +259,8 @@
 			ti,hwmods = "uart1";
 			clock-frequency = <48000000>;
 			status = "disabled";
+			dmas = <&sdma 49>, <&sdma 50>;
+			dma-names = "tx", "rx";
 		};
 
 		uart2: serial@4806c000 {
@@ -268,6 +270,8 @@
 			ti,hwmods = "uart2";
 			clock-frequency = <48000000>;
 			status = "disabled";
+			dmas = <&sdma 51>, <&sdma 52>;
+			dma-names = "tx", "rx";
 		};
 
 		uart3: serial@48020000 {
@@ -277,6 +281,8 @@
 			ti,hwmods = "uart3";
 			clock-frequency = <48000000>;
 			status = "disabled";
+			dmas = <&sdma 53>, <&sdma 54>;
+			dma-names = "tx", "rx";
 		};
 
 		uart4: serial@4806e000 {
@@ -286,6 +292,8 @@
 			ti,hwmods = "uart4";
 			clock-frequency = <48000000>;
                         status = "disabled";
+			dmas = <&sdma 55>, <&sdma 56>;
+			dma-names = "tx", "rx";
 		};
 
 		uart5: serial@48066000 {
@@ -295,6 +303,8 @@
 			ti,hwmods = "uart5";
 			clock-frequency = <48000000>;
 			status = "disabled";
+			dmas = <&sdma 63>, <&sdma 64>;
+			dma-names = "tx", "rx";
 		};
 
 		uart6: serial@48068000 {
@@ -304,6 +314,8 @@
 			ti,hwmods = "uart6";
 			clock-frequency = <48000000>;
 			status = "disabled";
+			dmas = <&sdma 79>, <&sdma 80>;
+			dma-names = "tx", "rx";
 		};
 
 		uart7: serial@48420000 {
-- 
2.0.1

