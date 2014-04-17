Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757060AbaDQNpA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 09:45:00 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:48835 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753585AbaDQNo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 09:44:56 -0400
From: Will Deacon <will.deacon@arm.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, monstr@monstr.eu, dhowells@redhat.com, broonie@linaro.org,
        benh@kernel.crashing.org, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, Will Deacon <will.deacon@arm.com>,
        Chris Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH 04/18] xtensa: io: remove dummy relaxed accessor macros for reads
Date: Thu, 17 Apr 2014 14:44:07 +0100
Message-Id: <1397742261-15621-5-git-send-email-will.deacon@arm.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1397742261-15621-1-git-send-email-will.deacon@arm.com>
References: <1397742261-15621-1-git-send-email-will.deacon@arm.com>
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
1.9.1

