Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933374Ab3DMPnR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 11:43:17 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:56140 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932607Ab3DMPnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 11:43:14 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Yinghai Lu <yinghai@kernel.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, David Rientjes <rientjes@google.com>,
        Wen Congyang <wency@cn.fujitsu.com>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, David Howells <dhowells@redhat.com>,
        Mark Salter <msalter@redhat.com>, Jianguo Wu <wujianguo@huawei.com>,
        linux-mm@kvack.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michal Simek <monstr@monstr.eu>,
        microblaze-uclinux@itee.uq.edu.au
Subject: [RFC PATCH v1 14/19] mm/microblaze: clean up unused VALID_PAGE()
Date: Sat, 13 Apr 2013 23:36:34 +0800
Message-Id: <1365867399-21323-15-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1365867399-21323-1-git-send-email-jiang.liu@huawei.com>
References: <1365867399-21323-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

VALID_PAGE() has been removed from kernel long time ago, so clean up it.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Michal Simek <monstr@monstr.eu>
Cc: microblaze-uclinux@itee.uq.edu.au
Cc: linux-kernel@vger.kernel.org
---
 arch/microblaze/include/asm/page.h |    1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/microblaze/include/asm/page.h b/arch/microblaze/include/asm/page.h
index 85a5ae8..fd85087 100644
--- a/arch/microblaze/include/asm/page.h
+++ b/arch/microblaze/include/asm/page.h
@@ -168,7 +168,6 @@ extern int page_is_ram(unsigned long pfn);
 #  else /* CONFIG_MMU */
 #  define ARCH_PFN_OFFSET	(memory_start >> PAGE_SHIFT)
 #  define pfn_valid(pfn)	((pfn) < (max_mapnr + ARCH_PFN_OFFSET))
-#  define VALID_PAGE(page) 	((page - mem_map) < max_mapnr)
 #  endif /* CONFIG_MMU */
 
 # endif /* __ASSEMBLY__ */
-- 
1.7.9.5

