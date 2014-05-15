Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215AbaEOPPd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 11:15:33 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:37823 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754523AbaEOPPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 11:15:32 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        <linux-arm-kernel@lists.infradead.org>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        <linux-kernel@vger.kernel.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 1/2] ARM: at91/dt: add DMA controller node to at91sam9rl
Date: Thu, 15 May 2014 17:15:23 +0200
Message-ID: <47a342121566bca0025a20a57282fb72c990ce09.1400166895.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/boot/dts/at91sam9rl.dtsi | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm/boot/dts/at91sam9rl.dtsi b/arch/arm/boot/dts/at91sam9rl.dtsi
index 6e6e87dd0c92..412617084cfd 100644
--- a/arch/arm/boot/dts/at91sam9rl.dtsi
+++ b/arch/arm/boot/dts/at91sam9rl.dtsi
@@ -348,6 +348,15 @@
 				};
 			};
 
+			dma0: dma-controller@ffffe600 {
+				compatible = "atmel,at91sam9rl-dma";
+				reg = <0xffffe600 0x200>;
+				interrupts = <21 IRQ_TYPE_LEVEL_HIGH 0>;
+				#dma-cells = <2>;
+				clocks = <&dma0_clk>;
+				clock-names = "dma_clk";
+			};
+
 			ramc0: ramc@ffffea00 {
 				compatible = "atmel,at91sam9260-sdramc";
 				reg = <0xffffea00 0x200>;
-- 
1.8.2.2

