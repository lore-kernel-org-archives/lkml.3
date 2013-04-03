Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763163Ab3DCJZH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 05:25:07 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:19279 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763122Ab3DCJZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 05:25:05 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <linux-arm-kernel@lists.infradead.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
CC: <linux-kernel@vger.kernel.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH] ARM: at91: remove unused dbgu_readl() macro
Date: Wed, 3 Apr 2013 11:25:03 +0200
Message-ID: <1364981103-22980-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/mach-at91/include/mach/at91_dbgu.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/arm/mach-at91/include/mach/at91_dbgu.h b/arch/arm/mach-at91/include/mach/at91_dbgu.h
index 2aa0c5e..3b59485 100644
--- a/arch/arm/mach-at91/include/mach/at91_dbgu.h
+++ b/arch/arm/mach-at91/include/mach/at91_dbgu.h
@@ -16,9 +16,6 @@
 #ifndef AT91_DBGU_H
 #define AT91_DBGU_H
 
-#define dbgu_readl(dbgu, field) \
-	__raw_readl(AT91_VA_BASE_SYS + dbgu + AT91_DBGU_ ## field)
-
 #if !defined(CONFIG_ARCH_AT91X40)
 #define AT91_DBGU_CR		(0x00)	/* Control Register */
 #define AT91_DBGU_MR		(0x04)	/* Mode Register */
-- 
1.8.0

