Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092AbaHIRIB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 13:08:01 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:34564 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059AbaHIRIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 13:08:00 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Brian Norris <computersforpeace@gmail.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] mtd: nand: Use ULL-suffix for big u64 constant
Date: Sat,  9 Aug 2014 19:07:53 +0200
Message-Id: <1407604073-7484-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/mtd/nand/nand_timings.c:45: warning: integer constant is too large for ‘long’ type

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/mtd/nand/nand_timings.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/nand_timings.c b/drivers/mtd/nand/nand_timings.c
index 8b36253420fa..e81470a8ac67 100644
--- a/drivers/mtd/nand/nand_timings.c
+++ b/drivers/mtd/nand/nand_timings.c
@@ -42,7 +42,7 @@ static const struct nand_sdr_timings onfi_sdr_timings[] = {
 		.tRHZ_max = 200000,
 		.tRLOH_min = 0,
 		.tRP_min = 50000,
-		.tRST_max = 250000000000,
+		.tRST_max = 250000000000ULL,
 		.tWB_max = 200000,
 		.tRR_min = 40000,
 		.tWC_min = 100000,
-- 
1.9.1

