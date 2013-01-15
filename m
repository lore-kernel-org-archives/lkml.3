Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637Ab3AOU05 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 15:26:57 -0500
Received: from muin.pair.com ([209.68.1.55]:52518 "EHLO muin.pair.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750963Ab3AOU04 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 15:26:56 -0500
X-Greylist: delayed 429 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Jan 2013 15:26:56 EST
From: Timur Tabi <timur@tabi.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] MAINTAINERS: update email address for Timur Tabi
Date: Tue, 15 Jan 2013 14:19:45 -0600
Message-Id: <1358281185-31656-1-git-send-email-timur@tabi.org>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Timur Tabi <timur@freescale.com>

Timur Tabi no longer works for Freescale, so update the email address and
status for all of his maintained projects.

Also mark the QE library as orphaned, for lack of interest in maintaining
it.

The CS4270 driver is marked as "Odd Fixes" because appropriate hardware is
no longer available.

Signed-off-by: Timur Tabi <timur@freescale.com>
---
 MAINTAINERS |   19 +++++++++----------
 1 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3ab0949..7a750d5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1964,9 +1964,9 @@ S:	Maintained
 F:	drivers/usb/host/ohci-ep93xx.c
 
 CIRRUS LOGIC CS4270 SOUND DRIVER
-M:	Timur Tabi <timur@freescale.com>
+M:	Timur Tabi <timur@tabi.org>
 L:	alsa-devel@alsa-project.org (moderated for non-subscribers)
-S:	Supported
+S:	Odd Fixes
 F:	sound/soc/codecs/cs4270*
 
 CLEANCACHE API
@@ -3183,9 +3183,9 @@ F:	include/uapi/video/
 F:	include/uapi/linux/fb.h
 
 FREESCALE DIU FRAMEBUFFER DRIVER
-M:	Timur Tabi <timur@freescale.com>
+M:	Timur Tabi <timur@tabi.org>
 L:	linux-fbdev@vger.kernel.org
-S:	Supported
+S:	Maintained
 F:	drivers/video/fsl-diu-fb.*
 
 FREESCALE DMA DRIVER
@@ -3220,9 +3220,8 @@ F:	drivers/net/ethernet/freescale/fs_enet/
 F:	include/linux/fs_enet_pd.h
 
 FREESCALE QUICC ENGINE LIBRARY
-M:	Timur Tabi <timur@freescale.com>
 L:	linuxppc-dev@lists.ozlabs.org
-S:	Supported
+S:	Orphan
 F:	arch/powerpc/sysdev/qe_lib/
 F:	arch/powerpc/include/asm/*qe.h
 
@@ -3241,16 +3240,16 @@ S:	Maintained
 F:	drivers/net/ethernet/freescale/ucc_geth*
 
 FREESCALE QUICC ENGINE UCC UART DRIVER
-M:	Timur Tabi <timur@freescale.com>
+M:	Timur Tabi <timur@tabi.org>
 L:	linuxppc-dev@lists.ozlabs.org
-S:	Supported
+S:	Maintained
 F:	drivers/tty/serial/ucc_uart.c
 
 FREESCALE SOC SOUND DRIVERS
-M:	Timur Tabi <timur@freescale.com>
+M:	Timur Tabi <timur@tabi.org>
 L:	alsa-devel@alsa-project.org (moderated for non-subscribers)
 L:	linuxppc-dev@lists.ozlabs.org
-S:	Supported
+S:	Maintained
 F:	sound/soc/fsl/fsl*
 F:	sound/soc/fsl/mpc8610_hpcd.c
 
-- 
1.7.3.4

