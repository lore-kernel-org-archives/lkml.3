Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757399AbaGDQ37 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 12:29:59 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:33286 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753391AbaGDQ36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 12:29:58 -0400
From: Nicholas Krause <xerofoify@gmail.com>
To: sammy@sammy.net
Cc: geert@linux-m68k.org, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] m68k: Remove define statement no longer needed
Date: Fri,  4 Jul 2014 12:29:53 -0400
Message-Id: <1404491393-4286-1-git-send-email-xerofoify@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the file sun3_pgalloc.h we should remove #define_KERNPG_TABLE equals 0
as this define statement hasn't been used since kernel verison 2.15.8 and
is now no longer needed.

Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
---
 arch/m68k/include/asm/sun3_pgalloc.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/m68k/include/asm/sun3_pgalloc.h b/arch/m68k/include/asm/sun3_pgalloc.h
index f868506..0931388 100644
--- a/arch/m68k/include/asm/sun3_pgalloc.h
+++ b/arch/m68k/include/asm/sun3_pgalloc.h
@@ -12,10 +12,6 @@
 
 #include <asm/tlb.h>
 
-/* FIXME - when we get this compiling */
-/* erm, now that it's compiling, what do we do with it? */
-#define _KERNPG_TABLE 0
-
 extern const char bad_pmd_string[];
 
 #define pmd_alloc_one(mm,address)       ({ BUG(); ((pmd_t *)2); })
-- 
1.9.1

