Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391Ab3GHGEo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 02:04:44 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:57554 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753710Ab3GHGE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 02:04:27 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: starvik@axis.com, jesper.nilsson@axis.com
Cc: sfr@canb.auug.org.au, gregkh@linuxfoundation.org,
        David.Woodhouse@intel.com, artem.bityutskiy@linux.intel.com,
        linux-cris-kernel@axis.com, linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH 3/3] cris: cleanup Kconfig
Date: Mon,  8 Jul 2013 08:04:11 +0200
Message-Id: <1373263451-26841-4-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1373263451-26841-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <1373263451-26841-1-git-send-email-michael.opdenacker@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch proposes to remove kernel configuration parameters
defined in arch/cris/Kconfig, but used nowhere
in the makefiles and source code.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 arch/cris/Kconfig | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/arch/cris/Kconfig b/arch/cris/Kconfig
index 3201ddb..70d9c27 100644
--- a/arch/cris/Kconfig
+++ b/arch/cris/Kconfig
@@ -99,9 +99,6 @@ config ETRAX_KMALLOCED_MODULES
 	help
 	  Enable module allocation with kmalloc instead of vmalloc.
 
-config OOM_REBOOT
-       bool "Enable reboot at out of memory"
-
 source "kernel/Kconfig.preempt"
 
 source mm/Kconfig
@@ -175,12 +172,6 @@ config ETRAX_FLASH_BUSWIDTH
 	help
 	  Width in bytes of the NOR Flash bus (1, 2 or 4). Is usually 2.
 
-config ETRAX_NANDFLASH_BUSWIDTH
-	int "Buswidth of NAND flash in bytes"
-	default "1"
-	help
-	  Width in bytes of the NAND flash (1 or 2).
-
 config ETRAX_FLASH1_SIZE
        int "FLASH1 size (dec, in MB. 0 = Unknown)"
        default "0"
-- 
1.8.1.2

