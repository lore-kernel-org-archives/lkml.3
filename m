Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186AbbAVUlD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 15:41:03 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:43518 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754148AbbAVUjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 15:39:13 -0500
From: Marek Belisko <marek@goldelico.com>
To: bcousson@baylibre.com, tony@atomide.com
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        hns@goldelico.com, neilb@suse.de, NeilBrown <neil@brown.name>
Subject: [PATCH 08/13] ARM: dts: omap3-gta04: add comments about gpios
Date: Thu, 22 Jan 2015 21:38:14 +0100
Message-Id: <1421959099-28319-9-git-send-email-marek@goldelico.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421959099-28319-1-git-send-email-marek@goldelico.com>
References: <1421959099-28319-1-git-send-email-marek@goldelico.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: NeilBrown <neil@brown.name>

Add comments to state which GPIO is used for some interrupts.

Signed-off-by: NeilBrown <neil@brown.name>
---
 arch/arm/boot/dts/omap3-gta04.dtsi | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/omap3-gta04.dtsi b/arch/arm/boot/dts/omap3-gta04.dtsi
index 6f5fcbb..b65b5ed 100644
--- a/arch/arm/boot/dts/omap3-gta04.dtsi
+++ b/arch/arm/boot/dts/omap3-gta04.dtsi
@@ -229,7 +229,7 @@
 		compatible = "bosch,bmp085";
 		reg = <0x77>;
 		interrupt-parent = <&gpio4>;
-		interrupts = <17 IRQ_TYPE_EDGE_RISING>;
+		interrupts = <17 IRQ_TYPE_EDGE_RISING>; /* GPIO_113 */
 	};
 
 	/* accelerometer */
@@ -237,7 +237,7 @@
 		compatible = "bosch,bma180";
 		reg = <0x41>;
 		interrupt-parent = <&gpio4>;
-		interrupts = <19 IRQ_TYPE_LEVEL_HIGH>;
+		interrupts = <19 IRQ_TYPE_LEVEL_HIGH>; /* GPIO_115 */
 	};
 
 	/* leds */
@@ -288,7 +288,7 @@
 		compatible = "ti,tsc2007";
 		reg = <0x48>;
 		interrupt-parent = <&gpio6>;
-		interrupts = <0 IRQ_TYPE_EDGE_FALLING>;
+		interrupts = <0 IRQ_TYPE_EDGE_FALLING>; /* GPIO_160 */
 		gpios = <&gpio6 0 GPIO_ACTIVE_LOW>;
 		ti,x-plate-ohms = <600>;
 	};
-- 
1.9.1

