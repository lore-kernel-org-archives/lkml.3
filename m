Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755584Ab3DWKkP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 06:40:15 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:56723 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755348Ab3DWKkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 06:40:10 -0400
X-AuditID: cbfee68d-b7feb6d000007be8-7b-517665073440
Message-id: <1366713550.31792.11.camel@kjgkr>
Subject: Re: [PATCH v4 2/7] f2fs: add tracepoints for truncate operation
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: rostedt@goodmis.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Pankaj Kumar <pankaj.km@samsung.com>
Date: Tue, 23 Apr 2013 19:39:10 +0900
In-reply-to: <1366388932-18846-1-git-send-email-linkinjeon@gmail.com>
References: <1366388932-18846-1-git-send-email-linkinjeon@gmail.com>
Organization: samsung
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary="=-RBCz4pvdzPssimFvHlYJ"
X-Mailer: Evolution 3.2.3-0ubuntu6
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphleLIzCtJLcpLzFFi42I5/e+Zvi57almgweJ/0hbX795itri0yN1i
	z96TLBaXd81hs/gxvd7ix67zzBb7Oh4wObB77Jx1l92jZd8tdo/dCz4zefRtWcXo8XmTXABr
	FJdNSmpOZllqkb5dAlfGjVur2AvuBFb8mv2YpYFxsksXIweHhICJRMNcri5GTiBTTOLCvfVs
	XYxcHEICyxglOn4fYIZImEhs2vADKrGIUaLt7VxWCOc1o8SH/R9ZQKp4BXQlrn46xAoyVVjA
	Q+LJGl4Qk01AW2LzfgOQCiEBRYm3+++CVYgIqElMeJYKMoVZ4CyjxL95TYwgNSwCqhLX705m
	B6nhFHCV+PooHqLVRWL6xR4mEJtfQFTiZOsnsHJmgSqJNceOsECcqSSxu72THeIYQYkfk++x
	gMyXEFjIIdE98TwzxHwBiW+TD7FA/C4rsQnmRUmJgytusExgFJ+FZOwsJKMg4poSrdt/s0PY
	2hLLFr5mhrBtJdatew9VYyOx6eoCRghbXmL72znMCxjZVzGKphYkFxQnpRcZ6hUn5haX5qXr
	JefnbmKERHnvDsbbB6wPMVYBnTiRWUo0OR+YJPJK4g2NzYwsTE1MjY3MLc2oIqwkzqvWYh0o
	JJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgTE+fptp/819CXNdmezM6s1rEq5NFogIeRv8ZvkV
	5l+WN+9Ni/Bc17TlZX1IqMeq6y6hKdu09z+bPblTxLd/nbEMV5WdywyvfPfrR/K17VYs+Wv2
	XuS6pNOF6Z+X7Ll4jPG8oMHezCyLE/0XJqQ94WmrirFS1A752dJX+4uloM0tWnQSm9ibn0os
	xRmJhlrMRcWJAOVI4BsfAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjk+LIzCtJLcpLzFFi42I5/e+xgC57almgwbvTohbX795itri0yN1i
	z96TLBaXd81hs/gxvd7ix67zzBb7Oh4wObB77Jx1l92jZd8tdo/dCz4zefRtWcXo8XmTXABr
	VAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QFUoK
	ZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjBu3VrEX3Ams+DX7MUsD42SX
	LkZODgkBE4lNG36wQdhiEhfurQeyuTiEBBYxSrS9ncsK4bxmlPiw/yMLSBWvgK7E1U+HgBIc
	HMICHhJP1vCCmGwC2hKb9xuAVAgJKEq83X8XrEJEQE1iwrNUkCnMAmcZJf7Na2IEqWERUJW4
	fncyO0gNp4CrxNdH8RCtLhLTL/Ywgdj8AqISJ1s/gZUzC1RJrDl2hAXiTCWJ3e2d7BDHCEr8
	mHyPZQKj4CwkZbOQpCDimhKt23+zQ9jaEssWvmaGsG0l1q17D1VjI7Hp6gJGCFteYvvbOcwL
	GNlXMYqmFiQXFCel5xrpFSfmFpfmpesl5+duYgQnkWfSOxhXNVgcYhTgYFTi4RVwLw0UYk0s
	K67MPcSoAjTn0YbVFxilWPLy81KVRHivSZUFCvGmJFZWpRblxxeV5qQWH2KcyAgMjYnMUqLJ
	+cDUl1cSb2hsYmZkaWRmYWRibk5LYSVx3oOt1oFCAumJJanZqakFqUUwRzFxcEo1MCZw//Kt
	nNd99Tbv1pDtkpMyvDW+y81PZL/Hyz95keB8rclCrcl8j36VVa9+pyheFru577L01X8debpl
	z31Ezkrsu3HplNSeKQ/6Zrj9/aq7zKnrbtLWJUc+Ss1fXfnJcnHH+wP7Dzr+zX87a1asFk/f
	6r36r/f/2GbVu1wm+dvdDBml6vs2Zi5KLMUZiYZazEXFiQBeWilqoQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-RBCz4pvdzPssimFvHlYJ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

=46rom 51dd62493477923723c797c6da60121ed39900ed Mon Sep 17 00:00:00 2001
From: Namjae Jeon <namjae.jeon@samsung.com>
Date: Sat, 20 Apr 2013 01:28:52 +0900
Subject: [PATCH 2/7] f2fs: add tracepoints for truncate operation
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
linux-f2fs-devel@lists.sourceforge.net

add tracepoints for tracing the truncate operations
like truncate node/data blocks, f2fs_truncate etc.

Tracepoints are added at entry and exit of operation
to trace the success & failure of operation.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Pankaj Kumar <pankaj.km@samsung.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
[Jaegeuk: combine and modify the tracepoint structures]
Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/file.c              |   9 +++
 fs/f2fs/node.c              |  20 ++++-
 include/trace/events/f2fs.h | 176
++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 203 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 0b0ba26..71efa37 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -193,6 +193,9 @@ static int truncate_data_blocks_range(struct
dnode_of_data *dn, int count)
 		sync_inode_page(dn);
 	}
 	dn->ofs_in_node =3D ofs;
+
+	trace_f2fs_truncate_data_blocks_range(dn->inode, dn->nid,
+					 dn->ofs_in_node, nr_free);
 	return nr_free;
 }
=20
@@ -229,6 +232,8 @@ static int truncate_blocks(struct inode *inode, u64
from)
 	int count =3D 0, ilock =3D -1;
 	int err;
=20
+	trace_f2fs_truncate_blocks_enter(inode, from);
+
 	free_from =3D (pgoff_t)
 			((from + blocksize - 1) >> (sbi->log_blocksize));
=20
@@ -239,6 +244,7 @@ static int truncate_blocks(struct inode *inode, u64
from)
 		if (err =3D=3D -ENOENT)
 			goto free_next;
 		mutex_unlock_op(sbi, ilock);
+		trace_f2fs_truncate_blocks_exit(inode, err);
 		return err;
 	}
=20
@@ -263,6 +269,7 @@ free_next:
 	/* lastly zero out the first data page */
 	truncate_partial_data_page(inode, from);
=20
+	trace_f2fs_truncate_blocks_exit(inode, err);
 	return err;
 }
=20
@@ -272,6 +279,8 @@ void f2fs_truncate(struct inode *inode)
 				S_ISLNK(inode->i_mode)))
 		return;
=20
+	trace_f2fs_truncate(inode);
+
 	if (!truncate_blocks(inode, i_size_read(inode))) {
 		inode->i_mtime =3D inode->i_ctime =3D CURRENT_TIME;
 		mark_inode_dirty(inode);
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 5a7edf9..5a82550 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -19,6 +19,7 @@
 #include "f2fs.h"
 #include "node.h"
 #include "segment.h"
+#include <trace/events/f2fs.h>
=20
 static struct kmem_cache *nat_entry_slab;
 static struct kmem_cache *free_nid_slab;
@@ -508,6 +509,7 @@ invalidate:
=20
 	f2fs_put_page(dn->node_page, 1);
 	dn->node_page =3D NULL;
+	trace_f2fs_truncate_node(dn->inode, dn->nid, ni.blk_addr);
 }
=20
 static int truncate_dnode(struct dnode_of_data *dn)
@@ -548,9 +550,13 @@ static int truncate_nodes(struct dnode_of_data *dn,
unsigned int nofs,
 	if (dn->nid =3D=3D 0)
 		return NIDS_PER_BLOCK + 1;
=20
+	trace_f2fs_truncate_nodes_enter(dn->inode, dn->nid, dn->data_blkaddr);
+
 	page =3D get_node_page(sbi, dn->nid);
-	if (IS_ERR(page))
+	if (IS_ERR(page)) {
+		trace_f2fs_truncate_nodes_exit(dn->inode, PTR_ERR(page));
 		return PTR_ERR(page);
+	}
=20
 	rn =3D (struct f2fs_node *)page_address(page);
 	if (depth < 3) {
@@ -592,10 +598,12 @@ static int truncate_nodes(struct dnode_of_data
*dn, unsigned int nofs,
 	} else {
 		f2fs_put_page(page, 1);
 	}
+	trace_f2fs_truncate_nodes_exit(dn->inode, freed);
 	return freed;
=20
 out_err:
 	f2fs_put_page(page, 1);
+	trace_f2fs_truncate_nodes_exit(dn->inode, ret);
 	return ret;
 }
=20
@@ -650,6 +658,9 @@ static int truncate_partial_nodes(struct
dnode_of_data *dn,
 fail:
 	for (i =3D depth - 3; i >=3D 0; i--)
 		f2fs_put_page(pages[i], 1);
+
+	trace_f2fs_truncate_partial_nodes(dn->inode, nid, depth, err);
+
 	return err;
 }
=20
@@ -666,11 +677,15 @@ int truncate_inode_blocks(struct inode *inode,
pgoff_t from)
 	struct dnode_of_data dn;
 	struct page *page;
=20
+	trace_f2fs_truncate_inode_blocks_enter(inode, from);
+
 	level =3D get_node_path(from, offset, noffset);
=20
 	page =3D get_node_page(sbi, inode->i_ino);
-	if (IS_ERR(page))
+	if (IS_ERR(page)) {
+		trace_f2fs_truncate_inode_blocks_exit(inode, PTR_ERR(page));
 		return PTR_ERR(page);
+	}
=20
 	set_new_dnode(&dn, inode, page, NULL, 0);
 	unlock_page(page);
@@ -740,6 +755,7 @@ skip_partial:
 	}
 fail:
 	f2fs_put_page(page, 0);
+	trace_f2fs_truncate_inode_blocks_exit(inode, err);
 	return err > 0 ? 0 : err;
 }
=20
diff --git a/include/trace/events/f2fs.h b/include/trace/events/f2fs.h
index 03bb0db..4bbd19f 100644
--- a/include/trace/events/f2fs.h
+++ b/include/trace/events/f2fs.h
@@ -189,6 +189,182 @@ DEFINE_EVENT(f2fs__inode_exit, f2fs_unlink_exit,
=20
 	TP_ARGS(inode, ret)
 );
+
+DEFINE_EVENT(f2fs__inode, f2fs_truncate,
+
+	TP_PROTO(struct inode *inode),
+
+	TP_ARGS(inode)
+);
+
+TRACE_EVENT(f2fs_truncate_data_blocks_range,
+
+	TP_PROTO(struct inode *inode, nid_t nid, unsigned int ofs, int free),
+
+	TP_ARGS(inode, nid,  ofs, free),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(ino_t,	ino)
+		__field(nid_t,	nid)
+		__field(unsigned int,	ofs)
+		__field(int,	free)
+	),
+
+	TP_fast_assign(
+		__entry->dev	=3D inode->i_sb->s_dev;
+		__entry->ino	=3D inode->i_ino;
+		__entry->nid	=3D nid;
+		__entry->ofs	=3D ofs;
+		__entry->free	=3D free;
+	),
+
+	TP_printk("dev =3D (%d,%d), ino =3D %lu, nid =3D %u, offset =3D %u, freed=
 =3D %
d",
+		show_dev_ino(__entry),
+		(unsigned int)__entry->nid,
+		__entry->ofs,
+		__entry->free)
+);
+
+DECLARE_EVENT_CLASS(f2fs__truncate_op,
+
+	TP_PROTO(struct inode *inode, u64 from),
+
+	TP_ARGS(inode, from),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(ino_t,	ino)
+		__field(loff_t,	size)
+		__field(blkcnt_t, blocks)
+		__field(u64,	from)
+	),
+
+	TP_fast_assign(
+		__entry->dev	=3D inode->i_sb->s_dev;
+		__entry->ino	=3D inode->i_ino;
+		__entry->size	=3D inode->i_size;
+		__entry->blocks	=3D inode->i_blocks;
+		__entry->from	=3D from;
+	),
+
+	TP_printk("dev =3D (%d,%d), ino =3D %lu, i_size =3D %lld, i_blocks =3D %l=
lu, "
+		"start file offset =3D %llu",
+		show_dev_ino(__entry),
+		__entry->size,
+		(unsigned long long)__entry->blocks,
+		(unsigned long long)__entry->from)
+);
+
+DEFINE_EVENT(f2fs__truncate_op, f2fs_truncate_blocks_enter,
+
+	TP_PROTO(struct inode *inode, u64 from),
+
+	TP_ARGS(inode, from)
+);
+
+DEFINE_EVENT(f2fs__inode_exit, f2fs_truncate_blocks_exit,
+
+	TP_PROTO(struct inode *inode, int ret),
+
+	TP_ARGS(inode, ret)
+);
+
+DEFINE_EVENT(f2fs__truncate_op, f2fs_truncate_inode_blocks_enter,
+
+	TP_PROTO(struct inode *inode, u64 from),
+
+	TP_ARGS(inode, from)
+);
+
+DEFINE_EVENT(f2fs__inode_exit, f2fs_truncate_inode_blocks_exit,
+
+	TP_PROTO(struct inode *inode, int ret),
+
+	TP_ARGS(inode, ret)
+);
+
+DECLARE_EVENT_CLASS(f2fs__truncate_node,
+
+	TP_PROTO(struct inode *inode, nid_t nid, block_t blk_addr),
+
+	TP_ARGS(inode, nid, blk_addr),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(ino_t,	ino)
+		__field(nid_t,	nid)
+		__field(block_t,	blk_addr)
+	),
+
+	TP_fast_assign(
+		__entry->dev		=3D inode->i_sb->s_dev;
+		__entry->ino		=3D inode->i_ino;
+		__entry->nid		=3D nid;
+		__entry->blk_addr	=3D blk_addr;
+	),
+
+	TP_printk("dev =3D (%d,%d), ino =3D %lu, nid =3D %u, block_address =3D 0x=
%
llx",
+		show_dev_ino(__entry),
+		(unsigned int)__entry->nid,
+		(unsigned long long)__entry->blk_addr)
+);
+
+DEFINE_EVENT(f2fs__truncate_node, f2fs_truncate_nodes_enter,
+
+	TP_PROTO(struct inode *inode, nid_t nid, block_t blk_addr),
+
+	TP_ARGS(inode, nid, blk_addr)
+);
+
+DEFINE_EVENT(f2fs__inode_exit, f2fs_truncate_nodes_exit,
+
+	TP_PROTO(struct inode *inode, int ret),
+
+	TP_ARGS(inode, ret)
+);
+
+DEFINE_EVENT(f2fs__truncate_node, f2fs_truncate_node,
+
+	TP_PROTO(struct inode *inode, nid_t nid, block_t blk_addr),
+
+	TP_ARGS(inode, nid, blk_addr)
+);
+
+TRACE_EVENT(f2fs_truncate_partial_nodes,
+
+	TP_PROTO(struct inode *inode, nid_t nid[], int depth, int err),
+
+	TP_ARGS(inode, nid, depth, err),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(ino_t,	ino)
+		__field(nid_t,	nid[3])
+		__field(int,	depth)
+		__field(int,	err)
+	),
+
+	TP_fast_assign(
+		__entry->dev	=3D inode->i_sb->s_dev;
+		__entry->ino	=3D inode->i_ino;
+		__entry->nid[0]	=3D nid[0];
+		__entry->nid[1]	=3D nid[1];
+		__entry->nid[2]	=3D nid[2];
+		__entry->depth	=3D depth;
+		__entry->err	=3D err;
+	),
+
+	TP_printk("dev =3D (%d,%d), ino =3D %lu, "
+		"nid[0] =3D %u, nid[1] =3D %u, nid[2] =3D %u, depth =3D %d, err =3D %d",
+		show_dev_ino(__entry),
+		(unsigned int)__entry->nid[0],
+		(unsigned int)__entry->nid[1],
+		(unsigned int)__entry->nid[2],
+		__entry->depth,
+		__entry->err)
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

--=-RBCz4pvdzPssimFvHlYJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJRdmTOAAoJEEAUqH6CSFDS/QoP/3yQd8OTQCZKag4Q6KIiVDXf
at5Jh4GQUE4mwTEtp+Cjyq6s12T2enCgxALWDr+We11EdzT6bfGtPZEm5tNZlKw9
NzKvNbRcYiE3DcKGZNxYDG8rYBOuiSESicSgXubLSkc94vYsNaDeJkRL0phBnTNn
7Z2uPEXiySGkfCCLVfLbG0GWEzn4FsRwwvqs+yY9ZdemkscN1XxEAlIarzsIXfQ+
70QdnZrLL4yu0NoY8nABbOTcEqO0b6cqJzTvaDVOV3YTV8mXAsAxZbwcFL3JIyjr
dNoQDZknt8tO2N28AORrhq2s+5nLPsnrgxfL8MyqWSoBKxqCgplVny8+EIn14LZj
nVt/5YfnGa7loiw1/fIY8QNUFy2fbRoqF6bo2z7JrnM6u+BgBdqsR/rCrKTT/WXC
epGQx1Dj85XPLKsYjCl8U+pimaMCbKkqgGXKmqX5HwTG7eBxiVZdbMImgZauMPO7
S6LxMs53nCqYDLUEMOpXX1TbD9LEJR6WPXrVxTpF56mfPSjP/Sa94AsdeSn93PoW
suGONYAWgbhspdO832q8N++V+8aVUzBOuC9fMwr/Y280kSDdnfbw09Cyn6t3KxWt
ci1f2G4odNRGwdBDUsPR+LT6fvNy14aSnHiWKFaSliLX64jmRRnv0PQGcaLpFPxz
YcpXTYx0uohV3wt6Uo3Z
=F8er
-----END PGP SIGNATURE-----

--=-RBCz4pvdzPssimFvHlYJ--

