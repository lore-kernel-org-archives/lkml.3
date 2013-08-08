Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758171Ab3HHTIJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 15:08:09 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:2730 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752450Ab3HHTIH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 15:08:07 -0400
X-Server-Uuid: 06151B78-6688-425E-9DE2-57CB27892261
From: "Christian Daudt" <csd@broadcom.com>
To: "Christian Daudt" <csd@broadcom.com>
cc: "Lee Jones" <lee.jones@linaro.org>, "Alex Elder" <elder@linaro.org>,
        "Rob Herring" <rob.herring@calxeda.com>,
        "Pawel Moll" <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        "Stephen Warren" <swarren@wwwdotorg.org>,
        "Ian Campbell" <ian.campbell@citrix.com>,
        "Russell King" <linux@arm.linux.org.uk>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] ARM: dts: align sdio numbers to HW definition
Date: Thu, 8 Aug 2013 12:07:53 -0700
Message-ID: <1375988874-11303-1-git-send-email-csd@broadcom.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
X-WSS-ID: 7E1D342C31W82347457-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clean up the sdio numbering to be 1-base as defined in HW spec,
instead of the current 0-base

Reviewed-by: Alex Elder <elder@linaro.org>
Signed-off-by: Christian Daudt <csd@broadcom.com>

diff --git a/arch/arm/boot/dts/bcm11351-brt.dts b/arch/arm/boot/dts/bcm11351-brt.dts
index 67ec524..647a78c 100644
--- a/arch/arm/boot/dts/bcm11351-brt.dts
+++ b/arch/arm/boot/dts/bcm11351-brt.dts
@@ -27,18 +27,18 @@
 		status = "okay";
 	};
 
-	sdio0: sdio@0x3f180000 {
+	sdio1: sdio@3f180000 {
 		max-frequency = <48000000>;
 		status = "okay";
 	};
 
-	sdio1: sdio@0x3f190000 {
+	sdio2: sdio@3f190000 {
 		non-removable;
 		max-frequency = <48000000>;
 		status = "okay";
 	};
 
-	sdio3: sdio@0x3f1b0000 {
+	sdio4: sdio@3f1b0000 {
 		max-frequency = <48000000>;
 		status = "okay";
 	};
diff --git a/arch/arm/boot/dts/bcm11351.dtsi b/arch/arm/boot/dts/bcm11351.dtsi
index 8f094ba..d34e49db 100644
--- a/arch/arm/boot/dts/bcm11351.dtsi
+++ b/arch/arm/boot/dts/bcm11351.dtsi
@@ -68,28 +68,28 @@
 		clock-frequency = <32768>;
 	};
 
-	sdio0: sdio@0x3f180000 {
+	sdio1: sdio@3f180000 {
 		compatible = "bcm,kona-sdhci";
 		reg = <0x3f180000 0x10000>;
 		interrupts = <0x0 77 0x4>;
 		status = "disabled";
 	};
 
-	sdio1: sdio@0x3f190000 {
+	sdio2: sdio@3f190000 {
 		compatible = "bcm,kona-sdhci";
 		reg = <0x3f190000 0x10000>;
 		interrupts = <0x0 76 0x4>;
 		status = "disabled";
 	};
 
-	sdio2: sdio@0x3f1a0000 {
+	sdio3: sdio@3f1a0000 {
 		compatible = "bcm,kona-sdhci";
 		reg = <0x3f1a0000 0x10000>;
 		interrupts = <0x0 74 0x4>;
 		status = "disabled";
 	};
 
-	sdio3: sdio@0x3f1b0000 {
+	sdio4: sdio@3f1b0000 {
 		compatible = "bcm,kona-sdhci";
 		reg = <0x3f1b0000 0x10000>;
 		interrupts = <0x0 73 0x4>;
-- 
1.7.10.4


