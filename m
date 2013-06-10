Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740Ab3FJOg5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 10:36:57 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:41803 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945Ab3FJOgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 10:36:55 -0400
Message-ID: <51B5E480.6060303@gmail.com>
Date: Mon, 10 Jun 2013 22:36:48 +0800
From: Zhang Yanfei <zhangyanfei.yes@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120607 Thunderbird/10.0.5
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux MM <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] mm: Fix the comment for GFP_ZONE_TABLE
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>

0xc just means MOVABLE + DMA32, which results in zone DMA32.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
---
 include/linux/gfp.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 0f615eb..9b4dd49 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -209,7 +209,7 @@ static inline int allocflags_to_migratetype(gfp_t gfp_flags)
  *       0x9    => DMA or NORMAL (MOVABLE+DMA)
  *       0xa    => MOVABLE (Movable is valid only if HIGHMEM is set too)
  *       0xb    => BAD (MOVABLE+HIGHMEM+DMA)
- *       0xc    => DMA32 (MOVABLE+HIGHMEM+DMA32)
+ *       0xc    => DMA32 (MOVABLE+DMA32)
  *       0xd    => BAD (MOVABLE+DMA32+DMA)
  *       0xe    => BAD (MOVABLE+DMA32+HIGHMEM)
  *       0xf    => BAD (MOVABLE+DMA32+HIGHMEM+DMA)
-- 
1.7.1
