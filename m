Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756437AbbAZQRP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 11:17:15 -0500
Received: from michel.telenet-ops.be ([195.130.137.88]:43386 "EHLO
	michel.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756246AbbAZQQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 11:16:37 -0500
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Kevin Hilman <khilman@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Felipe Balbi <balbi@ti.com>
Cc: Olof Johansson <olof@lixom.net>, Simon Horman <horms+renesas@verge.net.au>,
        Magnus Damm <magnus.damm@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devicetree@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH v4 2/5] drivers: bus: Sort Makefile entries alphabetically
Date: Mon, 26 Jan 2015 17:16:14 +0100
Message-Id: <1422288977-20353-3-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422288977-20353-1-git-send-email-geert+renesas@glider.be>
References: <1422288977-20353-1-git-send-email-geert+renesas@glider.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Tested-by: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
---
v4:
  - No changes,

v3:
  - Add Tested-by,

v2:
  - New.
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

