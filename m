Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757222AbaDQNtb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 09:49:31 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:48827 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751516AbaDQNoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 09:44:55 -0400
From: Will Deacon <will.deacon@arm.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, monstr@monstr.eu, dhowells@redhat.com, broonie@linaro.org,
        benh@kernel.crashing.org, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, Will Deacon <will.deacon@arm.com>
Subject: [PATCH 02/18] microblaze: io: remove dummy relaxed accessor macros
Date: Thu, 17 Apr 2014 14:44:05 +0100
Message-Id: <1397742261-15621-3-git-send-email-will.deacon@arm.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1397742261-15621-1-git-send-email-will.deacon@arm.com>
References: <1397742261-15621-1-git-send-email-will.deacon@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are now defined by asm-generic/io.h, so we don't need the private
definitions anymore.

Cc: Michal Simek <monstr@monstr.eu>
Signed-off-by: Will Deacon <will.deacon@arm.com>
---
 arch/microblaze/include/asm/io.h | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/arch/microblaze/include/asm/io.h b/arch/microblaze/include/asm/io.h
index 1e4c3329f62e..2987fd4c73d6 100644
--- a/arch/microblaze/include/asm/io.h
+++ b/arch/microblaze/include/asm/io.h
@@ -72,12 +72,4 @@ extern void __iomem *ioremap(phys_addr_t address, unsigned long size);
 
 #include <asm-generic/io.h>
 
-#define readb_relaxed	readb
-#define readw_relaxed	readw
-#define readl_relaxed	readl
-
-#define writeb_relaxed	writeb
-#define writew_relaxed	writew
-#define writel_relaxed	writel
-
 #endif /* _ASM_MICROBLAZE_IO_H */
-- 
1.9.1

