Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618AbaIXRWy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 13:22:54 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:41677 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753883AbaIXRUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 13:20:39 -0400
From: Will Deacon <will.deacon@arm.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, benh@kernel.crashing.org, chris@zankel.net,
        cmetcalf@tilera.com, davem@davemloft.net, deller@gmx.de,
        dhowells@redhat.com, geert@linux-m68k.org, heiko.carstens@de.ibm.com,
        hpa@zytor.com, jcmvbkbc@gmail.com, jesper.nilsson@axis.com,
        mingo@redhat.com, monstr@monstr.eu, paulmck@linux.vnet.ibm.com,
        rdunlap@infradead.org, sam@ravnborg.org, schwidefsky@de.ibm.com,
        starvik@axis.com, takata@linux-m32r.org, tglx@linutronix.de,
        tony.luck@intel.com, daniel.thompson@linaro.org, broonie@linaro.org,
        linux@arm.linux.org.uk, Will Deacon <will.deacon@arm.com>
Subject: [PATCH v3 04/17] xtensa: io: remove dummy relaxed accessor macros for reads
Date: Wed, 24 Sep 2014 18:17:23 +0100
Message-Id: <1411579056-16966-5-git-send-email-will.deacon@arm.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1411579056-16966-1-git-send-email-will.deacon@arm.com>
References: <1411579056-16966-1-git-send-email-will.deacon@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are now defined by asm-generic/io.h, so we don't need the private
definitions anymore.

Cc: Chris Zankel <chris@zankel.net>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
---
 arch/xtensa/include/asm/io.h | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/arch/xtensa/include/asm/io.h b/arch/xtensa/include/asm/io.h
index 74944207167e..fe1600a09438 100644
--- a/arch/xtensa/include/asm/io.h
+++ b/arch/xtensa/include/asm/io.h
@@ -74,13 +74,6 @@ static inline void iounmap(volatile void __iomem *addr)
 
 #endif /* CONFIG_MMU */
 
-/*
- * Generic I/O
- */
-#define readb_relaxed readb
-#define readw_relaxed readw
-#define readl_relaxed readl
-
 #endif	/* __KERNEL__ */
 
 #include <asm-generic/io.h>
-- 
2.1.0

