Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751377AbaCWTfT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 15:35:19 -0400
Received: from albert.telenet-ops.be ([195.130.137.90]:47350 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbaCWTfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 15:35:16 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Subject: [PATCH 2/2] ARM: shmobile: kzm9g-reference dts: Use KEY_* macros for gpio-keys
Date: Sun, 23 Mar 2014 20:35:02 +0100
Message-Id: <1395603302-32056-2-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1395603302-32056-1-git-send-email-geert@linux-m68k.org>
References: <1395603302-32056-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
---
 arch/arm/boot/dts/sh73a0-kzm9g-reference.dts |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/arch/arm/boot/dts/sh73a0-kzm9g-reference.dts b/arch/arm/boot/dts/sh73a0-kzm9g-reference.dts
index eb8886b535e4..a99171c8a782 100644
--- a/arch/arm/boot/dts/sh73a0-kzm9g-reference.dts
+++ b/arch/arm/boot/dts/sh73a0-kzm9g-reference.dts
@@ -14,6 +14,7 @@
 /dts-v1/;
 #include "sh73a0.dtsi"
 #include <dt-bindings/gpio/gpio.h>
+#include <dt-bindings/input/input.h>
 #include <dt-bindings/interrupt-controller/irq.h>
 
 / {
@@ -112,43 +113,43 @@
 
 		back-key {
 			gpios = <&pcf8575 8 GPIO_ACTIVE_LOW>;
-			linux,code = <158>;
+			linux,code = <KEY_BACK>;
 			label = "SW3";
 		};
 
 		right-key {
 			gpios = <&pcf8575 9 GPIO_ACTIVE_LOW>;
-			linux,code = <106>;
+			linux,code = <KEY_RIGHT>;
 			label = "SW2-R";
 		};
 
 		left-key {
 			gpios = <&pcf8575 10 GPIO_ACTIVE_LOW>;
-			linux,code = <105>;
+			linux,code = <KEY_LEFT>;
 			label = "SW2-L";
 		};
 
 		enter-key {
 			gpios = <&pcf8575 11 GPIO_ACTIVE_LOW>;
-			linux,code = <28>;
+			linux,code = <KEY_ENTER>;
 			label = "SW2-P";
 		};
 
 		up-key {
 			gpios = <&pcf8575 12 GPIO_ACTIVE_LOW>;
-			linux,code = <103>;
+			linux,code = <KEY_UP>;
 			label = "SW2-U";
 		};
 
 		down-key {
 			gpios = <&pcf8575 13 GPIO_ACTIVE_LOW>;
-			linux,code = <108>;
+			linux,code = <KEY_DOWN>;
 			label = "SW2-D";
 		};
 
 		home-key {
 			gpios = <&pcf8575 14 GPIO_ACTIVE_LOW>;
-			linux,code = <102>;
+			linux,code = <KEY_HOME>;
 			label = "SW1";
 		};
 	};
-- 
1.7.9.5

