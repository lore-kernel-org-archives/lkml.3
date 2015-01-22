Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891AbbAVJfb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 04:35:31 -0500
Received: from baptiste.telenet-ops.be ([195.130.132.51]:55930 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364AbbAVJei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 04:34:38 -0500
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Kevin Hilman <khilman@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Olof Johansson <olof@lixom.net>, Simon Horman <horms+renesas@verge.net.au>,
        Magnus Damm <magnus.damm@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devicetree@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH v3/resend 2/4] drivers: bus: Sort Makefile entries alphabetically
Date: Thu, 22 Jan 2015 10:34:11 +0100
Message-Id: <1421919253-4784-3-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421919253-4784-1-git-send-email-geert+renesas@glider.be>
References: <1421919253-4784-1-git-send-email-geert+renesas@glider.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Tested-by: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
---
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

