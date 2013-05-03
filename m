Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762965Ab3ECJSX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 05:18:23 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:39274 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762858Ab3ECJST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 05:18:19 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: linux-arm-kernel@lists.infradead.org, Wolfram Sang <wsa@the-dreams.de>
Cc: Emilio Lopez <emilio@elopez.com.ar>, linux-i2c@vger.kernel.org,
        kevin@allwinnertech.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] ARM: sunxi: dt: Add i2c controller nodes to the DTSI
Date: Fri,  3 May 2013 11:17:46 +0200
Message-Id: <1367572669-24354-3-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367572669-24354-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1367572669-24354-1-git-send-email-maxime.ripard@free-electrons.com>
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

