Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621AbbAVKHo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 05:07:44 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:51171 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752408AbbAVKHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 05:07:33 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, maxime.coquelin@st.com,
        devicetree@vger.kernel.org
Subject: [PATCH 2/2] ARM: sti: Provide DT nodes for SBC SSC[0..2]
Date: Thu, 22 Jan 2015 10:07:17 +0000
Message-Id: <1421921237-8991-2-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421921237-8991-1-git-send-email-lee.jones@linaro.org>
References: <1421921237-8991-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Synchronous Serial Controller is used to provide SPI.

These are the ports which are located on the Stand-By Controller (SBC).

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/stih407-family.dtsi | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/arch/arm/boot/dts/stih407-family.dtsi b/arch/arm/boot/dts/stih407-family.dtsi
index d52347a..eb0bde7 100644
--- a/arch/arm/boot/dts/stih407-family.dtsi
+++ b/arch/arm/boot/dts/stih407-family.dtsi
@@ -328,5 +328,36 @@
 
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

