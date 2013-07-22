Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932332Ab3GVK64 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 06:58:56 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:44145 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932184Ab3GVKw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 06:52:59 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>, Christian Daudt <csd@broadcom.com>
Subject: [PATCH 06/22] ARM: dts: bcm281xx: Remove '0x's from BCM11351 DTS file
Date: Mon, 22 Jul 2013 11:52:25 +0100
Message-Id: <1374490361-25769-6-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374490361-25769-1-git-send-email-lee.jones@linaro.org>
References: <1374490361-25769-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Christian Daudt <csd@broadcom.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/bcm11351.dtsi | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm/boot/dts/bcm11351.dtsi b/arch/arm/boot/dts/bcm11351.dtsi
index c0cdf66..db5873a 100644
--- a/arch/arm/boot/dts/bcm11351.dtsi
+++ b/arch/arm/boot/dts/bcm11351.dtsi
@@ -34,7 +34,7 @@
 		      <0x3ff00100 0x100>;
 	};
 
-	smc@0x3404c000 {
+	smc@3404c000 {
 		compatible = "bcm,bcm11351-smc", "bcm,kona-smc";
 		reg = <0x3404c000 0x400>; /* 1 KiB in SRAM */
 	};
@@ -63,28 +63,28 @@
 		clock-frequency = <32768>;
 	};
 
-	sdio0: sdio@0x3f180000 {
+	sdio0: sdio@3f180000 {
 		compatible = "bcm,kona-sdhci";
 		reg = <0x3f180000 0x10000>;
 		interrupts = <0x0 77 0x4>;
 		status = "disabled";
 	};
 
-	sdio1: sdio@0x3f190000 {
+	sdio1: sdio@3f190000 {
 		compatible = "bcm,kona-sdhci";
 		reg = <0x3f190000 0x10000>;
 		interrupts = <0x0 76 0x4>;
 		status = "disabled";
 	};
 
-	sdio2: sdio@0x3f1a0000 {
+	sdio2: sdio@3f1a0000 {
 		compatible = "bcm,kona-sdhci";
 		reg = <0x3f1a0000 0x10000>;
 		interrupts = <0x0 74 0x4>;
 		status = "disabled";
 	};
 
-	sdio3: sdio@0x3f1b0000 {
+	sdio3: sdio@3f1b0000 {
 		compatible = "bcm,kona-sdhci";
 		reg = <0x3f1b0000 0x10000>;
 		interrupts = <0x0 73 0x4>;
-- 
1.8.1.2

