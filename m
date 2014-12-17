Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000AbaLQSup (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 13:50:45 -0500
Received: from michel.telenet-ops.be ([195.130.137.88]:42275 "EHLO
	michel.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572AbaLQStZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 13:49:25 -0500
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        linux-pm@vger.kernel.org
Cc: Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        Ulrich Hecht <ulrich.hecht+renesas@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Kevin Hilman <khilman@kernel.org>,
        linux-sh@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 2/8] drivers: bus: Sort Makefile entries alphabetically
Date: Wed, 17 Dec 2014 19:49:07 +0100
Message-Id: <1418842153-17113-3-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418842153-17113-1-git-send-email-geert+renesas@glider.be>
References: <1418842153-17113-1-git-send-email-geert+renesas@glider.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
v2:
  - New
---
 drivers/bus/Makefile | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/bus/Makefile b/drivers/bus/Makefile
index 2973c18cbcc27816..3cfaf2c7f25ac4f0 100644
--- a/drivers/bus/Makefile
+++ b/drivers/bus/Makefile
@@ -2,16 +2,16 @@
 # Makefile for the bus drivers.
 #
 
+# Interconnect bus drivers for ARM platforms
+obj-$(CONFIG_ARM_CCI)		+= arm-cci.o
+obj-$(CONFIG_ARM_CCN)		+= arm-ccn.o
+
 obj-$(CONFIG_BRCMSTB_GISB_ARB)	+= brcmstb_gisb.o
-obj-$(CONFIG_IMX_WEIM)	+= imx-weim.o
-obj-$(CONFIG_MVEBU_MBUS) += mvebu-mbus.o
-obj-$(CONFIG_OMAP_OCP2SCP)	+= omap-ocp2scp.o
+obj-$(CONFIG_IMX_WEIM)		+= imx-weim.o
+obj-$(CONFIG_MVEBU_MBUS) 	+= mvebu-mbus.o
 
 # Interconnect bus driver for OMAP SoCs.
 obj-$(CONFIG_OMAP_INTERCONNECT)	+= omap_l3_smx.o omap_l3_noc.o
 
-# Interconnect bus drivers for ARM platforms
-obj-$(CONFIG_ARM_CCI)		+= arm-cci.o
-obj-$(CONFIG_ARM_CCN)		+= arm-ccn.o
-
+obj-$(CONFIG_OMAP_OCP2SCP)	+= omap-ocp2scp.o
 obj-$(CONFIG_VEXPRESS_CONFIG)	+= vexpress-config.o
-- 
1.9.1

