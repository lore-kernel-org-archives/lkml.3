Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104AbaFCMlV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 08:41:21 -0400
Received: from mail-yh0-f46.google.com ([209.85.213.46]:33391 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158AbaFCMlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 08:41:18 -0400
From: Vincent Heuken <me@vincentheuken.com>
To: lidza.louina@gmail.com, markh@compro.net, gregkh@linuxfoundation.org
Cc: driverdev-devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        Vincent Heuken <me@vincentheuken.com>
Subject: [PATCH] Staging: dgnc: fixed brace coding style issue in dgnc_driver.c
Date: Tue,  3 Jun 2014 05:41:33 -0700
Message-Id: <1401799293-24835-1-git-send-email-me@vincentheuken.com>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the dgnc_driver.c file that fixes the following
error:
ERROR: open brace '{' following function declarations go on
the next line

Signed-off-by: Vincent Heuken <me@vincentheuken.com>
---
 drivers/staging/dgnc/dgnc_driver.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/dgnc/dgnc_driver.c b/drivers/staging/dgnc/dgnc_driver.c
index 5af8300..d52a9e8 100644
--- a/drivers/staging/dgnc/dgnc_driver.c
+++ b/drivers/staging/dgnc/dgnc_driver.c
@@ -710,7 +710,8 @@ failed:
 }
 
 
-static int dgnc_finalize_board_init(struct dgnc_board *brd) {
+static int dgnc_finalize_board_init(struct dgnc_board *brd)
+{
 	int rc = 0;
 
 	DPR_INIT(("dgnc_finalize_board_init() - start\n"));
-- 
2.0.0

