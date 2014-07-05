Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760359AbaGECu1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 22:50:27 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:52454 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753874AbaGECuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 22:50:25 -0400
From: Nicholas Krause <xerofoify@gmail.com>
To: ralf@linux-mips.org
Cc: jchandra@broadcom.com, blogic@openwrt.org, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mips: Add #ifdef in file bridge.h
Date: Fri,  4 Jul 2014 22:50:19 -0400
Message-Id: <1404528619-3715-1-git-send-email-xerofoify@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch addes a #ifdef __ASSEMBLY__ in order to check if this part
of the file is configured to fix this #ifdef block in bridge.h for mips.

Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
---
 arch/mips/include/asm/netlogic/xlp-hal/bridge.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/include/asm/netlogic/xlp-hal/bridge.h b/arch/mips/include/asm/netlogic/xlp-hal/bridge.h
index 3067f98..4f315c3 100644
--- a/arch/mips/include/asm/netlogic/xlp-hal/bridge.h
+++ b/arch/mips/include/asm/netlogic/xlp-hal/bridge.h
@@ -143,7 +143,7 @@
 #define BRIDGE_GIO_WEIGHT		0x2cb
 #define BRIDGE_FLASH_WEIGHT		0x2cc
 
-/* FIXME verify */
+#ifdef __ASSEMBLY__
 #define BRIDGE_9XX_FLASH_BAR(i)		(0x11 + (i))
 #define BRIDGE_9XX_FLASH_BAR_LIMIT(i)	(0x15 + (i))
 
-- 
1.9.1

