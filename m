Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932261AbbAOV7e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 16:59:34 -0500
Received: from down.free-electrons.com ([37.187.137.238]:57562 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755858AbbAOV7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 16:59:32 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Bo Shen <voice.shen@atmel.com>, Wenyou Yang <Wenyou.Yang@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 03/17] ARM: at91:remove unused mach/system_rev.h
Date: Thu, 15 Jan 2015 22:58:06 +0100
Message-Id: <1421359100-8930-4-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1421359100-8930-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1421359100-8930-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mach/system_rev.h is not used, remove it.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/mach-at91/include/mach/system_rev.h | 27 ---------------------------
 1 file changed, 27 deletions(-)
 delete mode 100644 arch/arm/mach-at91/include/mach/system_rev.h

diff --git a/arch/arm/mach-at91/include/mach/system_rev.h b/arch/arm/mach-at91/include/mach/system_rev.h
deleted file mode 100644
index ef79a9aafc08..000000000000
--- a/arch/arm/mach-at91/include/mach/system_rev.h
+++ /dev/null
@@ -1,27 +0,0 @@
-/*
- * Copyright (C) 2011 Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
- *
- * Under GPLv2 only
- */
-
-#ifndef __ARCH_SYSTEM_REV_H__
-#define __ARCH_SYSTEM_REV_H__
-
-#include <asm/system_info.h>
-
-/*
- * board revision encoding
- * mach specific
- * the 16-31 bit are reserved for at91 generic information
- *
- * bit 31:
- *	0 => nand 8 bit
- *	1 => nand 16 bit
- */
-#define BOARD_HAVE_NAND_16BIT	(1 << 31)
-static inline int board_have_nand_16bit(void)
-{
-	return (system_rev & BOARD_HAVE_NAND_16BIT) ? 1 : 0;
-}
-
-#endif /* __ARCH_SYSTEM_REV_H__ */
-- 
2.1.0

