Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596AbaBISuJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 13:50:09 -0500
Received: from mail.sigma-star.at ([95.130.255.111]:62425 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339AbaBISso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 13:48:44 -0500
From: Richard Weinberger <richard@nod.at>
To: Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org (moderated list:ARM
	SUB-ARCHITECT...),
        linux-sh@vger.kernel.org (open list:ARM/SHMOBILE ARM...),
        linux-kernel@vger.kernel.org (open list)
Cc: Richard Weinberger <richard@nod.at>
Subject: [PATCH 26/28] Remove LOCAL_TIMERS
Date: Sun,  9 Feb 2014 19:48:04 +0100
Message-Id: <1391971686-9517-27-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1391971686-9517-1-git-send-email-richard@nod.at>
References: <1391971686-9517-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The symbol is an orphan, get rid of it.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/arm/mach-shmobile/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/mach-shmobile/Kconfig b/arch/arm/mach-shmobile/Kconfig
index 3386406..c055388 100644
--- a/arch/arm/mach-shmobile/Kconfig
+++ b/arch/arm/mach-shmobile/Kconfig
@@ -8,7 +8,6 @@ config ARCH_SHMOBILE_MULTI
 	select CPU_V7
 	select GENERIC_CLOCKEVENTS
 	select HAVE_ARM_SCU if SMP
-	select HAVE_ARM_TWD if LOCAL_TIMERS
 	select HAVE_SMP
 	select ARM_GIC
 	select MIGHT_HAVE_CACHE_L2X0
-- 
1.8.4.2

