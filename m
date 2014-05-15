Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312AbaEOPPy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 11:15:54 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:37851 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506AbaEOPPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 11:15:53 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        <linux-arm-kernel@lists.infradead.org>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        <linux-kernel@vger.kernel.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 2/2] ARM: at91/dt: add NAND + DMA property for at91sam9rl
Date: Thu, 15 May 2014 17:15:24 +0200
Message-ID: <e1b405979615b46321a63df3f91f1998763b22fe.1400166895.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <47a342121566bca0025a20a57282fb72c990ce09.1400166895.git.nicolas.ferre@atmel.com>
References: <47a342121566bca0025a20a57282fb72c990ce09.1400166895.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the "atmel,nand-has-dma" property to NAND node

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/boot/dts/at91sam9rl.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/at91sam9rl.dtsi b/arch/arm/boot/dts/at91sam9rl.dtsi
index 412617084cfd..f21163c7dc2b 100644
--- a/arch/arm/boot/dts/at91sam9rl.dtsi
+++ b/arch/arm/boot/dts/at91sam9rl.dtsi
@@ -95,6 +95,7 @@
 			      <0xffffe800 0x200>;
 			atmel,nand-addr-offset = <21>;
 			atmel,nand-cmd-offset = <22>;
+			atmel,nand-has-dma;
 			pinctrl-names = "default";
 			pinctrl-0 = <&pinctrl_nand>;
 			gpios = <&pioD 17 GPIO_ACTIVE_HIGH>,
-- 
1.8.2.2

