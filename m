Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484Ab3BAFoU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 00:44:20 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:34828 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755408Ab3BAFoP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 00:44:15 -0500
From: Philip Avinash <avinashphilip@ti.com>
To: <b-cousson@ti.com>, <tony@atomide.com>, <linux@arm.linux.org.uk>
CC: <linux-omap@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <nsekhar@ti.com>, <gururaja.hebbar@ti.com>, <vaibhav.bedia@ti.com>,
        <hvaibhav@ti.com>, Philip Avinash <avinashphilip@ti.com>
Subject: [PATCH] ARM: dts: AM33XX: Corrects typo in interrupt field in SPI node
Date: Fri, 1 Feb 2013 11:07:27 +0530
Message-ID: <1359697047-1816-1-git-send-email-avinashphilip@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DT field of "interrupts" was mentioned wrongly as "interrupt" in SPI
node. This went unnoticed as spi-omap2 driver not making use of
interrupt. Fixes the typo.

Signed-off-by: Philip Avinash <avinashphilip@ti.com>
---
 arch/arm/boot/dts/am33xx.dtsi |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
index fbcb90b..cece3ad 100644
--- a/arch/arm/boot/dts/am33xx.dtsi
+++ b/arch/arm/boot/dts/am33xx.dtsi
@@ -309,7 +309,7 @@
 			#address-cells = <1>;
 			#size-cells = <0>;
 			reg = <0x48030000 0x400>;
-			interrupt = <65>;
+			interrupts = <65>;
 			ti,spi-num-cs = <2>;
 			ti,hwmods = "spi0";
 			status = "disabled";
@@ -320,7 +320,7 @@
 			#address-cells = <1>;
 			#size-cells = <0>;
 			reg = <0x481a0000 0x400>;
-			interrupt = <125>;
+			interrupts = <125>;
 			ti,spi-num-cs = <2>;
 			ti,hwmods = "spi1";
 			status = "disabled";
-- 
1.7.9.5

