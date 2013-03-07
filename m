Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759968Ab3CGWQF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 17:16:05 -0500
Received: from mail.free-electrons.com ([94.23.35.102]:33238 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759041Ab3CGWQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 17:16:01 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: linux-arm-kernel@lists.infradead.org
Cc: kevin@allwinnertech.com, sunny@allwinnertech.com, shuge@allwinnertech.com,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] ARM: sunxi: dt: Add A10 UARTs to the dtsi.
Date: Thu,  7 Mar 2013 23:14:19 +0100
Message-Id: <1362694460-1919-6-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1362694460-1919-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1362694460-1919-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Allwinner A10 SoC has 8 available UARTs, which is 6 more than on the
A13, so add the missing UARTs to the sun4i-a10 dtsi.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/boot/dts/sun4i-a10.dtsi |   51 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)

diff --git a/arch/arm/boot/dts/sun4i-a10.dtsi b/arch/arm/boot/dts/sun4i-a10.dtsi
index 703e7cb..0142ca0 100644
--- a/arch/arm/boot/dts/sun4i-a10.dtsi
+++ b/arch/arm/boot/dts/sun4i-a10.dtsi
@@ -57,5 +57,56 @@
 			clocks = <&osc>;
 			status = "disabled";
 		};
+
+		uart2: uart@01c28800 {
+			compatible = "snps,dw-apb-uart";
+			reg = <0x01c28800 0x400>;
+			interrupts = <3>;
+			reg-shift = <2>;
+			reg-io-width = <4>;
+			clocks = <&osc>;
+			status = "disabled";
+		};
+
+
+		uart4: uart@01c29000 {
+			compatible = "snps,dw-apb-uart";
+			reg = <0x01c29000 0x400>;
+			interrupts = <17>;
+			reg-shift = <2>;
+			reg-io-width = <4>;
+			clocks = <&osc>;
+			status = "disabled";
+		};
+
+		uart5: uart@01c29400 {
+			compatible = "snps,dw-apb-uart";
+			reg = <0x01c29400 0x400>;
+			interrupts = <18>;
+			reg-shift = <2>;
+			reg-io-width = <4>;
+			clocks = <&osc>;
+			status = "disabled";
+		};
+
+		uart6: uart@01c29800 {
+			compatible = "snps,dw-apb-uart";
+			reg = <0x01c29800 0x400>;
+			interrupts = <19>;
+			reg-shift = <2>;
+			reg-io-width = <4>;
+			clocks = <&osc>;
+			status = "disabled";
+		};
+
+		uart7: uart@01c29c00 {
+			compatible = "snps,dw-apb-uart";
+			reg = <0x01c29c00 0x400>;
+			interrupts = <20>;
+			reg-shift = <2>;
+			reg-io-width = <4>;
+			clocks = <&osc>;
+			status = "disabled";
+		};
 	};
 };
-- 
1.7.10.4

