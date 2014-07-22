Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756800AbaGVTcO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 15:32:14 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:48810 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756681AbaGVTav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 15:30:51 -0400
From: Marek Belisko <marek@goldelico.com>
To: bcousson@baylibre.com, tony@atomide.com
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, hns@goldelico.com,
        Marek Belisko <marek@goldelico.com>
Subject: [PATCH v2 3/7] arm: dts: omap3-gta04: Add wifi reset node
Date: Tue, 22 Jul 2014 21:30:16 +0200
Message-Id: <1406057420-22269-4-git-send-email-marek@goldelico.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406057420-22269-1-git-send-email-marek@goldelico.com>
References: <1406057420-22269-1-git-send-email-marek@goldelico.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define gpio node in tca6507 which will be used as
wifi reset pin.

Signed-off-by: Marek Belisko <marek@goldelico.com>
---
 arch/arm/boot/dts/omap3-gta04.dts | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm/boot/dts/omap3-gta04.dts b/arch/arm/boot/dts/omap3-gta04.dts
index 6d1a8d8..5b08d93 100644
--- a/arch/arm/boot/dts/omap3-gta04.dts
+++ b/arch/arm/boot/dts/omap3-gta04.dts
@@ -196,6 +196,9 @@
 		#size-cells = <0>;
 		reg = <0x45>;
 
+		gpio-controller;
+		#gpio-cells = <2>;
+
 		gta04_led0: red_aux@0 {
 			label = "gta04:red:aux";
 			reg = <0x0>;
@@ -216,6 +219,11 @@
 			label = "gta04:green:power";
 			reg = <0x4>;
 		};
+
+		wifi_reset: wifi_reset@6 {
+			reg = <0x6>;
+			compatible = "gpio";
+		};
 	};
 
 	/* compass aka magnetometer */
-- 
1.9.1

