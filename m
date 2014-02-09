Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752304AbaBISsj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 13:48:39 -0500
Received: from mail.sigma-star.at ([95.130.255.111]:62416 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906AbaBISsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 13:48:32 -0500
From: Richard Weinberger <richard@nod.at>
To: Ralf Baechle <ralf@linux-mips.org>,
        linux-mips@linux-mips.org (open list:MIPS),
        linux-kernel@vger.kernel.org (open list)
Cc: Richard Weinberger <richard@nod.at>
Subject: [PATCH 11/28] Remove ARCH_SUPPORTS_MSI
Date: Sun,  9 Feb 2014 19:47:49 +0100
Message-Id: <1391971686-9517-12-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1391971686-9517-1-git-send-email-richard@nod.at>
References: <1391971686-9517-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The symbol is an orphan, get rid of it.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/mips/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 792bd22..5b08fe9 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -782,7 +782,6 @@ config NLM_XLP_BOARD
 	select CEVT_R4K
 	select CSRC_R4K
 	select IRQ_CPU
-	select ARCH_SUPPORTS_MSI
 	select ZONE_DMA32 if 64BIT
 	select SYNC_R4K
 	select SYS_HAS_EARLY_PRINTK
-- 
1.8.4.2

