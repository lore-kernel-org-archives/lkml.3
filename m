Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257AbaCGMSK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 07:18:10 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:44369 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753061AbaCGMRx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 07:17:53 -0500
From: Sricharan R <r.sricharan@ti.com>
To: <r.sricharan@ti.com>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <dmaengine@vger.kernel.org>
CC: <santosh.shilimkar@ti.com>, <rnayak@ti.com>, <nsekhar@ti.com>,
        <tony@atomide.com>, <linux@arm.linux.org.uk>, <vinod.koul@intel.com>,
        <dan.j.williams@intel.com>, <nm@ti.com>
Subject: [RFC PATCH 9/9] arm: dts: dra7: Change the total dma-req numbers to crossbar channels
Date: Fri, 7 Mar 2014 17:46:16 +0530
Message-ID: <1394194576-23741-10-git-send-email-r.sricharan@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1394194576-23741-1-git-send-email-r.sricharan@ti.com>
References: <1394194576-23741-1-git-send-email-r.sricharan@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On DRA7 there is a crossbar router which maps the peripheral
dma request channels to the dma controller inputs. The
dma-controller can receive requests from any of the crossbar
channels. So register the total number crossbar channels instead
of the shared dma-request lines.

Signed-off-by: Sricharan R <r.sricharan@ti.com>
---
 arch/arm/boot/dts/dra7.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/dra7.dtsi b/arch/arm/boot/dts/dra7.dtsi
index baa781e..f5ae8c9 100644
--- a/arch/arm/boot/dts/dra7.dtsi
+++ b/arch/arm/boot/dts/dra7.dtsi
@@ -167,7 +167,7 @@
 				     <GIC_SPI 15 IRQ_TYPE_LEVEL_HIGH>;
 			#dma-cells = <2>;
 			#dma-channels = <32>;
-			#dma-requests = <127>;
+			#dma-requests = <203>;
 		};
 
 		dmacb: crossbar@4a020000 {
-- 
1.7.9.5

