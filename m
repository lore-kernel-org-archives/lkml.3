Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696Ab3HRTjQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 15:39:16 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:42912 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666Ab3HRTjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 15:39:14 -0400
From: Thiagarajan Thangavel <write2thiagu@gmail.com>
To: grant.likely@linaro.org
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH 2/2] drivers: block :swim3: fixed the errors on coding style
Date: Mon, 19 Aug 2013 01:09:00 +0530
Message-Id: <1376854740-17580-1-git-send-email-write2thiagu@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed the coding style errors

Signed-off-by: Thiagarajan Thangavel <write2thiagu@gmail.com>
---
 drivers/block/swim3.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/block/swim3.c b/drivers/block/swim3.c
index a473e25..89c9a85 100644
--- a/drivers/block/swim3.c
+++ b/drivers/block/swim3.c
@@ -783,7 +783,7 @@ static irqreturn_t swim3_interrupt(int irq, void *dev_id)
 				act(fs);
 			} else {
 				swim3_err("Error %sing block %ld (err=%x)\n",
-				       rq_data_dir(req) == WRITE ? "writ" : "read",
+				rq_data_dir(req) == WRITE ? "writ" : "read",
 				       (long)blk_rq_pos(req), err);
 				swim3_end_request(fs, -EIO, 0);
 				fs->state = idle;
@@ -894,7 +894,18 @@ static int fd_eject(struct floppy_state *fs)
 	return err;
 }
 
-static struct floppy_struct floppy_type = { 2880, 18, 2, 80, 0, 0x1B, 0x00, 0xCF, 0x6C, NULL };	/*  7 1.44MB 3.5"   */
+static struct floppy_struct floppy_type = {
+	2880,
+	18,
+	2,
+	80,
+	0,
+	0x1B,
+	0x00,
+	0xCF,
+	0x6C,
+	NULL
+};	/*  7 1.44MB 3.5"   */
 
 static int floppy_locked_ioctl(struct block_device *bdev, fmode_t mode,
 			unsigned int cmd, unsigned long param)
-- 
1.7.9.5

