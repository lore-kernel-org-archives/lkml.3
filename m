Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755624Ab3JVWuc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 18:50:32 -0400
Received: from ring0.de ([91.143.88.219]:38650 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755435Ab3JVWuQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 18:50:16 -0400
X-Spam-Report: * -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
From: Sebastian Reichel <sre@debian.org>
To: =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sebastian Reichel <sre@debian.org>
Subject: [PATCH 09/14] DTS: ARM: OMAP3-N900: Specify regulator info
Date: Wed, 23 Oct 2013 00:49:38 +0200
Message-Id: <1382482183-14426-10-git-send-email-sre@debian.org>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1382482183-14426-1-git-send-email-sre@debian.org>
References: <1382482183-14426-1-git-send-email-sre@debian.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add regulator names and voltage information to
the Nokia N900 DTS file.

Signed-off-by: Sebastian Reichel <sre@debian.org>
---
 arch/arm/boot/dts/omap3-n900.dts | 84 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 84 insertions(+)

diff --git a/arch/arm/boot/dts/omap3-n900.dts b/arch/arm/boot/dts/omap3-n900.dts
index c7e0d2d..0a45af3 100644
--- a/arch/arm/boot/dts/omap3-n900.dts
+++ b/arch/arm/boot/dts/omap3-n900.dts
@@ -142,6 +142,90 @@
 #include "twl4030.dtsi"
 #include "twl4030_omap3.dtsi"
 
+&vaux1 {
+	regulator-name = "V28";
+	regulator-min-microvolt = <2800000>;
+	regulator-max-microvolt = <2800000>;
+	regulator-always-on; /* due battery cover sensor */
+};
+
+&vaux2 {
+	regulator-name = "VCSI";
+	regulator-min-microvolt = <1800000>;
+	regulator-max-microvolt = <1800000>;
+};
+
+&vaux3 {
+	regulator-name = "VMMC2_30";
+	regulator-min-microvolt = <2800000>;
+	regulator-max-microvolt = <3000000>;
+};
+
+&vaux4 {
+	regulator-name = "VCAM_ANA_28";
+	regulator-min-microvolt = <2800000>;
+	regulator-max-microvolt = <2800000>;
+};
+
+&vmmc1 {
+	regulator-name = "VMMC1";
+	regulator-min-microvolt = <1850000>;
+	regulator-max-microvolt = <3150000>;
+};
+
+&vmmc2 {
+	regulator-name = "V28_A";
+	regulator-min-microvolt = <2800000>;
+	regulator-max-microvolt = <3000000>;
+	regulator-always-on; /* due VIO leak to AIC34 VDDs */
+};
+
+&vpll1 {
+	regulator-name = "VPLL";
+	regulator-min-microvolt = <1800000>;
+	regulator-max-microvolt = <1800000>;
+	regulator-always-on;
+};
+
+&vpll2 {
+	regulator-name = "VSDI_CSI";
+	regulator-min-microvolt = <1800000>;
+	regulator-max-microvolt = <1800000>;
+	regulator-always-on;
+};
+
+&vsim {
+	regulator-name = "VMMC2_IO_18";
+	regulator-min-microvolt = <1800000>;
+	regulator-max-microvolt = <1800000>;
+};
+
+&vio {
+	regulator-name = "VIO";
+	regulator-min-microvolt = <1800000>;
+	regulator-max-microvolt = <1800000>;
+
+};
+
+&vintana1 {
+	regulator-name = "VINTANA1";
+	/* fixed to 1500000 */
+	regulator-always-on;
+};
+
+&vintana2 {
+	regulator-name = "VINTANA2";
+	regulator-min-microvolt = <2750000>;
+	regulator-max-microvolt = <2750000>;
+	regulator-always-on;
+};
+
+&vintdig {
+	regulator-name = "VINTDIG";
+	/* fixed to 1500000 */
+	regulator-always-on;
+};
+
 &twl {
 	twl_audio: audio {
 		compatible = "ti,twl4030-audio";
-- 
1.8.4.rc3

