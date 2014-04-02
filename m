Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932718AbaDBRFy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 13:05:54 -0400
Received: from mail.kmu-office.ch ([178.209.48.102]:33022 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932701AbaDBRFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 13:05:49 -0400
From: stefan@agner.ch
To: shawn.guo@freescale.com, kernel@pengutronix.de, viresh.linux@gmail.com
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        stefan@agner.ch
Subject: [PATCH v2 2/2] ARM: dts: SPEAr: fix wrong stmpe-ts bindings
Date: Wed,  2 Apr 2014 19:05:38 +0200
Message-Id: <d4a7f6bcdf6ec00970aabb9ff501c7d342f37bd7.1396457876.git.stefan@agner.ch>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1396457876.git.stefan@agner.ch>
References: <cover.1396457876.git.stefan@agner.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Agner <stefan@agner.ch>

Fix bindings for STMPE touchscreen controller to match the documented
bindings and the actual bindings used by the driver.

Signed-off-by: Stefan Agner <stefan@agner.ch>
Reviewed-by: Marek Vasut <marex@denx.de>
---
 arch/arm/boot/dts/spear1310-evb.dts | 18 +++++++++---------
 arch/arm/boot/dts/spear1340-evb.dts | 18 +++++++++---------
 arch/arm/boot/dts/spear320-hmi.dts  | 20 ++++++++++----------
 3 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/arch/arm/boot/dts/spear1310-evb.dts b/arch/arm/boot/dts/spear1310-evb.dts
index b56a801..fe2ece2 100644
--- a/arch/arm/boot/dts/spear1310-evb.dts
+++ b/arch/arm/boot/dts/spear1310-evb.dts
@@ -369,15 +369,15 @@
 
 					stmpe_touchscreen {
 						compatible = "st,stmpe-ts";
-						ts,sample-time = <4>;
-						ts,mod-12b = <1>;
-						ts,ref-sel = <0>;
-						ts,adc-freq = <1>;
-						ts,ave-ctrl = <1>;
-						ts,touch-det-delay = <2>;
-						ts,settling = <2>;
-						ts,fraction-z = <7>;
-						ts,i-drive = <1>;
+						st,sample-time = <4>;
+						st,mod-12b = <1>;
+						st,ref-sel = <0>;
+						st,adc-freq = <1>;
+						st,ave-ctrl = <1>;
+						st,touch-det-delay = <2>;
+						st,settling = <2>;
+						st,fraction-z = <7>;
+						st,i-drive = <1>;
 					};
 				};
 
diff --git a/arch/arm/boot/dts/spear1340-evb.dts b/arch/arm/boot/dts/spear1340-evb.dts
index d6c30ae..d3dcba9 100644
--- a/arch/arm/boot/dts/spear1340-evb.dts
+++ b/arch/arm/boot/dts/spear1340-evb.dts
@@ -480,15 +480,15 @@
 
 					stmpe_touchscreen {
 						compatible = "st,stmpe-ts";
-						ts,sample-time = <4>;
-						ts,mod-12b = <1>;
-						ts,ref-sel = <0>;
-						ts,adc-freq = <1>;
-						ts,ave-ctrl = <1>;
-						ts,touch-det-delay = <2>;
-						ts,settling = <2>;
-						ts,fraction-z = <7>;
-						ts,i-drive = <1>;
+						st,sample-time = <4>;
+						st,mod-12b = <1>;
+						st,ref-sel = <0>;
+						st,adc-freq = <1>;
+						st,ave-ctrl = <1>;
+						st,touch-det-delay = <2>;
+						st,settling = <2>;
+						st,fraction-z = <7>;
+						st,i-drive = <1>;
 					};
 				};
 
diff --git a/arch/arm/boot/dts/spear320-hmi.dts b/arch/arm/boot/dts/spear320-hmi.dts
index 3075d2d..2a5d013 100644
--- a/arch/arm/boot/dts/spear320-hmi.dts
+++ b/arch/arm/boot/dts/spear320-hmi.dts
@@ -256,17 +256,17 @@
 					};
 
 					stmpe610-ts {
-						compatible = "stmpe,ts";
+						compatible = "st,stmpe-ts";
 						reg = <0>;
-						ts,sample-time = <4>;
-						ts,mod-12b = <1>;
-						ts,ref-sel = <0>;
-						ts,adc-freq = <1>;
-						ts,ave-ctrl = <1>;
-						ts,touch-det-delay = <3>;
-						ts,settling = <4>;
-						ts,fraction-z = <7>;
-						ts,i-drive = <1>;
+						st,sample-time = <4>;
+						st,mod-12b = <1>;
+						st,ref-sel = <0>;
+						st,adc-freq = <1>;
+						st,ave-ctrl = <1>;
+						st,touch-det-delay = <3>;
+						st,settling = <4>;
+						st,fraction-z = <7>;
+						st,i-drive = <1>;
 					};
 				};
 			};
-- 
1.9.1

