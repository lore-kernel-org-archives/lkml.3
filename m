Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933114AbaLMBrX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 20:47:23 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:38704 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933017AbaLMBrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 20:47:07 -0500
From: Silvio Fricke <silvio.fricke@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Silvio Fricke <silvio.fricke@gmail.com>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 3/3] ARM: SPEAr: dts: remove unused irq-trigger, id and block entries
Date: Sat, 13 Dec 2014 02:46:48 +0100
Message-Id: <557b9b23d0313dede22786d9550c7867d9f22837.1418434448.git.silvio.fricke@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <cover.1418434448.git.silvio.fricke@gmail.com>
References: <cover.1418434448.git.silvio.fricke@gmail.com>
In-Reply-To: <cover.1418434448.git.silvio.fricke@gmail.com>
References: <cover.1418434448.git.silvio.fricke@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Silvio Fricke <silvio.fricke@gmail.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Jason Cooper <jason@lakedaemon.net>
CC: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/boot/dts/spear1310-evb.dts | 1 -
 arch/arm/boot/dts/spear1340-evb.dts | 2 --
 arch/arm/boot/dts/spear320-hmi.dts  | 3 ---
 3 files changed, 6 deletions(-)

diff --git a/arch/arm/boot/dts/spear1310-evb.dts b/arch/arm/boot/dts/spear1310-evb.dts
index d42c84b..95c2ff1 100644
--- a/arch/arm/boot/dts/spear1310-evb.dts
+++ b/arch/arm/boot/dts/spear1310-evb.dts
@@ -369,7 +369,6 @@
 					pl022,duplex = <0>;
 					interrupts = <6 0x4>;
 					interrupt-parent = <&gpio1>;
-					irq-trigger = <0x2>;
 
 					stmpe_touchscreen {
 						compatible = "st,stmpe-ts";
diff --git a/arch/arm/boot/dts/spear1340-evb.dts b/arch/arm/boot/dts/spear1340-evb.dts
index b23e05e..bba3389 100644
--- a/arch/arm/boot/dts/spear1340-evb.dts
+++ b/arch/arm/boot/dts/spear1340-evb.dts
@@ -325,7 +325,6 @@
 					reg = <0x41>;
 					interrupts = <4 0x4>;
 					interrupt-parent = <&gpio0>;
-					irq-trigger = <0x2>;
 
 					stmpegpio: stmpe_gpio {
 						compatible = "st,stmpe-gpio";
@@ -478,7 +477,6 @@
 					pl022,duplex = <0>;
 					interrupts = <100 0>;
 					interrupt-parent = <&gpiopinctrl>;
-					irq-trigger = <0x2>;
 					#address-cells = <1>;
 					#size-cells = <0>;
 
diff --git a/arch/arm/boot/dts/spear320-hmi.dts b/arch/arm/boot/dts/spear320-hmi.dts
index 0aa6fef..f8ed01e 100644
--- a/arch/arm/boot/dts/spear320-hmi.dts
+++ b/arch/arm/boot/dts/spear320-hmi.dts
@@ -243,9 +243,6 @@
 					reg = <0x41>;
 					irq-over-gpio;
 					irq-gpios = <&gpiopinctrl 29 0x4>;
-					id = <0>;
-					blocks = <0x5>;
-					irq-trigger = <0x1>;
 
 					stmpegpio: stmpe-gpio {
 						compatible = "stmpe,gpio";
-- 
2.1.3

