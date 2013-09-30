Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755697Ab3I3N06 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 09:26:58 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:55684 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755663Ab3I3N0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 09:26:52 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-d2-52497c1bfbc0
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: axboe@kernel.dk
Cc: abhansali@stec-inc.com, jmoyer@redhat.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH 07/14] skd: use <asm/unaligned.h>
Date: Mon, 30 Sep 2013 15:25:48 +0200
Message-id: <1380547556-17719-8-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1380547556-17719-1-git-send-email-b.zolnierkie@samsung.com>
References: <1380547556-17719-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplluLIzCtJLcpLzFFi42I5/e+xgK50jWeQwbN16ha9PSfZLVbf7Wez
	2DhjPavF2V9XWSzONr1ht7i8aw6bA5vH5bOlHu/3XWXz6NuyitHjzrkPTB6fN8kFsEZx2aSk
	5mSWpRbp2yVwZVx8l1twk7Vi+YINrA2Mn1m6GDk5JARMJDZvOscKYYtJXLi3ng3EFhJYxCjx
	dRVnFyMXkN3FJLFtwQpmkASbgJXExPZVjCC2iICwxP6OVhaQImaBJkaJjUvmgHULCxhKvJ69
	D2wqi4CqRNvsXrA4r4CHROejnVCb5SWe3u8Di3MKeEr8v32UEWKzh8S3Q5eZJjDyLmBkWMUo
	mlqQXFCclJ5rqFecmFtcmpeul5yfu4kRHEjPpHYwrmywOMQowMGoxMM7YblHkBBrYllxZe4h
	RgkOZiURXvEyzyAh3pTEyqrUovz4otKc1OJDjNIcLErivAdarQOFBNITS1KzU1MLUotgskwc
	nFINjD4B6axVl/fYF52drbdo+dalz849nxyzc+LuMsfl81MyhE43hoV+mqu0RmSDzdy9HzMe
	ruz8e61xQ/thRof1Fx9Uv/3+8Z6ZZOrThX7zW1Yub2BVN/VmMHdjfZ5e/dhSyniq8SP1NmmR
	2yv8v3buFlEO39FYsmVefNlE2V97pq6K+L3CcvujvzlKLMUZiYZazEXFiQDNx/k4IAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use <asm/unaligned.h> instead of <asm-generic/unaligned.h>.

Cc: Akhil Bhansali <abhansali@stec-inc.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/block/skd_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/skd_main.c b/drivers/block/skd_main.c
index 930ac88..e003137 100644
--- a/drivers/block/skd_main.c
+++ b/drivers/block/skd_main.c
@@ -45,7 +45,7 @@
 #include <scsi/sg.h>
 #include <linux/io.h>
 #include <linux/uaccess.h>
-#include <asm-generic/unaligned.h>
+#include <asm/unaligned.h>
 
 #include "skd_s1120.h"
 
-- 
1.8.2.3

