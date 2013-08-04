Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905Ab3HDJ7k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Aug 2013 05:59:40 -0400
Received: from up.free-electrons.com ([94.23.35.102]:37166 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753703Ab3HDJ7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Aug 2013 05:59:23 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Emilio Lopez <emilio@elopez.com.ar>, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCHv3 7/9] ARM: sun7i: DT: Add UART muxing options to the DTSI
Date: Sun,  4 Aug 2013 11:58:48 +0200
Message-Id: <1375610330-18185-8-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.3.4
In-Reply-To: <1375610330-18185-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1375610330-18185-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The UARTs on the A20 can be muxed to several pins. Add a few options to
the DTSI so that we can start using them in the boards' DT.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/boot/dts/sun7i-a20.dtsi | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/arch/arm/boot/dts/sun7i-a20.dtsi b/arch/arm/boot/dts/sun7i-a20.dtsi
index c5d3432..da1411b 100644
--- a/arch/arm/boot/dts/sun7i-a20.dtsi
+++ b/arch/arm/boot/dts/sun7i-a20.dtsi
@@ -71,6 +71,27 @@
 			#address-cells = <1>;
 			#size-cells = <0>;
 			#gpio-cells = <3>;
+
+			uart0_pins_a: uart0@0 {
+				allwinner,pins = "PB22", "PB23";
+				allwinner,function = "uart0";
+				allwinner,drive = <0>;
+				allwinner,pull = <0>;
+			};
+
+			uart6_pins_a: uart6@0 {
+				allwinner,pins = "PI12", "PI13";
+				allwinner,function = "uart6";
+				allwinner,drive = <0>;
+				allwinner,pull = <0>;
+			};
+
+			uart7_pins_a: uart7@0 {
+				allwinner,pins = "PI20", "PI21";
+				allwinner,function = "uart7";
+				allwinner,drive = <0>;
+				allwinner,pull = <0>;
+			};
 		};
 
 		timer@01c20c00 {
-- 
1.8.3.4

