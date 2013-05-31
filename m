Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756715Ab3EaPqB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 11:46:01 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:51050 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753051Ab3EaPpx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 11:45:53 -0400
From: Dan Murphy <dmurphy@ti.com>
To: <b-cousson@ti.com>, <tony@atomide.com>, <linux@arm.linux.org.uk>
CC: <linux-omap@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Dan Murphy <dmurphy@ti.com>
Subject: [PATCH v1] ARM: dts: omap4-panda: Update the twl6040 gpio to macro definition
Date: Fri, 31 May 2013 10:45:22 -0500
Message-ID: <1370015122-26792-1-git-send-email-dmurphy@ti.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the dt property ti,audpwron-gpio to use the
gpio macro definition for GPIO_ACTIVE_HIGH.

Signed-off-by: Dan Murphy <dmurphy@ti.com>
---
 arch/arm/boot/dts/omap4-panda-common.dtsi |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/boot/dts/omap4-panda-common.dtsi b/arch/arm/boot/dts/omap4-panda-common.dtsi
index 800fa4e..00cbaa5 100644
--- a/arch/arm/boot/dts/omap4-panda-common.dtsi
+++ b/arch/arm/boot/dts/omap4-panda-common.dtsi
@@ -190,7 +190,7 @@
 		/* IRQ# = 119 */
 		interrupts = <GIC_SPI 119 IRQ_TYPE_LEVEL_HIGH>; /* IRQ_SYS_2N cascaded to gic */
 		interrupt-parent = <&gic>;
-		ti,audpwron-gpio = <&gpio4 31 0>;  /* gpio line 127 */
+		ti,audpwron-gpio = <&gpio4 31 GPIO_ACTIVE_HIGH>;  /* gpio line 127 */
 
 		vio-supply = <&v1v8>;
 		v2v1-supply = <&v2v1>;
-- 
1.7.5.4

