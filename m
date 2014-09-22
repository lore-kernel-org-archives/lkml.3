Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754613AbaIVRJm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 13:09:42 -0400
Received: from mail.kmu-office.ch ([178.209.48.102]:58148 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754486AbaIVRJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 13:09:40 -0400
X-Amavis-Alert: BAD HEADER, Duplicate header field: "In-Reply-To"
From: Stefan Agner <stefan@agner.ch>
To: shawn.guo@freescale.com, kernel@pengutronix.de, linus.walleij@linaro.org,
        gnurou@gmail.com
Cc: linux@arm.linux.org.uk, jingchang.lu@freescale.com, b20788@freescale.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org, stefan@agner.ch
Subject: [PATCH 2/9] ARM: dts: vf610: add global power controller (GPC)
Date: Mon, 22 Sep 2014 19:09:23 +0200
Message-Id: <21796ac49b3b40094cdea25f6d7c887dc53eefab.1411404079.git.stefan@agner.ch>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1411404079.git.stefan@agner.ch>
References: <cover.1411404079.git.stefan@agner.ch>
In-Reply-To: <cover.1411404079.git.stefan@agner.ch>
References: <cover.1411404079.git.stefan@agner.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add global power controller module (GPC) to Vybrid device tree.

Signed-off-by: Stefan Agner <stefan@agner.ch>
---
 arch/arm/boot/dts/vf610.dtsi | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/boot/dts/vf610.dtsi b/arch/arm/boot/dts/vf610.dtsi
index 122a64956..67bb3b7 100644
--- a/arch/arm/boot/dts/vf610.dtsi
+++ b/arch/arm/boot/dts/vf610.dtsi
@@ -367,6 +367,11 @@
 				clocks = <&clks VF610_CLK_USBC0>;
 			};
 
+			gpc: gpc@4006c000 {
+				compatible = "fsl,vf610-gpc";
+				reg = <0x4006c000 0x1000>;
+			};
+
 			src: src@4006e000 {
 				compatible = "fsl,vf610-src";
 				reg = <0x4006e000 0x1000>;
-- 
2.1.0

