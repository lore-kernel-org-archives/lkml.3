Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712AbaBJNmf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 08:42:35 -0500
Received: from michel.telenet-ops.be ([195.130.137.88]:60482 "EHLO
	michel.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254AbaBJNmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 08:42:33 -0500
From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
To: Simon Horman <horms@verge.net.au>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Subject: [PATCH] ARM: shmobile: r8a7778 dtsi: Remove duplicate i2c nodes
Date: Mon, 10 Feb 2014 14:42:19 +0100
Message-Id: <1392039739-22571-1-git-send-email-geert+renesas@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"ARM: shmobile: r8a7778: add I2C support on DTSI" was applied twice:

    commit ae4273ec7b25c8b9c895a4aae31f2fced980b7bf
    commit 3acb51b9215bd99da403ecf8200f8425176b1926

Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
---
 arch/arm/boot/dts/r8a7778.dtsi |   40 ----------------------------------------
 1 file changed, 40 deletions(-)

diff --git a/arch/arm/boot/dts/r8a7778.dtsi b/arch/arm/boot/dts/r8a7778.dtsi
index ddb3bd7a8838..85c5b3b99f5e 100644
--- a/arch/arm/boot/dts/r8a7778.dtsi
+++ b/arch/arm/boot/dts/r8a7778.dtsi
@@ -203,46 +203,6 @@
 		status = "disabled";
 	};
 
-	i2c0: i2c@ffc70000 {
-		#address-cells = <1>;
-		#size-cells = <0>;
-		compatible = "renesas,i2c-r8a7778";
-		reg = <0xffc70000 0x1000>;
-		interrupt-parent = <&gic>;
-		interrupts = <0 67 IRQ_TYPE_LEVEL_HIGH>;
-		status = "disabled";
-	};
-
-	i2c1: i2c@ffc71000 {
-		#address-cells = <1>;
-		#size-cells = <0>;
-		compatible = "renesas,i2c-r8a7778";
-		reg = <0xffc71000 0x1000>;
-		interrupt-parent = <&gic>;
-		interrupts = <0 78 IRQ_TYPE_LEVEL_HIGH>;
-		status = "disabled";
-	};
-
-	i2c2: i2c@ffc72000 {
-		#address-cells = <1>;
-		#size-cells = <0>;
-		compatible = "renesas,i2c-r8a7778";
-		reg = <0xffc72000 0x1000>;
-		interrupt-parent = <&gic>;
-		interrupts = <0 76 IRQ_TYPE_LEVEL_HIGH>;
-		status = "disabled";
-	};
-
-	i2c3: i2c@ffc73000 {
-		#address-cells = <1>;
-		#size-cells = <0>;
-		compatible = "renesas,i2c-r8a7778";
-		reg = <0xffc73000 0x1000>;
-		interrupt-parent = <&gic>;
-		interrupts = <0 77 IRQ_TYPE_LEVEL_HIGH>;
-		status = "disabled";
-	};
-
 	hspi0: spi@fffc7000 {
 		compatible = "renesas,hspi";
 		reg = <0xfffc7000 0x18>;
-- 
1.7.9.5

