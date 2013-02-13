Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758321Ab3BMJ2r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 04:28:47 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:45829 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757225Ab3BMJ2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 04:28:44 -0500
From: Sourav Poddar <sourav.poddar@ti.com>
To: <balbi@ti.com>, <santosh.shilimkar@ti.com>, <b-cousson@ti.com>,
        <tony@atomide.com>, <linux-omap@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
CC: Sourav Poddar <sourav.poddar@ti.com>
Subject: [PATCH 4/5] arm: dts: omap5: add SPI devices to OMAP5 DeviceTree file
Date: Wed, 13 Feb 2013 14:58:36 +0530
Message-ID: <1360747716-1565-1-git-send-email-sourav.poddar@ti.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Felipe Balbi <balbi@ti.com>

Add all 4 mcspi instances to omap5.dtsi file.

Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Sourav Poddar <sourav.poddar@ti.com>
---
 arch/arm/boot/dts/omap5.dtsi |   40 ++++++++++++++++++++++++++++++++++++++++
 1 files changed, 40 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/omap5.dtsi b/arch/arm/boot/dts/omap5.dtsi
index 790bb2a..9e182a9 100644
--- a/arch/arm/boot/dts/omap5.dtsi
+++ b/arch/arm/boot/dts/omap5.dtsi
@@ -241,6 +241,46 @@
 			ti,hwmods = "i2c5";
 		};
 
+		mcspi1: spi@48098000 {
+			compatible = "ti,omap4-mcspi";
+			reg = <0x48098000 0x200>;
+			interrupts = <0 65 0x4>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+			ti,hwmods = "mcspi1";
+			ti,spi-num-cs = <4>;
+		};
+
+		mcspi2: spi@4809a000 {
+			compatible = "ti,omap4-mcspi";
+			reg = <0x4809a000 0x200>;
+			interrupts = <0 66 0x4>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+			ti,hwmods = "mcspi2";
+			ti,spi-num-cs = <2>;
+		};
+
+		mcspi3: spi@480b8000 {
+			compatible = "ti,omap4-mcspi";
+			reg = <0x480b8000 0x200>;
+			interrupts = <0 91 0x4>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+			ti,hwmods = "mcspi3";
+			ti,spi-num-cs = <2>;
+		};
+
+		mcspi4: spi@480ba000 {
+			compatible = "ti,omap4-mcspi";
+			reg = <0x480ba000 0x200>;
+			interrupts = <0 48 0x4>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+			ti,hwmods = "mcspi4";
+			ti,spi-num-cs = <1>;
+		};
+
 		uart1: serial@4806a000 {
 			compatible = "ti,omap4-uart";
 			reg = <0x4806a000 0x100>;
-- 
1.7.1

