Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753686AbaH2Oir (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 10:38:47 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:63630 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752650AbaH2Oip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 10:38:45 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Michal Simek <michal.simek@xilinx.com>
Cc: =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
        Ezra Savard <ezras@xilinx.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Ezra Savard <ezra.savard@xilinx.com>
Subject: [PATCH v2] ARM: zynq: DT: Add LEDs to zc702 DT
Date: Fri, 29 Aug 2014 07:38:37 -0700
Message-Id: <1409323117-21711-1-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 2.1.0.1.g27b9230
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ezra Savard <ezra.savard@xilinx.com>

Adds LEDs to the zc702 devicetree for use with the leds-gpio driver.

Signed-off-by: Ezra Savard <ezra.savard@xilinx.com>
Reviewed-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
v2:
 - fix node names
---
 arch/arm/boot/dts/zynq-zc702.dts | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm/boot/dts/zynq-zc702.dts b/arch/arm/boot/dts/zynq-zc702.dts
index 835c3089c61c..b29e0f97e764 100644
--- a/arch/arm/boot/dts/zynq-zc702.dts
+++ b/arch/arm/boot/dts/zynq-zc702.dts
@@ -27,6 +27,15 @@
 		bootargs = "console=ttyPS0,115200 earlyprintk";
 	};
 
+	leds {
+		compatible = "gpio-leds";
+
+		ds23 {
+			label = "ds23";
+			gpios = <&gpio0 10 0>;
+			linux,default-trigger = "heartbeat";
+		};
+	};
 };
 
 &can0 {
-- 
2.1.0.1.g27b9230

