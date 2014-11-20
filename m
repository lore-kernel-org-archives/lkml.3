Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757710AbaKTS6P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 13:58:15 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:56931 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755003AbaKTS6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 13:58:13 -0500
From: Anjana Sasindran <anjanasasindran123@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Anjana Sasindran <anjanasasindran123@gmail.com>
Subject: [PATCH] Drivers:staging:dgap: Added a blank line after declaration
Date: Fri, 21 Nov 2014 00:27:50 +0530
Message-Id: <1416509870-7808-1-git-send-email-anjanasasindran123@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the checkpatch.pl warning:

WARNING:Missing a blank line after declaration

Signed-off-by: Anjana Sasindran <anjanasasindran123@gmail.com>
---
 drivers/staging/dgap/dgap.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
index f38354f..bdb5317 100644
--- a/drivers/staging/dgap/dgap.c
+++ b/drivers/staging/dgap/dgap.c
@@ -4414,6 +4414,7 @@ static struct board_t *find_board_by_major(unsigned int major)
 
 	for (i = 0; i < MAXBOARDS; i++) {
 		struct board_t *brd = dgap_board[i];
+
 		if (!brd)
 			return NULL;
 		if (major == brd->serial_driver->major ||
-- 
1.9.1

