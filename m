Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756AbaDGDsB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 23:48:01 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:64640 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754636AbaDGDr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 23:47:59 -0400
From: Garret Kelly <garret.kelly@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Garret Kelly <garret.kelly@gmail.com>
Subject: [PATCH] staging: goldfish: Fix missing blank lines
Date: Sun,  6 Apr 2014 23:47:31 -0400
Message-Id: <1396842451-10350-1-git-send-email-garret.kelly@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix two instances of the following checkpatch warning:
WARNING: Missing a blank line after declarations

Signed-off-by: Garret Kelly <garret.kelly@gmail.com>
---
 drivers/staging/goldfish/goldfish_audio.c | 1 +
 drivers/staging/goldfish/goldfish_nand.c  | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/staging/goldfish/goldfish_audio.c b/drivers/staging/goldfish/goldfish_audio.c
index f96dcec..aca980e 100644
--- a/drivers/staging/goldfish/goldfish_audio.c
+++ b/drivers/staging/goldfish/goldfish_audio.c
@@ -147,6 +147,7 @@ static ssize_t goldfish_audio_write(struct file *fp, const char __user *buf,
 
 	while (count > 0) {
 		ssize_t copy = count;
+
 		if (copy > WRITE_BUFFER_SIZE)
 			copy = WRITE_BUFFER_SIZE;
 		wait_event_interruptible(data->wait, (data->buffer_status &
diff --git a/drivers/staging/goldfish/goldfish_nand.c b/drivers/staging/goldfish/goldfish_nand.c
index eca0873..fe6771c 100644
--- a/drivers/staging/goldfish/goldfish_nand.c
+++ b/drivers/staging/goldfish/goldfish_nand.c
@@ -425,6 +425,7 @@ static int goldfish_nand_remove(struct platform_device *pdev)
 {
 	struct goldfish_nand *nand = platform_get_drvdata(pdev);
 	int i;
+
 	for (i = 0; i < nand->mtd_count; i++) {
 		if (nand->mtd[i].name)
 			mtd_device_unregister(&nand->mtd[i]);
-- 
1.8.3.2

