Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157AbaGWE1p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 00:27:45 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:51891 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbaGWE1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 00:27:43 -0400
From: Nicholas Krause <xerofoify@gmail.com>
To: monstr@monstr.eu
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] microblaze: Add comment for defines
Date: Wed, 23 Jul 2014 00:27:38 -0400
Message-Id: <1406089658-4671-1-git-send-email-xerofoify@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a comment for and removes a fix me by labeling these
defines as memory cache definitions.

Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
---
 arch/microblaze/include/asm/pvr.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/microblaze/include/asm/pvr.h b/arch/microblaze/include/asm/pvr.h
index 4bbdb4c..441f3a0 100644
--- a/arch/microblaze/include/asm/pvr.h
+++ b/arch/microblaze/include/asm/pvr.h
@@ -186,7 +186,7 @@ struct pvr_s {
 #define PVR_DCACHE_USE_FSL(_pvr)	(_pvr.pvr[5] & PVR5_DCACHE_USE_FSL_MASK)
 #define PVR_DCACHE_ALLOW_WR(_pvr) \
 			(_pvr.pvr[5] & PVR5_DCACHE_ALLOW_WR_MASK)
-/* FIXME two shifts on one line needs any comment */
+/* memory caches */
 #define PVR_DCACHE_LINE_LEN(_pvr) \
 		(1 << ((_pvr.pvr[5] & PVR5_DCACHE_LINE_LEN_MASK) >> 21))
 #define PVR_DCACHE_BYTE_SIZE(_pvr) \
-- 
1.9.1

