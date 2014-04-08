Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756321AbaDHJVS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 05:21:18 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:48569 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbaDHJVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 05:21:15 -0400
From: Johan Hovold <jhovold@gmail.com>
To: =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>
Cc: Jon Hunter <jon-hunter@ti.com>, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Johan Hovold <jhovold@gmail.com>
Subject: [PATCH] ARM: dts: OMAP2+: remove uses of obsolete gpmc,device-nand
Date: Tue,  8 Apr 2014 11:20:17 +0200
Message-Id: <1396948817-29362-1-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove all remaining uses of gpmc,device-nand that have been added since
the property was removed by commit f40739faba8e ("ARM: dts: OMAP2+:
Simplify NAND support").

Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 arch/arm/boot/dts/am335x-igep0033.dtsi  | 1 -
 arch/arm/boot/dts/omap3-devkit8000.dts  | 1 -
 arch/arm/boot/dts/omap3-lilly-a83x.dtsi | 1 -
 3 files changed, 3 deletions(-)

diff --git a/arch/arm/boot/dts/am335x-igep0033.dtsi b/arch/arm/boot/dts/am335x-igep0033.dtsi
index 7063311a58d9..06c822a48b71 100644
--- a/arch/arm/boot/dts/am335x-igep0033.dtsi
+++ b/arch/arm/boot/dts/am335x-igep0033.dtsi
@@ -118,7 +118,6 @@
 		reg = <0 0 0>; /* CS0, offset 0 */
 		nand-bus-width = <8>;
 		ti,nand-ecc-opt = "bch8";
-		gpmc,device-nand = "true";
 		gpmc,device-width = <1>;
 		gpmc,sync-clk-ps = <0>;
 		gpmc,cs-on-ns = <0>;
diff --git a/arch/arm/boot/dts/omap3-devkit8000.dts b/arch/arm/boot/dts/omap3-devkit8000.dts
index bf5a515a3247..da402f0fdab4 100644
--- a/arch/arm/boot/dts/omap3-devkit8000.dts
+++ b/arch/arm/boot/dts/omap3-devkit8000.dts
@@ -112,7 +112,6 @@
 		reg = <0 0 0>; /* CS0, offset 0 */
 		nand-bus-width = <16>;
 
-		gpmc,device-nand;
 		gpmc,sync-clk-ps = <0>;
 		gpmc,cs-on-ns = <0>;
 		gpmc,cs-rd-off-ns = <44>;
diff --git a/arch/arm/boot/dts/omap3-lilly-a83x.dtsi b/arch/arm/boot/dts/omap3-lilly-a83x.dtsi
index 6369d9f43ca2..cc1dce6978f5 100644
--- a/arch/arm/boot/dts/omap3-lilly-a83x.dtsi
+++ b/arch/arm/boot/dts/omap3-lilly-a83x.dtsi
@@ -368,7 +368,6 @@
 		/* no elm on omap3 */
 
 		gpmc,mux-add-data = <0>;
-		gpmc,device-nand;
 		gpmc,device-width = <2>;
 		gpmc,wait-pin = <0>;
 		gpmc,wait-monitoring-ns = <0>;
-- 
1.8.3.2

