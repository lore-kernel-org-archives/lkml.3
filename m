Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965362Ab3BNNtx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 08:49:53 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:57377 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965229Ab3BNNto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 08:49:44 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: arm@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 05/11] ARM: sa1100: don't warn about mach/ide.h
Date: Thu, 14 Feb 2013 14:49:21 +0100
Message-Id: <1360849767-1463135-6-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1360849767-1463135-1-git-send-email-arnd@arndb.de>
References: <1360849767-1463135-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:shwFPS5JENGI7X2Whgr7szrUASttmgBNfvYIbpTtjPD
 b2TT4lupv51Wtih9s+hgnqVcdx7vLid9hhY//2ggFsCcRijckk
 F4oq/deE5fq2iA/7fKCtypgi8be3+/Yyz46GlJBSfm2yoHBAx8
 b/njsXBxpKF9sH3DI0v9uY9ASCHx58dNjrRFi/2QMGjxbMiDKj
 g/16ff1yrTERAYnfPxoZ1mhH79LG+4gO2oRHGKcJh5m2IGv0BD
 aoaSOTiKY3J7fese2HfwidnbDvI06x7OW8E0XjLCnYQe9w93Tp
 YChSmT06QrL8nCVwUDEum8bu8t4vti9x/4kgutkfQ2JikHymN2
 gWERebtVlBLHYHWrQyxLVgd+l6sr9abxuFy2ivQht
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This warning has existed since before the start of (git) history.
Apparently nobody has bothered to fix it in a long time, and
this is unlikely to change. Note that the file that the warning
refers to has moved to a different location and was subsequently
deleted in 2008.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King <linux@arm.linux.org.uk>
---
 arch/arm/mach-sa1100/lart.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/arm/mach-sa1100/lart.c b/arch/arm/mach-sa1100/lart.c
index f69f78f..bca7e60 100644
--- a/arch/arm/mach-sa1100/lart.c
+++ b/arch/arm/mach-sa1100/lart.c
@@ -24,9 +24,6 @@
 
 #include "generic.h"
 
-
-#warning "include/asm/arch-sa1100/ide.h needs fixing for lart"
-
 static struct mcp_plat_data lart_mcp_data = {
 	.mccr0		= MCCR0_ADM,
 	.sclk_rate	= 11981000,
-- 
1.8.1.2

