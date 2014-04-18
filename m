Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746AbaDRJuw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 05:50:52 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:64300 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488AbaDRJtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 05:49:50 -0400
From: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
To: nicolas.ferre@atmel.com, boris.brezillon@free-electrons.com,
        linux-arm-kernel@lists.infradead.org, dri-devel@lists.freedesktop.org
Cc: plagnioj@jcrosoft.com, airlied@linux.ie, robdclark@gmail.com,
        linux-kernel@vger.kernel.org,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Subject: [RFC 2/3] atmel: drm: dt: Added DT entry for the atmel hlcdc found in the sama5
Date: Fri, 18 Apr 2014 11:45:08 +0200
Message-Id: <1397814309-32160-3-git-send-email-jjhiblot@traphandler.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1397814309-32160-1-git-send-email-jjhiblot@traphandler.com>
References: <1397814309-32160-1-git-send-email-jjhiblot@traphandler.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
---
 arch/arm/boot/dts/sama5d3_lcd.dtsi | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm/boot/dts/sama5d3_lcd.dtsi b/arch/arm/boot/dts/sama5d3_lcd.dtsi
index 85d3027..2a2bced 100644
--- a/arch/arm/boot/dts/sama5d3_lcd.dtsi
+++ b/arch/arm/boot/dts/sama5d3_lcd.dtsi
@@ -51,6 +51,17 @@
 				};
 			};
 
+			hlcdc: hlcdc@f0030000 {
+				compatible = "atmel,hlcdc";
+				reg = <0xf0030000 0x4000>;
+				interrupts = <36 IRQ_TYPE_LEVEL_HIGH 0>;
+				clocks = <&lcdc_clk>, <&lcdck>;
+				clock-names = "lcdc_clk","bus_clk";
+				pinctrl-names = "default";
+				pinctrl-0 = <&pinctrl_lcd>;
+				status = "disabled";
+			};
+
 			pmc: pmc@fffffc00 {
 				periphck {
 					lcdc_clk: lcdc_clk {
-- 
1.9.1

