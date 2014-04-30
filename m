Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933600AbaD3M46 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 08:56:58 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:50337 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758864AbaD3M4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 08:56:54 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 02/15] ARM: dts: kirkwood: add node labels
Date: Wed, 30 Apr 2014 14:56:29 +0200
Message-Id: <1398862602-29595-3-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1398862602-29595-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1398862602-29595-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds missing node labels to Kirkwood common and SoC specific nodes
to allow to reference them more easily.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Kumar Gala <galak@codeaurora.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Gregory Clement <gregory.clement@free-electrons.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: devicetree@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/boot/dts/kirkwood-6192.dtsi | 10 +++++-----
 arch/arm/boot/dts/kirkwood-6281.dtsi | 10 +++++-----
 arch/arm/boot/dts/kirkwood-6282.dtsi | 16 ++++++++--------
 arch/arm/boot/dts/kirkwood.dtsi      | 16 ++++++++--------
 4 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/arch/arm/boot/dts/kirkwood-6192.dtsi b/arch/arm/boot/dts/kirkwood-6192.dtsi
index 3916937d6818..294a6fa0208c 100644
--- a/arch/arm/boot/dts/kirkwood-6192.dtsi
+++ b/arch/arm/boot/dts/kirkwood-6192.dtsi
@@ -1,6 +1,6 @@
 / {
 	mbus {
-		pcie-controller {
+		pciec: pcie-controller {
 			compatible = "marvell,kirkwood-pcie";
 			status = "disabled";
 			device_type = "pci";
@@ -15,7 +15,7 @@
 				0x82000000 0x1 0     MBUS_ID(0x04, 0xe8) 0       1 0 /* Port 0.0 MEM */
 				0x81000000 0x1 0     MBUS_ID(0x04, 0xe0) 0       1 0 /* Port 0.0 IO  */>;
 
-			pcie@1,0 {
+			pcie0: pcie@1,0 {
 				device_type = "pci";
 				assigned-addresses = <0x82000800 0 0x00040000 0 0x2000>;
 				reg = <0x0800 0 0 0 0>;
@@ -76,14 +76,14 @@
 			};
 		};
 
-		rtc@10300 {
+		rtc: rtc@10300 {
 			compatible = "marvell,kirkwood-rtc", "marvell,orion-rtc";
 			reg = <0x10300 0x20>;
 			interrupts = <53>;
 			clocks = <&gate_clk 7>;
 		};
 
-		sata@80000 {
+		sata: sata@80000 {
 			compatible = "marvell,orion-sata";
 			reg = <0x80000 0x5000>;
 			interrupts = <21>;
@@ -92,7 +92,7 @@
 			status = "disabled";
 		};
 
-		mvsdio@90000 {
+		sdio: mvsdio@90000 {
 			compatible = "marvell,orion-sdio";
 			reg = <0x90000 0x200>;
 			interrupts = <28>;
diff --git a/arch/arm/boot/dts/kirkwood-6281.dtsi b/arch/arm/boot/dts/kirkwood-6281.dtsi
index 416d96e1302f..2560cbbdb0b3 100644
--- a/arch/arm/boot/dts/kirkwood-6281.dtsi
+++ b/arch/arm/boot/dts/kirkwood-6281.dtsi
@@ -1,6 +1,6 @@
 / {
 	mbus {
-		pcie-controller {
+		pciec: pcie-controller {
 			compatible = "marvell,kirkwood-pcie";
 			status = "disabled";
 			device_type = "pci";
@@ -15,7 +15,7 @@
 				0x82000000 0x1 0     MBUS_ID(0x04, 0xe8) 0       1 0 /* Port 0.0 MEM */
 				0x81000000 0x1 0     MBUS_ID(0x04, 0xe0) 0       1 0 /* Port 0.0 IO  */>;
 
-			pcie@1,0 {
+			pcie0: pcie@1,0 {
 				device_type = "pci";
 				assigned-addresses = <0x82000800 0 0x00040000 0 0x2000>;
 				reg = <0x0800 0 0 0 0>;
@@ -76,14 +76,14 @@
 			};
 		};
 
-		rtc@10300 {
+		rtc: rtc@10300 {
 			compatible = "marvell,kirkwood-rtc", "marvell,orion-rtc";
 			reg = <0x10300 0x20>;
 			interrupts = <53>;
 			clocks = <&gate_clk 7>;
 		};
 
-		sata@80000 {
+		sata: sata@80000 {
 			compatible = "marvell,orion-sata";
 			reg = <0x80000 0x5000>;
 			interrupts = <21>;
@@ -94,7 +94,7 @@
 			status = "disabled";
 		};
 
-		mvsdio@90000 {
+		sdio: mvsdio@90000 {
 			compatible = "marvell,orion-sdio";
 			reg = <0x90000 0x200>;
 			interrupts = <28>;
diff --git a/arch/arm/boot/dts/kirkwood-6282.dtsi b/arch/arm/boot/dts/kirkwood-6282.dtsi
index 2902e0d7971d..f4b4786b9a01 100644
--- a/arch/arm/boot/dts/kirkwood-6282.dtsi
+++ b/arch/arm/boot/dts/kirkwood-6282.dtsi
@@ -1,6 +1,6 @@
 / {
 	mbus {
-		pcie-controller {
+		pciec: pcie-controller {
 			compatible = "marvell,kirkwood-pcie";
 			status = "disabled";
 			device_type = "pci";
@@ -19,7 +19,7 @@
 				0x82000000 0x2 0     MBUS_ID(0x04, 0xd8) 0       1 0 /* Port 1.0 MEM */
 				0x81000000 0x2 0     MBUS_ID(0x04, 0xd0) 0       1 0 /* Port 1.0 IO  */>;
 
-			pcie@1,0 {
+			pcie0: pcie@1,0 {
 				device_type = "pci";
 				assigned-addresses = <0x82000800 0 0x00040000 0 0x2000>;
 				reg = <0x0800 0 0 0 0>;
@@ -36,7 +36,7 @@
 				status = "disabled";
 			};
 
-			pcie@2,0 {
+			pcie1: pcie@2,0 {
 				device_type = "pci";
 				assigned-addresses = <0x82001000 0 0x00044000 0 0x2000>;
 				reg = <0x1000 0 0 0 0>;
@@ -104,20 +104,20 @@
 			};
 		};
 
-		thermal@10078 {
+		thermal: thermal@10078 {
 			compatible = "marvell,kirkwood-thermal";
 			reg = <0x10078 0x4>;
 			status = "okay";
 		};
 
-		rtc@10300 {
+		rtc: rtc@10300 {
 			compatible = "marvell,kirkwood-rtc", "marvell,orion-rtc";
 			reg = <0x10300 0x20>;
 			interrupts = <53>;
 			clocks = <&gate_clk 7>;
 		};
 
-		i2c@11100 {
+		i2c1: i2c@11100 {
 			compatible = "marvell,mv64xxx-i2c";
 			reg = <0x11100 0x20>;
 			#address-cells = <1>;
@@ -128,7 +128,7 @@
 			status = "disabled";
 		};
 
-		sata@80000 {
+		sata: sata@80000 {
 			compatible = "marvell,orion-sata";
 			reg = <0x80000 0x5000>;
 			interrupts = <21>;
@@ -139,7 +139,7 @@
 			status = "disabled";
 		};
 
-		mvsdio@90000 {
+		sdio: mvsdio@90000 {
 			compatible = "marvell,orion-sdio";
 			reg = <0x90000 0x200>;
 			interrupts = <28>;
diff --git a/arch/arm/boot/dts/kirkwood.dtsi b/arch/arm/boot/dts/kirkwood.dtsi
index 90384587c278..2570e0f1673f 100644
--- a/arch/arm/boot/dts/kirkwood.dtsi
+++ b/arch/arm/boot/dts/kirkwood.dtsi
@@ -40,7 +40,7 @@
 		pcie-mem-aperture = <0xe0000000 0x10000000>; /* 256 MiB memory space */
 		pcie-io-aperture  = <0xf2000000 0x100000>;   /*   1 MiB    I/O space */
 
-		crypto@0301 {
+		cesa: crypto@0301 {
 			compatible = "marvell,orion-crypto";
 			reg = <MBUS_ID(0xf0, 0x01) 0x30000 0x10000>,
 			      <MBUS_ID(0x03, 0x01) 0 0x800>;
@@ -77,7 +77,7 @@
 			#clock-cells = <1>;
 		};
 
-		spi@10600 {
+		spi0: spi@10600 {
 			compatible = "marvell,orion-spi";
 			#address-cells = <1>;
 			#size-cells = <0>;
@@ -123,7 +123,7 @@
 			status = "disabled";
 		};
 
-		serial@12000 {
+		uart0: serial@12000 {
 			compatible = "ns16550a";
 			reg = <0x12000 0x100>;
 			reg-shift = <2>;
@@ -132,7 +132,7 @@
 			status = "disabled";
 		};
 
-		serial@12100 {
+		uart1: serial@12100 {
 			compatible = "ns16550a";
 			reg = <0x12100 0x100>;
 			reg-shift = <2>;
@@ -146,7 +146,7 @@
 			reg = <0x20000 0x80>, <0x1500 0x20>;
 		};
 
-		system-controller@20000 {
+		sysc: system-controller@20000 {
 			compatible = "marvell,orion-system-controller";
 			reg = <0x20000 0x120>;
 		};
@@ -196,7 +196,7 @@
 			status = "okay";
 		};
 
-		ehci@50000 {
+		usb0: ehci@50000 {
 			compatible = "marvell,orion-ehci";
 			reg = <0x50000 0x1000>;
 			interrupts = <19>;
@@ -204,7 +204,7 @@
 			status = "okay";
 		};
 
-		xor@60800 {
+		dma0: xor@60800 {
 			compatible = "marvell,orion-xor";
 			reg = <0x60800 0x100
 			       0x60A00 0x100>;
@@ -224,7 +224,7 @@
 			};
 		};
 
-		xor@60900 {
+		dma1: xor@60900 {
 			compatible = "marvell,orion-xor";
 			reg = <0x60900 0x100
 			       0x60B00 0x100>;
-- 
1.9.1

