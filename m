Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756045Ab3I3POK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 11:14:10 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:50845 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756006Ab3I3POF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 11:14:05 -0400
From: Joel Fernandes <joelf@ti.com>
To: Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Benoit Cousson <bcousson@baylibre.com>
CC: Joel Fernandes <joelf@ti.com>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 7/9] ARM: am437x: dts: Add DES node for am437x
Date: Mon, 30 Sep 2013 10:13:04 -0500
Message-ID: <1380553986-15910-8-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1380553986-15910-1-git-send-email-joelf@ti.com>
References: <1380553986-15910-1-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AM437x SoC has a DES3DES module similar to the one on OMAP4.
Add DT node for the same.

Signed-off-by: Joel Fernandes <joelf@ti.com>
---
 arch/arm/boot/dts/am4372.dtsi | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm/boot/dts/am4372.dtsi b/arch/arm/boot/dts/am4372.dtsi
index 7e9ff75..a403172 100644
--- a/arch/arm/boot/dts/am4372.dtsi
+++ b/arch/arm/boot/dts/am4372.dtsi
@@ -418,5 +418,12 @@
 			reg = <0x53501000 0xa0>;
 			interrupts = <GIC_SPI 103 IRQ_TYPE_LEVEL_HIGH>;
 		};
+
+		des: des@53701000 {
+			compatible = "ti,omap4-des";
+			ti,hwmods = "des";
+			reg = <0x53701000 0xa0>;
+			interrupts = <GIC_SPI 130 IRQ_TYPE_LEVEL_HIGH>;
+		};
 	};
 };
-- 
1.8.1.2

