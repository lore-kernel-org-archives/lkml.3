Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758369Ab3K0UYg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 15:24:36 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:49646 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757862Ab3K0UQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 15:16:54 -0500
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
        Tomasz Figa <tomasz.figa@gmail.com>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH v4 2/2] arm: dt: zynq: Add fclk-enable property to clkc node
Date: Wed, 27 Nov 2013 12:16:24 -0800
Message-Id: <1385583384-28870-2-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.8.4.4
In-Reply-To: <1385583384-28870-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1385583384-28870-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
Acked-by: Michal Simek <michal.simek@xilinx.com>
---
 arch/arm/boot/dts/zynq-7000.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/zynq-7000.dtsi b/arch/arm/boot/dts/zynq-7000.dtsi
index e7f73b2e4550..60d155224c98 100644
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
1.8.4.4

