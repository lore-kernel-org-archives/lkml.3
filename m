Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932343Ab3KHXnq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 18:43:46 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:52864 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932274Ab3KHXnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 18:43:43 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
To: <tj@kernel.org>, <linux-kernel@vger.kernel.org>
CC: <linux-mm@kvack.org>, <linux-arm-kernel@lists.infradead.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: [PATCH 04/24] mm/block: remove unnecessary inclusion of bootmem.h
Date: Fri, 8 Nov 2013 18:41:40 -0500
Message-ID: <1383954120-24368-5-git-send-email-santosh.shilimkar@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1383954120-24368-1-git-send-email-santosh.shilimkar@ti.com>
References: <1383954120-24368-1-git-send-email-santosh.shilimkar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>

Clean-up to remove depedency with bootmem headers.

Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jens Axboe <axboe@kernel.dk>

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 block/blk-ioc.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/block/blk-ioc.c b/block/blk-ioc.c
index 46cd7bd..242df01 100644
--- a/block/blk-ioc.c
+++ b/block/blk-ioc.c
@@ -6,7 +6,6 @@
 #include <linux/init.h>
 #include <linux/bio.h>
 #include <linux/blkdev.h>
-#include <linux/bootmem.h>	/* for max_pfn/max_low_pfn */
 #include <linux/slab.h>
 
 #include "blk.h"
-- 
1.7.9.5

