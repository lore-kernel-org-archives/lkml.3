Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414Ab3KGSBf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 13:01:35 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:51608 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754661Ab3KGSB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 13:01:28 -0500
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
Subject: [PATCH v3 2/2] arm: dt: zynq: Add fclk-enable property to clkc node
Date: Thu,  7 Nov 2013 10:00:44 -0800
Message-Id: <1383847244-2079-3-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1383847244-2079-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1383847244-2079-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
Acked-by: Michal Simek <michal.simek@xilinx.com>
---
---
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
1.8.4.2

