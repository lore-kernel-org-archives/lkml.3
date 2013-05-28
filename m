Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933562Ab3E1Iek (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 04:34:40 -0400
Received: from atlantis.wh2.tu-dresden.de ([141.30.228.39]:54661 "EHLO
	atlantis.wh2.tu-dresden.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933478Ab3E1Ieh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 04:34:37 -0400
X-Greylist: delayed 555 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 May 2013 04:34:37 EDT
From: Lars Poeschel <larsi@wh2.tu-dresden.de>
To: poeschel@lemonage.de, b-cousson@ti.com, tony@atomide.com,
        linux@arm.linux.org.uk, linux-omap@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] dts: am33xx: Correct properties on gpmc node
Date: Tue, 28 May 2013 10:24:57 +0200
Message-Id: <1369729497-11897-1-git-send-email-larsi@wh2.tu-dresden.de>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Poeschel <poeschel@lemonage.de>

The gpmc driver is actually looking for "gpmc,num-cs" and
"gpmc,num-waitpins" properties in DT. The binding doc also states
this.
Correct the properties in the dts to provide the right values for the
gpmc driver.

Signed-off-by: Lars Poeschel <poeschel@lemonage.de>
---
 arch/arm/boot/dts/am33xx.dtsi |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
index 1460d9b..8e1248f 100644
--- a/arch/arm/boot/dts/am33xx.dtsi
+++ b/arch/arm/boot/dts/am33xx.dtsi
@@ -409,8 +409,8 @@
 			ti,hwmods = "gpmc";
 			reg = <0x50000000 0x2000>;
 			interrupts = <100>;
-			num-cs = <7>;
-			num-waitpins = <2>;
+			gpmc,num-cs = <7>;
+			gpmc,num-waitpins = <2>;
 			#address-cells = <2>;
 			#size-cells = <1>;
 			status = "disabled";
-- 
1.7.10.4

