Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751248AbaG1QYX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 12:24:23 -0400
Received: from mail-qg0-f41.google.com ([209.85.192.41]:42309 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750701AbaG1QYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 12:24:20 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Michal Simek <michal.simek@xilinx.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Soren Brinkmann <soren.brinkmann@xilinx.com>,
        =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>
Subject: [LINUX PATCH] ARM: zynq: DT: Remove DMA from board DTs
Date: Mon, 28 Jul 2014 09:24:03 -0700
Message-Id: <1406564643-10417-1-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 2.0.1.1.gfbfc394
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The DMA engine is enabled for all DTs that derive from zynq-7000.dtsi.
There is no need to override the 'status' property in board DTs.

Cc: Andreas Färber <afaerber@suse.de>
Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
When the 'status' property was removed from the DMA node, this had been
overlooked.

	Sören

 arch/arm/boot/dts/zynq-parallella.dts | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/arm/boot/dts/zynq-parallella.dts b/arch/arm/boot/dts/zynq-parallella.dts
index 1595138ec499..41afd9da6876 100644
--- a/arch/arm/boot/dts/zynq-parallella.dts
+++ b/arch/arm/boot/dts/zynq-parallella.dts
@@ -34,10 +34,6 @@
 	};
 };
 
-&dmac_s {
-	status = "okay";
-};
-
 &gem0 {
 	status = "okay";
 	phy-mode = "rgmii-id";
-- 
2.0.1.1.gfbfc394

