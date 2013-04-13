Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933472Ab3DMPn7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 11:43:59 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:42573 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932263Ab3DMPn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 11:43:57 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Yinghai Lu <yinghai@kernel.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, David Rientjes <rientjes@google.com>,
        Wen Congyang <wency@cn.fujitsu.com>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, David Howells <dhowells@redhat.com>,
        Mark Salter <msalter@redhat.com>, Jianguo Wu <wujianguo@huawei.com>,
        linux-mm@kvack.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, Guan Xuetao <gxt@mprc.pku.edu.cn>
Subject: [RFC PATCH v1 16/19] mm/unicore32: fix stale comment about VALID_PAGE()
Date: Sat, 13 Apr 2013 23:36:36 +0800
Message-Id: <1365867399-21323-17-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1365867399-21323-1-git-send-email-jiang.liu@huawei.com>
References: <1365867399-21323-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

VALID_PAGE() has been removed from kernel long time ago,
so fix the comment.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
Cc: linux-kernel@vger.kernel.org
---
 arch/unicore32/include/asm/memory.h |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/arch/unicore32/include/asm/memory.h b/arch/unicore32/include/asm/memory.h
index 5eddb99..debafc4 100644
--- a/arch/unicore32/include/asm/memory.h
+++ b/arch/unicore32/include/asm/memory.h
@@ -98,12 +98,6 @@
 /*
  * Conversion between a struct page and a physical address.
  *
- * Note: when converting an unknown physical address to a
- * struct page, the resulting pointer must be validated
- * using VALID_PAGE().  It must return an invalid struct page
- * for any physical address not corresponding to a system
- * RAM address.
- *
  *  page_to_pfn(page)	convert a struct page * to a PFN number
  *  pfn_to_page(pfn)	convert a _valid_ PFN number to struct page *
  *
-- 
1.7.9.5

