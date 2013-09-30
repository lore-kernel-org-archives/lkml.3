Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755671Ab3I3N0x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 09:26:53 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:55673 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755633Ab3I3N0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 09:26:50 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-cd-52497c18a0dc
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: axboe@kernel.dk
Cc: abhansali@stec-inc.com, jmoyer@redhat.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH 06/14] skd: remove SCSI subsystem specific includes
Date: Mon, 30 Sep 2013 15:25:47 +0200
Message-id: <1380547556-17719-7-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1380547556-17719-1-git-send-email-b.zolnierkie@samsung.com>
References: <1380547556-17719-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjluLIzCtJLcpLzFFi42I5/e+xgK5EjWeQwbw/+ha9PSfZLVbf7Wez
	2DhjPavF2V9XWSzONr1ht7i8aw6bA5vH5bOlHu/3XWXz6NuyitHjzrkPTB6fN8kFsEZx2aSk
	5mSWpRbp2yVwZVyb/o29YD5bxZqfG9gaGNeydjFyckgImEis/nkayhaTuHBvPRuILSSwiFFi
	6X6HLkYuILuLSWJL+wZGkASbgJXExPZVYLaIgLDE/o5WFpAiZoEmRomNS+aAdQsLOEucvrIP
	rIhFQFXi99uJYBt4BTwkfjzbxwaxTV7i6f0+MJtTwFPi/+2jjBCbPSS+HbrMNIGRdwEjwypG
	0dSC5ILipPRcQ73ixNzi0rx0veT83E2M4FB6JrWDcWWDxSFGAQ5GJR7eCcs9goRYE8uKK3MP
	MUpwMCuJ8IqXeQYJ8aYkVlalFuXHF5XmpBYfYpTmYFES5z3Qah0oJJCeWJKanZpakFoEk2Xi
	4JRqYNzb8l3N51zuUalXac6MyWmL13R/CPmxb//fg5eqTDiuTDk/7VLwubTqw4zMkx80uXtw
	labvWDHl0VNJ6R9P/mwvvmXLa5PftOGj0cx/0ifKLqWHy/B6vjNbvEU0VvjX4eI1yTsad76d
	lxpv+vHB/8K4LiP1zb22pjcr9z/fZrfoRlXUo4KCFnYlluKMREMt5qLiRACHlko9IQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is not a SCSI host driver so remove SCSI subsystem specific
includes.

Cc: Akhil Bhansali <abhansali@stec-inc.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/block/skd_main.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/block/skd_main.c b/drivers/block/skd_main.c
index 738f847..930ac88 100644
--- a/drivers/block/skd_main.c
+++ b/drivers/block/skd_main.c
@@ -42,9 +42,6 @@
 #include <linux/wait.h>
 #include <linux/uio.h>
 #include <scsi/scsi.h>
-#include <scsi/scsi_host.h>
-#include <scsi/scsi_tcq.h>
-#include <scsi/scsi_cmnd.h>
 #include <scsi/sg.h>
 #include <linux/io.h>
 #include <linux/uaccess.h>
-- 
1.8.2.3

