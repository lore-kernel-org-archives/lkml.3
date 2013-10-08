Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042Ab3JHMZ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 08:25:56 -0400
Received: from mail-bk0-f42.google.com ([209.85.214.42]:45415 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755035Ab3JHMYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 08:24:47 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Jason Cooper <jason@lakedaemon.net>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Arnd Bergmann <arnd@arndb.de>, Rob Landley <rob@landley.net>,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/8] ARM: add Marvell Berlin SoC familiy to Marvell doc
Date: Tue,  8 Oct 2013 14:24:29 +0200
Message-Id: <1381235073-17134-5-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1381235073-17134-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1381235073-17134-1-git-send-email-sebastian.hesselbarth@gmail.com>
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
RFCv2->v1:
- move Berlin below PXA/MMP[23] where it belongs to
- add note about IP (re-)used in Berlin SoCs
RFCv1->RFCv2:
- initial patch

Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Rob Landley <rob@landley.net>
Cc: linux-doc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 Documentation/arm/Marvell/README |   29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/Documentation/arm/Marvell/README b/Documentation/arm/Marvell/README
index 8f08a86..993c45d 100644
--- a/Documentation/arm/Marvell/README
+++ b/Documentation/arm/Marvell/README
@@ -210,6 +210,35 @@ MMP/MMP2 family (communication processor)
    Linux kernel mach directory: arch/arm/mach-mmp
    Linux kernel plat directory: arch/arm/plat-pxa
 
+Berlin family (Digital Entertainment)
+-------------------------------------
+
+  Flavors:
+	88DE3005, Armada 1500-mini
+		Design name:	BG2CD(A0)
+		Core:		ARM Cortex-A9, PL310 L2CC
+		Homepage:	http://www.marvell.com/digital-entertainment/armada-1500-mini/
+	88DE3010, Armada 1000
+		Design name:	BG2(?)
+		Core:		Marvell PJ4B (ARMv7), Tauros3 L2CC
+		Product Brief:	http://www.marvell.com/digital-entertainment/assets/armada_1000_pb.pdf
+	88DE3100, Armada 1500
+		Design name:	BG2(A0)
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
+   * Currently known design names are: C2, BG2(Z1), BG2(A0), BG2CD(A0), BG2CT(A0)
+
 Long-term plans
 ---------------
 
-- 
1.7.10.4

