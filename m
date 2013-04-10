Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936670Ab3DJA1M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 20:27:12 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:36197 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935205Ab3DJA1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 20:27:09 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Bob Liu <bob.liu@oracle.com>, Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH 09/10] staging: zcache/debug: fix coding style
Date: Wed, 10 Apr 2013 08:25:59 +0800
Message-Id: <1365553560-32258-10-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1365553560-32258-1-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1365553560-32258-1-git-send-email-liwanp@linux.vnet.ibm.com>
x-cbid: 13041000-5140-0000-0000-00000301275A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix coding style issue: ERROR: space prohibited before that '++' (ctx:WxO)

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 drivers/staging/zcache/debug.h |   36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/zcache/debug.h b/drivers/staging/zcache/debug.h
index ddad92f..08c9c7b5 100644
--- a/drivers/staging/zcache/debug.h
+++ b/drivers/staging/zcache/debug.h
@@ -174,26 +174,26 @@ extern ssize_t zcache_writtenback_pages;
 extern ssize_t zcache_outstanding_writeback_pages;
 #endif
 
-static inline void inc_zcache_flush_total(void) { zcache_flush_total ++; };
-static inline void inc_zcache_flush_found(void) { zcache_flush_found ++; };
-static inline void inc_zcache_flobj_total(void) { zcache_flobj_total ++; };
-static inline void inc_zcache_flobj_found(void) { zcache_flobj_found ++; };
-static inline void inc_zcache_failed_eph_puts(void) { zcach.e_failed_eph_puts ++; };
-static inline void inc_zcache_failed_pers_puts(void) { zcache_failed_pers_puts ++; };
-static inline void inc_zcache_failed_getfreepages(void) { zcache_failed_getfreepages ++; };
-static inline void inc_zcache_failed_alloc(void) { zcache_failed_alloc ++; };
-static inline void inc_zcache_put_to_flush(void) { zcache_put_to_flush ++; };
-static inline void inc_zcache_compress_poor(void) { zcache_compress_poor ++; };
-static inline void inc_zcache_mean_compress_poor(void) { zcache_mean_compress_poor ++; };
-static inline void inc_zcache_eph_ate_tail(void) { zcache_eph_ate_tail ++; };
-static inline void inc_zcache_eph_ate_tail_failed(void) { zcache_eph_ate_tail_failed ++; };
-static inline void inc_zcache_pers_ate_eph(void) { zcache_pers_ate_eph ++; };
-static inline void inc_zcache_pers_ate_eph_failed(void) { zcache_pers_ate_eph_failed ++; };
+static inline void inc_zcache_flush_total(void) { zcache_flush_total++; };
+static inline void inc_zcache_flush_found(void) { zcache_flush_found++; };
+static inline void inc_zcache_flobj_total(void) { zcache_flobj_total++; };
+static inline void inc_zcache_flobj_found(void) { zcache_flobj_found++; };
+static inline void inc_zcache_failed_eph_puts(void) { zcache_failed_eph_puts++; };
+static inline void inc_zcache_failed_pers_puts(void) { zcache_failed_pers_puts++; };
+static inline void inc_zcache_failed_getfreepages(void) { zcache_failed_getfreepages++; };
+static inline void inc_zcache_failed_alloc(void) { zcache_failed_alloc++; };
+static inline void inc_zcache_put_to_flush(void) { zcache_put_to_flush++; };
+static inline void inc_zcache_compress_poor(void) { zcache_compress_poor++; };
+static inline void inc_zcache_mean_compress_poor(void) { zcache_mean_compress_poor++; };
+static inline void inc_zcache_eph_ate_tail(void) { zcache_eph_ate_tail++; };
+static inline void inc_zcache_eph_ate_tail_failed(void) { zcache_eph_ate_tail_failed++; };
+static inline void inc_zcache_pers_ate_eph(void) { zcache_pers_ate_eph++; };
+static inline void inc_zcache_pers_ate_eph_failed(void) { zcache_pers_ate_eph_failed++; };
 static inline void inc_zcache_evicted_eph_zpages(unsigned zpages) { zcache_evicted_eph_zpages += zpages; };
-static inline void inc_zcache_evicted_eph_pageframes(void) { zcache_evicted_eph_pageframes ++; };
+static inline void inc_zcache_evicted_eph_pageframes(void) { zcache_evicted_eph_pageframes++; };
 
-static inline void inc_zcache_eph_nonactive_puts_ignored(void) { zcache_eph_nonactive_puts_ignored ++; };
-static inline void inc_zcache_pers_nonactive_puts_ignored(void) { zcache_pers_nonactive_puts_ignored ++; };
+static inline void inc_zcache_eph_nonactive_puts_ignored(void) { zcache_eph_nonactive_puts_ignored++; };
+static inline void inc_zcache_pers_nonactive_puts_ignored(void) { zcache_pers_nonactive_puts_ignored++; };
 
 int zcache_debugfs_init(void);
 #else
-- 
1.7.10.4

