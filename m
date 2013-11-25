Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960Ab3KYJBa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 04:01:30 -0500
Received: from georges.telenet-ops.be ([195.130.137.68]:60393 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753509Ab3KYIzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 03:55:45 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-mips@linux-mips.org
Subject: [PATCH 13/24] mips: Remove #include <uapi/asm/types.h> from <asm/types.h>
Date: Mon, 25 Nov 2013 09:55:23 +0100
Message-Id: <1385369734-24893-14-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1385369734-24893-1-git-send-email-geert@linux-m68k.org>
References: <1385369734-24893-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Everything in arch/mips/include/uapi/asm/types.h is protected by
"#ifndef __KERNEL__", so it's unused for kernelspace.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Ralf Baechle <ralf@linux-mips.org>>
Cc: linux-mips@linux-mips.org
---
 arch/mips/include/asm/types.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/mips/include/asm/types.h b/arch/mips/include/asm/types.h
index a845aafedee4..4d5ce4c9c924 100644
--- a/arch/mips/include/asm/types.h
+++ b/arch/mips/include/asm/types.h
@@ -11,8 +11,7 @@
 #ifndef _ASM_TYPES_H
 #define _ASM_TYPES_H
 
-# include <asm-generic/int-ll64.h>
-#include <uapi/asm/types.h>
+#include <asm-generic/int-ll64.h>
 
 /*
  * These aren't exported outside the kernel to avoid name space clashes
-- 
1.7.9.5

