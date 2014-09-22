Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230AbaIVRMY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 13:12:24 -0400
Received: from mail.kmu-office.ch ([178.209.48.102]:58133 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754051AbaIVRJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 13:09:39 -0400
X-Amavis-Alert: BAD HEADER, Duplicate header field: "In-Reply-To"
From: Stefan Agner <stefan@agner.ch>
To: shawn.guo@freescale.com, kernel@pengutronix.de, linus.walleij@linaro.org,
        gnurou@gmail.com
Cc: linux@arm.linux.org.uk, jingchang.lu@freescale.com, b20788@freescale.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org, stefan@agner.ch
Subject: [PATCH 1/9] ARM: dts: vf610: Add system reset controller (SRC)
Date: Mon, 22 Sep 2014 19:09:22 +0200
Message-Id: <2ca1cf3732a00512fa19b6118f9fb30aba014deb.1411404079.git.stefan@agner.ch>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1411404079.git.stefan@agner.ch>
References: <cover.1411404079.git.stefan@agner.ch>
In-Reply-To: <cover.1411404079.git.stefan@agner.ch>
References: <cover.1411404079.git.stefan@agner.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device tree property for system reset controller.

Signed-off-by: Stefan Agner <stefan@agner.ch>
---
 arch/arm/boot/dts/vf610.dtsi | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm/boot/dts/vf610.dtsi b/arch/arm/boot/dts/vf610.dtsi
index 3a6840c..122a64956 100644
--- a/arch/arm/boot/dts/vf610.dtsi
+++ b/arch/arm/boot/dts/vf610.dtsi
@@ -366,6 +366,13 @@
 				reg = <0x40034800 0x200>;
 				clocks = <&clks VF610_CLK_USBC0>;
 			};
+
+			src: src@4006e000 {
+				compatible = "fsl,vf610-src";
+				reg = <0x4006e000 0x1000>;
+				interrupts = <0 96 IRQ_TYPE_LEVEL_HIGH>;
+				#reset-cells = <0>;
+			};
 		};
 
 		aips1: aips-bus@40080000 {
-- 
2.1.0

