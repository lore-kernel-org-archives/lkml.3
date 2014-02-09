Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752567AbaBISzh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 13:55:37 -0500
Received: from mail.sigma-star.at ([95.130.255.111]:62413 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146AbaBISsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 13:48:30 -0500
From: Richard Weinberger <richard@nod.at>
To: Ralf Baechle <ralf@linux-mips.org>,
        linux-mips@linux-mips.org (open list:MIPS),
        linux-kernel@vger.kernel.org (open list)
Cc: Richard Weinberger <richard@nod.at>
Subject: [PATCH 08/28] Remove SYS_HAS_DMA_OPS
Date: Sun,  9 Feb 2014 19:47:46 +0100
Message-Id: <1391971686-9517-9-git-send-email-richard@nod.at>
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
index dcae3a7..792bd22 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -1396,7 +1396,6 @@ config CPU_CAVIUM_OCTEON
 	select LIBFDT
 	select USE_OF
 	select USB_EHCI_BIG_ENDIAN_MMIO
-	select SYS_HAS_DMA_OPS
 	select MIPS_L1_CACHE_SHIFT_7
 	help
 	  The Cavium Octeon processor is a highly integrated chip containing
-- 
1.8.4.2

