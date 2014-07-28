Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752165AbaG1JR1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 05:17:27 -0400
Received: from top.free-electrons.com ([176.31.233.9]:37562 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752051AbaG1JQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 05:16:57 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH 2/2] mtd: nand: add Hynix's H27UCG8T2ATR-BC to nand_ids table
Date: Mon, 28 Jul 2014 11:16:52 +0200
Message-Id: <1406539012-16320-3-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1406539012-16320-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1406539012-16320-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the full description of the Hynix H27UCG8T2ATR-BC NAND chip in the
nand_ids table so that we can later use the NAND ECC infos and ONFI timings
mode in controller drivers.

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
---
 drivers/mtd/nand/nand_ids.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/mtd/nand/nand_ids.c b/drivers/mtd/nand/nand_ids.c
index 3d7c89f..19d4168 100644
--- a/drivers/mtd/nand/nand_ids.c
+++ b/drivers/mtd/nand/nand_ids.c
@@ -46,6 +46,10 @@ struct nand_flash_dev nand_flash_ids[] = {
 	{"SDTNRGAMA 64G 3.3V 8-bit",
 		{ .id = {0x45, 0xde, 0x94, 0x93, 0x76, 0x50} },
 		  SZ_16K, SZ_8K, SZ_4M, 0, 6, 1280, NAND_ECC_INFO(40, SZ_1K) },
+	{"H27UCG8T2ATR-BC 64G 3.3V 8-bit",
+		{ .id = {0xad, 0xde, 0x94, 0xda, 0x74, 0xc4} },
+		  SZ_8K, SZ_8K, SZ_4M, 0, 6, 640, NAND_ECC_INFO(40, SZ_1K),
+		  4 },
 
 	LEGACY_ID_NAND("NAND 4MiB 5V 8-bit",   0x6B, 4, SZ_8K, SP_OPTIONS),
 	LEGACY_ID_NAND("NAND 4MiB 3,3V 8-bit", 0xE3, 4, SZ_8K, SP_OPTIONS),
-- 
1.8.3.2

