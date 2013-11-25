Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231Ab3KYI5b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 03:57:31 -0500
Received: from georges.telenet-ops.be ([195.130.137.68]:60349 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753894Ab3KYIzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 03:55:48 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>, linux-alpha@vger.kernel.org
Subject: [PATCH 12/24] alpha: Remove #include <uapi/asm/types.h> from <asm/types.h>
Date: Mon, 25 Nov 2013 09:55:22 +0100
Message-Id: <1385369734-24893-13-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1385369734-24893-1-git-send-email-geert@linux-m68k.org>
References: <1385369734-24893-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Everything in arch/alpha/include/uapi/asm/types.h is protected by
"#ifndef __KERNEL__", so it's unused for kernelspace.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Cc: linux-alpha@vger.kernel.org
---
 arch/alpha/include/asm/types.h |    1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/alpha/include/asm/types.h b/arch/alpha/include/asm/types.h
index f61e1a56c378..4cb4b6d3452c 100644
--- a/arch/alpha/include/asm/types.h
+++ b/arch/alpha/include/asm/types.h
@@ -2,6 +2,5 @@
 #define _ALPHA_TYPES_H
 
 #include <asm-generic/int-ll64.h>
-#include <uapi/asm/types.h>
 
 #endif /* _ALPHA_TYPES_H */
-- 
1.7.9.5

