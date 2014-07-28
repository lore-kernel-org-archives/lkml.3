Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752254AbaG1VRm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 17:17:42 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:33662 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752139AbaG1VRi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 17:17:38 -0400
From: Felipe Balbi <balbi@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        <bcousson@baylibre.com>, <linux@arm.linux.org.uk>,
        <khilman@deeprootsystems.com>, <tglx@linutronix.de>,
        <jason@lakedaemon.net>, <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH 20/35] arm: boot: dts: omap2/3/am33xx: drop ti,intc-size
Date: Mon, 28 Jul 2014 16:16:08 -0500
Message-ID: <1406582183-696-21-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 2.0.1.563.g66f467c
In-Reply-To: <1406582183-696-1-git-send-email-balbi@ti.com>
References: <1406582183-696-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

we are now infering number of IRQ lines based
on correct compatible flag, which renders this
binding completely useless.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 arch/arm/boot/dts/am33xx.dtsi | 1 -
 arch/arm/boot/dts/omap2.dtsi  | 1 -
 arch/arm/boot/dts/omap3.dtsi  | 1 -
 3 files changed, 3 deletions(-)

diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
index ddaa4ae..1f8b836 100644
--- a/arch/arm/boot/dts/am33xx.dtsi
+++ b/arch/arm/boot/dts/am33xx.dtsi
@@ -136,7 +136,6 @@
 			compatible = "ti,am33xx-intc";
 			interrupt-controller;
 			#interrupt-cells = <1>;
-			ti,intc-size = <128>;
 			reg = <0x48200000 0x1000>;
 		};
 
diff --git a/arch/arm/boot/dts/omap2.dtsi b/arch/arm/boot/dts/omap2.dtsi
index 8f8c07d..59d1c29 100644
--- a/arch/arm/boot/dts/omap2.dtsi
+++ b/arch/arm/boot/dts/omap2.dtsi
@@ -75,7 +75,6 @@
 			compatible = "ti,omap2-intc";
 			interrupt-controller;
 			#interrupt-cells = <1>;
-			ti,intc-size = <96>;
 			reg = <0x480FE000 0x1000>;
 		};
 
diff --git a/arch/arm/boot/dts/omap3.dtsi b/arch/arm/boot/dts/omap3.dtsi
index b693929..ff953c9 100644
--- a/arch/arm/boot/dts/omap3.dtsi
+++ b/arch/arm/boot/dts/omap3.dtsi
@@ -143,7 +143,6 @@
 			compatible = "ti,omap3-intc";
 			interrupt-controller;
 			#interrupt-cells = <1>;
-			ti,intc-size = <96>;
 			reg = <0x48200000 0x1000>;
 		};
 
-- 
2.0.1.563.g66f467c

