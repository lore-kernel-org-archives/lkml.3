Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121AbaFEQI4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 12:08:56 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:54932 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538AbaFEQIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 12:08:54 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 1/2] ARM: zynq: DT: Add XADC node
Date: Thu,  5 Jun 2014 09:05:23 -0700
Message-Id: <1401984324-6075-1-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add node for the Xilinx A/D Converter.

Cc: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
 arch/arm/boot/dts/zynq-7000.dtsi | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm/boot/dts/zynq-7000.dtsi b/arch/arm/boot/dts/zynq-7000.dtsi
index 760bbc463c5b..c5854286a95a 100644
--- a/arch/arm/boot/dts/zynq-7000.dtsi
+++ b/arch/arm/boot/dts/zynq-7000.dtsi
@@ -65,6 +65,14 @@
 		interrupt-parent = <&intc>;
 		ranges;
 
+		adc@f8007100 {
+			compatible = "xlnx,zynq-xadc-1.00.a";
+			reg = <0xf8007100 0x20>;
+			interrupts = <0 7 4>;
+			interrupt-parent = <&intc>;
+			clocks = <&clkc 12>;
+		};
+
 		i2c0: i2c@e0004000 {
 			compatible = "cdns,i2c-r1p10";
 			status = "disabled";
-- 
2.0.0

