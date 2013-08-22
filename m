Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545Ab3HVCra (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 22:47:30 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:62589 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031Ab3HVCr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 22:47:29 -0400
MIME-Version: 1.0
Date: Thu, 22 Aug 2013 10:47:27 +0800
Message-ID: <CAPgLHd8+CD8iNZ4d7OJgc-jqd4ObgLnE0WmkGM5S98Q1TtTROQ@mail.gmail.com>
Subject: [PATCH -next] mm/page_alloc.c: remove duplicated include from page_alloc.c
From: Wei Yongjun <weiyj.lk@gmail.com>
To: akpm@linux-foundation.org, mgorman@suse.de, jiang.liu@huawei.com,
        cody@linux.vnet.ibm.com, minchan@kernel.org
Cc: yongjun_wei@trendmicro.com.cn, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Remove duplicated include.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 mm/page_alloc.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index efb2ffa..4751901 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -60,7 +60,6 @@
 #include <linux/page-debug-flags.h>
 #include <linux/hugetlb.h>
 #include <linux/sched/rt.h>
-#include <linux/hugetlb.h>
 
 #include <asm/sections.h>
 #include <asm/tlbflush.h>

