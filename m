Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756703AbaGVTaw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 15:30:52 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:45142 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756661AbaGVTas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 15:30:48 -0400
From: Marek Belisko <marek@goldelico.com>
To: bcousson@baylibre.com, tony@atomide.com
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, hns@goldelico.com,
        Marek Belisko <marek@goldelico.com>
Subject: [PATCH v2 2/7] arm: dts: omap3-gta04: Fix magnetometer model
Date: Tue, 22 Jul 2014 21:30:15 +0200
Message-Id: <1406057420-22269-3-git-send-email-marek@goldelico.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406057420-22269-1-git-send-email-marek@goldelico.com>
References: <1406057420-22269-1-git-send-email-marek@goldelico.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gta04 is using hmc5843l not hmc5843 so fix wrong compatible
entry.

Signed-off-by: Marek Belisko <marek@goldelico.com>
---
 arch/arm/boot/dts/omap3-gta04.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/omap3-gta04.dts b/arch/arm/boot/dts/omap3-gta04.dts
index 7d7ddd7..6d1a8d8 100644
--- a/arch/arm/boot/dts/omap3-gta04.dts
+++ b/arch/arm/boot/dts/omap3-gta04.dts
@@ -220,7 +220,7 @@
 
 	/* compass aka magnetometer */
 	hmc5843@1e {
-		compatible = "honeywell,hmc5843";
+		compatible = "honeywell,hmc5843l";
 		reg = <0x1e>;
 	};
 
-- 
1.9.1

