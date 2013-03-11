Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185Ab3CKSL3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 14:11:29 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:40029 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753491Ab3CKSLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 14:11:23 -0400
From: Johan Hovold <jhovold@gmail.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Andrew Victor <linux@maxim.org.za>,
        Alessandro Zummo <a.zummo@towertech.it>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com, Johan Hovold <jhovold@gmail.com>
Subject: [PATCH v2 3/5] ARM: at91/dts: add RTT nodes
Date: Mon, 11 Mar 2013 19:07:57 +0100
Message-Id: <1363025279-17615-4-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1363025279-17615-1-git-send-email-jhovold@gmail.com>
References: <20130311180611.GF8797@localhost>
 <1363025279-17615-1-git-send-email-jhovold@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add RTT nodes for Atmel SOCs.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 arch/arm/boot/dts/at91sam9260.dtsi |  5 +++++
 arch/arm/boot/dts/at91sam9263.dtsi | 10 ++++++++++
 arch/arm/boot/dts/at91sam9g45.dtsi |  5 +++++
 3 files changed, 20 insertions(+)

diff --git a/arch/arm/boot/dts/at91sam9260.dtsi b/arch/arm/boot/dts/at91sam9260.dtsi
index cb7bcc5..3a7a8dd 100644
--- a/arch/arm/boot/dts/at91sam9260.dtsi
+++ b/arch/arm/boot/dts/at91sam9260.dtsi
@@ -462,6 +462,11 @@
 				status = "disabled";
 			};
 
+			rtt@fffffd20 {
+				compatible = "atmel,at91sam9260-rtt";
+				reg = <0xfffffd20 0x10>;
+			};
+
 			ssc0: ssc@fffbc000 {
 				compatible = "atmel,at91rm9200-ssc";
 				reg = <0xfffbc000 0x4000>;
diff --git a/arch/arm/boot/dts/at91sam9263.dtsi b/arch/arm/boot/dts/at91sam9263.dtsi
index 271d4de..3a44382 100644
--- a/arch/arm/boot/dts/at91sam9263.dtsi
+++ b/arch/arm/boot/dts/at91sam9263.dtsi
@@ -457,6 +457,16 @@
 				status = "disabled";
 			};
 
+			rtt@fffffd20 {
+				compatible = "atmel,at91sam9260-rtt";
+				reg = <0xfffffd20 0x10>;
+			};
+
+			rtt@fffffd50 {
+				compatible = "atmel,at91sam9260-rtt";
+				reg = <0xfffffd50 0x10>;
+			};
+
 			watchdog@fffffd40 {
 				compatible = "atmel,at91sam9260-wdt";
 				reg = <0xfffffd40 0x10>;
diff --git a/arch/arm/boot/dts/at91sam9g45.dtsi b/arch/arm/boot/dts/at91sam9g45.dtsi
index c1ad522..750b696 100644
--- a/arch/arm/boot/dts/at91sam9g45.dtsi
+++ b/arch/arm/boot/dts/at91sam9g45.dtsi
@@ -531,6 +531,11 @@
 				reg = <0xfffffdb0 0x30>;
 			};
 
+			rtt@fffffd20 {
+				compatible = "atmel,at91sam9260-rtt";
+				reg = <0xfffffd20 0x10>;
+			};
+
 			watchdog@fffffd40 {
 				compatible = "atmel,at91sam9260-wdt";
 				reg = <0xfffffd40 0x10>;
-- 
1.8.1.5

