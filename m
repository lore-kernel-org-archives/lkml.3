Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754Ab3KELh4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 06:37:56 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:28685 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754652Ab3KELhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 06:37:54 -0500
X-AuditID: cbfee61b-b7fd56d000001fc6-3c-5278d8916a32
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: axboe@kernel.dk
Cc: abhansali@stec-inc.com, jmoyer@redhat.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH v2 06/11] skd: use <asm/unaligned.h>
Date: Tue, 05 Nov 2013 12:37:04 +0100
Message-id: <1383651429-4322-7-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1383651429-4322-1-git-send-email-b.zolnierkie@samsung.com>
References: <1383651429-4322-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphluLIzCtJLcpLzFFi42I5/e+xoO7EGxVBBiuuCFv09pxkt1h9t5/N
	YuOM9awWZ39dZbE42/SG3eLyrjlsDmwel8+Werzfd5XNo2/LKkaPO+c+MHl83iQXwBrFZZOS
	mpNZllqkb5fAlbHg2CP2glusFXP2xTcwfmHpYuTgkBAwkZj8TrGLkRPIFJO4cG89WxcjF4eQ
	wHRGiQ/fL7JCOF1MEo9/XWECqWITsJKY2L6KEcQWERCW2N/RygJSxCywgFFi8o457CAJYaCp
	d1euZgTZwCKgKjH7XjlImFfAXeL62y5miG3yEk/v97GB2JwCHhJXLr0BaxUCqtn2cS/rBEbe
	BYwMqxhFUwuSC4qT0nON9IoTc4tL89L1kvNzNzGCw+iZ9A7GVQ0WhxgFOBiVeHgvhlYECbEm
	lhVX5h5ilOBgVhLhbTsCFOJNSaysSi3Kjy8qzUktPsQozcGiJM57sNU6UEggPbEkNTs1tSC1
	CCbLxMEp1cBYs31xRI2HuOHrv28n7+SczXS2dkLyXP+JK5qNJz8LN/ebdGXHmZz+evVHQR15
	0S1HuSJ1PhS1OMwLVViebWMm/PfCB1Y3O8693bd/8qZ+MtjYuF326uGYXpY4VaPX+hoLVe60
	dbybsvSaQU9X4KIrG7Z+W7+zXip3krXb/fxj8ilRVy9MlBZWYinOSDTUYi4qTgQAgLd+Bx8C	AAA=
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
index 47d8a6a..e3dfd0da 100644
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

