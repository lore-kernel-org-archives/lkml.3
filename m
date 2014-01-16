Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752975AbaAPNQ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 08:16:29 -0500
Received: from mail-ee0-f47.google.com ([74.125.83.47]:58879 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752948AbaAPNQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 08:16:24 -0500
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan@kernel.org>, Jerome Marchand <jmarchan@redhat.com>,
        Nitin Gupta <ngupta@vflare.org>, linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: [PATCHv3 7/8] zram: drop not used table `count' member
Date: Thu, 16 Jan 2014 16:12:15 +0300
Message-Id: <1389877936-15543-8-git-send-email-sergey.senozhatsky@gmail.com>
X-Mailer: git-send-email 1.8.5.3.493.gb139ac2
In-Reply-To: <1389877936-15543-1-git-send-email-sergey.senozhatsky@gmail.com>
References: <1389877936-15543-1-git-send-email-sergey.senozhatsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct table `count' member is not used.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
---
 drivers/block/zram/zram_drv.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/block/zram/zram_drv.h b/drivers/block/zram/zram_drv.h
index 58d4ac5..1d5b1f5 100644
--- a/drivers/block/zram/zram_drv.h
+++ b/drivers/block/zram/zram_drv.h
@@ -64,7 +64,6 @@ enum zram_pageflags {
 struct table {
 	unsigned long handle;
 	u16 size;	/* object size (excluding header) */
-	u8 count;	/* object ref count (not yet used) */
 	u8 flags;
 } __aligned(4);
 
-- 
1.8.5.3.493.gb139ac2

