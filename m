Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759577Ab3HNIgZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 04:36:25 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:49428 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756769Ab3HNIf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 04:35:57 -0400
From: Ruslan Bilovol <ruslan.bilovol@ti.com>
To: bcousson@baylibre.com
Cc: linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        uri.y@variscite.com, nm@ti.com
Subject: [PATCH v2 2/2] arm: dts: omap4: configure connection to PMIC on Variscite's SOM
Date: Wed, 14 Aug 2013 11:35:48 +0300
Message-Id: <1376469348-10797-3-git-send-email-ruslan.bilovol@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1376469348-10797-1-git-send-email-ruslan.bilovol@ti.com>
References: <1376469348-10797-1-git-send-email-ruslan.bilovol@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now when typical OMAP4 to PMIC connection is figured out
into separate .dtsi file, ve can configure properly OMAP4
pins connected to TWL6030 just including one.

Signed-off-by: Ruslan Bilovol <ruslan.bilovol@ti.com>
---
 arch/arm/boot/dts/omap4-var-som.dts |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/omap4-var-som.dts b/arch/arm/boot/dts/omap4-var-som.dts
index b41269e..6f0b763 100644
--- a/arch/arm/boot/dts/omap4-var-som.dts
+++ b/arch/arm/boot/dts/omap4-var-som.dts
@@ -40,6 +40,7 @@
 };
 
 #include "twl6030.dtsi"
+#include "twl6030_omap4.dtsi"
 
 &i2c2 {
 	clock-frequency = <400000>;
-- 
1.7.9.5

