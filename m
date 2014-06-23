Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594AbaFWMNb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 08:13:31 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:48855 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758AbaFWMN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 08:13:29 -0400
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>,
        Weijie Yang <weijie.yang@samsung.com>, linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: [PATCH 2/2] zram: remove unused SECTOR_SIZE define
Date: Mon, 23 Jun 2014 21:12:43 +0900
Message-Id: <1403525563-7549-3-git-send-email-sergey.senozhatsky@gmail.com>
X-Mailer: git-send-email 2.0.0.548.ge727dec
In-Reply-To: <1403525563-7549-1-git-send-email-sergey.senozhatsky@gmail.com>
References: <1403525563-7549-1-git-send-email-sergey.senozhatsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drop SECTOR_SIZE define, because it's not used.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
---
 drivers/block/zram/zram_drv.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/block/zram/zram_drv.h b/drivers/block/zram/zram_drv.h
index 75d604d..cf1bedb 100644
--- a/drivers/block/zram/zram_drv.h
+++ b/drivers/block/zram/zram_drv.h
@@ -43,7 +43,6 @@ static const size_t max_zpage_size = PAGE_SIZE / 4 * 3;
 /*-- End of configurable params */
 
 #define SECTOR_SHIFT		9
-#define SECTOR_SIZE		(1 << SECTOR_SHIFT)
 #define SECTORS_PER_PAGE_SHIFT	(PAGE_SHIFT - SECTOR_SHIFT)
 #define SECTORS_PER_PAGE	(1 << SECTORS_PER_PAGE_SHIFT)
 #define ZRAM_LOGICAL_BLOCK_SHIFT 12
-- 
2.0.0.421.g5428530

