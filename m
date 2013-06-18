Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388Ab3FRGkR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 02:40:17 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:59555 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753072Ab3FRGjX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 02:39:23 -0400
From: Joel A Fernandes <joelagnel@ti.com>
To: Tony Lindgren <tony@atomide.com>, Sekhar Nori <nsekhar@ti.com>,
        Matt Porter <matt@ohporter.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>, Rob Landley <rob@landley.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jason Kridner <jkridner@beagleboard.org>,
        Koen Kooi <koen@beagleboard.org>
CC: Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Arnd Bergmann <arnd@arndb.de>, Joel A Fernandes <joelagnel@ti.com>
Subject: [PATCH v11 5/8] ARM: dts: add AM33XX SPI DMA support
Date: Tue, 18 Jun 2013 01:38:16 -0500
Message-ID: <1371537499-12970-6-git-send-email-joelagnel@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1371537499-12970-1-git-send-email-joelagnel@ti.com>
References: <1371537499-12970-1-git-send-email-joelagnel@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Porter <mporter@ti.com>

Adds DMA resources to the AM33XX SPI nodes.

Signed-off-by: Matt Porter <mporter@ti.com>
Signed-off-by: Joel A Fernandes <joelagnel@ti.com>
---
 arch/arm/boot/dts/am33xx.dtsi |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
index 3d59bb3..fb17103 100644
--- a/arch/arm/boot/dts/am33xx.dtsi
+++ b/arch/arm/boot/dts/am33xx.dtsi
@@ -361,6 +361,11 @@
 			interrupts = <65>;
 			ti,spi-num-cs = <2>;
 			ti,hwmods = "spi0";
+			dmas = <&edma 16
+				&edma 17
+				&edma 18
+				&edma 19>;
+			dma-names = "tx0", "rx0", "tx1", "rx1";
 			status = "disabled";
 		};
 
@@ -372,6 +377,11 @@
 			interrupts = <125>;
 			ti,spi-num-cs = <2>;
 			ti,hwmods = "spi1";
+			dmas = <&edma 42
+				&edma 43
+				&edma 44
+				&edma 45>;
+			dma-names = "tx0", "rx0", "tx1", "rx1";
 			status = "disabled";
 		};
 
-- 
1.7.9.5

