Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198Ab3EMEvj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 00:51:39 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:63738 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902Ab3EMEvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 00:51:38 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: matthew.r.wilcox@intel.com, vishal.l.verma@linux.intel.com,
        keith.busch@intel.com, sachin.kamat@linaro.org
Subject: [PATCH 1/1] NVMe: Remove redundant version.h header include
Date: Mon, 13 May 2013 10:08:18 +0530
Message-Id: <1368419898-25493-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

version.h header inclusion is not necessary as detected by
checkversion.pl.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/block/nvme-scsi.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/block/nvme-scsi.c b/drivers/block/nvme-scsi.c
index fed54b0..64bde68 100644
--- a/drivers/block/nvme-scsi.c
+++ b/drivers/block/nvme-scsi.c
@@ -44,7 +44,6 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/types.h>
-#include <linux/version.h>
 #include <scsi/sg.h>
 #include <scsi/scsi.h>
 
-- 
1.7.9.5

