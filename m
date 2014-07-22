Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868AbaGVOHw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 10:07:52 -0400
Received: from top.free-electrons.com ([176.31.233.9]:33778 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752205AbaGVOHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 10:07:51 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH] ARM: at91/dt: sam9x5: fix ADC compatible string
Date: Tue, 22 Jul 2014 16:07:47 +0200
Message-Id: <1406038067-14697-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the correct compatible string for the ADC of the at91sam9x5 family of SoCs.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/boot/dts/at91sam9x5.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/at91sam9x5.dtsi b/arch/arm/boot/dts/at91sam9x5.dtsi
index 2c0d6ea3ab41..5d7cf394f537 100644
--- a/arch/arm/boot/dts/at91sam9x5.dtsi
+++ b/arch/arm/boot/dts/at91sam9x5.dtsi
@@ -964,7 +964,7 @@
 			adc0: adc@f804c000 {
 				#address-cells = <1>;
 				#size-cells = <0>;
-				compatible = "atmel,at91sam9260-adc";
+				compatible = "atmel,at91sam9x5-adc";
 				reg = <0xf804c000 0x100>;
 				interrupts = <19 IRQ_TYPE_LEVEL_HIGH 0>;
 				clocks = <&adc_clk>,
-- 
1.9.1

