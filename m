Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755706Ab3KXDwV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 22:52:21 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:52037 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539Ab3KXDwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 22:52:19 -0500
X-AuditID: cbfee691-b7f666d0000048b0-e5-529177f11098
Message-id: <1385265084.26319.90.camel@kjgkr>
Subject: Re: [f2fs-dev] [PATCH 2/2] f2fs: adds a tracepoint for
 f2fs_submit_read_bio
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Chao Yu <chao2.yu@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        =?UTF-8?Q?=E8=B0=AD=E5=A7=9D?= <shu.tan@samsung.com>
Date: Sun, 24 Nov 2013 12:51:24 +0900
In-reply-to: <001f01cee5cc$5d297450$177c5cf0$@samsung.com>
References: <001f01cee5cc$5d297450$177c5cf0$@samsung.com>
Organization: Samsung
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIIsWRmVeSWpSXmKPExsVy+t8zQ92P5RODDFbdkLX43/SRzeLSIneL
	PXtPslhc3jWHzaJ14XlmB1aP3Qs+M3n0bVnF6PF5k1wAcxSXTUpqTmZZapG+XQJXxrY7CxgL
	upUqLr7/wNjA2CzdxcjJISFgIrF2wS5GCFtM4sK99WxdjFwcQgLLGCV2TWpj7WLkACvaOlUD
	Ij6dUeJ77zQWCOcVo8SiRY9YQbp5BXQl9l+fxgxiCwuESUzZsYYNpJlNQFti834DkLCQgKLE
	2/13wcpFBJQkfs1fxAoyh1lgIaPEwQU32UASLAKqEhs754HN4RSwkvg3+yUrRLOlRPeb62CX
	8guIShxeuB2shllAXWLSvEXMEB8oSexu72SHiMtLbF7zlhniNkGJH5PvgR0tIXCOXeLjkT4W
	iGUCEt8mH2KB+FJWYtMBqDmSEgdX3GCZwCgxC8mKWUjGzkIydgEj8ypG0dSC5ILipPQiU73i
	xNzi0rx0veT83E2MkOibuIPx/gHrQ4zJQCsnMkuJJucDozevJN7Q2MzIwtTE1NjI3NKMNGEl
	cd70R0lBQgLpiSWp2ampBalF8UWlOanFhxiZODilGhiVJ525zrTqbgFn8FyvnJ8VkjuqdR8r
	dXxZ8cCdNaV/Qp6eVr504kRxyZzfHuXyB95MO+7U9LGp4oG43fzb7jdSf3/2TH0p6jVRwq8z
	b5ML383JuQF/ci5kMzt0L3/AfsN3zbO8tzc1oi8cZvKQbbFJYM5WKpVV6Fqi0pspvOl+3b6E
	+84svkosxRmJhlrMRcWJAGcOq3TUAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHKsWRmVeSWpSXmKPExsVy+t9jQd2P5RODDOb2S1r8b/rIZnFpkbvF
	nr0nWSwu75rDZtG68DyzA6vH7gWfmTz6tqxi9Pi8SS6AOaqB0SYjNTEltUghNS85PyUzL91W
	yTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaKWSQlliTilQKCCxuFhJ3w7ThNAQN10L
	mMYIXd+QILgeIwM0kLCOMWPbnQWMBd1KFRfff2BsYGyW7mLk4JAQMJHYOlWji5ETyBSTuHBv
	PVsXIxeHkMB0RonvvdNYIJxXjBKLFj1iBaniFdCV2H99GjOILSwQJjFlxxo2kEFsAtoSm/cb
	gISFBBQl3u6/C1YuIqAk8Wv+IlaQOcwCCxklDi64yQaSYBFQldjYOQ9sDqeAlcS/2S9ZIZot
	JbrfXGcEsfkFRCUOL9wOVsMsoC4xad4iZohLlSR2t3eyQ8TlJTavecsMcZugxI/J91gmMArN
	QtIyC0nZLCRlCxiZVzGKphYkFxQnpeca6RUn5haX5qXrJefnbmIEx/Yz6R2MqxosDjEKcDAq
	8fA2Ok4MEmJNLCuuzD3EKMHBrCTC2xUPFOJNSaysSi3Kjy8qzUktPsSYDPTdRGYp0eR8YNrJ
	K4k3NDYxM7I0MrMwMjE3J01YSZz3YKt1oJBAemJJanZqakFqEcwWJg5OqQbGWibWvGmsK5vj
	Wno4u82KUk5Hr8r4XLBL8/Az3b135JXP5h2887Vd1NFsXtCVKXxthSXeSpXT+27UrGE1z1jg
	EBgelJz6ZgK3+sMZ2Zf/5PBfnrT/seSp1xdDPH5/2HjKp3p6xRsxniezNn892LPG7cXTjEs+
	3krrTxZPWegQedRKvsbiRF+PEktxRqKhFnNRcSIASJOZcTEDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Again, this tracepoint alos can be integrated with write_bios like this.


>From e0360910b24624e40d92eb2e1949914339b83881 Mon Sep 17 00:00:00 2001
From: Chao Yu <chao2.yu@samsung.com>
Date: Sun, 24 Nov 2013 12:36:42 +0900
Subject: [PATCH] f2fs: adds a tracepoint for f2fs_submit_read_bio

This patch adds a tracepoint for f2fs_submit_read_bio.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
[Jaegeuk Kim: integrate tracepoints of f2fs_submit_read(_write)_bio]
Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/data.c              |  2 ++
 fs/f2fs/segment.c           |  5 +++--
 include/trace/events/f2fs.h | 49
+++++++++++++++++++++++++++++----------------
 3 files changed, 37 insertions(+), 19 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index cdb342e..7117220 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -421,6 +421,8 @@ void f2fs_submit_read_bio(struct f2fs_sb_info *sbi,
int rw)
 	if (!io->bio)
 		return;
 
+	trace_f2fs_submit_read_bio(sbi->sb, rw, META, io->bio);
+
 	mutex_lock(&io->io_mutex);
 	if (io->bio) {
 		submit_bio(rw, io->bio);
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 264a5ff..3aad374 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -846,6 +846,9 @@ static void do_submit_bio(struct f2fs_sb_info *sbi,
 
 	if (type >= META_FLUSH)
 		rw = WRITE_FLUSH_FUA;
+
+	trace_f2fs_submit_write_bio(sbi->sb, rw, btype, io->bio);
+
 	if (btype == META)
 		rw |= REQ_META;
 
@@ -853,8 +856,6 @@ static void do_submit_bio(struct f2fs_sb_info *sbi,
 	p->sbi = sbi;
 	io->bio->bi_end_io = f2fs_end_io_write;
 
-	trace_f2fs_do_submit_bio(sbi->sb, btype, sync, io->bio);
-
 	if (type == META_FLUSH) {
 		DECLARE_COMPLETION_ONSTACK(wait);
 		p->is_sync = true;
diff --git a/include/trace/events/f2fs.h b/include/trace/events/f2fs.h
index 73cc5f0..1f59f5d 100644
--- a/include/trace/events/f2fs.h
+++ b/include/trace/events/f2fs.h
@@ -18,13 +18,14 @@
 
 #define show_bio_type(type)						\
 	__print_symbolic(type,						\
-		{ READ, 	"READ" },				\
-		{ READA, 	"READAHEAD" },				\
-		{ READ_SYNC, 	"READ_SYNC" },				\
-		{ WRITE, 	"WRITE" },				\
-		{ WRITE_SYNC, 	"WRITE_SYNC" },				\
-		{ WRITE_FLUSH,	"WRITE_FLUSH" },			\
-		{ WRITE_FUA, 	"WRITE_FUA" })
+		{ READ, 		"READ" },			\
+		{ READA, 		"READAHEAD" },			\
+		{ READ_SYNC, 		"READ_SYNC" },			\
+		{ WRITE, 		"WRITE" },			\
+		{ WRITE_SYNC, 		"WRITE_SYNC" },			\
+		{ WRITE_FLUSH,		"WRITE_FLUSH" },		\
+		{ WRITE_FUA, 		"WRITE_FUA" },			\
+		{ WRITE_FLUSH_FUA,	"WRITE_FLUSH_FUA" })
 
 #define show_data_type(type)						\
 	__print_symbolic(type,						\
@@ -598,36 +599,50 @@ TRACE_EVENT(f2fs_reserve_new_block,
 		__entry->ofs_in_node)
 );
 
-TRACE_EVENT(f2fs_do_submit_bio,
+DECLARE_EVENT_CLASS(f2fs__submit_bio,
 
-	TP_PROTO(struct super_block *sb, int btype, bool sync, struct bio
*bio),
+	TP_PROTO(struct super_block *sb, int rw, int type, struct bio *bio),
 
-	TP_ARGS(sb, btype, sync, bio),
+	TP_ARGS(sb, rw, type, bio),
 
 	TP_STRUCT__entry(
 		__field(dev_t,	dev)
-		__field(int,	btype)
-		__field(bool,	sync)
+		__field(int,	rw)
+		__field(int,	type)
 		__field(sector_t,	sector)
 		__field(unsigned int,	size)
 	),
 
 	TP_fast_assign(
 		__entry->dev		= sb->s_dev;
-		__entry->btype		= btype;
-		__entry->sync		= sync;
+		__entry->rw		= rw;
+		__entry->type		= type;
 		__entry->sector		= bio->bi_sector;
 		__entry->size		= bio->bi_size;
 	),
 
-	TP_printk("dev = (%d,%d), type = %s, io = %s, sector = %lld, size = %
u",
+	TP_printk("dev = (%d,%d), %s, %s, sector = %lld, size = %u",
 		show_dev(__entry),
-		show_block_type(__entry->btype),
-		__entry->sync ? "sync" : "no sync",
+		show_bio_type(__entry->rw),
+		show_block_type(__entry->type),
 		(unsigned long long)__entry->sector,
 		__entry->size)
 );
 
+DEFINE_EVENT(f2fs__submit_bio, f2fs_submit_write_bio,
+
+	TP_PROTO(struct super_block *sb, int rw, int type, struct bio *bio),
+
+	TP_ARGS(sb, rw, type, bio)
+);
+
+DEFINE_EVENT(f2fs__submit_bio, f2fs_submit_read_bio,
+
+	TP_PROTO(struct super_block *sb, int rw, int type, struct bio *bio),
+
+	TP_ARGS(sb, rw, type, bio)
+);
+
 DECLARE_EVENT_CLASS(f2fs__page,
 
 	TP_PROTO(struct page *page, int type),
-- 
1.8.4.474.g128a96c



-- 
Jaegeuk Kim
Samsung

