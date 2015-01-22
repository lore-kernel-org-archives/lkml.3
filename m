Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846AbbAVUj1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 15:39:27 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:35154 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754739AbbAVUjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 15:39:22 -0500
From: Marek Belisko <marek@goldelico.com>
To: bcousson@baylibre.com, tony@atomide.com
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        hns@goldelico.com, neilb@suse.de, NeilBrown <neil@brown.name>
Subject: [PATCH 10/13] ARM: dts: omap3-gta04: add gyroscope
Date: Thu, 22 Jan 2015 21:38:16 +0100
Message-Id: <1421959099-28319-11-git-send-email-marek@goldelico.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421959099-28319-1-git-send-email-marek@goldelico.com>
References: <1421959099-28319-1-git-send-email-marek@goldelico.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: NeilBrown <neil@brown.name>

Signed-off-by: NeilBrown <neil@brown.name>
---
 arch/arm/boot/dts/omap3-gta04.dtsi | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm/boot/dts/omap3-gta04.dtsi b/arch/arm/boot/dts/omap3-gta04.dtsi
index ab5dd98..08f0b25 100644
--- a/arch/arm/boot/dts/omap3-gta04.dtsi
+++ b/arch/arm/boot/dts/omap3-gta04.dtsi
@@ -240,6 +240,14 @@
 		interrupts = <19 IRQ_TYPE_LEVEL_HIGH>; /* GPIO_115 */
 	};
 
+	/* gyroscope */
+	itg3200@68 {
+		compatible = "invensense,itg3200";
+		reg = <0x68>;
+		interrupt-parent = <&gpio2>;
+		interrupts = <24 0>; /* GPIO_56 */
+	};
+
 	/* leds */
 	tca6507@45 {
 		compatible = "ti,tca6507";
-- 
1.9.1

