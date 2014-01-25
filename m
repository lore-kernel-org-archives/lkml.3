Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391AbaAYV3v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 16:29:51 -0500
Received: from mail-ea0-f177.google.com ([209.85.215.177]:60860 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228AbaAYV3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 16:29:49 -0500
From: Marek Belisko <marek@goldelico.com>
To: bcousson@baylibre.com, tony@atomide.com, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk
Cc: linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        neilb@suse.de, hns@goldelico.com, Marek Belisko <marek@goldelico.com>
Subject: [PATCH 7/9] ARM: dts: omap3-gta04: Add touchscreen properties.
Date: Sat, 25 Jan 2014 22:29:01 +0100
Message-Id: <1390685343-11663-8-git-send-email-marek@goldelico.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1390685343-11663-1-git-send-email-marek@goldelico.com>
References: <1390685343-11663-1-git-send-email-marek@goldelico.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek@goldelico.com>
---
 arch/arm/boot/dts/omap3-gta04.dts | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm/boot/dts/omap3-gta04.dts b/arch/arm/boot/dts/omap3-gta04.dts
index f72e408..151ed3b 100644
--- a/arch/arm/boot/dts/omap3-gta04.dts
+++ b/arch/arm/boot/dts/omap3-gta04.dts
@@ -150,6 +150,16 @@
 			reg = <0x4>;
 		};
 	};
+
+	/* touchscreen */
+	tsc2007@48 {
+		compatible = "ti,tsc2007";
+		reg = <0x48>;
+		interrupt-parent = <&gpio6>;
+		interrupts = <0 IRQ_TYPE_EDGE_FALLING>;
+		gpios = <&gpio6 0 GPIO_ACTIVE_LOW>;
+		ti,x-plate-ohms = <600>;
+	};
 };
 
 &i2c3 {
-- 
1.8.3.2

