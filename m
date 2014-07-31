Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756510AbaGaKTi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 06:19:38 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:59299 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302AbaGaKTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 06:19:36 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: <nsekhar@ti.com>, <robh+dt@kernel.org>
CC: <khilman@deeprootsystems.com>, <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>,
        <davinci-linux-open-source@linux.davincidsp.com>, <pawel.moll@arm.com>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/6] ARM: DTS: da850: Add node for edma0
Date: Thu, 31 Jul 2014 13:18:50 +0300
Message-ID: <1406801934-23334-3-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <1406801934-23334-1-git-send-email-peter.ujfalusi@ti.com>
References: <1406801934-23334-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add DT node for edma0.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 arch/arm/boot/dts/da850.dtsi | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm/boot/dts/da850.dtsi b/arch/arm/boot/dts/da850.dtsi
index b695548dbb4e..41ce4e8bf227 100644
--- a/arch/arm/boot/dts/da850.dtsi
+++ b/arch/arm/boot/dts/da850.dtsi
@@ -150,6 +150,12 @@
 			};
 
 		};
+		edma0: edma@01c00000 {
+			compatible = "ti,edma3";
+			reg =	<0x0 0x10000>;
+			interrupts = <11 13 12>;
+			#dma-cells = <1>;
+		};
 		serial0: serial@1c42000 {
 			compatible = "ns16550a";
 			reg = <0x42000 0x100>;
-- 
2.0.2

