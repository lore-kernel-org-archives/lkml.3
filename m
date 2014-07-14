Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752761AbaGNDId (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 23:08:33 -0400
Received: from nasmtp01.atmel.com ([192.199.1.246]:14131 "EHLO
	DVREDG02.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752550AbaGNDIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 23:08:24 -0400
From: Bo Shen <voice.shen@atmel.com>
To: <nicolas.ferre@atmel.com>
CC: <boris.brezillon@free-electrons.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Bo Shen <voice.shen@atmel.com>
Subject: [PATCH] ARM: at91: at91sam9x5: correct typo error for ohci clock
Date: Mon, 14 Jul 2014 11:08:14 +0800
Message-ID: <1405307294-17708-1-git-send-email-voice.shen@atmel.com>
X-Mailer: git-send-email 1.8.5.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct the typo error for the second "uhphs_clk".

Signed-off-by: Bo Shen <voice.shen@atmel.com>
---
 arch/arm/boot/dts/at91sam9x5.dtsi | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/at91sam9x5.dtsi b/arch/arm/boot/dts/at91sam9x5.dtsi
index 2ebc421..727d3a4 100644
--- a/arch/arm/boot/dts/at91sam9x5.dtsi
+++ b/arch/arm/boot/dts/at91sam9x5.dtsi
@@ -1155,8 +1155,7 @@
 			compatible = "atmel,at91rm9200-ohci", "usb-ohci";
 			reg = <0x00600000 0x100000>;
 			interrupts = <22 IRQ_TYPE_LEVEL_HIGH 2>;
-			clocks = <&usb>, <&uhphs_clk>, <&udphs_clk>,
-				 <&uhpck>;
+			clocks = <&usb>, <&uhphs_clk>, <&uhphs_clk>, <&uhpck>;
 			clock-names = "usb_clk", "ohci_clk", "hclk", "uhpck";
 			status = "disabled";
 		};
-- 
1.8.5.2

