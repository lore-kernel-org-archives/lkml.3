Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460AbaAYV35 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 16:29:57 -0500
Received: from mail-ea0-f173.google.com ([209.85.215.173]:36615 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228AbaAYV3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 16:29:53 -0500
From: Marek Belisko <marek@goldelico.com>
To: bcousson@baylibre.com, tony@atomide.com, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk
Cc: linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        neilb@suse.de, hns@goldelico.com, Marek Belisko <marek@goldelico.com>
Subject: [PATCH 8/9] ARM: dts: omap3-gta04: Add support for magnetometer.
Date: Sat, 25 Jan 2014 22:29:02 +0100
Message-Id: <1390685343-11663-9-git-send-email-marek@goldelico.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1390685343-11663-1-git-send-email-marek@goldelico.com>
References: <1390685343-11663-1-git-send-email-marek@goldelico.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: NeilBrown <neilb@suse.de>
---
 arch/arm/boot/dts/omap3-gta04.dts | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm/boot/dts/omap3-gta04.dts b/arch/arm/boot/dts/omap3-gta04.dts
index 151ed3b..ea1b94d 100644
--- a/arch/arm/boot/dts/omap3-gta04.dts
+++ b/arch/arm/boot/dts/omap3-gta04.dts
@@ -100,6 +100,12 @@
 			regulator-max-microvolt = <3150000>;
 		};
 	};
+
+	/* compass aka magnetometer */
+	hmc5843@1e {
+		compatible = "honeywell,hmc5843";
+		reg = <0x1e>;
+	};
 };
 
 #include "twl4030.dtsi"
-- 
1.8.3.2

