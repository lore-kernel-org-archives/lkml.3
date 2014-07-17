Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975AbaGQCN5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 22:13:57 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:42308 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbaGQCNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 22:13:54 -0400
From: Nicholas Krause <xerofoify@gmail.com>
To: sammy@sammy.net
Cc: geert@linux-m68k.org, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] m68k: Remove unneeded FIXME message in sun3_pgalloc.h
Date: Wed, 16 Jul 2014 22:13:37 -0400
Message-Id: <1405563217-9628-1-git-send-email-xerofoify@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes a FIX ME message due to this file not compiling.
Now that this message is no longer needed I am removing it
from sun3_pgalloc.h.

Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
---
 arch/m68k/include/asm/sun3_pgalloc.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/m68k/include/asm/sun3_pgalloc.h b/arch/m68k/include/asm/sun3_pgalloc.h
index f868506..66644f3 100644
--- a/arch/m68k/include/asm/sun3_pgalloc.h
+++ b/arch/m68k/include/asm/sun3_pgalloc.h
@@ -12,8 +12,6 @@
 
 #include <asm/tlb.h>
 
-/* FIXME - when we get this compiling */
-/* erm, now that it's compiling, what do we do with it? */
 #define _KERNPG_TABLE 0
 
 extern const char bad_pmd_string[];
-- 
1.9.1

