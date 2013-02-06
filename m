Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751952Ab3BFJNf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 04:13:35 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:50982 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833Ab3BFJN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 04:13:29 -0500
X-AuditID: 9c93016f-b7b1fae000006419-c8-51121eb4fd29
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        js1304@gmail.com, Will Deacon <will.deacon@arm.com>,
        Nicolas Pitre <nico@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH v6 1/3] ARM: vmregion: remove vmregion code entirely
Date: Wed,  6 Feb 2013 18:13:28 +0900
Message-Id: <1360142010-10598-2-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360142010-10598-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1360142010-10598-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, there is no user for vmregion.
So remove it.

Acked-by: Nicolas Pitre <nico@linaro.org>
Tested-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/arch/arm/mm/Makefile b/arch/arm/mm/Makefile
index 8a9c4cb..4e333fa 100644
--- a/arch/arm/mm/Makefile
+++ b/arch/arm/mm/Makefile
@@ -6,7 +6,7 @@ obj-y				:= dma-mapping.o extable.o fault.o init.o \
 				   iomap.o
 
 obj-$(CONFIG_MMU)		+= fault-armv.o flush.o idmap.o ioremap.o \
-				   mmap.o pgd.o mmu.o vmregion.o
+				   mmap.o pgd.o mmu.o
 
 ifneq ($(CONFIG_MMU),y)
 obj-y				+= nommu.o
diff --git a/arch/arm/mm/vmregion.c b/arch/arm/mm/vmregion.c
deleted file mode 100644
index a631016..0000000
diff --git a/arch/arm/mm/vmregion.h b/arch/arm/mm/vmregion.h
deleted file mode 100644
index 0f5a5f2..0000000
-- 
1.7.9.5

