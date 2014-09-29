Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755046AbaI2Oo6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 10:44:58 -0400
Received: from top.free-electrons.com ([176.31.233.9]:47988 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754881AbaI2Oom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 10:44:42 -0400
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>, linux-pwm@vger.kernel.org,
        Rob Clark <robdclark@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mark Yao <mark.yao@rock-chips.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH v6 11/11] ARM: at91/dt: enable the LCD panel on sama5d3xek boards
Date: Mon, 29 Sep 2014 16:44:24 +0200
Message-Id: <1412001864-3251-12-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412001864-3251-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1412001864-3251-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Boris BREZILLON <boris.brezillon@free-electrons.com>

Enable LCD related nodes.

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
---
 arch/arm/boot/dts/sama5d31ek.dts | 20 ++++++++++++++++++++
 arch/arm/boot/dts/sama5d33ek.dts | 20 ++++++++++++++++++++
 arch/arm/boot/dts/sama5d34ek.dts | 20 ++++++++++++++++++++
 arch/arm/boot/dts/sama5d36ek.dts | 20 ++++++++++++++++++++
 4 files changed, 80 insertions(+)

diff --git a/arch/arm/boot/dts/sama5d31ek.dts b/arch/arm/boot/dts/sama5d31ek.dts
index 04eec0d..6e605fe 100644
--- a/arch/arm/boot/dts/sama5d31ek.dts
+++ b/arch/arm/boot/dts/sama5d31ek.dts
@@ -33,6 +33,10 @@
 				status = "okay";
 			};
 
+			hlcdc: hlcdc@f0030000 {
+				status = "okay";
+			};
+
 			macb1: ethernet@f802c000 {
 				status = "okay";
 			};
@@ -46,6 +50,22 @@
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
index cbd6a3f..0400641 100644
--- a/arch/arm/boot/dts/sama5d33ek.dts
+++ b/arch/arm/boot/dts/sama5d33ek.dts
@@ -36,9 +36,29 @@
 			macb0: ethernet@f0028000 {
 				status = "okay";
 			};
+
+			hlcdc: hlcdc@f0030000 {
+				status = "okay";
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
index 878aa16..9cf473e 100644
--- a/arch/arm/boot/dts/sama5d34ek.dts
+++ b/arch/arm/boot/dts/sama5d34ek.dts
@@ -46,6 +46,10 @@
 			macb0: ethernet@f0028000 {
 				status = "okay";
 			};
+
+			hlcdc: hlcdc@f0030000 {
+				status = "okay";
+			};
 		};
 	};
 
@@ -56,6 +60,22 @@
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
index 59576c6..1c65741 100644
--- a/arch/arm/boot/dts/sama5d36ek.dts
+++ b/arch/arm/boot/dts/sama5d36ek.dts
@@ -41,12 +41,32 @@
 				status = "okay";
 			};
 
+			hlcdc: hlcdc@f0030000 {
+				status = "okay";
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
1.9.1

