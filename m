Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933772AbaJUVcM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 17:32:12 -0400
Received: from mail-qg0-f51.google.com ([209.85.192.51]:61137 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933458AbaJUVcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 17:32:09 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Michal Simek <michal.simek@xilinx.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH] MAINTAINERS: Update Zynq maintainer record
Date: Tue, 21 Oct 2014 14:31:43 -0700
Message-Id: <1413927103-31358-1-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 2.1.2.1.g5e69ed6
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 - add myself as reviewer for Zynq
 - add entry to cover Zynq clock drivers
 - add entry to cover Xilinx DMA drivers

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
 MAINTAINERS | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index a20df9bf8ab0..07eecdddbe8b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1543,6 +1543,7 @@ F:	arch/arm/mach-pxa/include/mach/z2.h
 
 ARM/ZYNQ ARCHITECTURE
 M:	Michal Simek <michal.simek@xilinx.com>
+R:	Sören Brinkmann <soren.brinkmann@xilinx.com>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 W:	http://wiki.xilinx.com
 T:	git git://git.xilinx.com/linux-xlnx.git
@@ -1552,7 +1553,9 @@ F:	drivers/cpuidle/cpuidle-zynq.c
 F:	drivers/block/xsysace.c
 N:	zynq
 N:	xilinx
+F:	drivers/clk/zynq/
 F:	drivers/clocksource/cadence_ttc_timer.c
+F:	drivers/dma/xilinx/
 F:	drivers/i2c/busses/i2c-cadence.c
 F:	drivers/mmc/host/sdhci-of-arasan.c
 
-- 
2.1.2.1.g5e69ed6

