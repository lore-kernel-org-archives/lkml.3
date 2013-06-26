Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608Ab3FZLvy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 07:51:54 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:50047 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037Ab3FZLvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 07:51:52 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kgene.kim@samsung.com, tglx@linutronix.de, t.figa@samsung.com,
        arnd@arndb.de, sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 1/2] ARM: EXYNOS: Remove combiner_init declaration
Date: Wed, 26 Jun 2013 17:06:36 +0530
Message-Id: <1372246597-32323-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit d243997f ("ARM: EXYNOS: Remove legacy interrupt initialization
code") removed the call to combiner_init(). Since there are no more
users in the machine code, remove the declaration as well.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 arch/arm/mach-exynos/common.h |    2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm/mach-exynos/common.h b/arch/arm/mach-exynos/common.h
index 3e156bc..c4abde2 100644
--- a/arch/arm/mach-exynos/common.h
+++ b/arch/arm/mach-exynos/common.h
@@ -72,8 +72,6 @@ void exynos4212_register_clocks(void);
 #endif
 
 struct device_node;
-void combiner_init(void __iomem *combiner_base, struct device_node *np,
-			unsigned int max_nr, int irq_base);
 
 extern struct smp_operations exynos_smp_ops;
 
-- 
1.7.9.5

