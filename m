Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333AbaJWL6S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 07:58:18 -0400
Received: from axentia.se ([87.96.186.132]:15803 "EHLO EMAIL.axentia.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754480AbaJWL6R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 07:58:17 -0400
From: Peter Rosin <peda@axentia.se>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Andrew Victor <linux@maxim.org.za>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "Russell King" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: [PATCH] ARM: at91/dt: Fix sama5d3x typos.
Thread-Topic: [PATCH] ARM: at91/dt: Fix sama5d3x typos.
Thread-Index: Ac/uuJ5uKo8dz62zSWyHwFRAK7txHA==
Date: Thu, 23 Oct 2014 11:56:25 +0000
Message-ID: <ec77270840f94da6a6d7548e7a3bf5a8@EMAIL.axentia.se>
Accept-Language: en-US, sv-SE
Content-Language: sv-SE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [217.210.101.82]
x-gfi-smtp-submission: 1
x-gfi-smtp-hellodomain: EMAIL.axentia.se
x-gfi-smtp-remoteip: 192.168.2.5
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From c23d712fe924b929c2eb39eba644fe74bcccfd37 Mon Sep 17 00:00:00 2001
From: Peter Rosin <peda@axentia.se>
Date: Thu, 23 Oct 2014 13:52:03 +0200
Subject: [PATCH] ARM: at91/dt: Fix sama5d3x typos.

The DT compatible strings also need binding documentation, but that is for
someone else to write.

Signed-off-by: Peter Rosin <peda@axentia.se>
---
 arch/arm/boot/dts/sama5d31.dtsi   |    2 +-
 arch/arm/boot/dts/sama5d33.dtsi   |    2 +-
 arch/arm/boot/dts/sama5d34.dtsi   |    2 +-
 arch/arm/boot/dts/sama5d35.dtsi   |    2 +-
 arch/arm/boot/dts/sama5d36.dtsi   |    2 +-
 arch/arm/boot/dts/sama5d3xcm.dtsi |    2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm/boot/dts/sama5d31.dtsi b/arch/arm/boot/dts/sama5d31.dtsi
index 7997dc9..883878b 100644
--- a/arch/arm/boot/dts/sama5d31.dtsi
+++ b/arch/arm/boot/dts/sama5d31.dtsi
@@ -12,5 +12,5 @@
 #include "sama5d3_uart.dtsi"
 
 / {
-	compatible = "atmel,samad31", "atmel,sama5d3", "atmel,sama5";
+	compatible = "atmel,sama5d31", "atmel,sama5d3", "atmel,sama5";
 };
diff --git a/arch/arm/boot/dts/sama5d33.dtsi b/arch/arm/boot/dts/sama5d33.dtsi
index 39f8322..4b4434a 100644
--- a/arch/arm/boot/dts/sama5d33.dtsi
+++ b/arch/arm/boot/dts/sama5d33.dtsi
@@ -10,5 +10,5 @@
 #include "sama5d3_gmac.dtsi"
 
 / {
-	compatible = "atmel,samad33", "atmel,sama5d3", "atmel,sama5";
+	compatible = "atmel,sama5d33", "atmel,sama5d3", "atmel,sama5";
 };
diff --git a/arch/arm/boot/dts/sama5d34.dtsi b/arch/arm/boot/dts/sama5d34.dtsi
index 89cda2c..aa01573 100644
--- a/arch/arm/boot/dts/sama5d34.dtsi
+++ b/arch/arm/boot/dts/sama5d34.dtsi
@@ -12,5 +12,5 @@
 #include "sama5d3_mci2.dtsi"
 
 / {
-	compatible = "atmel,samad34", "atmel,sama5d3", "atmel,sama5";
+	compatible = "atmel,sama5d34", "atmel,sama5d3", "atmel,sama5";
 };
diff --git a/arch/arm/boot/dts/sama5d35.dtsi b/arch/arm/boot/dts/sama5d35.dtsi
index d20cd71..16c39f4 100644
--- a/arch/arm/boot/dts/sama5d35.dtsi
+++ b/arch/arm/boot/dts/sama5d35.dtsi
@@ -14,5 +14,5 @@
 #include "sama5d3_tcb1.dtsi"
 
 / {
-	compatible = "atmel,samad35", "atmel,sama5d3", "atmel,sama5";
+	compatible = "atmel,sama5d35", "atmel,sama5d3", "atmel,sama5";
 };
diff --git a/arch/arm/boot/dts/sama5d36.dtsi b/arch/arm/boot/dts/sama5d36.dtsi
index db58cad..e85139e 100644
--- a/arch/arm/boot/dts/sama5d36.dtsi
+++ b/arch/arm/boot/dts/sama5d36.dtsi
@@ -16,5 +16,5 @@
 #include "sama5d3_uart.dtsi"
 
 / {
-	compatible = "atmel,samad36", "atmel,sama5d3", "atmel,sama5";
+	compatible = "atmel,sama5d36", "atmel,sama5d3", "atmel,sama5";
 };
diff --git a/arch/arm/boot/dts/sama5d3xcm.dtsi b/arch/arm/boot/dts/sama5d3xcm.dtsi
index f7d8583..56574c8 100644
--- a/arch/arm/boot/dts/sama5d3xcm.dtsi
+++ b/arch/arm/boot/dts/sama5d3xcm.dtsi
@@ -8,7 +8,7 @@
  */
 
 / {
-	compatible = "atmel,samad3xcm", "atmel,sama5d3", "atmel,sama5";
+	compatible = "atmel,sama5d3xcm", "atmel,sama5d3", "atmel,sama5";
 
 	chosen {
 		bootargs = "console=ttyS0,115200 rootfstype=ubifs ubi.mtd=5 root=ubi0:rootfs";
-- 
1.7.10.4

