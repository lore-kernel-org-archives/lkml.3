Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989AbaFET1z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 15:27:55 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:53827 "EHLO
	new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752626AbaFET1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 15:27:53 -0400
X-Sasl-enc: GR4kKNGoQtQWRYrZuN46B2I0QmJVvtB1ww21xKV7orfY 1401996467
From: Andrew Ruder <andrew.ruder@elecsyscorp.com>
To: devicetree@vger.kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        rdunlap@infradead.org, galak@codeaurora.org,
        ijc+devicetree@hellion.org.uk, mark.rutland@arm.com,
        pawel.moll@arm.com, robh+dt@kernel.org,
        Andrew Ruder <andrew.ruder@elecsyscorp.com>
Subject: [PATCH 1/6] arm: pxa2xx.dtsi: compatible tags for usb, mmc
Date: Thu,  5 Jun 2014 14:27:03 -0500
Message-Id: <708a099c2c0e2220ad5d2ad7b999378caf237439.1401995177.git.andrew.ruder@elecsyscorp.com>
X-Mailer: git-send-email 1.9.0.rc3.12.gbc97e2d
In-Reply-To: <cover.1401995177.git.andrew.ruder@elecsyscorp.com>
References: <cover.1401995177.git.andrew.ruder@elecsyscorp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This changes pxa2xx.dtsi's compatible tags for MMC and USB to match both
the documentation and the code.

Signed-off-by: Andrew Ruder <andrew.ruder@elecsyscorp.com>
---
 arch/arm/boot/dts/pxa2xx.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/pxa2xx.dtsi b/arch/arm/boot/dts/pxa2xx.dtsi
index a5e90f0..c08f846 100644
--- a/arch/arm/boot/dts/pxa2xx.dtsi
+++ b/arch/arm/boot/dts/pxa2xx.dtsi
@@ -113,14 +113,14 @@
 		};
 
 		usb0: ohci@4c000000 {
-			compatible = "mrvl,pxa-ohci";
+			compatible = "marvell,pxa-ohci";
 			reg = <0x4c000000 0x10000>;
 			interrupts = <3>;
 			status = "disabled";
 		};
 
 		mmc0: mmc@41100000 {
-			compatible = "mrvl,pxa-mmc";
+			compatible = "marvell,pxa-mmc";
 			reg = <0x41100000 0x1000>;
 			interrupts = <23>;
 			status = "disabled";
-- 
1.9.0.rc3.12.gbc97e2d

