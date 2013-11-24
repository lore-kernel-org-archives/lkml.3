Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756465Ab3KXDJw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 22:09:52 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:42122 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755991Ab3KXDJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 22:09:48 -0500
X-AuditID: cbfee68f-b7f336d00000481b-1d-52916dfa94e0
Message-id: <1385262534.26319.88.camel@kjgkr>
Subject: Re: [f2fs-dev] [PATCH 1/2] f2fs: adds a tracepoint for submit_read_page
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Chao Yu <chao2.yu@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        =?UTF-8?Q?=E8=B0=AD=E5=A7=9D?= <shu.tan@samsung.com>
Date: Sun, 24 Nov 2013 12:08:54 +0900
In-reply-to: <001e01cee5cc$3d118310$b7348930$@samsung.com>
References: <001e01cee5cc$3d118310$b7348930$@samsung.com>
Organization: Samsung
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAIsWRmVeSWpSXmKPExsVy+t8zfd3fuRODDJaqWfxv+shmcWmRu8We
	vSdZLC7vmsNm0brwPLMDq8fuBZ+ZPPq2rGL0+LxJLoA5issmJTUnsyy1SN8ugSvjyEWvggeS
	Fc1LrrI2MC4Q7WLk5JAQMJHY9/k8O4QtJnHh3nq2LkYuDiGBZYwSPU8a2GCK3j08xgqRWMQo
	sbP5KDOE84pR4uO/7WDtvAK6EtNvPwTrEBYIkPjU8Yqpi5GDg01AW2LzfgOQsJCAosTb/XdZ
	QWwRASWJX/MXgQ1lFljIKHFwwU2wXhYBVYlPE2+DFXEKWEnsmTuZDaLZUmLFl/VgcX4BUYnD
	C7czg9jMAuoSk+YtYoa4VElid3snO0RcXmLzmrfMELcJSvyYfI8FZJmEwDl2iWcH/jJDLBOQ
	+Db5EAvIoRICshKbDkDNkZQ4uOIGywRGiVlIVsxCMnYWkrELGJlXMYqmFiQXFCelFxnrFSfm
	Fpfmpesl5+duYoTEXv8OxrsHrA8xJgOtnMgsJZqcD4zdvJJ4Q2MzIwtTE1NjI3NLM9KElcR5
	7z9MChISSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAuN/szDzOnDj/+V/bOGd/XTTH5pjx4xeu
	xxgVZPaxrdD9dO34q7AQp6bJs5pYor+bn1n3505S2muba3NM95zh4zx1ZKFqjMeiYJfwI4en
	qWvbvBFR4n4X0rN9bdf1fb+7/Z9dC2n5yqFmu7Swckm+yvyr+3wlzjEL/zQsE/kWIrVggsDh
	VbtuCSqxFGckGmoxFxUnAgCL3AwG0wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHKsWRmVeSWpSXmKPExsVy+t9jAd1fuRODDJ4ctrD43/SRzeLSIneL
	PXtPslhc3jWHzaJ14XlmB1aP3Qs+M3n0bVnF6PF5k1wAc1QDo01GamJKapFCal5yfkpmXrqt
	kndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0EolhbLEnFKgUEBicbGSvh2mCaEhbroW
	MI0Rur4hQXA9RgZoIGEdY8aRi14FDyQrmpdcZW1gXCDaxcjJISFgIvHu4TFWCFtM4sK99Wxd
	jFwcQgKLGCV2Nh9lhnBeMUp8/LedHaSKV0BXYvrth2wgtrBAgMSnjldMXYwcHGwC2hKb9xuA
	hIUEFCXe7r8LNlREQEni1/xFrCBzmAUWMkocXHATrJdFQFXi08TbYEWcAlYSe+ZOZoNotpRY
	8WU9WJxfQFTi8MLtzCA2s4C6xKR5i5ghLlWS2N3eyQ4Rl5fYvOYtM8RtghI/Jt9jmcAoNAtJ
	yywkZbOQlC1gZF7FKJpakFxQnJSea6RXnJhbXJqXrpecn7uJERzbz6R3MK5qsDjEKMDBqMTD
	2+g4MUiINbGsuDL3EKMEB7OSCG9XPFCINyWxsiq1KD++qDQntfgQYzLQdxOZpUST84FpJ68k
	3tDYxMzI0sjMwsjE3Jw0YSVx3oOt1oFCAumJJanZqakFqUUwW5g4OKUaGM3t/NVmLL+/le37
	4pVbK+LVvxadf8peujlpw1emFo63U5fKdVyfMfd+ydo932ZwJxbc+aORbbbj19QVa5K/Xqu6
	MO1nw7fU/BtfLk2yen1hz0uh+puv80RFrh1J6JRTvJUrsOFyYse6i+9jPR59+GmUdHV6zycx
	U3HXN6tDWJ7e28oowPSS6bqpEktxRqKhFnNRcSIAelGesjEDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

We need to avoid redundancy as much as possible.
So, how about this patch?

>From 7b4a4f1628a1a793942c7f675e6afecece64b659 Mon Sep 17 00:00:00 2001
From: Chao Yu <chao2.yu@samsung.com>
Date: Wed, 20 Nov 2013 16:40:10 +0800
Subject: [PATCH] f2fs: adds a tracepoint for submit_read_page

This patch adds a tracepoint for submit_read_page.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
[Jaegeuk Kim: integrate tracepoints of f2fs_submit_read(_write)_page]
Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/data.c              |  1 +
 fs/f2fs/segment.c           |  2 +-
 include/trace/events/f2fs.h | 25 +++++++++++++++++++++----
 3 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index ce3cbd9..cdb342e 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -462,6 +462,7 @@ alloc_new:
 	io->last_block_in_bio = blk_addr;
 
 	mutex_unlock(&io->io_mutex);
+	trace_f2fs_submit_read_page(page, rw, META, blk_addr);
 }
 
 /*
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 9607cc4..264a5ff 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -925,7 +925,7 @@ retry:
 	io->last_block_in_bio = blk_addr;
 
 	mutex_unlock(&io->io_mutex);
-	trace_f2fs_submit_write_page(page, blk_addr, type);
+	trace_f2fs_submit_write_page(page, WRITE, type, blk_addr);
 }
 
 void f2fs_wait_on_page_writeback(struct page *page,
diff --git a/include/trace/events/f2fs.h b/include/trace/events/f2fs.h
index 47ee70d..73cc5f0 100644
--- a/include/trace/events/f2fs.h
+++ b/include/trace/events/f2fs.h
@@ -674,15 +674,16 @@ DEFINE_EVENT(f2fs__page, f2fs_vm_page_mkwrite,
 	TP_ARGS(page, type)
 );
 
-TRACE_EVENT(f2fs_submit_write_page,
+DECLARE_EVENT_CLASS(f2fs_io_page,
 
-	TP_PROTO(struct page *page, block_t blk_addr, int type),
+	TP_PROTO(struct page *page, int rw, int type, block_t blk_addr),
 
-	TP_ARGS(page, blk_addr, type),
+	TP_ARGS(page, rw, type, blk_addr),
 
 	TP_STRUCT__entry(
 		__field(dev_t,	dev)
 		__field(ino_t,	ino)
+		__field(int, rw)
 		__field(int, type)
 		__field(pgoff_t, index)
 		__field(block_t, block)
@@ -691,18 +692,34 @@ TRACE_EVENT(f2fs_submit_write_page,
 	TP_fast_assign(
 		__entry->dev	= page->mapping->host->i_sb->s_dev;
 		__entry->ino	= page->mapping->host->i_ino;
+		__entry->rw	= rw;
 		__entry->type	= type;
 		__entry->index	= page->index;
 		__entry->block	= blk_addr;
 	),
 
-	TP_printk("dev = (%d,%d), ino = %lu, %s, index = %lu, blkaddr = 0x%
llx",
+	TP_printk("dev = (%d,%d), ino = %lu, %s, %s, index = %lu, blkaddr = 0x
%llx",
 		show_dev_ino(__entry),
+		show_bio_type(__entry->rw),
 		show_block_type(__entry->type),
 		(unsigned long)__entry->index,
 		(unsigned long long)__entry->block)
 );
 
+DEFINE_EVENT(f2fs_io_page, f2fs_submit_write_page,
+
+	TP_PROTO(struct page *page, int rw, int type, block_t blk_addr),
+
+	TP_ARGS(page, rw, type, blk_addr)
+);
+
+DEFINE_EVENT(f2fs_io_page, f2fs_submit_read_page,
+
+	TP_PROTO(struct page *page, int rw, int type, block_t blk_addr),
+
+	TP_ARGS(page, rw, type, blk_addr)
+);
+
 TRACE_EVENT(f2fs_write_checkpoint,
 
 	TP_PROTO(struct super_block *sb, bool is_umount, char *msg),
-- 
1.8.4.474.g128a96c


-- 
Jaegeuk Kim
Samsung

