Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752478AbaBIStD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 13:49:03 -0500
Received: from mail.sigma-star.at ([95.130.255.111]:62424 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376AbaBISsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 13:48:45 -0500
From: Richard Weinberger <richard@nod.at>
To: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
        linux-omap@vger.kernel.org (open list:OMAP SUPPORT),
        linux-arm-kernel@lists.infradead.org (moderated list:ARM
	SUB-ARCHITECT...),
        linux-kernel@vger.kernel.org (open list)
Cc: Richard Weinberger <richard@nod.at>
Subject: [PATCH 28/28] Remove LOCAL_TIMERS
Date: Sun,  9 Feb 2014 19:48:06 +0100
Message-Id: <1391971686-9517-29-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1391971686-9517-1-git-send-email-richard@nod.at>
References: <1391971686-9517-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The symbol is an orphan, get rid of it.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/arm/mach-omap2/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
index 653b489..2817f1f 100644
--- a/arch/arm/mach-omap2/Kconfig
+++ b/arch/arm/mach-omap2/Kconfig
@@ -54,7 +54,6 @@ config SOC_OMAP5
 	select ARM_GIC
 	select CPU_V7
 	select HAVE_ARM_SCU if SMP
-	select HAVE_ARM_TWD if LOCAL_TIMERS
 	select HAVE_SMP
 	select HAVE_ARM_ARCH_TIMER
 	select ARM_ERRATA_798181 if SMP
-- 
1.8.4.2

