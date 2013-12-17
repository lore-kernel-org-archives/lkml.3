Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529Ab3LQGMS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 01:12:18 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:64901 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953Ab3LQGLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 01:11:39 -0500
X-AuditID: 9c93017e-b7c17ae000003961-37-52afeb18c8ef
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nitin Gupta <ngupta@vflare.org>, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, linux-mm@kvack.org,
        Minchan Kim <minchan@kernel.org>
Subject: [PATCH 2/5] zram: add copyright
Date: Tue, 17 Dec 2013 15:12:00 +0900
Message-Id: <1387260723-15817-3-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1387260723-15817-1-git-send-email-minchan@kernel.org>
References: <1387260723-15817-1-git-send-email-minchan@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add my copyright to the zram source code which I maintain.

Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 drivers/block/zram/zram_drv.c |    1 +
 drivers/block/zram/zram_drv.h |    1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 134d605836ca..f9711c520269 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -2,6 +2,7 @@
  * Compressed RAM block device
  *
  * Copyright (C) 2008, 2009, 2010  Nitin Gupta
+ *               2012, 2013 Minchan Kim
  *
  * This code is released using a dual license strategy: BSD/GPL
  * You can choose the licence that better fits your requirements.
diff --git a/drivers/block/zram/zram_drv.h b/drivers/block/zram/zram_drv.h
index 92f70e8f457c..0e46953c08e9 100644
--- a/drivers/block/zram/zram_drv.h
+++ b/drivers/block/zram/zram_drv.h
@@ -2,6 +2,7 @@
  * Compressed RAM block device
  *
  * Copyright (C) 2008, 2009, 2010  Nitin Gupta
+ *               2012, 2013 Minchan Kim
  *
  * This code is released using a dual license strategy: BSD/GPL
  * You can choose the licence that better fits your requirements.
-- 
1.7.9.5

