Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754427AbaIXRZc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 13:25:32 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:41622 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751969AbaIXRUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 13:20:23 -0400
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
Subject: [PATCH v3 02/17] microblaze: io: remove dummy relaxed accessor macros
Date: Wed, 24 Sep 2014 18:17:21 +0100
Message-Id: <1411579056-16966-3-git-send-email-will.deacon@arm.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1411579056-16966-1-git-send-email-will.deacon@arm.com>
References: <1411579056-16966-1-git-send-email-will.deacon@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are now defined by asm-generic/io.h, so we don't need the private
definitions anymore.

Acked-by: Michal Simek <monstr@monstr.eu>
Signed-off-by: Will Deacon <will.deacon@arm.com>
---
 arch/microblaze/include/asm/io.h | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/arch/microblaze/include/asm/io.h b/arch/microblaze/include/asm/io.h
index 433751b2a003..940f5fc1d1da 100644
--- a/arch/microblaze/include/asm/io.h
+++ b/arch/microblaze/include/asm/io.h
@@ -69,12 +69,4 @@ extern void __iomem *ioremap(phys_addr_t address, unsigned long size);
 
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
2.1.0

