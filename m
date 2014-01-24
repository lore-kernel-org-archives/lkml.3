Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812AbaAXMuQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 07:50:16 -0500
Received: from michel.telenet-ops.be ([195.130.137.88]:47252 "EHLO
	michel.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630AbaAXMuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 07:50:07 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>
Cc: linux-sh@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
        devicetree@vger.kernel.org
Subject: [PATCH v4 06/15] ARM: shmobile: r7s72100 dtsi: Add RSPI nodes
Date: Fri, 24 Jan 2014 13:49:42 +0100
Message-Id: <1390567791-8988-7-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1390567791-8988-1-git-send-email-geert@linux-m68k.org>
References: <1390567791-8988-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Cc: devicetree@vger.kernel.org
---
v4:
  - Switch to named IRQs
v3:
  - No changes
v2:
  - No changes

 arch/arm/boot/dts/r7s72100.dtsi |   70 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 70 insertions(+)

diff --git a/arch/arm/boot/dts/r7s72100.dtsi b/arch/arm/boot/dts/r7s72100.dtsi
index ff0bd6be454f..d7013df6bb10 100644
--- a/arch/arm/boot/dts/r7s72100.dtsi
+++ b/arch/arm/boot/dts/r7s72100.dtsi
@@ -34,6 +34,11 @@
 		gpio10 = &port10;
 		gpio11 = &port11;
 		gpio12 = &jtagport0;
+		spi0 = &spi0;
+		spi1 = &spi1;
+		spi2 = &spi2;
+		spi3 = &spi3;
+		spi4 = &spi4;
 	};
 
 	cpus {
@@ -289,4 +294,69 @@
 		clock-frequency = <100000>;
 		status = "disabled";
 	};
+
+	spi0: spi@e800c800 {
+		compatible = "renesas,rspi-r7s72100", "renesas,rspi-rz";
+		reg = <0xe800c800 0x24>;
+		interrupts = <0 238 IRQ_TYPE_LEVEL_HIGH>,
+			     <0 239 IRQ_TYPE_LEVEL_HIGH>,
+			     <0 240 IRQ_TYPE_LEVEL_HIGH>;
+		interrupt-names = "error", "rx", "tx";
+		num-cs = <1>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		status = "disabled";
+	};
+
+	spi1: spi@e800d000 {
+		compatible = "renesas,rspi-r7s72100", "renesas,rspi-rz";
+		reg = <0xe800d000 0x24>;
+		interrupts = <0 241 IRQ_TYPE_LEVEL_HIGH>,
+			     <0 242 IRQ_TYPE_LEVEL_HIGH>,
+			     <0 243 IRQ_TYPE_LEVEL_HIGH>;
+		interrupt-names = "error", "rx", "tx";
+		num-cs = <1>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		status = "disabled";
+	};
+
+	spi2: spi@e800d800 {
+		compatible = "renesas,rspi-r7s72100", "renesas,rspi-rz";
+		reg = <0xe800d800 0x24>;
+		interrupts = <0 244 IRQ_TYPE_LEVEL_HIGH>,
+			     <0 245 IRQ_TYPE_LEVEL_HIGH>,
+			     <0 246 IRQ_TYPE_LEVEL_HIGH>;
+		interrupt-names = "error", "rx", "tx";
+		num-cs = <1>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		status = "disabled";
+	};
+
+	spi3: spi@e800e000 {
+		compatible = "renesas,rspi-r7s72100", "renesas,rspi-rz";
+		reg = <0xe800e000 0x24>;
+		interrupts = <0 247 IRQ_TYPE_LEVEL_HIGH>,
+			     <0 248 IRQ_TYPE_LEVEL_HIGH>,
+			     <0 249 IRQ_TYPE_LEVEL_HIGH>;
+		interrupt-names = "error", "rx", "tx";
+		num-cs = <1>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		status = "disabled";
+	};
+
+	spi4: spi@e800e800 {
+		compatible = "renesas,rspi-r7s72100", "renesas,rspi-rz";
+		reg = <0xe800e800 0x24>;
+		interrupts = <0 250 IRQ_TYPE_LEVEL_HIGH>,
+			     <0 251 IRQ_TYPE_LEVEL_HIGH>,
+			     <0 252 IRQ_TYPE_LEVEL_HIGH>;
+		interrupt-names = "error", "rx", "tx";
+		num-cs = <1>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		status = "disabled";
+	};
 };
-- 
1.7.9.5

