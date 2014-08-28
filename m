Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751125AbaH1QXN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 12:23:13 -0400
Received: from mail-qg0-f51.google.com ([209.85.192.51]:44073 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbaH1QXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 12:23:11 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Michal Simek <michal.simek@xilinx.com>
Cc: =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
        Ezra Savard <ezras@xilinx.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Ezra Savard <ezra.savard@xilinx.com>
Subject: [PATCH] ARM: zynq: DT: Add LEDs to zc702 DT
Date: Thu, 28 Aug 2014 09:22:53 -0700
Message-Id: <1409242973-2735-1-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 2.1.0.1.g27b9230
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ezra Savard <ezra.savard@xilinx.com>

Adds LEDs to the zc702 devicetree for use with the leds-gpio driver.

Signed-off-by: Ezra Savard <ezra.savard@xilinx.com>
Reviewed-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
 arch/arm/boot/dts/zynq-zc702.dts | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm/boot/dts/zynq-zc702.dts b/arch/arm/boot/dts/zynq-zc702.dts
index 835c3089c61c..4e9fe26b3e85 100644
--- a/arch/arm/boot/dts/zynq-zc702.dts
+++ b/arch/arm/boot/dts/zynq-zc702.dts
@@ -27,6 +27,16 @@
 		bootargs = "console=ttyPS0,115200 earlyprintk";
 	};
 
+	gpio-leds {
+		compatible = "gpio-leds";
+
+		led-ds23 {
+			label = "ds23";
+			gpios = <&gpio0 10 0>;
+			linux,default-trigger = "heartbeat";
+		};
+	};
+
 };
 
 &can0 {
-- 
2.1.0.1.g27b9230

