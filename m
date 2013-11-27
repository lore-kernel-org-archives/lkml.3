Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759230Ab3K0BHy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:07:54 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:48859 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759054Ab3K0BFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 20:05:13 -0500
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH v2 1/9] arm: dt: zynq: Remove 'clock-ranges' from TTC nodes
Date: Tue, 26 Nov 2013 17:04:48 -0800
Message-Id: <1385514296-26702-2-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.8.4.4
In-Reply-To: <1385514296-26702-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1385514296-26702-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The bindings for the TTC changed in commit 'arm: zynq: Use standard
timer binding' (e932900a3279b5dbb6d8f43c7b369003620e137c). That change
removed possible subnodes from this driver rendering the 'clock-ranges'
property invalid for this node.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
Acked-by: Peter Crosthwaite <peter.crosthwaite@xilinx.com>
Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 arch/arm/boot/dts/zynq-7000.dtsi | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm/boot/dts/zynq-7000.dtsi b/arch/arm/boot/dts/zynq-7000.dtsi
index e7f73b2e4550..605a2d0a39fc 100644
--- a/arch/arm/boot/dts/zynq-7000.dtsi
+++ b/arch/arm/boot/dts/zynq-7000.dtsi
@@ -106,7 +106,6 @@
 			compatible = "cdns,ttc";
 			clocks = <&clkc 6>;
 			reg = <0xF8001000 0x1000>;
-			clock-ranges;
 		};
 
 		ttc1: ttc1@f8002000 {
@@ -115,7 +114,6 @@
 			compatible = "cdns,ttc";
 			clocks = <&clkc 6>;
 			reg = <0xF8002000 0x1000>;
-			clock-ranges;
 		};
 		scutimer: scutimer@f8f00600 {
 			interrupt-parent = <&intc>;
-- 
1.8.4.4

