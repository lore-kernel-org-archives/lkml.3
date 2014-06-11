Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750835AbaFKI52 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 04:57:28 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:59743 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751238AbaFKI5X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 04:57:23 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>, <dwmw2@infradead.org>, <computersforpeace@gmail.com>
CC: <kyungmin.park@samsung.com>, <pekon@ti.com>,
        <ezequiel.garcia@free-electrons.com>, <javier@dowhile0.org>,
        <nsekhar@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-mtd@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: [PATCH 02/36] ARM: dts: OMAP2+: Fix GPMC register space size
Date: Wed, 11 Jun 2014 11:56:07 +0300
Message-ID: <1402477001-31132-3-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1402477001-31132-1-git-send-email-rogerq@ti.com>
References: <1402477001-31132-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use actual register space size from Reference Manual.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/boot/dts/am33xx.dtsi   | 2 +-
 arch/arm/boot/dts/am4372.dtsi   | 2 +-
 arch/arm/boot/dts/omap2420.dtsi | 2 +-
 arch/arm/boot/dts/omap2430.dtsi | 2 +-
 arch/arm/boot/dts/omap3.dtsi    | 2 +-
 arch/arm/boot/dts/omap4.dtsi    | 2 +-
 arch/arm/boot/dts/omap5.dtsi    | 2 +-
 7 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
index 7ad75b4..27f0b25 100644
--- a/arch/arm/boot/dts/am33xx.dtsi
+++ b/arch/arm/boot/dts/am33xx.dtsi
@@ -767,7 +767,7 @@
 			compatible = "ti,am3352-gpmc";
 			ti,hwmods = "gpmc";
 			ti,no-idle-on-init;
-			reg = <0x50000000 0x2000>;
+			reg = <0x50000000 0x36c>;
 			interrupts = <100>;
 			gpmc,num-cs = <7>;
 			gpmc,num-waitpins = <2>;
diff --git a/arch/arm/boot/dts/am4372.dtsi b/arch/arm/boot/dts/am4372.dtsi
index d1f8707..0014d5d 100644
--- a/arch/arm/boot/dts/am4372.dtsi
+++ b/arch/arm/boot/dts/am4372.dtsi
@@ -727,7 +727,7 @@
 			ti,hwmods = "gpmc";
 			clocks = <&l3s_gclk>;
 			clock-names = "fck";
-			reg = <0x50000000 0x2000>;
+			reg = <0x50000000 0x36c>;
 			interrupts = <GIC_SPI 100 IRQ_TYPE_LEVEL_HIGH>;
 			gpmc,num-cs = <7>;
 			gpmc,num-waitpins = <2>;
diff --git a/arch/arm/boot/dts/omap2420.dtsi b/arch/arm/boot/dts/omap2420.dtsi
index 2d99798..d0f5953 100644
--- a/arch/arm/boot/dts/omap2420.dtsi
+++ b/arch/arm/boot/dts/omap2420.dtsi
@@ -79,7 +79,7 @@
 
 		gpmc: gpmc@6800a000 {
 			compatible = "ti,omap2420-gpmc";
-			reg = <0x6800a000 0x1000>;
+			reg = <0x6800a000 0x23c>;
 			#address-cells = <2>;
 			#size-cells = <1>;
 			interrupts = <20>;
diff --git a/arch/arm/boot/dts/omap2430.dtsi b/arch/arm/boot/dts/omap2430.dtsi
index 42d2c61..94f81e8 100644
--- a/arch/arm/boot/dts/omap2430.dtsi
+++ b/arch/arm/boot/dts/omap2430.dtsi
@@ -106,7 +106,7 @@
 
 		gpmc: gpmc@6e000000 {
 			compatible = "ti,omap2430-gpmc";
-			reg = <0x6e000000 0x1000>;
+			reg = <0x6e000000 0x23c>;
 			#address-cells = <2>;
 			#size-cells = <1>;
 			interrupts = <20>;
diff --git a/arch/arm/boot/dts/omap3.dtsi b/arch/arm/boot/dts/omap3.dtsi
index 4231191..fc7a3e3 100644
--- a/arch/arm/boot/dts/omap3.dtsi
+++ b/arch/arm/boot/dts/omap3.dtsi
@@ -687,7 +687,7 @@
 		gpmc: gpmc@6e000000 {
 			compatible = "ti,omap3430-gpmc";
 			ti,hwmods = "gpmc";
-			reg = <0x6e000000 0x02d0>;
+			reg = <0x6e000000 0x02d4>;
 			interrupts = <20>;
 			gpmc,num-cs = <8>;
 			gpmc,num-waitpins = <4>;
diff --git a/arch/arm/boot/dts/omap4.dtsi b/arch/arm/boot/dts/omap4.dtsi
index 649b5cd..469c699 100644
--- a/arch/arm/boot/dts/omap4.dtsi
+++ b/arch/arm/boot/dts/omap4.dtsi
@@ -288,7 +288,7 @@
 
 		gpmc: gpmc@50000000 {
 			compatible = "ti,omap4430-gpmc";
-			reg = <0x50000000 0x1000>;
+			reg = <0x50000000 0x37c>;
 			#address-cells = <2>;
 			#size-cells = <1>;
 			interrupts = <GIC_SPI 20 IRQ_TYPE_LEVEL_HIGH>;
diff --git a/arch/arm/boot/dts/omap5.dtsi b/arch/arm/boot/dts/omap5.dtsi
index 36b4312..187c93f 100644
--- a/arch/arm/boot/dts/omap5.dtsi
+++ b/arch/arm/boot/dts/omap5.dtsi
@@ -317,7 +317,7 @@
 
 		gpmc: gpmc@50000000 {
 			compatible = "ti,omap4430-gpmc";
-			reg = <0x50000000 0x1000>;
+			reg = <0x50000000 0x37c>;
 			#address-cells = <2>;
 			#size-cells = <1>;
 			interrupts = <GIC_SPI 20 IRQ_TYPE_LEVEL_HIGH>;
-- 
1.8.3.2

