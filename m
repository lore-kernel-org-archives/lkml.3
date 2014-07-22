Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756786AbaGVTb3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 15:31:29 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:46436 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756710AbaGVTbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 15:31:03 -0400
From: Marek Belisko <marek@goldelico.com>
To: bcousson@baylibre.com, tony@atomide.com
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, hns@goldelico.com,
        Marek Belisko <marek@goldelico.com>
Subject: [PATCH v2 7/7] arm: dts: omap3-gta04: Add twl4030 regulators parameters
Date: Tue, 22 Jul 2014 21:30:20 +0200
Message-Id: <1406057420-22269-8-git-send-email-marek@goldelico.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406057420-22269-1-git-send-email-marek@goldelico.com>
References: <1406057420-22269-1-git-send-email-marek@goldelico.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define voltages and properties for various twl4030
regulators used on gta04 board.

Signed-off-by: Marek Belisko <marek@goldelico.com>
---
 arch/arm/boot/dts/omap3-gta04.dts | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/arch/arm/boot/dts/omap3-gta04.dts b/arch/arm/boot/dts/omap3-gta04.dts
index 05fd4d2..e39ede2 100644
--- a/arch/arm/boot/dts/omap3-gta04.dts
+++ b/arch/arm/boot/dts/omap3-gta04.dts
@@ -346,11 +346,37 @@
 	bb_uamp = <150>;
 };
 
+/* spare */
+&vaux1 {
+	regulator-min-microvolt = <2500000>;
+	regulator-max-microvolt = <3000000>;
+};
+
+/* sensors */
+&vaux2 {
+	regulator-min-microvolt = <2800000>;
+	regulator-max-microvolt = <2800000>;
+	regulator-always-on;
+};
+
+/* camera */
+&vaux3 {
+	regulator-min-microvolt = <2500000>;
+	regulator-max-microvolt = <2500000>;
+};
+
+/* WLAN/BT */
 &vaux4 {
 	regulator-min-microvolt = <2800000>;
 	regulator-max-microvolt = <3150000>;
 };
 
+/* GPS LNA */
+&vsim {
+	regulator-min-microvolt = <2800000>;
+	regulator-max-microvolt = <3150000>;
+};
+
 /* Needed to power the DPI pins */
 &vpll2 {
 	regulator-always-on;
-- 
1.9.1

