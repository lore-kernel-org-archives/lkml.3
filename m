Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098Ab3KYI4O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 03:56:14 -0500
Received: from gerard.telenet-ops.be ([195.130.132.48]:39848 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753711Ab3KYIzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 03:55:46 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Paul Mundt <lethal@linux-sh.org>, linux-sh@vger.kernel.org
Subject: [PATCH 19/24] sh: Replace <uapi/asm/types.h> by <asm-generic/int-ll64.h>
Date: Mon, 25 Nov 2013 09:55:29 +0100
Message-Id: <1385369734-24893-20-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1385369734-24893-1-git-send-email-geert@linux-m68k.org>
References: <1385369734-24893-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As arch/sh/include/uapi/asm/types.h doesn't exist, sh doesn't provide
any sh-specific uapi definitions, and it can just include
<asm-generic/int-ll64.h>, like most other architectures.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: linux-sh@vger.kernel.org
---
 arch/sh/include/asm/types.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/sh/include/asm/types.h b/arch/sh/include/asm/types.h
index 6a31053fa5e3..062324be5cd6 100644
--- a/arch/sh/include/asm/types.h
+++ b/arch/sh/include/asm/types.h
@@ -1,7 +1,7 @@
 #ifndef __ASM_SH_TYPES_H
 #define __ASM_SH_TYPES_H
 
-#include <uapi/asm/types.h>
+#include <asm-generic/int-ll64.h>
 
 /*
  * These aren't exported outside the kernel to avoid name space clashes
-- 
1.7.9.5

