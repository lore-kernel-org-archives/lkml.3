Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709AbbAJB0D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 20:26:03 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:60605 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759AbbAJB0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 20:26:01 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: roland@kernel.org, sean.hefty@intel.com, hal.rosenstock@gmail.com,
        linux-kernel@vger.kernel.org
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] IB/mlx4: Remove unnecessary KERN_WARNING
Date: Sat, 10 Jan 2015 10:25:46 +0900
Message-Id: <1420853146-15117-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 2.2.1.268.g1e6f5b2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch remove unnecessary KERN_WARNING from pr_warn.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/infiniband/hw/mlx4/main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 57ecc5b..6e15136 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -1493,8 +1493,7 @@ static void reset_gids_task(struct work_struct *work)
 			       MLX4_CMD_TIME_CLASS_B,
 			       MLX4_CMD_WRAPPED);
 		if (err)
-			pr_warn(KERN_WARNING
-				"set port %d command failed\n", gw->port);
+			pr_warn("set port %d command failed\n", gw->port);
 	}
 
 	mlx4_free_cmd_mailbox(dev, mailbox);
-- 
2.2.1.268.g1e6f5b2

