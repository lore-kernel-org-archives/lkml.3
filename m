Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757153Ab3IDFJA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 01:09:00 -0400
Received: from top.free-electrons.com ([176.31.233.9]:59844 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754635Ab3IDFI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 01:08:59 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: vapier@gentoo.org
Cc: uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH][RESEND] blackfin: remove unused parameters in Kconfig
Date: Wed,  4 Sep 2013 07:08:56 +0200
Message-Id: <1378271336-25134-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch proposes to remove kernel configuration parameters
defined in arch/blackfin/Kconfig, but used nowhere
in the makefiles and source code.

This is an update for 3.11 of a patch already sent for 3.10

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 arch/blackfin/Kconfig | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index 3b6abc5..4445758 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -861,14 +861,6 @@ config SYS_BFIN_SPINLOCK_L1
 	  If enabled, sys_bfin_spinlock function is linked
 	  into L1 instruction memory. (less latency)
 
-config IP_CHECKSUM_L1
-	bool "Locate IP Checksum function in L1 Memory"
-	default n
-	depends on !SMP
-	help
-	  If enabled, the IP Checksum function is linked
-	  into L1 instruction memory. (less latency)
-
 config CACHELINE_ALIGNED_L1
 	bool "Locate cacheline_aligned data to L1 Data Memory"
 	default y if !BF54x
@@ -1330,13 +1322,6 @@ config PM_BFIN_WAKE_PB15
 	help
 	  Enable PB15 Wake-Up
 
-config PM_BFIN_WAKE_PB15_POL
-	int "Wake-up priority"
-	depends on PM_BFIN_WAKE_PB15
-	default 0
-	help
-	  Wake-Up priority 0(low) 1(high)
-
 config PM_BFIN_WAKE_PC15
 	bool "Allow Wake-Up from PC15"
 	depends on PM && BF60x
-- 
1.8.1.2

