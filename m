Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128Ab3JJRKf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 13:10:35 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:63684 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755723Ab3JJRKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 13:10:31 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>,
        Michal Simek <michal.simek@xilinx.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-doc@vger.kernel.org, devicetree@vger.kernel.org,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH v2 2/2] arm: dt: zynq: Add fclk-enable property to clkc node
Date: Thu, 10 Oct 2013 10:10:18 -0700
Message-Id: <1381425018-5653-2-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1381425018-5653-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1381425018-5653-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
This is kind of optional since it does not have any effect due to the changed
default in 1/2.

v2:
 - no change


 arch/arm/boot/dts/zynq-7000.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/zynq-7000.dtsi b/arch/arm/boot/dts/zynq-7000.dtsi
index e32b92b949d2..b48d0403537b 100644
--- a/arch/arm/boot/dts/zynq-7000.dtsi
+++ b/arch/arm/boot/dts/zynq-7000.dtsi
@@ -77,6 +77,7 @@
 					#clock-cells = <1>;
 					compatible = "xlnx,ps7-clkc";
 					ps-clk-frequency = <33333333>;
+					fclk-enable = <0>;
 					clock-output-names = "armpll", "ddrpll", "iopll", "cpu_6or4x",
 							"cpu_3or2x", "cpu_2x", "cpu_1x", "ddr2x", "ddr3x",
 							"dci", "lqspi", "smc", "pcap", "gem0", "gem1",
-- 
1.8.4

