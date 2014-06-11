Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664AbaFKVNy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 17:13:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16051 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752263AbaFKVNw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 17:13:52 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: axboe@fb.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] null_blk: fix name and description of 'queue_mode' module parameter
Date: Wed, 11 Jun 2014 17:13:50 -0400
Message-Id: <1402521230-28330-1-git-send-email-snitzer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'use_mq' is not the name of the module parameter, 'queue_mode' is.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/block/null_blk.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/block/null_blk.c b/drivers/block/null_blk.c
index 091b9ea..8c598f6 100644
--- a/drivers/block/null_blk.c
+++ b/drivers/block/null_blk.c
@@ -78,7 +78,7 @@ MODULE_PARM_DESC(home_node, "Home node for the device");
 
 static int queue_mode = NULL_Q_MQ;
 module_param(queue_mode, int, S_IRUGO);
-MODULE_PARM_DESC(use_mq, "Use blk-mq interface (0=bio,1=rq,2=multiqueue)");
+MODULE_PARM_DESC(queue_mode, "Block interface to use (0=bio,1=rq,2=multiqueue)");
 
 static int gb = 250;
 module_param(gb, int, S_IRUGO);
-- 
1.7.1

