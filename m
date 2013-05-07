Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757641Ab3EGJ5h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 05:57:37 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:43366 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755082Ab3EGJ5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 05:57:35 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Chris Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>
Cc: linux-xtensa@linux-xtensa.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 3/3] xtensa: Switch to asm-generic/linkage.h
Date: Tue,  7 May 2013 11:57:33 +0200
Message-Id: <1367920653-18626-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/xtensa/include/asm/Kbuild    |    1 +
 arch/xtensa/include/asm/linkage.h |   16 ----------------
 2 files changed, 1 insertions(+), 16 deletions(-)
 delete mode 100644 arch/xtensa/include/asm/linkage.h

diff --git a/arch/xtensa/include/asm/Kbuild b/arch/xtensa/include/asm/Kbuild
index 095f0a2..1b98264 100644
--- a/arch/xtensa/include/asm/Kbuild
+++ b/arch/xtensa/include/asm/Kbuild
@@ -15,6 +15,7 @@ generic-y += irq_regs.h
 generic-y += kdebug.h
 generic-y += kmap_types.h
 generic-y += kvm_para.h
+generic-y += linkage.h
 generic-y += local.h
 generic-y += local64.h
 generic-y += percpu.h
diff --git a/arch/xtensa/include/asm/linkage.h b/arch/xtensa/include/asm/linkage.h
deleted file mode 100644
index bf2128a..0000000
--- a/arch/xtensa/include/asm/linkage.h
+++ /dev/null
@@ -1,16 +0,0 @@
-/*
- * include/asm-xtensa/linkage.h
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- *
- * Copyright (C) 2001 - 2005 Tensilica Inc.
- */
-
-#ifndef _XTENSA_LINKAGE_H
-#define _XTENSA_LINKAGE_H
-
-/* Nothing to do here ... */
-
-#endif	/* _XTENSA_LINKAGE_H */
-- 
1.7.0.4

