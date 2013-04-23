Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755617Ab3DWKkb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 06:40:31 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:56777 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085Ab3DWKk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 06:40:26 -0400
X-AuditID: cbfee690-b7f3c6d000001ab5-7d-5176651975d8
Message-id: <1366713568.31792.12.camel@kjgkr>
Subject: Re: [PATCH v4 3/7] f2fs: add tracepoint for tracing the page i/o
 operations
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: rostedt@goodmis.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Pankaj Kumar <pankaj.km@samsung.com>
Date: Tue, 23 Apr 2013 19:39:28 +0900
In-reply-to: <1366388945-18881-1-git-send-email-linkinjeon@gmail.com>
References: <1366388945-18881-1-git-send-email-linkinjeon@gmail.com>
Organization: samsung
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary="=-aGLJJhMRE5Eh5l0KSn95"
X-Mailer: Evolution 3.2.3-0ubuntu6
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjleLIzCtJLcpLzFFi42I5/e+Zga5kalmgwefbGhbX795itri0yN1i
	z96TLBaXd81hs/gxvd7ix67zzBb7Oh4wObB77Jx1l92jZd8tdo/dCz4zefRtWcXo8XmTXABr
	FJdNSmpOZllqkb5dAlfG8X1XWQq2GFZMalvK1sB4WLOLkZNDQsBE4tutAywQtpjEhXvr2boY
	uTiEBJYxSnzcdZEJpujAx39QiUWMEl+b97KBJIQEXjNK3NysC2LzCuhKzO46wg5iCwuEScxb
	v5y1i5GDg01AW2LzfgOIckWJt/vvgoVFBNQkJjxLBRnJLHCWUeLfvCZGkBoWAVWJPbt2M4PY
	nAKuEpP3H2OF6HWReHOhBewefgFRiZOtn8DqmQWqJN43vmCFuFNJYnd7JzvEOYISPybfYwFZ
	ICGwkENieVc/K8QCAYlvkw+xgBwhISArsekAM0SvpMTBFTdYJjCKz0IydhaSURBxTYnW7b/Z
	IWxtiWULXzND2LYS69a9h6qxkdh0dQEjhC0vsf3tHOYFjOyrGEVTC5ILipPSi0z0ihNzi0vz
	0vWS83M3MUIifcIOxnsHrA8xVgGdOJFZSjQ5H5go8kriDY3NjCxMTUyNjcwtzagirCTOq95i
	HSgkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qBcR3jP4F5bcVb14pwv2f6mKM58dXvEKlszR0y
	OSmJr95aLr4q0nDf/M+/4N9T3L7emmSTsniLSeFPL0tBVhWr25xvmJ9tcqwRfWbRIL39D1fm
	frkbM28wyx6OjbuzOmk+a1nOqcevVscxed+3O6Z1eV/S5SWfNm22frRUfuMsllyBinM1H2Jb
	vymxFGckGmoxFxUnAgB6Z/qUIQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnk+LIzCtJLcpLzFFi42I5/e+xgK5kalmgwaLzyhbX795itri0yN1i
	z96TLBaXd81hs/gxvd7ix67zzBb7Oh4wObB77Jx1l92jZd8tdo/dCz4zefRtWcXo8XmTXABr
	VAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QFUoK
	ZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjOP7rrIUbDGsmNS2lK2B8bBm
	FyMnh4SAicSBj//YIGwxiQv31gPZXBxCAosYJb427wVLCAm8ZpS4uVkXxOYV0JWY3XWEHcQW
	FgiTmLd+OWsXIwcHm4C2xOb9BhDlihJv998FC4sIqElMeJYKMpJZ4CyjxL95TYwgNSwCqhJ7
	du1mBrE5BVwlJu8/xgrR6yLx5kILE4jNLyAqcbL1E1g9s0CVxPvGF6wQdypJ7G7vZIc4R1Di
	x+R7LBMYBWchKZuFJAUR15Ro3f6bHcLWlli28DUzhG0rsW7de6gaG4lNVxcwQtjyEtvfzmFe
	wMi+ilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyM4jTyT3sG4qsHiEKMAB6MSD6+Ae2mgEGti
	WXFl7iFGFaA5jzasvsAoxZKXn5eqJMJ7TaosUIg3JbGyKrUoP76oNCe1+BDjREZgcExklhJN
	zgcmv7ySeENjEzMjSyMzCyMTc3NaCiuJ8x5stQ4UEkhPLEnNTk0tSC2COYqJg1OqgTHuk9Pb
	kw2OTy7ee7vfIGHycvvjszsV7tz6YFq+ZLF+ZO2Mvh/cFtkcr7QnVl887LWo515UhZ7HPYX9
	fkv0+P77fchlWPAvrvx+sNOKvsXW0XzxUioOprdCV76On1PFGdTg4NrBdMhBNJQnuurRZI/d
	x/9xTF4lx3Lqy5yZ6wtEsljcri9jkFdiKc5INNRiLipOBAD9rTnCogMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-aGLJJhMRE5Eh5l0KSn95
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

=46rom 848753aa3b19a6513315ca54f22ba1e2732ea94a Mon Sep 17 00:00:00 2001
From: Namjae Jeon <namjae.jeon@samsung.com>
Date: Tue, 23 Apr 2013 16:38:02 +0900
Subject: [PATCH 3/7] f2fs: add tracepoint for tracing the page i/o
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
linux-f2fs-devel@lists.sourceforge.net

Add tracepoints for page i/o operations and block allocation
tracing during page read operation.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Pankaj Kumar <pankaj.km@samsung.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
[Jaegeuk: combine and modify the tracepoint structures]
Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/data.c              | 12 ++++++--
 include/trace/events/f2fs.h | 74
+++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 84 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 3c31ec7..8e8b14d 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -21,6 +21,7 @@
 #include "f2fs.h"
 #include "node.h"
 #include "segment.h"
+#include <trace/events/f2fs.h>
=20
 /*
  * Lock ordering for the change of data block address:
@@ -348,6 +349,8 @@ int f2fs_readpage(struct f2fs_sb_info *sbi, struct
page *page,
 	struct block_device *bdev =3D sbi->sb->s_bdev;
 	struct bio *bio;
=20
+	trace_f2fs_readpage(page, blk_addr, type);
+
 	down_read(&sbi->bio_sem);
=20
 	/* Allocate a new bio */
@@ -388,14 +391,18 @@ static int get_data_block_ro(struct inode *inode,
sector_t iblock,
 	/* Get the page offset from the block offset(iblock) */
 	pgofs =3D	(pgoff_t)(iblock >> (PAGE_CACHE_SHIFT - blkbits));
=20
-	if (check_extent_cache(inode, pgofs, bh_result))
+	if (check_extent_cache(inode, pgofs, bh_result)) {
+		trace_f2fs_get_data_block(inode, iblock, bh_result, 0);
 		return 0;
+	}
=20
 	/* When reading holes, we need its node page */
 	set_new_dnode(&dn, inode, NULL, NULL, 0);
 	err =3D get_dnode_of_data(&dn, pgofs, LOOKUP_NODE_RA);
-	if (err)
+	if (err) {
+		trace_f2fs_get_data_block(inode, iblock, bh_result, err);
 		return (err =3D=3D -ENOENT) ? 0 : err;
+	}
=20
 	/* It does not support data allocation */
 	BUG_ON(create);
@@ -420,6 +427,7 @@ static int get_data_block_ro(struct inode *inode,
sector_t iblock,
 		bh_result->b_size =3D (i << blkbits);
 	}
 	f2fs_put_dnode(&dn);
+	trace_f2fs_get_data_block(inode, iblock, bh_result, 0);
 	return 0;
 }
=20
diff --git a/include/trace/events/f2fs.h b/include/trace/events/f2fs.h
index 4bbd19f..924e69a 100644
--- a/include/trace/events/f2fs.h
+++ b/include/trace/events/f2fs.h
@@ -8,6 +8,15 @@
=20
 #define show_dev(entry)		MAJOR(entry->dev), MINOR(entry->dev)
 #define show_dev_ino(entry)	show_dev(entry), (unsigned long)entry->ino
+#define show_bio_type(type)						\
+	__print_symbolic(type,						\
+		{ READ, 	"READ" },				\
+		{ READA, 	"READAHEAD" },				\
+		{ READ_SYNC, 	"READ_SYNC" },				\
+		{ WRITE, 	"WRITE" },				\
+		{ WRITE_SYNC, 	"WRITE_SYNC" },				\
+		{ WRITE_FLUSH,	"WRITE_FLUSH" },			\
+		{ WRITE_FUA, 	"WRITE_FUA" })
=20
 DECLARE_EVENT_CLASS(f2fs__inode,
=20
@@ -365,6 +374,71 @@ TRACE_EVENT(f2fs_truncate_partial_nodes,
 		__entry->err)
 );
=20
+TRACE_EVENT_CONDITION(f2fs_readpage,
+
+	TP_PROTO(struct page *page, sector_t blkaddr, int type),
+
+	TP_ARGS(page, blkaddr, type),
+
+	TP_CONDITION(page->mapping),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(ino_t,	ino)
+		__field(pgoff_t,	index)
+		__field(sector_t,	blkaddr)
+		__field(int,	type)
+	),
+
+	TP_fast_assign(
+		__entry->dev		=3D page->mapping->host->i_sb->s_dev;
+		__entry->ino		=3D page->mapping->host->i_ino;
+		__entry->index		=3D page->index;
+		__entry->blkaddr	=3D blkaddr;
+		__entry->type		=3D type;
+	),
+
+	TP_printk("dev =3D (%d,%d), ino =3D %lu, page_index =3D 0x%lx, "
+		"blkaddr =3D 0x%llx, bio_type =3D %s",
+		show_dev_ino(__entry),
+		(unsigned long)__entry->index,
+		(unsigned long long)__entry->blkaddr,
+		show_bio_type(__entry->type))
+);
+
+TRACE_EVENT(f2fs_get_data_block,
+	TP_PROTO(struct inode *inode, sector_t iblock,
+				struct buffer_head *bh, int ret),
+
+	TP_ARGS(inode, iblock, bh, ret),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(ino_t,	ino)
+		__field(sector_t,	iblock)
+		__field(sector_t,	bh_start)
+		__field(size_t,	bh_size)
+		__field(int,	ret)
+	),
+
+	TP_fast_assign(
+		__entry->dev		=3D inode->i_sb->s_dev;
+		__entry->ino		=3D inode->i_ino;
+		__entry->iblock		=3D iblock;
+		__entry->bh_start	=3D bh->b_blocknr;
+		__entry->bh_size	=3D bh->b_size;
+		__entry->ret		=3D ret;
+	),
+
+	TP_printk("dev =3D (%d,%d), ino =3D %lu, file offset =3D %llu, "
+		"start blkaddr =3D 0x%llx, len =3D 0x%llx bytes, err =3D %d",
+		show_dev_ino(__entry),
+		(unsigned long long)__entry->iblock,
+		(unsigned long long)__entry->bh_start,
+		(unsigned long long)__entry->bh_size,
+		__entry->ret)
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

--=-aGLJJhMRE5Eh5l0KSn95
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJRdmTgAAoJEEAUqH6CSFDSW1QP/AgFKNArHp4rBq/gmMb6sy7H
WE4nAjA8I+EHajUmMB9hOGY84+xMRrlsXAMb1SdiL9fImLONOp6VzpcMqcwDHBh0
AZwZPt45dSESNyuMrsIg9LlAjQzScu4LZucVMO8wbFuc+cDimR7FZ8G2dQkzJrRC
9WpBB77ZmC6ZkkKpJbluTYmMGhO/d3jOH5+mEd9spDrnjBqROyQIBoREyQeMxGdR
/ibJQ1w/ej4nSTN+yzY9Cd09nN9hf6Z/9aAP1/QvN+ZOloRMtf6itEvDdzTvzOwB
OlkoB0g3tFnE3D7+ecFMJc9uhPfgIPKD5k9G5K8fDblQT5Usqtup99bmWtUy1tcX
+HmO1Wmby7VYMb6jg9f5RaNpsEcCt3jXIdBU4PG03Smu89j7/KGDcGvSke0k7R3T
Vyu56Hpz2GFMX7bNjCBoyqlV0K9uPIJjuhPByjB1lTuCe8GCirmwFO7mmlnwgZal
mx0zlg9c+flu38yahBeSImZU3RT/M4wXZYSnGIrAJfq1eASN4X53lsp45P7v4s9e
XITABT7kNVEG3ACFFotVwCI9GsQCVx30Lt6TVQC2UZyq/NDQuNUDg4K4NCo03kLt
fhxValMXEbh2JmVWAfXIWWH3YKT/0AIGbh8p8pyVjoT34VbDiqt4Zyv7fLaD+Cmd
yADqDCz5ggFK2/6RdI3Y
=QhdO
-----END PGP SIGNATURE-----

--=-aGLJJhMRE5Eh5l0KSn95--

