Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017AbaGCBlm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 21:41:42 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:46130 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbaGCBll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 21:41:41 -0400
From: Nicholas Krause <xerofoify@gmail.com>
To: sammy@sammy.net
Cc: geert@linux-m68k.org, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] m68k: Remove FIXME comment in file sun3_pgalloc.h
Date: Wed,  2 Jul 2014 21:41:33 -0400
Message-Id: <1404351693-5588-1-git-send-email-xerofoify@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes a FIXME comment in this file due to it not compiling
as it now compiles.

Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
---
 arch/m68k/include/asm/sun3_pgalloc.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/m68k/include/asm/sun3_pgalloc.h b/arch/m68k/include/asm/sun3_pgalloc.h
index f868506..1798f25 100644
--- a/arch/m68k/include/asm/sun3_pgalloc.h
+++ b/arch/m68k/include/asm/sun3_pgalloc.h
@@ -12,7 +12,6 @@
 
 #include <asm/tlb.h>
 
-/* FIXME - when we get this compiling */
 /* erm, now that it's compiling, what do we do with it? */
 #define _KERNPG_TABLE 0
 
-- 
1.9.1

