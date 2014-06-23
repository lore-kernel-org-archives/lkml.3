Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522AbaFWMN2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 08:13:28 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:47500 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758AbaFWMNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 08:13:25 -0400
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>,
        Weijie Yang <weijie.yang@samsung.com>, linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: [PATCH 1/2] zram: rename struct `table' to `zram_table_entry'
Date: Mon, 23 Jun 2014 21:12:42 +0900
Message-Id: <1403525563-7549-2-git-send-email-sergey.senozhatsky@gmail.com>
X-Mailer: git-send-email 2.0.0.548.ge727dec
In-Reply-To: <1403525563-7549-1-git-send-email-sergey.senozhatsky@gmail.com>
References: <1403525563-7549-1-git-send-email-sergey.senozhatsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton has recently noted that `struct table'
actually represents table entry and, thus, should be
renamed. Rename to `zram_table_entry'.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
---
 drivers/block/zram/zram_drv.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/block/zram/zram_drv.h b/drivers/block/zram/zram_drv.h
index 71bc4ad..75d604d 100644
--- a/drivers/block/zram/zram_drv.h
+++ b/drivers/block/zram/zram_drv.h
@@ -74,7 +74,7 @@ enum zram_pageflags {
 /*-- Data structures */
 
 /* Allocated for each disk page */
-struct table {
+struct zram_table_entry {
 	unsigned long handle;
 	unsigned long value;
 };
@@ -92,7 +92,7 @@ struct zram_stats {
 };
 
 struct zram_meta {
-	struct table *table;
+	struct zram_table_entry *table;
 	struct zs_pool *mem_pool;
 };
 
-- 
2.0.0.421.g5428530

