Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754321Ab3KYI5m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 03:57:42 -0500
Received: from jacques.telenet-ops.be ([195.130.132.50]:50541 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753643Ab3KYIzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 03:55:45 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Chen Liqin <liqin.linux@gmail.com>, Lennox Wu <lennox.wu@gmail.com>
Subject: [PATCH 09/24] score/uapi: Use Kbuild logic to include <asm-generic/types.h>
Date: Mon, 25 Nov 2013 09:55:19 +0100
Message-Id: <1385369734-24893-10-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1385369734-24893-1-git-send-email-geert@linux-m68k.org>
References: <1385369734-24893-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Chen Liqin <liqin.linux@gmail.com>
Cc: Lennox Wu <lennox.wu@gmail.com>
---
 arch/score/include/uapi/asm/Kbuild  |    3 ++-
 arch/score/include/uapi/asm/types.h |    6 ------
 2 files changed, 2 insertions(+), 7 deletions(-)
 delete mode 100644 arch/score/include/uapi/asm/types.h

diff --git a/arch/score/include/uapi/asm/Kbuild b/arch/score/include/uapi/asm/Kbuild
index 040178cdb3eb..bdc329ac60aa 100644
--- a/arch/score/include/uapi/asm/Kbuild
+++ b/arch/score/include/uapi/asm/Kbuild
@@ -1,6 +1,8 @@
 # UAPI Header export list
 include include/uapi/asm-generic/Kbuild.asm
 
+generic-y += types.h
+
 header-y += auxvec.h
 header-y += bitsperlong.h
 header-y += byteorder.h
@@ -30,5 +32,4 @@ header-y += statfs.h
 header-y += swab.h
 header-y += termbits.h
 header-y += termios.h
-header-y += types.h
 header-y += unistd.h
diff --git a/arch/score/include/uapi/asm/types.h b/arch/score/include/uapi/asm/types.h
deleted file mode 100644
index 2140032778ee..000000000000
--- a/arch/score/include/uapi/asm/types.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_SCORE_TYPES_H
-#define _ASM_SCORE_TYPES_H
-
-#include <asm-generic/types.h>
-
-#endif /* _ASM_SCORE_TYPES_H */
-- 
1.7.9.5

