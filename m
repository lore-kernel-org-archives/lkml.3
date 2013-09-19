Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892Ab3ISRSh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 13:18:37 -0400
Received: from mail-ye0-f176.google.com ([209.85.213.176]:47545 "EHLO
	mail-ye0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071Ab3ISRSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 13:18:35 -0400
From: Matt Porter <matt.porter@linaro.org>
To: Christian Daudt <csd@broadcom.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Devicetree List <devicetree@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linaro Patches <patches@linaro.org>
Subject: [PATCH] ARM: dts: bcm11351: Use GIC/IRQ defines for sdio interrupts
Date: Thu, 19 Sep 2013 13:18:26 -0400
Message-Id: <1379611106-18338-1-git-send-email-matt.porter@linaro.org>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trivial patch to make use of GIC/IRQ defines on the bcm11351 sdio
interrupt properties.

Signed-off-by: Matt Porter <matt.porter@linaro.org>
---
 arch/arm/boot/dts/bcm11351.dtsi | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/bcm11351.dtsi b/arch/arm/boot/dts/bcm11351.dtsi
index 05a5aab..5fc64ab 100644
--- a/arch/arm/boot/dts/bcm11351.dtsi
+++ b/arch/arm/boot/dts/bcm11351.dtsi
@@ -71,28 +71,28 @@
 	sdio1: sdio@3f180000 {
 		compatible = "brcm,kona-sdhci";
 		reg = <0x3f180000 0x10000>;
-		interrupts = <0x0 77 0x4>;
+		interrupts = <GIC_SPI 77 IRQ_TYPE_LEVEL_HIGH>;
 		status = "disabled";
 	};
 
 	sdio2: sdio@3f190000 {
 		compatible = "brcm,kona-sdhci";
 		reg = <0x3f190000 0x10000>;
-		interrupts = <0x0 76 0x4>;
+		interrupts = <GIC_SPI 76 IRQ_TYPE_LEVEL_HIGH>;
 		status = "disabled";
 	};
 
 	sdio3: sdio@3f1a0000 {
 		compatible = "brcm,kona-sdhci";
 		reg = <0x3f1a0000 0x10000>;
-		interrupts = <0x0 74 0x4>;
+		interrupts = <GIC_SPI 74 IRQ_TYPE_LEVEL_HIGH>;
 		status = "disabled";
 	};
 
 	sdio4: sdio@3f1b0000 {
 		compatible = "brcm,kona-sdhci";
 		reg = <0x3f1b0000 0x10000>;
-		interrupts = <0x0 73 0x4>;
+		interrupts = <GIC_SPI 73 IRQ_TYPE_LEVEL_HIGH>;
 		status = "disabled";
 	};
 
-- 
1.8.4

