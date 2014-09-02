Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523AbaIBKwQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 06:52:16 -0400
Received: from mail.interact-automation.nl ([193.141.16.74]:50902 "EHLO
	smtp.interact.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831AbaIBKwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 06:52:15 -0400
X-Greylist: delayed 338 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Sep 2014 06:52:15 EDT
From: Erik van Luijk <evanluijk@interact.nl>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Erik van Luijk <evanluijk@interact.nl>
Subject: [PATCH] ARM: at91/dt: at91sam9m10g45ek add rtc node
Date: Tue,  2 Sep 2014 12:52:12 +0200
Message-Id: <1409655132-17735-1-git-send-email-evanluijk@interact.nl>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erik van Luijk <evanluijk@interact.nl>
---
 arch/arm/boot/dts/at91sam9g45.dtsi     | 7 +++++++
 arch/arm/boot/dts/at91sam9m10g45ek.dts | 3 +++
 2 files changed, 10 insertions(+)

diff --git a/arch/arm/boot/dts/at91sam9g45.dtsi b/arch/arm/boot/dts/at91sam9g45.dtsi
index 932a669..bf62c18 100644
--- a/arch/arm/boot/dts/at91sam9g45.dtsi
+++ b/arch/arm/boot/dts/at91sam9g45.dtsi
@@ -1070,6 +1070,13 @@
 				status = "disabled";
 			};
 
+			rtc@fffffdb0 {
+				compatible = "atmel,at91rm9200-rtc";
+				reg = <0xfffffdb0 0x30>;
+				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
+				status = "disabled";
+			};
+
 			spi0: spi@fffa4000 {
 				#address-cells = <1>;
 				#size-cells = <0>;
diff --git a/arch/arm/boot/dts/at91sam9m10g45ek.dts b/arch/arm/boot/dts/at91sam9m10g45ek.dts
index 96ccc7d..2dd2347 100644
--- a/arch/arm/boot/dts/at91sam9m10g45ek.dts
+++ b/arch/arm/boot/dts/at91sam9m10g45ek.dts
@@ -70,6 +70,9 @@
 
 			watchdog@fffffd40 {
 				status = "okay";
+
+			rtc@fffffdb0 {
+				status = "okay";
 			};
 
 			mmc0: mmc@fff80000 {
-- 
1.9.1

