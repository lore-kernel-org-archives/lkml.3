Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761413Ab3LIUPw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 15:15:52 -0500
Received: from mail.kmu-office.ch ([178.209.48.102]:43057 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755964Ab3LIUPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 15:15:50 -0500
From: Stefan Agner <stefan@agner.ch>
To: stefan@agner.ch, marex@denx.de, viresh.linux@gmail.com,
        shiraz.hashim@st.com
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        galak@codeaurora.org, ijc+devicetree@hellion.org.uk,
        mark.rutland@arm.com, pawel.moll@arm.com, rob.herring@calxeda.com
Subject: [PATCH] ARM: dts: stmpe-ts: fix wrong bindings
Date: Mon,  9 Dec 2013 21:15:11 +0100
Message-Id: <1386620111-1413-1-git-send-email-stefan@agner.ch>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix bindings for STMPE touchscreen device to match the documented
bindings and the actual bindings used by the driver.

Signed-off-by: Stefan Agner <stefan@agner.ch>
---
I don't have any of these hardware, but the error is obvious. The device
probably works anyway since the device/driver will use default values.
---
 arch/arm/boot/dts/imx53-m53evk.dts  | 20 ++++++++++----------
 arch/arm/boot/dts/spear1310-evb.dts | 18 +++++++++---------
 arch/arm/boot/dts/spear1340-evb.dts | 18 +++++++++---------
 arch/arm/boot/dts/spear320-hmi.dts  | 20 ++++++++++----------
 4 files changed, 38 insertions(+), 38 deletions(-)

diff --git a/arch/arm/boot/dts/imx53-m53evk.dts b/arch/arm/boot/dts/imx53-m53evk.dts
index 7d304d0..e97f298 100644
--- a/arch/arm/boot/dts/imx53-m53evk.dts
+++ b/arch/arm/boot/dts/imx53-m53evk.dts
@@ -165,17 +165,17 @@
 		irq-trigger = <0x1>;
 
 		stmpe_touchscreen {
-			compatible = "stmpe,ts";
+			compatible = "st,stmpe-ts";
 			reg = <0>;
-			ts,sample-time = <4>;
-			ts,mod-12b = <1>;
-			ts,ref-sel = <0>;
-			ts,adc-freq = <1>;
-			ts,ave-ctrl = <3>;
-			ts,touch-det-delay = <3>;
-			ts,settling = <4>;
-			ts,fraction-z = <7>;
-			ts,i-drive = <1>;
+			st,sample-time = <4>;
+			st,mod-12b = <1>;
+			st,ref-sel = <0>;
+			st,adc-freq = <1>;
+			st,ave-ctrl = <3>;
+			st,touch-det-delay = <3>;
+			st,settling = <4>;
+			st,fraction-z = <7>;
+			st,i-drive = <1>;
 		};
 	};
 
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
1.8.4.2

