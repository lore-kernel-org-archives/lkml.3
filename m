Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932123Ab3ICRxW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 13:53:22 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:35104 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760214Ab3ICRxI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 13:53:08 -0400
From: Suman Anna <s-anna@ti.com>
To: Benoit Cousson <bcousson@baylibre.com>
CC: Ohad Ben-Cohen <ohad@wizery.com>, Tony Lindgren <tony@atomide.com>,
        Kumar Gala <galak@codeaurora.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Suman Anna <s-anna@ti.com>
Subject: [PATCH 2/2] ARM: dts: OMAP4: Add hwspinlock node
Date: Tue, 3 Sep 2013 12:52:52 -0500
Message-ID: <1378230772-54967-1-git-send-email-s-anna@ti.com>
X-Mailer: git-send-email 1.8.3.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the hwspinlock device tree node for OMAP4 family
of SoCs.

Signed-off-by: Suman Anna <s-anna@ti.com>
---
 arch/arm/boot/dts/omap4.dtsi | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm/boot/dts/omap4.dtsi b/arch/arm/boot/dts/omap4.dtsi
index 22d9f2b..a8cc274 100644
--- a/arch/arm/boot/dts/omap4.dtsi
+++ b/arch/arm/boot/dts/omap4.dtsi
@@ -248,6 +248,12 @@
 			clock-frequency = <48000000>;
 		};
 
+		hwspinlock: spinlock@4a0f6000 {
+			compatible = "ti,omap4-hwspinlock";
+			reg = <0x4a0f6000 0x1000>;
+			ti,hwmods = "spinlock";
+		};
+
 		i2c1: i2c@48070000 {
 			compatible = "ti,omap4-i2c";
 			reg = <0x48070000 0x100>;
-- 
1.8.3.3

