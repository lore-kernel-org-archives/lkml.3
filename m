Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753142Ab3JETFK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 15:05:10 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:45518 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752371Ab3JETFG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 15:05:06 -0400
From: Joel Fernandes <joelf@ti.com>
To: Mark Rutland <mark.rutland@arm.com>,
        Benoit Cousson <bcousson@baylibre.com>
CC: Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Joel Fernandes <joelf@ti.com>
Subject: [PATCH v3 3/3] ARM: dts: AM33XX: Fix AES interrupt number
Date: Sat, 5 Oct 2013 14:04:37 -0500
Message-ID: <1380999877-20884-4-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1380999877-20884-1-git-send-email-joelf@ti.com>
References: <1380999877-20884-1-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AES interrupts were previously not used, but after recent changes to omap-aes
driver, its being used. We correct the interrupt number to have working PIO
mode.

Signed-off-by: Joel Fernandes <joelf@ti.com>
---
 arch/arm/boot/dts/am33xx.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
index 2664da9..5c2d6c1 100644
--- a/arch/arm/boot/dts/am33xx.dtsi
+++ b/arch/arm/boot/dts/am33xx.dtsi
@@ -724,7 +724,7 @@
 			compatible = "ti,omap4-aes";
 			ti,hwmods = "aes";
 			reg = <0x53500000 0xa0>;
-			interrupts = <102>;
+			interrupts = <103>;
 			dmas = <&edma 6>,
 			       <&edma 5>;
 			dma-names = "tx", "rx";
-- 
1.8.1.2

