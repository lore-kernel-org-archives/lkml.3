Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752413AbaBISxM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 13:53:12 -0500
Received: from mail.sigma-star.at ([95.130.255.111]:62420 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234AbaBISsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 13:48:36 -0500
From: Richard Weinberger <richard@nod.at>
To: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        linux-mtd@lists.infradead.org (open list:MEMORY TECHNOLOGY...),
        linux-kernel@vger.kernel.org (open list)
Cc: Richard Weinberger <richard@nod.at>
Subject: [PATCH 15/28] Remove TI_AEMIF
Date: Sun,  9 Feb 2014 19:47:53 +0100
Message-Id: <1391971686-9517-16-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1391971686-9517-1-git-send-email-richard@nod.at>
References: <1391971686-9517-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The symbol is an orphan, get rid of it.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/nand/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/Kconfig b/drivers/mtd/nand/Kconfig
index 90ff447..a195d57 100644
--- a/drivers/mtd/nand/Kconfig
+++ b/drivers/mtd/nand/Kconfig
@@ -465,7 +465,7 @@ config MTD_NAND_SH_FLCTL
 
 config MTD_NAND_DAVINCI
         tristate "Support NAND on DaVinci/Keystone SoC"
-        depends on ARCH_DAVINCI || (ARCH_KEYSTONE && TI_AEMIF)
+        depends on ARCH_DAVINCI || ARCH_KEYSTONE
         help
 	  Enable the driver for NAND flash chips on Texas Instruments
 	  DaVinci/Keystone processors.
-- 
1.8.4.2

