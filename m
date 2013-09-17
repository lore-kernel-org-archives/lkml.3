Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872Ab3IQTbm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 15:31:42 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:43818 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753706Ab3IQTbj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 15:31:39 -0400
From: Suman Anna <s-anna@ti.com>
To: Benoit Cousson <bcousson@baylibre.com>
CC: Ohad Ben-Cohen <ohad@wizery.com>, Tony Lindgren <tony@atomide.com>,
        Kumar Gala <galak@codeaurora.org>, Paul Walmsley <paul@pwsan.com>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Suman Anna <s-anna@ti.com>
Subject: [PATCHv2 5/9] ARM: dts: OMAP5: Add hwspinlock node
Date: Tue, 17 Sep 2013 14:31:06 -0500
Message-ID: <4ee33d847bd5fbf4e164cddbb69d15292f2ed3c3.1379445653.git.s-anna@ti.com>
X-Mailer: git-send-email 1.8.3.3
In-Reply-To: <cover.1379445653.git.s-anna@ti.com>
References: <cover.1379445653.git.s-anna@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the hwspinlock device tree node for OMAP5 SoCs.

Signed-off-by: Suman Anna <s-anna@ti.com>
---
 arch/arm/boot/dts/omap5.dtsi | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm/boot/dts/omap5.dtsi b/arch/arm/boot/dts/omap5.dtsi
index 07be2cd..449be92 100644
--- a/arch/arm/boot/dts/omap5.dtsi
+++ b/arch/arm/boot/dts/omap5.dtsi
@@ -276,6 +276,12 @@
 			ti,hwmods = "i2c5";
 		};
 
+		hwspinlock: spinlock@4a0f6000 {
+			compatible = "ti,omap4-hwspinlock";
+			reg = <0x4a0f6000 0x1000>;
+			ti,hwmods = "spinlock";
+		};
+
 		mcspi1: spi@48098000 {
 			compatible = "ti,omap4-mcspi";
 			reg = <0x48098000 0x200>;
-- 
1.8.3.3

