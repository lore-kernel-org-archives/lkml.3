Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759447Ab3LHOQW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 09:16:22 -0500
Received: from mail-ea0-f173.google.com ([209.85.215.173]:56268 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759577Ab3LHOOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 09:14:17 -0500
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, Kevin Hilman <khilman@linaro.org>,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 4/9] ARM: add Marvell Berlin SoC familiy to Marvell doc
Date: Sun,  8 Dec 2013 15:14:01 +0100
Message-Id: <1386512047-874-5-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1386512047-874-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1383661723-17956-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1386512047-874-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds known facts and rumors about the Marvell Berlin (88DE3xxx) SoC
family to the Marvell SoC documentation.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Reviewed-by: Jason Cooper <jason@lakedaemon.net>
Reviewed-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
---
Changelog:
v3->v4:
- remove Armada 1000 which has been discontinued by Marvell
- remove BG2 steppings
v2->v3:
- add stepping Z1 to Armada 1000 (88DE3010)
RFCv2->v1:
- move Berlin below PXA/MMP[23] where it belongs to
- add note about IP (re-)used in Berlin SoCs
RFCv1->RFCv2:
- initial patch

Cc: Russell King <linux@arm.linux.org.uk>
Cc: Olof Johansson <olof@lixom.net>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Kevin Hilman <khilman@linaro.org>
Cc: linux-doc@vger.kernel.org 
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 Documentation/arm/Marvell/README | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/Documentation/arm/Marvell/README b/Documentation/arm/Marvell/README
index da0151d..5a930c1 100644
--- a/Documentation/arm/Marvell/README
+++ b/Documentation/arm/Marvell/README
@@ -211,6 +211,30 @@ MMP/MMP2 family (communication processor)
    Linux kernel mach directory: arch/arm/mach-mmp
    Linux kernel plat directory: arch/arm/plat-pxa
 
+Berlin family (Digital Entertainment)
+-------------------------------------
+
+  Flavors:
+	88DE3005, Armada 1500-mini
+		Design name:	BG2CD
+		Core:		ARM Cortex-A9, PL310 L2CC
+		Homepage:	http://www.marvell.com/digital-entertainment/armada-1500-mini/
+	88DE3100, Armada 1500
+		Design name:	BG2
+		Core:		Marvell PJ4B (ARMv7), Tauros3 L2CC
+		Homepage:	http://www.marvell.com/digital-entertainment/armada-1500/
+		Product Brief:	http://www.marvell.com/digital-entertainment/armada-1500/assets/Marvell-ARMADA-1500-Product-Brief.pdf
+	88DE????
+		Design name:	BG3
+		Core:		ARM Cortex-A15, CA15 integrated L2CC
+
+  Homepage: http://www.marvell.com/digital-entertainment/
+  Directory: arch/arm/mach-berlin
+
+  Comments:
+   * This line of SoCs is based on Marvell Sheeva or ARM Cortex CPUs
+     with Synopsys DesignWare (IRQ, GPIO, Timers, ...) and PXA IP (SDHCI, USB, ETH, ...).
+
 Long-term plans
 ---------------
 
-- 
1.8.4.rc3

