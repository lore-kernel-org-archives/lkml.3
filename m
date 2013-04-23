Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937Ab3DWKlc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 06:41:32 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:26548 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755888Ab3DWKl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 06:41:29 -0400
X-AuditID: cbfee68e-b7f0d6d0000053ce-e0-51766558657a
Message-id: <1366713631.31792.15.camel@kjgkr>
Subject: Re: [PATCH v4 6/7] f2fs: add tracepoints for write page operations
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: rostedt@goodmis.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Pankaj Kumar <pankaj.km@samsung.com>
Date: Tue, 23 Apr 2013 19:40:31 +0900
In-reply-to: <1366388998-18983-1-git-send-email-linkinjeon@gmail.com>
References: <1366388998-18983-1-git-send-email-linkinjeon@gmail.com>
Organization: samsung
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary="=-nQLx5z6CguMWGgKOfytf"
X-Mailer: Evolution 3.2.3-0ubuntu6
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplleLIzCtJLcpLzFFi42I5/e+ZgW5EalmgwcO7ShbX795itri0yN1i
	z96TLBaXd81hs/gxvd7ix67zzBb7Oh4wObB77Jx1l92jZd8tdo/dCz4zefRtWcXo8XmTXABr
	FJdNSmpOZllqkb5dAlfG/Q9HGAv+a1YsnnOMvYHxgHIXIyeHhICJxNNt29khbDGJC/fWs3Ux
	cnEICSxjlJjx/Tk7TFHr8xksEInpjBJvG6cxQTivGSUa/vxiBKniFdCVOHWqC6iKg0NYwFvi
	0ds8EJNNQFti834DkAohAUWJt/vvsoKERQTUJCY8SwWZwixwllHi37wmsCksAqoS35cdYwKx
	OQVcJZ5PPM0K0esisWHKKxYQm19AVOJk6yewemaBKokXU86yQtypJLG7vZMd4hpBiR+T77FA
	xBdySLycxwcxX0Di2+RDYFdKCMhKbDrADFEiKXFwxQ2WCYzis5BMnYVkEkRcU6J1+292CFtb
	YtnC18wQtq3EunXvoWpsJDZdXcAIYctLbH87h3kBI/sqRtHUguSC4qT0IiO94sTc4tK8dL3k
	/NxNjJA479vBePOA9SHGKqATJzJLiSbnA9NEXkm8obGZkYWpiamxkbmlGVWElcR51VqsA4UE
	0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUwGgv/cwnbuWpHsivbKxZRXs6PFbpcorv7riwTSzxu
	bXu6tuVS+P7IhR8KQyaxrZbjKL0aV+jY/+nvgf9X/Oe8WbDYOTy0dMaT6Zszyg696Vz2R3OO
	xovf6eyf+QsKIhe8yU30PLtrvZ+Pb8HNa4yqG6/2MV2pfc4//QTbcv5ayUSx4sU7NR3nKbEU
	ZyQaajEXFScCAOFqPTYgAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnk+LIzCtJLcpLzFFi42I5/e+xoG5EalmgwawlshbX795itri0yN1i
	z96TLBaXd81hs/gxvd7ix67zzBb7Oh4wObB77Jx1l92jZd8tdo/dCz4zefRtWcXo8XmTXABr
	VAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QFUoK
	ZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjPsfjjAW/NesWDznGHsD4wHl
	LkZODgkBE4nW5zNYIGwxiQv31rN1MXJxCAlMZ5R42ziNCcJ5zSjR8OcXI0gVr4CuxKlTXUAd
	HBzCAt4Sj97mgZhsAtoSm/cbgFQICShKvN1/lxUkLCKgJjHhWSrIFGaBs4wS/+Y1gU1hEVCV
	+L7sGBOIzSngKvF84mlWiF4XiQ1TXoHdwy8gKnGy9RNYPbNAlcSLKWdZIe5Uktjd3skOcY2g
	xI/J91gmMArOQlI2C0kKIq4p0br9NzuErS2xbOFrZgjbVmLduvdQNTYSm64uYISw5SW2v53D
	vICRfRWjaGpBckFxUnquoV5xYm5xaV66XnJ+7iZGcBp5JrWDcWWDxSFGAQ5GJR5eAffSQCHW
	xLLiytxDjCpAcx5tWH2BUYolLz8vVUmE95pUWaAQb0piZVVqUX58UWlOavEhxomMwOCYyCwl
	mpwPTH55JfGGxiZmRpZGZhZGJubmtBRWEuc90GodKCSQnliSmp2aWpBaBHMUEwenVANj1tVb
	WmK1vzqauzs+C86+9iYp/5nW7p9aRccYz/2Z8yhj6+EpJfd0suMcjePX15W/r3VNe8Hr76/+
	6uPUhmiHpacPxKwuerF2teDlJt3ow70NCSfjPJ0YRJc6ph/h4FTZll8vVP7Mf3rwr48HD1/e
	q/Dm/5vIDxv31nnZn/+ydxP322Mxz7YfVWIpzkg01GIuKk4EAJf4XluiAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-nQLx5z6CguMWGgKOfytf
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

=46rom 6ec178dac6768204a6edf70f4a53d40b691c12b4 Mon Sep 17 00:00:00 2001
From: Namjae Jeon <namjae.jeon@samsung.com>
Date: Tue, 23 Apr 2013 17:51:43 +0900
Subject: [PATCH 6/7] f2fs: add tracepoints for write page operations
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
linux-f2fs-devel@lists.sourceforge.net

Add tracepoints to debug the various page write operation
like data pages, meta pages.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Pankaj Kumar <pankaj.km@samsung.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
[Jaegeuk: remove unnecessary tracepoints]
Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/segment.c           |  5 ++++
 include/trace/events/f2fs.h | 67
+++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 72 insertions(+)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 7c67ec2..0a65284 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -18,6 +18,7 @@
 #include "f2fs.h"
 #include "segment.h"
 #include "node.h"
+#include <trace/events/f2fs.h>
=20
 /*
  * This function balances dirty node and dentry pages.
@@ -691,6 +692,9 @@ static void do_submit_bio(struct f2fs_sb_info *sbi,
 		struct bio_private *p =3D sbi->bio[btype]->bi_private;
 		p->sbi =3D sbi;
 		sbi->bio[btype]->bi_end_io =3D f2fs_end_io_write;
+
+		trace_f2fs_do_submit_bio(sbi->sb, btype, sync, sbi->bio[btype]);
+
 		if (type =3D=3D META_FLUSH) {
 			DECLARE_COMPLETION_ONSTACK(wait);
 			p->is_sync =3D true;
@@ -745,6 +749,7 @@ alloc_new:
 	sbi->last_block_in_bio[type] =3D blk_addr;
=20
 	up_write(&sbi->bio_sem);
+	trace_f2fs_submit_write_page(page, blk_addr, type);
 }
=20
 static bool __has_curseg_space(struct f2fs_sb_info *sbi, int type)
diff --git a/include/trace/events/f2fs.h b/include/trace/events/f2fs.h
index 56b6240..ae2da92 100644
--- a/include/trace/events/f2fs.h
+++ b/include/trace/events/f2fs.h
@@ -8,6 +8,14 @@
=20
 #define show_dev(entry)		MAJOR(entry->dev), MINOR(entry->dev)
 #define show_dev_ino(entry)	show_dev(entry), (unsigned long)entry->ino
+
+#define show_block_type(type)						\
+	__print_symbolic(type,						\
+		{ NODE,		"NODE" },				\
+		{ DATA,		"DATA" },				\
+		{ META,		"META" },				\
+		{ META_FLUSH,	"META_FLUSH" })
+
 #define show_bio_type(type)						\
 	__print_symbolic(type,						\
 		{ READ, 	"READ" },				\
@@ -578,6 +586,65 @@ TRACE_EVENT(f2fs_reserve_new_block,
 		__entry->ofs_in_node)
 );
=20
+TRACE_EVENT(f2fs_do_submit_bio,
+
+	TP_PROTO(struct super_block *sb, int btype, bool sync, struct bio
*bio),
+
+	TP_ARGS(sb, btype, sync, bio),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(int,	btype)
+		__field(bool,	sync)
+		__field(sector_t,	sector)
+		__field(unsigned int,	size)
+	),
+
+	TP_fast_assign(
+		__entry->dev		=3D sb->s_dev;
+		__entry->btype		=3D btype;
+		__entry->sync		=3D sync;
+		__entry->sector		=3D bio->bi_sector;
+		__entry->size		=3D bio->bi_size;
+	),
+
+	TP_printk("dev =3D (%d,%d), type =3D %s, io =3D %s, sector =3D %lld, size=
 =3D %
u",
+		show_dev(__entry),
+		show_block_type(__entry->btype),
+		__entry->sync ? "sync" : "no sync",
+		(unsigned long long)__entry->sector,
+		__entry->size)
+);
+
+TRACE_EVENT(f2fs_submit_write_page,
+
+	TP_PROTO(struct page *page, block_t blk_addr, int type),
+
+	TP_ARGS(page, blk_addr, type),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(ino_t,	ino)
+		__field(int, type)
+		__field(pgoff_t, index)
+		__field(block_t, block)
+	),
+
+	TP_fast_assign(
+		__entry->dev	=3D page->mapping->host->i_sb->s_dev;
+		__entry->ino	=3D page->mapping->host->i_ino;
+		__entry->type	=3D type;
+		__entry->index	=3D page->index;
+		__entry->block	=3D blk_addr;
+	),
+
+	TP_printk("dev =3D (%d,%d), ino =3D %lu, %s, index =3D %lu, blkaddr =3D 0=
x%
llx",
+		show_dev_ino(__entry),
+		show_block_type(__entry->type),
+		(unsigned long)__entry->index,
+		(unsigned long long)__entry->block)
+);
+
 #endif /* _TRACE_F2FS_H */
=20
  /* This part must be outside protection */
--=20
1.8.1.3.566.gaa39828



--=20
Jaegeuk Kim
Samsung

--=-nQLx5z6CguMWGgKOfytf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJRdmUfAAoJEEAUqH6CSFDSQsoP/jp4HaAMyckJHKPDCf/1nYoV
WqITfPx7JQXXijiUa3krlQX027/oPkopuUteWQu5Kfl1Q6iUSPXgs/XCTbrN3czy
FYYiQF5YjrbhN6HWpJpefXwoms2yF/2H/sQs8gHZy/KBJjynTWJAU+OED9hiZB/R
1nrLFfbMS2LW6hFBz+YbpUrJZzO7mAg1kMX9CaUNSCJ//yn9dPnyQ7QjSN8gyimS
RlMxHMzLRS5JeWUjfUFgBJHTwdWzEbAbP00k9qLw9NxV17JJzb0PQJa9DTgfr8W6
epjol5k1ztd0EO6fymSSUJRI1tptbkJ57LsAFsdn0Ne5aPrUG+unhENoEjK3yOAy
1HupAggLP9aGQe875ujvjydS3wl9/YsFKmPyRtZJJwEPt5nsP0/KhYf09MS0LwVB
lbz92DavY3cOBAu/k46ex1kg9eB5dLfLfVRD+CAcMf5ecgm+1nNO6cmsezMkzUsD
rby3Nx0h1nxaEFPi92azbLi8ARVR2T0M/LeU8q6EV9KZM5s3+GbINiirV9UW9KAG
z0SIA3lpw4tkY87F0IsCf/cjXKoa6UbrPwSdbg6ASd1j5p0Gb/Hugkta3QLfMa1N
RbAUcJhvROu+WtFHItsyHJLRWd7QLGT4sPmRhMvYii7mIsRxLAHQBItAp6gv35RY
tVijnG4lyG37dWhHuWub
=wAFP
-----END PGP SIGNATURE-----

--=-nQLx5z6CguMWGgKOfytf--

