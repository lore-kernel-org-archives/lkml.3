Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933920AbaEMKbR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:31:17 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:50140 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933373AbaEMKbN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 06:31:13 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: <nsekhar@ti.com>, <joelf@ti.com>
CC: <linux@arm.linux.org.uk>, <vinod.koul@intel.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <tony@atomide.com>,
        <bcousson@baylibre.com>
Subject: [PATCH v2 4/5] ARM: dts: am33xx: Remove obsolete properties from edma node
Date: Tue, 13 May 2014 13:30:31 +0300
Message-ID: <1399977032-26469-5-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1399977032-26469-1-git-send-email-peter.ujfalusi@ti.com>
References: <1399977032-26469-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dma-channels, ti,edma-regions and ti,edma-slots no longer needed in DT since
the the same information is available in the IP's CCCFG register.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 arch/arm/boot/dts/am33xx.dtsi | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
index baf56cc92040..5e8f647ee4ec 100644
--- a/arch/arm/boot/dts/am33xx.dtsi
+++ b/arch/arm/boot/dts/am33xx.dtsi
@@ -147,9 +147,6 @@
 				<0x44e10f90 0x10>;
 			interrupts = <12 13 14>;
 			#dma-cells = <1>;
-			dma-channels = <64>;
-			ti,edma-regions = <4>;
-			ti,edma-slots = <256>;
 		};
 
 		gpio0: gpio@44e07000 {
-- 
1.9.3

