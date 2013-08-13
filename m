Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759176Ab3HMUUZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 16:20:25 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:13012 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758796Ab3HMUUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 16:20:23 -0400
Message-ID: <201308132020.r7DKKMOW022745@farm-0021.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Tue, 13 Aug 2013 14:01:58 -0400
Subject: [PATCH] tile: use standard 'generic-y' model for <asm/hw_irq.h>
To: <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/asm/Kbuild   |  1 +
 arch/tile/include/asm/hw_irq.h | 18 ------------------
 2 files changed, 1 insertion(+), 18 deletions(-)
 delete mode 100644 arch/tile/include/asm/hw_irq.h

diff --git a/arch/tile/include/asm/Kbuild b/arch/tile/include/asm/Kbuild
index c5737f1..664d6ad 100644
--- a/arch/tile/include/asm/Kbuild
+++ b/arch/tile/include/asm/Kbuild
@@ -11,6 +11,7 @@ generic-y += errno.h
 generic-y += exec.h
 generic-y += fb.h
 generic-y += fcntl.h
+generic-y += hw_irq.h
 generic-y += ioctl.h
 generic-y += ioctls.h
 generic-y += ipcbuf.h
diff --git a/arch/tile/include/asm/hw_irq.h b/arch/tile/include/asm/hw_irq.h
deleted file mode 100644
index 4fac5fb..0000000
--- a/arch/tile/include/asm/hw_irq.h
+++ /dev/null
@@ -1,18 +0,0 @@
-/*
- * Copyright 2010 Tilera Corporation. All Rights Reserved.
- *
- *   This program is free software; you can redistribute it and/or
- *   modify it under the terms of the GNU General Public License
- *   as published by the Free Software Foundation, version 2.
- *
- *   This program is distributed in the hope that it will be useful, but
- *   WITHOUT ANY WARRANTY; without even the implied warranty of
- *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
- *   NON INFRINGEMENT.  See the GNU General Public License for
- *   more details.
- */
-
-#ifndef _ASM_TILE_HW_IRQ_H
-#define _ASM_TILE_HW_IRQ_H
-
-#endif /* _ASM_TILE_HW_IRQ_H */
-- 
1.8.3.1

