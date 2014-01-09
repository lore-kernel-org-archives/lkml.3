Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755744AbaAIMh4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 07:37:56 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:62783 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753009AbaAIMfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 07:35:07 -0500
From: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
To: nicolas.ferre@atmel.com, b.brezillon@overkiz.com, arnd@arndb.de
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Subject: [PATCH v2 05/12] at91: smc: Increased the size of tdf_cycles in struct sam9_smc_config.
Date: Thu,  9 Jan 2014 13:31:42 +0100
Message-Id: <1389270709-32662-6-git-send-email-jjhiblot@traphandler.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1389270709-32662-1-git-send-email-jjhiblot@traphandler.com>
References: <1389270709-32662-1-git-send-email-jjhiblot@traphandler.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes it possible to check if the tdf_cycle is too big to fit in the
register.

Signed-off-by: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
---
 arch/arm/mach-at91/include/mach/at91sam9_smc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-at91/include/mach/at91sam9_smc.h b/arch/arm/mach-at91/include/mach/at91sam9_smc.h
index 56de08a..c3e29311 100644
--- a/arch/arm/mach-at91/include/mach/at91sam9_smc.h
+++ b/arch/arm/mach-at91/include/mach/at91sam9_smc.h
@@ -38,7 +38,7 @@ struct sam9_smc_config {
 
 	/* Mode register */
 	u32 mode;
-	u8 tdf_cycles:4;
+	u8 tdf_cycles;
 };
 
 extern void sam9_smc_configure(int id, int cs, struct sam9_smc_config *config);
-- 
1.8.5.2

