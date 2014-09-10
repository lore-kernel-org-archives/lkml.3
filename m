Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551AbaIJT4t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 15:56:49 -0400
Received: from www.linutronix.de ([62.245.132.108]:35659 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360AbaIJT4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 15:56:47 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, tony@atomide.com, balbi@ti.com,
        gregkh@linuxfoundation.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        devicetree@vger.kernel.org
Subject: [PATCH 15/16] arm: dts: dra7: add DMA properties for UART
Date: Wed, 10 Sep 2014 21:30:10 +0200
Message-Id: <1410377411-26656-16-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410377411-26656-1-git-send-email-bigeasy@linutronix.de>
References: <1410377411-26656-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: devicetree@vger.kernel.org
Reviewed-by: Tony Lindgren <tony@atomide.com>
Tested-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 arch/arm/boot/dts/dra7.dtsi | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm/boot/dts/dra7.dtsi b/arch/arm/boot/dts/dra7.dtsi
index d678152db4cb..f273e3811f75 100644
--- a/arch/arm/boot/dts/dra7.dtsi
+++ b/arch/arm/boot/dts/dra7.dtsi
@@ -332,6 +332,8 @@
 			ti,hwmods = "uart1";
 			clock-frequency = <48000000>;
 			status = "disabled";
+			dmas = <&sdma 49>, <&sdma 50>;
+			dma-names = "tx", "rx";
 		};
 
 		uart2: serial@4806c000 {
@@ -341,6 +343,8 @@
 			ti,hwmods = "uart2";
 			clock-frequency = <48000000>;
 			status = "disabled";
+			dmas = <&sdma 51>, <&sdma 52>;
+			dma-names = "tx", "rx";
 		};
 
 		uart3: serial@48020000 {
@@ -350,6 +354,8 @@
 			ti,hwmods = "uart3";
 			clock-frequency = <48000000>;
 			status = "disabled";
+			dmas = <&sdma 53>, <&sdma 54>;
+			dma-names = "tx", "rx";
 		};
 
 		uart4: serial@4806e000 {
@@ -359,6 +365,8 @@
 			ti,hwmods = "uart4";
 			clock-frequency = <48000000>;
                         status = "disabled";
+			dmas = <&sdma 55>, <&sdma 56>;
+			dma-names = "tx", "rx";
 		};
 
 		uart5: serial@48066000 {
@@ -368,6 +376,8 @@
 			ti,hwmods = "uart5";
 			clock-frequency = <48000000>;
 			status = "disabled";
+			dmas = <&sdma 63>, <&sdma 64>;
+			dma-names = "tx", "rx";
 		};
 
 		uart6: serial@48068000 {
@@ -377,6 +387,8 @@
 			ti,hwmods = "uart6";
 			clock-frequency = <48000000>;
 			status = "disabled";
+			dmas = <&sdma 79>, <&sdma 80>;
+			dma-names = "tx", "rx";
 		};
 
 		uart7: serial@48420000 {
-- 
2.1.0

