Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760970Ab3DBNWL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 09:22:11 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:62424 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760699Ab3DBNWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 09:22:10 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 2/9] ARM: ux500: Remove incorrect DB9540 PRCMU TCDM base location
Date: Tue,  2 Apr 2013 14:21:49 +0100
Message-Id: <1364908916-29803-2-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364908916-29803-1-git-send-email-lee.jones@linaro.org>
References: <1364908916-29803-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Tightly Coupled Data Memory for the DB9540 is actually in the
same place as the DB8500's. This definition is just plain wrong.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/include/mach/db8500-regs.h |    1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/mach-ux500/include/mach/db8500-regs.h b/arch/arm/mach-ux500/include/mach/db8500-regs.h
index 1530d49..856e584 100644
--- a/arch/arm/mach-ux500/include/mach/db8500-regs.h
+++ b/arch/arm/mach-ux500/include/mach/db8500-regs.h
@@ -102,7 +102,6 @@
 #define U8500_PRCMU_BASE	(U8500_PER4_BASE + 0x07000)
 #define U9540_DMC1_BASE		(U8500_PER4_BASE + 0x0A000)
 #define U8500_PRCMU_TCDM_BASE	(U8500_PER4_BASE + 0x68000)
-#define U9540_PRCMU_TCDM_BASE	(U8500_PER4_BASE + 0x6A000)
 #define U8500_PRCMU_TCPM_BASE   (U8500_PER4_BASE + 0x60000)
 #define U8500_PRCMU_TIMER_3_BASE (U8500_PER4_BASE + 0x07338)
 #define U8500_PRCMU_TIMER_4_BASE (U8500_PER4_BASE + 0x07450)
-- 
1.7.10.4

