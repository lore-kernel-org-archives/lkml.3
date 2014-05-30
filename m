Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964799AbaE3SU7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 14:20:59 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:34603 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933951AbaE3SU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 14:20:57 -0400
From: Thomas Wood <tommyandrena@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Thomas Wood <tommyandrena@gmail.com>
Subject: [PATCH] staging/goldfish: Clean up trailing whitespace.
Date: Fri, 30 May 2014 11:20:05 -0700
Message-Id: <1401474005-27804-1-git-send-email-tommyandrena@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When using scripts/checkpatch.pl, there are errors about trailing whitespace. Use scripts/cleanfile to remove these errors.

Signed-off-by: Thomas Wood <tommyandrena@gmail.com>
---

 drivers/staging/goldfish/goldfish_nand.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/goldfish/goldfish_nand.c b/drivers/staging/goldfish/goldfish_nand.c
index ab1f019..3b7ba61 100644
--- a/drivers/staging/goldfish/goldfish_nand.c
+++ b/drivers/staging/goldfish/goldfish_nand.c
@@ -326,7 +326,7 @@ static int goldfish_nand_init_device(struct platform_device *pdev,
 			(mtd->writesize + mtd->oobsize) * mtd->writesize;
 	do_div(mtd->size, mtd->writesize + mtd->oobsize);
 	mtd->size *= mtd->writesize;
-	dev_dbg(&pdev->dev, 
+	dev_dbg(&pdev->dev,
 		"goldfish nand dev%d: size %llx, page %d, extra %d, erase %d\n",
 		       id, mtd->size, mtd->writesize, mtd->oobsize, mtd->erasesize);
 	spin_unlock_irqrestore(&nand->lock, irq_flags);
@@ -340,7 +340,7 @@ static int goldfish_nand_init_device(struct platform_device *pdev,
 	result = goldfish_nand_cmd(mtd, NAND_CMD_GET_DEV_NAME, 0, name_len,
 									name);
 	if (result != name_len) {
-		dev_err(&pdev->dev, 
+		dev_err(&pdev->dev,
 			"goldfish_nand_init_device failed to get dev name %d != %d\n",
 			       result, name_len);
 		return -ENODEV;
@@ -391,7 +391,7 @@ static int goldfish_nand_probe(struct platform_device *pdev)
 
 	version = readl(base + NAND_VERSION);
 	if (version != NAND_VERSION_CURRENT) {
-		dev_err(&pdev->dev, 
+		dev_err(&pdev->dev,
 			"goldfish_nand_init: version mismatch, got %d, expected %d\n",
 				version, NAND_VERSION_CURRENT);
 		return -ENODEV;
@@ -400,7 +400,7 @@ static int goldfish_nand_probe(struct platform_device *pdev)
 	if (num_dev == 0)
 		return -ENODEV;
 
-	nand = devm_kzalloc(&pdev->dev, sizeof(*nand) + 
+	nand = devm_kzalloc(&pdev->dev, sizeof(*nand) +
 				sizeof(struct mtd_info) * num_dev, GFP_KERNEL);
 	if (nand == NULL)
 		return -ENOMEM;
-- 
1.9.1

