Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984Ab3I3PNz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 11:13:55 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:50817 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755942Ab3I3PNu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 11:13:50 -0400
From: Joel Fernandes <joelf@ti.com>
To: Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Benoit Cousson <bcousson@baylibre.com>
CC: Joel Fernandes <joelf@ti.com>, Tony Lindgren <tony@atomide.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        "open list:OMAP DEVICE TREE..." <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 2/9] omap4: dts: Add node for DES3DES module
Date: Mon, 30 Sep 2013 10:12:59 -0500
Message-ID: <1380553986-15910-3-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1380553986-15910-1-git-send-email-joelf@ti.com>
References: <1380553986-15910-1-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OMAP4 has an DES3DES  module that uses the omap-des crypto driver.
Add DT entries for the same.

Signed-off-by: Joel Fernandes <joelf@ti.com>
---
 arch/arm/boot/dts/omap4.dtsi | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm/boot/dts/omap4.dtsi b/arch/arm/boot/dts/omap4.dtsi
index 16a44d6..6be1f56 100644
--- a/arch/arm/boot/dts/omap4.dtsi
+++ b/arch/arm/boot/dts/omap4.dtsi
@@ -672,5 +672,14 @@
 			dmas = <&sdma 111>, <&sdma 110>;
 			dma-names = "tx", "rx";
 		};
+
+		des: des@480a5000 {
+			compatible = "ti,omap4-des";
+			ti,hwmods = "des";
+			reg = <0x480a5000 0xa0>;
+			interrupts = <GIC_SPI 82 IRQ_TYPE_LEVEL_HIGH>;
+			dmas = <&sdma 117>, <&sdma 116>;
+			dma-names = "tx", "rx";
+		};
 	};
 };
-- 
1.8.1.2

