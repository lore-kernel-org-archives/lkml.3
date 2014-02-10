Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653AbaBJRdU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 12:33:20 -0500
Received: from top.free-electrons.com ([176.31.233.9]:59742 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753596AbaBJRdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 12:33:10 -0500
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Subject: [PATCH 5/6] dt: Update binding information for mvebu core clocks with Armada 380/385
Date: Mon, 10 Feb 2014 18:32:48 +0100
Message-Id: <1392053569-28037-6-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1392053569-28037-1-git-send-email-gregory.clement@free-electrons.com>
References: <1392053569-28037-1-git-send-email-gregory.clement@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

Add the binding information for the core clocks of the Armada 380 and
Armada 385 SoCs

Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
---
 Documentation/devicetree/bindings/clock/mvebu-core-clock.txt | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/devicetree/bindings/clock/mvebu-core-clock.txt b/Documentation/devicetree/bindings/clock/mvebu-core-clock.txt
index 62fc34a1506d..307a503c5db8 100644
--- a/Documentation/devicetree/bindings/clock/mvebu-core-clock.txt
+++ b/Documentation/devicetree/bindings/clock/mvebu-core-clock.txt
@@ -17,6 +17,12 @@ The following is a list of provided IDs and clock names on Armada 375:
  2 = l2clk   (L2 Cache clock)
  3 = ddrclk  (DDR clock)
 
+The following is a list of provided IDs and clock names on Armada 380/385:
+ 0 = tclk    (Internal Bus clock)
+ 1 = cpuclk  (CPU clock)
+ 2 = l2clk   (L2 Cache clock)
+ 3 = ddrclk  (DDR clock)
+
 The following is a list of provided IDs and clock names on Kirkwood and Dove:
  0 = tclk   (Internal Bus clock)
  1 = cpuclk (CPU0 clock)
@@ -27,6 +33,7 @@ Required properties:
 - compatible : shall be one of the following:
 	"marvell,armada-370-core-clock" - For Armada 370 SoC core clocks
 	"marvell,armada-375-core-clock" - For Armada 375 SoC core clocks
+	"marvell,armada-380-core-clock" - For Armada 380/385 SoC core clocks
 	"marvell,armada-xp-core-clock" - For Armada XP SoC core clocks
 	"marvell,dove-core-clock" - for Dove SoC core clocks
 	"marvell,kirkwood-core-clock" - for Kirkwood SoC (except mv88f6180)
-- 
1.8.1.2

