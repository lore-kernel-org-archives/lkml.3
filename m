Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934053AbaFIQHk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 12:07:40 -0400
Received: from top.free-electrons.com ([176.31.233.9]:50364 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933567AbaFIQEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 12:04:33 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Thierry Reding <thierry.reding@gmail.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        David Airlie <airlied@linux.ie>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>
Cc: Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pwm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, dri-devel@lists.freedesktop.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH v2 7/7] ARM: at91/dt: enable the LCD panel on sama5d3xek boards
Date: Mon,  9 Jun 2014 18:04:20 +0200
Message-Id: <1402329860-27520-8-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1402329860-27520-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1402329860-27520-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable LCD related nodes and reference panel node in the hlcdc (High
LCD Controller) controller on sama5d3xek boards.

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
---
 arch/arm/boot/dts/sama5d31ek.dts | 24 ++++++++++++++++++++++++
 arch/arm/boot/dts/sama5d33ek.dts | 24 ++++++++++++++++++++++++
 arch/arm/boot/dts/sama5d34ek.dts | 24 ++++++++++++++++++++++++
 arch/arm/boot/dts/sama5d36ek.dts | 24 ++++++++++++++++++++++++
 4 files changed, 96 insertions(+)

diff --git a/arch/arm/boot/dts/sama5d31ek.dts b/arch/arm/boot/dts/sama5d31ek.dts
index 04eec0d..338f4c3 100644
--- a/arch/arm/boot/dts/sama5d31ek.dts
+++ b/arch/arm/boot/dts/sama5d31ek.dts
@@ -33,6 +33,14 @@
 				status = "okay";
 			};
 
+			hlcdc: hlcdc@f0030000 {
+				status = "okay";
+
+				hlcdc-display-controller {
+					atmel,panel = <&panel 3 0>;
+				};
+			};
+
 			macb1: ethernet@f802c000 {
 				status = "okay";
 			};
@@ -46,6 +54,22 @@
 		};
 	};
 
+	bl_reg: backlight_regulator {
+		status = "okay";
+	};
+
+	panel_reg: panel_regulator {
+		status = "okay";
+	};
+
+	backlight: backlight {
+		status = "okay";
+	};
+
+	panel: panel {
+		status = "okay";
+	};
+
 	sound {
 		status = "okay";
 	};
diff --git a/arch/arm/boot/dts/sama5d33ek.dts b/arch/arm/boot/dts/sama5d33ek.dts
index cbd6a3f..f2ab41d 100644
--- a/arch/arm/boot/dts/sama5d33ek.dts
+++ b/arch/arm/boot/dts/sama5d33ek.dts
@@ -36,9 +36,33 @@
 			macb0: ethernet@f0028000 {
 				status = "okay";
 			};
+
+			hlcdc: hlcdc@f0030000 {
+				status = "okay";
+
+				hlcdc-display-controller {
+					atmel,panel = <&panel 3 0>;
+				};
+			};
 		};
 	};
 
+	bl_reg: backlight_regulator {
+		status = "okay";
+	};
+
+	panel_reg: panel_regulator {
+		status = "okay";
+	};
+
+	backlight: backlight {
+		status = "okay";
+	};
+
+	panel: panel {
+		status = "okay";
+	};
+
 	sound {
 		status = "okay";
 	};
diff --git a/arch/arm/boot/dts/sama5d34ek.dts b/arch/arm/boot/dts/sama5d34ek.dts
index 878aa16..0d0049c 100644
--- a/arch/arm/boot/dts/sama5d34ek.dts
+++ b/arch/arm/boot/dts/sama5d34ek.dts
@@ -46,6 +46,14 @@
 			macb0: ethernet@f0028000 {
 				status = "okay";
 			};
+
+			hlcdc: hlcdc@f0030000 {
+				status = "okay";
+
+				hlcdc-display-controller {
+					atmel,panel = <&panel 3 0>;
+				};
+			};
 		};
 	};
 
@@ -56,6 +64,22 @@
 		};
 	};
 
+	bl_reg: backlight_regulator {
+		status = "okay";
+	};
+
+	panel_reg: panel_regulator {
+		status = "okay";
+	};
+
+	backlight: backlight {
+		status = "okay";
+	};
+
+	panel: panel {
+		status = "okay";
+	};
+
 	sound {
 		status = "okay";
 	};
diff --git a/arch/arm/boot/dts/sama5d36ek.dts b/arch/arm/boot/dts/sama5d36ek.dts
index 59576c6..8350358 100644
--- a/arch/arm/boot/dts/sama5d36ek.dts
+++ b/arch/arm/boot/dts/sama5d36ek.dts
@@ -41,12 +41,36 @@
 				status = "okay";
 			};
 
+			hlcdc: hlcdc@f0030000 {
+				status = "okay";
+
+				hlcdc-display-controller {
+					atmel,panel = <&panel 3 0>;
+				};
+			};
+
 			macb1: ethernet@f802c000 {
 				status = "okay";
 			};
 		};
 	};
 
+	bl_reg: backlight_regulator {
+		status = "okay";
+	};
+
+	panel_reg: panel_regulator {
+		status = "okay";
+	};
+
+	backlight: backlight {
+		status = "okay";
+	};
+
+	panel: panel {
+		status = "okay";
+	};
+
 	sound {
 		status = "okay";
 	};
-- 
1.8.3.2

