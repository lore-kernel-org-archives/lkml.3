Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755119AbaI2OqZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 10:46:25 -0400
Received: from top.free-electrons.com ([176.31.233.9]:47979 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754449AbaI2Ooj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 10:44:39 -0400
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
Subject: [PATCH v6 08/11] ARM: AT91/dt: add alternative pin muxing for sama5d3 lcd pins
Date: Mon, 29 Sep 2014 16:44:21 +0200
Message-Id: <1412001864-3251-9-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412001864-3251-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1412001864-3251-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Boris BREZILLON <boris.brezillon@free-electrons.com>

Define alternative pin muxing for the LCDC pins.

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
Tested-by: Anthony Harivel <anthony.harivel@emtrion.de>
---
 arch/arm/boot/dts/sama5d3_lcd.dtsi | 50 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/arch/arm/boot/dts/sama5d3_lcd.dtsi b/arch/arm/boot/dts/sama5d3_lcd.dtsi
index 2186b89..e7581f6 100644
--- a/arch/arm/boot/dts/sama5d3_lcd.dtsi
+++ b/arch/arm/boot/dts/sama5d3_lcd.dtsi
@@ -82,6 +82,28 @@
 							 AT91_PIOA 13 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD13 pin */
 							 AT91_PIOA 14 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD14 pin */
 							 AT91_PIOA 15 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD15 pin */
+							 AT91_PIOA 16 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD16 pin */
+							 AT91_PIOA 17 AT91_PERIPH_A AT91_PINCTRL_NONE>;	/* LCDD17 pin */
+					};
+
+					pinctrl_lcd_rgb666_alt: lcd-rgb-2-alt {
+						atmel,pins =
+							<AT91_PIOA 0 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD0 pin */
+							 AT91_PIOA 1 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD1 pin */
+							 AT91_PIOA 2 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD2 pin */
+							 AT91_PIOA 3 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD3 pin */
+							 AT91_PIOA 4 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD4 pin */
+							 AT91_PIOA 5 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD5 pin */
+							 AT91_PIOA 6 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD6 pin */
+							 AT91_PIOA 7 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD7 pin */
+							 AT91_PIOA 8 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD8 pin */
+							 AT91_PIOA 9 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD9 pin */
+							 AT91_PIOA 10 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD10 pin */
+							 AT91_PIOA 11 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD11 pin */
+							 AT91_PIOA 12 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD12 pin */
+							 AT91_PIOA 13 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD13 pin */
+							 AT91_PIOA 14 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD14 pin */
+							 AT91_PIOA 15 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD15 pin */
 							 AT91_PIOC 14 AT91_PERIPH_C AT91_PINCTRL_NONE	/* LCDD16 pin */
 							 AT91_PIOC 13 AT91_PERIPH_C AT91_PINCTRL_NONE>;	/* LCDD17 pin */
 					};
@@ -104,6 +126,34 @@
 							 AT91_PIOA 13 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD13 pin */
 							 AT91_PIOA 14 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD14 pin */
 							 AT91_PIOA 15 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD15 pin */
+							 AT91_PIOA 16 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD16 pin */
+							 AT91_PIOA 17 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD17 pin */
+							 AT91_PIOA 18 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD18 pin */
+							 AT91_PIOA 19 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD19 pin */
+							 AT91_PIOA 20 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD20 pin */
+							 AT91_PIOA 21 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD21 pin */
+							 AT91_PIOA 22 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD22 pin */
+							 AT91_PIOA 23 AT91_PERIPH_A AT91_PINCTRL_NONE>;	/* LCDD23 pin */
+					};
+
+					pinctrl_lcd_rgb888_alt: lcd-rgb-3-alt {
+						atmel,pins =
+							<AT91_PIOA 0 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD0 pin */
+							 AT91_PIOA 1 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD1 pin */
+							 AT91_PIOA 2 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD2 pin */
+							 AT91_PIOA 3 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD3 pin */
+							 AT91_PIOA 4 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD4 pin */
+							 AT91_PIOA 5 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD5 pin */
+							 AT91_PIOA 6 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD6 pin */
+							 AT91_PIOA 7 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD7 pin */
+							 AT91_PIOA 8 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD8 pin */
+							 AT91_PIOA 9 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD9 pin */
+							 AT91_PIOA 10 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD10 pin */
+							 AT91_PIOA 11 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD11 pin */
+							 AT91_PIOA 12 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD12 pin */
+							 AT91_PIOA 13 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD13 pin */
+							 AT91_PIOA 14 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD14 pin */
+							 AT91_PIOA 15 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD15 pin */
 							 AT91_PIOC 14 AT91_PERIPH_C AT91_PINCTRL_NONE	/* LCDD16 pin */
 							 AT91_PIOC 13 AT91_PERIPH_C AT91_PINCTRL_NONE	/* LCDD17 pin */
 							 AT91_PIOC 12 AT91_PERIPH_C AT91_PINCTRL_NONE	/* LCDD18 pin */
-- 
1.9.1

