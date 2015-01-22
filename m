Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783AbbAVUjD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 15:39:03 -0500
Received: from mail-we0-f181.google.com ([74.125.82.181]:51527 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754762AbbAVUi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 15:38:59 -0500
From: Marek Belisko <marek@goldelico.com>
To: bcousson@baylibre.com, tony@atomide.com
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        hns@goldelico.com, neilb@suse.de, Marek Belisko <marek@goldelico.com>
Subject: [PATCH 05/13] ARM: dts: omap3-gta04: Fix a GPIO line for bma180 node
Date: Thu, 22 Jan 2015 21:38:11 +0100
Message-Id: <1421959099-28319-6-git-send-email-marek@goldelico.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421959099-28319-1-git-send-email-marek@goldelico.com>
References: <1421959099-28319-1-git-send-email-marek@goldelico.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GPIO_115 used as irq is in &gpio4, not &gpio3.

Signed-off-by: Marek Belisko <marek@goldelico.com>
---
 arch/arm/boot/dts/omap3-gta04.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/omap3-gta04.dtsi b/arch/arm/boot/dts/omap3-gta04.dtsi
index fd6ac80..0265474 100644
--- a/arch/arm/boot/dts/omap3-gta04.dtsi
+++ b/arch/arm/boot/dts/omap3-gta04.dtsi
@@ -230,7 +230,7 @@
 	bma180@41 {
 		compatible = "bosch,bma180";
 		reg = <0x41>;
-		interrupt-parent = <&gpio3>;
+		interrupt-parent = <&gpio4>;
 		interrupts = <19 IRQ_TYPE_LEVEL_HIGH>;
 	};
 
-- 
1.9.1

