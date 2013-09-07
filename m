Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751121Ab3IGDsE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 23:48:04 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:49516 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035Ab3IGDru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 23:47:50 -0400
Date: Sat, 7 Sep 2013 09:17:34 +0530
From: Anoop Thomas Mathew <atm@profoundis.com>
To: santosh.shilimkar@ti.com
Cc: tony@atomide.com, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: OMAP4 SMP: Corrected a typo fucntions to functions
Message-ID: <20130907034728.GA28216@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Corrected the functions spelling mistake in the OMAP4 SMP source file.

Signed-off-by: Anoop Thomas Mathew <atm@profoundis.com>
---
 arch/arm/mach-omap2/omap-smp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-omap2/omap-smp.c b/arch/arm/mach-omap2/omap-smp.c
index 8708b2a..8912110 100644
--- a/arch/arm/mach-omap2/omap-smp.c
+++ b/arch/arm/mach-omap2/omap-smp.c
@@ -1,5 +1,5 @@
 /*
- * OMAP4 SMP source file. It contains platform specific fucntions
+ * OMAP4 SMP source file. It contains platform specific functions
  * needed for the linux smp kernel.
  *
  * Copyright (C) 2009 Texas Instruments, Inc.
-- 
1.7.9.5

