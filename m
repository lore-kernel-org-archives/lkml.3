Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932497AbaLBPlP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 10:41:15 -0500
Received: from mail-yk0-f176.google.com ([209.85.160.176]:49504 "EHLO
	mail-yk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932464AbaLBPlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 10:41:08 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, broonie@kernel.org,
        linux-spi@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH v2 4/4] ARM: sti: Provide DT nodes for SBC SSC[0..2]
Date: Tue,  2 Dec 2014 15:40:44 +0000
Message-Id: <1417534844-25080-5-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417534844-25080-1-git-send-email-lee.jones@linaro.org>
References: <1417534844-25080-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Synchronous Serial Controller is used to provide SPI.

These are the ports which are located on the Stand-By Controller (SBC).

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/stih407.dtsi | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/arch/arm/boot/dts/stih407.dtsi b/arch/arm/boot/dts/stih407.dtsi
index 90bc090..80e2407 100644
--- a/arch/arm/boot/dts/stih407.dtsi
+++ b/arch/arm/boot/dts/stih407.dtsi
@@ -329,5 +329,36 @@
 
 			status = "disabled";
 		};
+
+		/* SBC SSC */
+		spi@9540000 {
+			compatible = "st,comms-ssc4-spi";
+			reg = <0x9540000 0x110>;
+			interrupts = <GIC_SPI 135 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&clk_sysin>;
+			clock-names = "ssc";
+
+			status = "disabled";
+		};
+
+		spi@9541000 {
+			compatible = "st,comms-ssc4-spi";
+			reg = <0x9541000 0x110>;
+			interrupts = <GIC_SPI 136 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&clk_sysin>;
+			clock-names = "ssc";
+
+			status = "disabled";
+		};
+
+		spi@9542000 {
+			compatible = "st,comms-ssc4-spi";
+			reg = <0x9542000 0x110>;
+			interrupts = <GIC_SPI 137 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&clk_sysin>;
+			clock-names = "ssc";
+
+			status = "disabled";
+		};
 	};
 };
-- 
1.9.1

