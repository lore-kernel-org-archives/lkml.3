Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758176Ab3EBKqN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 06:46:13 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:34562 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756709Ab3EBKqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 06:46:08 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: linux-arm-kernel@lists.infradead.org, Wolfram Sang <w.sang@pengutronix.de>
Cc: Emilio Lopez <emilio@elopez.com.ar>, linux-i2c@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] ARM: sunxi: dt: Add i2c controller nodes to the DTSI
Date: Thu,  2 May 2013 12:45:54 +0200
Message-Id: <1367491557-6027-3-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367491557-6027-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1367491557-6027-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Allwinner A10 and A13 both have 3 i2c controller embedded.
Add those to the common sunxi dtsi.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/boot/dts/sun4i-a10.dtsi | 27 +++++++++++++++++++++++++++
 arch/arm/boot/dts/sun5i-a13.dtsi | 27 +++++++++++++++++++++++++++
 2 files changed, 54 insertions(+)

diff --git a/arch/arm/boot/dts/sun4i-a10.dtsi b/arch/arm/boot/dts/sun4i-a10.dtsi
index e7ef619..311dcd4 100644
--- a/arch/arm/boot/dts/sun4i-a10.dtsi
+++ b/arch/arm/boot/dts/sun4i-a10.dtsi
@@ -292,5 +292,32 @@
 			clocks = <&apb1_gates 23>;
 			status = "disabled";
 		};
+
+		i2c0: i2c@01c2ac00 {
+			compatible = "allwinner,sun4i-i2c";
+			reg = <0x01c2ac00 0x400>;
+			interrupts = <7>;
+			clocks = <&apb1_gates 0>;
+			clock-frequency = <100000>;
+			status = "disabled";
+		};
+
+		i2c1: i2c@01c2b000 {
+			compatible = "allwinner,sun4i-i2c";
+			reg = <0x01c2b000 0x400>;
+			interrupts = <8>;
+			clocks = <&apb1_gates 1>;
+			clock-frequency = <100000>;
+			status = "disabled";
+		};
+
+		i2c2: i2c@01c2b400 {
+			compatible = "allwinner,sun4i-i2c";
+			reg = <0x01c2b400 0x400>;
+			interrupts = <9>;
+			clocks = <&apb1_gates 2>;
+			clock-frequency = <100000>;
+			status = "disabled";
+		};
 	};
 };
diff --git a/arch/arm/boot/dts/sun5i-a13.dtsi b/arch/arm/boot/dts/sun5i-a13.dtsi
index 8ba65c1..16df784 100644
--- a/arch/arm/boot/dts/sun5i-a13.dtsi
+++ b/arch/arm/boot/dts/sun5i-a13.dtsi
@@ -215,5 +215,32 @@
 			clocks = <&apb1_gates 19>;
 			status = "disabled";
 		};
+
+		i2c0: i2c@01c2ac00 {
+			compatible = "allwinner,sun4i-i2c";
+			reg = <0x01c2ac00 0x400>;
+			interrupts = <7>;
+			clocks = <&apb1_gates 0>;
+			clock-frequency = <100000>;
+			status = "disabled";
+		};
+
+		i2c1: i2c@01c2b000 {
+			compatible = "allwinner,sun4i-i2c";
+			reg = <0x01c2b000 0x400>;
+			interrupts = <8>;
+			clocks = <&apb1_gates 1>;
+			clock-frequency = <100000>;
+			status = "disabled";
+		};
+
+		i2c2: i2c@01c2b400 {
+			compatible = "allwinner,sun4i-i2c";
+			reg = <0x01c2b400 0x400>;
+			interrupts = <9>;
+			clocks = <&apb1_gates 2>;
+			clock-frequency = <100000>;
+			status = "disabled";
+		};
 	};
 };
-- 
1.8.1.2

