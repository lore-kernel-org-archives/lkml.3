Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991Ab3JVWwp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 18:52:45 -0400
Received: from ring0.de ([91.143.88.219]:38643 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755374Ab3JVWuP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 18:50:15 -0400
X-Spam-Report: * -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
From: Sebastian Reichel <sre@debian.org>
To: =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sebastian Reichel <sre@debian.org>
Subject: [PATCH 08/14] DTS: TWL4030: Add missing regulators
Date: Wed, 23 Oct 2013 00:49:37 +0200
Message-Id: <1382482183-14426-9-git-send-email-sre@debian.org>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1382482183-14426-1-git-send-email-sre@debian.org>
References: <1382482183-14426-1-git-send-email-sre@debian.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The twl4030.dtsi is missing some regulators. This patch adds
the missing ones and orders the regulators alphabetically.

Signed-off-by: Sebastian Reichel <sre@debian.org>
---
 arch/arm/boot/dts/twl4030.dtsi | 44 ++++++++++++++++++++++++++++++++++++++----
 1 file changed, 40 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/twl4030.dtsi b/arch/arm/boot/dts/twl4030.dtsi
index ae6a17a..cb5afcd 100644
--- a/arch/arm/boot/dts/twl4030.dtsi
+++ b/arch/arm/boot/dts/twl4030.dtsi
@@ -23,6 +23,22 @@
 		compatible = "ti,twl4030-wdt";
 	};
 
+	vaux1: regulator-vaux1 {
+		compatible = "ti,twl4030-vaux1";
+	};
+
+	vaux2: regulator-vaux2 {
+		compatible = "ti,twl4030-vaux2";
+	};
+
+	vaux3: regulator-vaux3 {
+		compatible = "ti,twl4030-vaux3";
+	};
+
+	vaux4: regulator-vaux4 {
+		compatible = "ti,twl4030-vaux4";
+	};
+
 	vcc: regulator-vdd1 {
 		compatible = "ti,twl4030-vdd1";
 		regulator-min-microvolt = <600000>;
@@ -35,10 +51,20 @@
 		regulator-max-microvolt = <1800000>;
 	};
 
-	vpll2: regulator-vpll2 {
-		compatible = "ti,twl4030-vpll2";
-		regulator-min-microvolt = <1800000>;
-		regulator-max-microvolt = <1800000>;
+	vio: regulator-vio {
+		compatible = "ti,twl4030-vio";
+	};
+
+	vintana1: regulator-vintana1 {
+		compatible = "ti,twl4030-vintana1";
+	};
+
+	vintana2: regulator-vintana2 {
+		compatible = "ti,twl4030-vintana2";
+	};
+
+	vintdig: regulator-vintdig {
+		compatible = "ti,twl4030-vintdig";
 	};
 
 	vmmc1: regulator-vmmc1 {
@@ -65,6 +91,16 @@
 		compatible = "ti,twl4030-vusb3v1";
 	};
 
+	vpll1: regulator-vpll1 {
+		compatible = "ti,twl4030-vpll1";
+	};
+
+	vpll2: regulator-vpll2 {
+		compatible = "ti,twl4030-vpll2";
+		regulator-min-microvolt = <1800000>;
+		regulator-max-microvolt = <1800000>;
+	};
+
 	vsim: regulator-vsim {
 		compatible = "ti,twl4030-vsim";
 		regulator-min-microvolt = <1800000>;
-- 
1.8.4.rc3

