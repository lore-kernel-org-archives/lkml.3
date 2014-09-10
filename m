Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610AbaIJT5c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 15:57:32 -0400
Received: from www.linutronix.de ([62.245.132.108]:35678 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701AbaIJT5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 15:57:30 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, tony@atomide.com, balbi@ti.com,
        gregkh@linuxfoundation.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        devicetree@vger.kernel.org
Subject: [PATCH 14/16] arm: dts: am33xx: add DMA properties for UART
Date: Wed, 10 Sep 2014 21:30:09 +0200
Message-Id: <1410377411-26656-15-git-send-email-bigeasy@linutronix.de>
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
 arch/arm/boot/dts/am33xx.dtsi | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
index 3a0a161342ba..078a760a4a21 100644
--- a/arch/arm/boot/dts/am33xx.dtsi
+++ b/arch/arm/boot/dts/am33xx.dtsi
@@ -200,6 +200,8 @@
 			reg = <0x44e09000 0x2000>;
 			interrupts = <72>;
 			status = "disabled";
+			dmas = <&edma 26>, <&edma 27>;
+			dma-names = "tx", "rx";
 		};
 
 		uart1: serial@48022000 {
@@ -209,6 +211,8 @@
 			reg = <0x48022000 0x2000>;
 			interrupts = <73>;
 			status = "disabled";
+			dmas = <&edma 28>, <&edma 29>;
+			dma-names = "tx", "rx";
 		};
 
 		uart2: serial@48024000 {
@@ -218,6 +222,8 @@
 			reg = <0x48024000 0x2000>;
 			interrupts = <74>;
 			status = "disabled";
+			dmas = <&edma 30>, <&edma 31>;
+			dma-names = "tx", "rx";
 		};
 
 		uart3: serial@481a6000 {
-- 
2.1.0

