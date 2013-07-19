Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759704Ab3GSHAg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 03:00:36 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:23906 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731Ab3GSHAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 03:00:35 -0400
X-AuditID: cbfee690-b7f6f6d00000740c-16-51e8e411bd57
From: Jingoo Han <jg1.han@samsung.com>
To: "'Jens Axboe'" <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH] block: replace strict_strtoul() with kstrtoul()
Date: Fri, 19 Jul 2013 16:00:33 +0900
Message-id: <000a01ce844d$a99733d0$fcc59b70$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac6ETTFtZJAZrH2AQU2OjLet/5dJIQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCIsWRmVeSWpSXmKPExsVy+t8zY13BJy8CDbadUbeYs34Nm8Xqu/1s
	FpcXXmK1uLxrDpsDi8fls6UeJ2b8ZvHo27KK0ePzJrkAligum5TUnMyy1CJ9uwSujC2fNrIX
	POSpuDl7I2MD40KuLkZODgkBE4nXq1qZIGwxiQv31rOB2EICyxglFvUWwdSs/LqCtYuRCyg+
	nVHi6tE5jBDOL0aJxv03WEGq2ATUJL58OcwOYosIKEn82boaLM4skC/R3/2fGcQWFnCQeH35
	KFCcg4NFQFWifY8bSJhXwFLiTW8/C4QtKPFj8j0WiFYtifU7jzNB2PISm9e8ZYY4SEFix9nX
	jBCr9CS27VnODlEjIrHvxTuw2yQENrFLHNqwDGwQi4CAxLfJh1hA9koIyEpsOgA1R1Li4Iob
	LBMYxWYhWT0LyepZSFbPQrJiASPLKkbR1ILkguKk9CITveLE3OLSvHS95PzcTYyQGJuwg/He
	AetDjMlA6ycyS4km5wNjNK8k3tDYzMjC1MTU2Mjc0ow0YSVxXvUW60AhgfTEktTs1NSC1KL4
	otKc1OJDjEwcnFINjGG+y5p2692OLJt5d9HZL1JssidvsW8Xvv5DYWV3oGyp8Nx9h91lNf6s
	P1yxwl8vJoW5/e3Tt7InH3O8L3rtwP39+oQy8dQLF9LnZ+3bn/t+Yftauxuchpr1pa/28dna
	nBCpeCrZFR3of9TfdHFliPuZNru+n9/W9rtW3TpybLGx1x/pXbet9JVYijMSDbWYi4oTASfU
	euvHAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEKsWRmVeSWpSXmKPExsVy+t9jQV3BJy8CDda+UbaYs34Nm8Xqu/1s
	FpcXXmK1uLxrDpsDi8fls6UeJ2b8ZvHo27KK0ePzJrkAlqgGRpuM1MSU1CKF1Lzk/JTMvHRb
	Je/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoJVKCmWJOaVAoYDE4mIlfTtME0JD3HQt
	YBojdH1DguB6jAzQQMI6xowtnzayFzzkqbg5eyNjA+NCri5GTg4JAROJlV9XsELYYhIX7q1n
	62Lk4hASmM4ocfXoHEYI5xejROP+G2BVbAJqEl++HGYHsUUElCT+bF0NFmcWyJfo7/7PDGIL
	CzhIvL58FCjOwcEioCrRvscNJMwrYCnxprefBcIWlPgx+R4LRKuWxPqdx5kgbHmJzWveMkMc
	pCCx4+xrRohVehLb9ixnh6gRkdj34h3jBEaBWUhGzUIyahaSUbOQtCxgZFnFKJpakFxQnJSe
	a6RXnJhbXJqXrpecn7uJERzDz6R3MK5qsDjEKMDBqMTD++DL80Ah1sSy4srcQ4wSHMxKIry/
	kl8ECvGmJFZWpRblxxeV5qQWH2JMBnp0IrOUaHI+ML3klcQbGpuYGVkamVkYmZibkyasJM57
	sNU6UEggPbEkNTs1tSC1CGYLEwenVANj8mOLZ9278tmVPV6KS365zzd1oZHZ9oDE4ATnomaz
	yKLkhgmiV1Rnx1dw1C20mFky30Xj2tYZQlYCh103lmR9q/0teayyleOG+vKo76VbQs5rH3/3
	iK8hes1R7TaXlqWNcxY+MF/wrCnljMHqd+6iR55VW18t//7V/1pKfOfmH6bL/ISOeCQrsRRn
	JBpqMRcVJwIAbPKY8iUDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The usage of strict_strtoul() is not preferred, because
strict_strtoul() is obsolete. Thus, kstrtoul() should be
used.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/block/osdblk.c             |    2 +-
 drivers/block/rbd.c                |    2 +-
 drivers/block/xen-blkback/xenbus.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/block/osdblk.c b/drivers/block/osdblk.c
index 1bbc681..79aa179 100644
--- a/drivers/block/osdblk.c
+++ b/drivers/block/osdblk.c
@@ -598,7 +598,7 @@ static ssize_t class_osdblk_remove(struct class *c,
 	unsigned long ul;
 	struct list_head *tmp;
 
-	rc = strict_strtoul(buf, 10, &ul);
+	rc = kstrtoul(buf, 10, &ul);
 	if (rc)
 		return rc;
 
diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 4ad2ad9..9e00010 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -5126,7 +5126,7 @@ static ssize_t rbd_remove(struct bus_type *bus,
 	bool already = false;
 	int ret;
 
-	ret = strict_strtoul(buf, 10, &ul);
+	ret = kstrtoul(buf, 10, &ul);
 	if (ret)
 		return ret;
 
diff --git a/drivers/block/xen-blkback/xenbus.c b/drivers/block/xen-blkback/xenbus.c
index fe5c3cd..c2014a0 100644
--- a/drivers/block/xen-blkback/xenbus.c
+++ b/drivers/block/xen-blkback/xenbus.c
@@ -620,7 +620,7 @@ static void backend_changed(struct xenbus_watch *watch,
 	}
 
 	/* Front end dir is a number, which is used as the handle. */
-	err = strict_strtoul(strrchr(dev->otherend, '/') + 1, 0, &handle);
+	err = kstrtoul(strrchr(dev->otherend, '/') + 1, 0, &handle);
 	if (err)
 		return;
 
-- 
1.7.10.4


