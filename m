Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149Ab3KYI5S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 03:57:18 -0500
Received: from juliette.telenet-ops.be ([195.130.137.74]:36480 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753794Ab3KYIzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 03:55:47 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Chris Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>,
        linux-xtensa@linux-xtensa.org
Subject: [PATCH 20/24] xtensa: Remove duplicate definition of BITS_PER_LONG
Date: Mon, 25 Nov 2013 09:55:30 +0100
Message-Id: <1385369734-24893-21-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1385369734-24893-1-git-send-email-geert@linux-m68k.org>
References: <1385369734-24893-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The definition for BITS_PER_LONG is already indirectly provided by
<asm-generic/types.h>, via <asm-generic/int-ll64.h> and
<asm/bitsperlong.h>

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Chris Zankel <chris@zankel.net>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: linux-xtensa@linux-xtensa.org
---
 arch/xtensa/include/asm/types.h |    8 --------
 1 file changed, 8 deletions(-)

diff --git a/arch/xtensa/include/asm/types.h b/arch/xtensa/include/asm/types.h
index 2b410b8c7f79..44f411c75837 100644
--- a/arch/xtensa/include/asm/types.h
+++ b/arch/xtensa/include/asm/types.h
@@ -12,12 +12,4 @@
 
 #include <uapi/asm/types.h>
 
-#ifndef __ASSEMBLY__
-/*
- * These aren't exported outside the kernel to avoid name space clashes
- */
-
-#define BITS_PER_LONG 32
-
-#endif
 #endif	/* _XTENSA_TYPES_H */
-- 
1.7.9.5

