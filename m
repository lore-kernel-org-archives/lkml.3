Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756506Ab3EOGne (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 02:43:34 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:49541 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754012Ab3EOGnc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 02:43:32 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <b-cousson@ti.com>, <tony@atomide.com>, <linux-omap@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
CC: <linux@arm.linux.org.uk>, Kishon Vijay Abraham I <kishon@ti.com>
Subject: [PATCH] ARM: dts: omap3 beagle: Add usb otg hs dt data
Date: Wed, 15 May 2013 12:12:41 +0530
Message-ID: <1368600161-10351-1-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added board specific dt data for omap3 beagle in omap3-beagle.dts
file.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 arch/arm/boot/dts/omap3-beagle.dts |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm/boot/dts/omap3-beagle.dts b/arch/arm/boot/dts/omap3-beagle.dts
index 6eec699..02bf5d0 100644
--- a/arch/arm/boot/dts/omap3-beagle.dts
+++ b/arch/arm/boot/dts/omap3-beagle.dts
@@ -142,3 +142,10 @@
 	 */
 	ti,pulldowns = <0x03a1c4>;
 };
+
+&usb_otg_hs {
+        interface-type = <0>;
+        usb-phy = <&usb2_phy>;
+        mode = <3>;
+        power = <50>;
+};
-- 
1.7.10.4

