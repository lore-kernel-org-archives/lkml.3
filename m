Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695AbbAVJe7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 04:34:59 -0500
Received: from xavier.telenet-ops.be ([195.130.132.52]:33457 "EHLO
	xavier.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752371AbbAVJei (ORCPT
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
Subject: [PATCH v3/resend 1/4] drivers: bus: Sort Kconfig entries alphabetically
Date: Thu, 22 Jan 2015 10:34:10 +0100
Message-Id: <1421919253-4784-2-git-send-email-geert+renesas@glider.be>
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
 drivers/bus/Kconfig | 44 ++++++++++++++++++++++----------------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/bus/Kconfig b/drivers/bus/Kconfig
index b99729e368608bda..626960819e6df16c 100644
--- a/drivers/bus/Kconfig
+++ b/drivers/bus/Kconfig
@@ -4,6 +4,21 @@
 
 menu "Bus devices"
 
+config ARM_CCI
+	bool "ARM CCI driver support"
+	depends on ARM && OF && CPU_V7
+	help
+	  Driver supporting the CCI cache coherent interconnect for ARM
+	  platforms.
+
+config ARM_CCN
+	bool "ARM CCN driver support"
+	depends on ARM || ARM64
+	depends on PERF_EVENTS
+	help
+	  PMU (perf) driver supporting the ARM CCN (Cache Coherent Network)
+	  interconnect.
+
 config BRCMSTB_GISB_ARB
 	bool "Broadcom STB GISB bus arbiter"
 	depends on ARM || MIPS
@@ -27,15 +42,6 @@ config MVEBU_MBUS
 	  Driver needed for the MBus configuration on Marvell EBU SoCs
 	  (Kirkwood, Dove, Orion5x, MV78XX0 and Armada 370/XP).
 
-config OMAP_OCP2SCP
-	tristate "OMAP OCP2SCP DRIVER"
-	depends on ARCH_OMAP2PLUS
-	help
-	  Driver to enable ocp2scp module which transforms ocp interface
-	  protocol to scp protocol. In OMAP4, USB PHY is connected via
-	  OCP2SCP and in OMAP5, both USB PHY and SATA PHY is connected via
-	  OCP2SCP.
-
 config OMAP_INTERCONNECT
 	tristate "OMAP INTERCONNECT DRIVER"
 	depends on ARCH_OMAP2PLUS
@@ -43,20 +49,14 @@ config OMAP_INTERCONNECT
 	help
 	  Driver to enable OMAP interconnect error handling driver.
 
-config ARM_CCI
-	bool "ARM CCI driver support"
-	depends on ARM && OF && CPU_V7
-	help
-	  Driver supporting the CCI cache coherent interconnect for ARM
-	  platforms.
-
-config ARM_CCN
-	bool "ARM CCN driver support"
-	depends on ARM || ARM64
-	depends on PERF_EVENTS
+config OMAP_OCP2SCP
+	tristate "OMAP OCP2SCP DRIVER"
+	depends on ARCH_OMAP2PLUS
 	help
-	  PMU (perf) driver supporting the ARM CCN (Cache Coherent Network)
-	  interconnect.
+	  Driver to enable ocp2scp module which transforms ocp interface
+	  protocol to scp protocol. In OMAP4, USB PHY is connected via
+	  OCP2SCP and in OMAP5, both USB PHY and SATA PHY is connected via
+	  OCP2SCP.
 
 config VEXPRESS_CONFIG
 	bool "Versatile Express configuration bus"
-- 
1.9.1

