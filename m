Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759111AbaEMHol (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 03:44:41 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:45292 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759003AbaEMHog (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 03:44:36 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: <nsekhar@ti.com>, <joelf@ti.com>
CC: <linux@arm.linux.org.uk>, <vinod.koul@intel.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <tony@atomide.com>,
        <bcousson@baylibre.com>
Subject: [PATCH 4/4] ARM: dts: am4372: Remove obsolete properties from edma node
Date: Tue, 13 May 2014 10:43:48 +0300
Message-ID: <1399967028-24757-5-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1399967028-24757-1-git-send-email-peter.ujfalusi@ti.com>
References: <1399967028-24757-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dma-channels, ti,edma-regions and ti,edma-slots no longer needed in DT since
the the same information is available in the IP's CCCFG register.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 arch/arm/boot/dts/am4372.dtsi | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/arm/boot/dts/am4372.dtsi b/arch/arm/boot/dts/am4372.dtsi
index 03a225505126..b9f83b705f4b 100644
--- a/arch/arm/boot/dts/am4372.dtsi
+++ b/arch/arm/boot/dts/am4372.dtsi
@@ -108,9 +108,6 @@
 					<GIC_SPI 13 IRQ_TYPE_LEVEL_HIGH>,
 					<GIC_SPI 14 IRQ_TYPE_LEVEL_HIGH>;
 			#dma-cells = <1>;
-			dma-channels = <64>;
-			ti,edma-regions = <4>;
-			ti,edma-slots = <256>;
 		};
 
 		uart0: serial@44e09000 {
-- 
1.9.3

