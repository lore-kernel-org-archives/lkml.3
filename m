Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782Ab3KYJGt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 04:06:49 -0500
Received: from jacques.telenet-ops.be ([195.130.132.50]:50350 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753453Ab3KYIzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 03:55:44 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>
Subject: [PATCH 02/24] avr32/uapi: Use Kbuild logic to provide <asm/types.h>
Date: Mon, 25 Nov 2013 09:55:12 +0100
Message-Id: <1385369734-24893-3-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1385369734-24893-1-git-send-email-geert@linux-m68k.org>
References: <1385369734-24893-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Uapi <asm-generic/types.h> just includes <asm-generic/int-ll64.h>

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>
Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
---
 arch/avr32/include/uapi/asm/Kbuild  |    2 +-
 arch/avr32/include/uapi/asm/types.h |   13 -------------
 2 files changed, 1 insertion(+), 14 deletions(-)
 delete mode 100644 arch/avr32/include/uapi/asm/types.h

diff --git a/arch/avr32/include/uapi/asm/Kbuild b/arch/avr32/include/uapi/asm/Kbuild
index 08d8a3d76ea8..1598223f0bfc 100644
--- a/arch/avr32/include/uapi/asm/Kbuild
+++ b/arch/avr32/include/uapi/asm/Kbuild
@@ -19,7 +19,6 @@ header-y += stat.h
 header-y += swab.h
 header-y += termbits.h
 header-y += termios.h
-header-y += types.h
 header-y += unistd.h
 generic-y += bitsperlong.h
 generic-y += errno.h
@@ -34,3 +33,4 @@ generic-y += poll.h
 generic-y += resource.h
 generic-y += siginfo.h
 generic-y += statfs.h
+generic-y += types.h
diff --git a/arch/avr32/include/uapi/asm/types.h b/arch/avr32/include/uapi/asm/types.h
deleted file mode 100644
index 7c986c4e99b5..000000000000
--- a/arch/avr32/include/uapi/asm/types.h
+++ /dev/null
@@ -1,13 +0,0 @@
-/*
- * Copyright (C) 2004-2006 Atmel Corporation
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-#ifndef _UAPI__ASM_AVR32_TYPES_H
-#define _UAPI__ASM_AVR32_TYPES_H
-
-#include <asm-generic/int-ll64.h>
-
-#endif /* _UAPI__ASM_AVR32_TYPES_H */
-- 
1.7.9.5

