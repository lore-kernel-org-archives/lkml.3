Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619AbaBJRdO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 12:33:14 -0500
Received: from top.free-electrons.com ([176.31.233.9]:59724 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753594AbaBJRdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 12:33:07 -0500
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Subject: [PATCH 3/6] dt: Update binding information for mvebu gating clocks with Armada 375
Date: Mon, 10 Feb 2014 18:32:46 +0100
Message-Id: <1392053569-28037-4-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1392053569-28037-1-git-send-email-gregory.clement@free-electrons.com>
References: <1392053569-28037-1-git-send-email-gregory.clement@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the binding information for the gating clocks of the Armada 375 SoCs

Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
Reviewed-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
---
 .../bindings/clock/mvebu-gated-clock.txt           | 31 +++++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/clock/mvebu-gated-clock.txt b/Documentation/devicetree/bindings/clock/mvebu-gated-clock.txt
index fc2910fa7e45..cbecec1f64fa 100644
--- a/Documentation/devicetree/bindings/clock/mvebu-gated-clock.txt
+++ b/Documentation/devicetree/bindings/clock/mvebu-gated-clock.txt
@@ -1,6 +1,6 @@
 * Gated Clock bindings for Marvell EBU SoCs
 
-Marvell Armada 370/XP, Dove and Kirkwood allow some peripheral clocks to be
+Marvell Armada 370/375/XP, Dove and Kirkwood allow some peripheral clocks to be
 gated to save some power. The clock consumer should specify the desired clock
 by having the clock ID in its "clocks" phandle cell. The clock ID is directly
 mapped to the corresponding clock gating control bit in HW to ease manual clock
@@ -22,6 +22,34 @@ ID	Clock	Peripheral
 28	ddr	DDR Cntrl
 30	sata1	SATA Host 0
 
+The following is a list of provided IDs for Armada 375:
+ID	Clock		Peripheral
+-----------------------------------
+2	mu		Management Unit
+3	pp		Packet Processor
+4	ptp		PTP
+5	pex0		PCIe 0 Clock out
+6	pex1		PCIe 1 Clock out
+8	audio		Audio Cntrl
+11	nd_clk		Nand Flash Cntrl
+14	sata0_link	SATA 0 Link
+15	sata0_core	SATA 0 Core
+16	usb3		USB3 Host
+17	sdio		SDHCI Host
+18	usb		USB Host
+19	gop		Gigabit Ethernet MAC
+20	sata1_link	SATA 1 Link
+21	sata1_core	SATA 1 Core
+22	xor0		XOR DMA 0
+23	xor1		XOR DMA 0
+24	copro		Coprocessor
+25	tdm		Time Division Mplx
+28	crypto0_enc	Cryptographic Unit Port 0 Encryption
+29	crypto0_core	Cryptographic Unit Port 0 Core
+30	crypto1_enc	Cryptographic Unit Port 1 Encryption
+31	crypto1_core	Cryptographic Unit Port 1 Core
+
+
 The following is a list of provided IDs for Armada XP:
 ID	Clock	Peripheral
 -----------------------------------
@@ -95,6 +123,7 @@ ID	Clock	Peripheral
 Required properties:
 - compatible : shall be one of the following:
 	"marvell,armada-370-gating-clock" - for Armada 370 SoC clock gating
+	"marvell,armada-375-gating-clock" - for Armada 375 SoC clock gating
 	"marvell,armada-xp-gating-clock" - for Armada XP SoC clock gating
 	"marvell,dove-gating-clock" - for Dove SoC clock gating
 	"marvell,kirkwood-gating-clock" - for Kirkwood SoC clock gating
-- 
1.8.1.2

