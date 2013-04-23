Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755664Ab3DWKlR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 06:41:17 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:56837 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755698Ab3DWKlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 06:41:14 -0400
X-AuditID: cbfee68d-b7feb6d000007be8-a0-5176654022c9
Message-id: <1366713607.31792.14.camel@kjgkr>
Subject: Re: [PATCH v4 5/7] f2fs: add tracepoints to debug the block allocation
 & fallocate
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: rostedt@goodmis.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Pankaj Kumar <pankaj.km@samsung.com>
Date: Tue, 23 Apr 2013 19:40:07 +0900
In-reply-to: <1366388970-18949-1-git-send-email-linkinjeon@gmail.com>
References: <1366388970-18949-1-git-send-email-linkinjeon@gmail.com>
Organization: samsung
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary="=-9Zrfk5B9PyKPqtr18E4o"
X-Mailer: Evolution 3.2.3-0ubuntu6
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnleLIzCtJLcpLzFFi42I5/e+Zoa5DalmgwYIJXBbX795itri0yN1i
	z96TLBaXd81hs/gxvd7ix67zzBb7Oh4wObB77Jx1l92jZd8tdo/dCz4zefRtWcXo8XmTXABr
	FJdNSmpOZllqkb5dAldG882vbAV/VSuaZz9ib2DcpNDFyMkhIWAi8ePuSkYIW0ziwr31bF2M
	XBxCAssYJXY0v2CBKfpz8hYTRGI6o8SSuyugnNeMEgentLCDVPEK6ErsX7OdDcQWFoiV+H79
	P3MXIwcHm4C2xOb9BiBhIQFFibf777KChEUE1CQmPEsFGcMscJZR4t+8JrArWARUJVZtmgU2
	klPAVWL+zfdMEL0uEi0HJoCN5xcQlTjZ+gmsnlmgSuLtw04miEOVJHa3d0KdIyjxY/I9FpAF
	EgILOSSOT7nHCrFAQOLb5EMsIEdICMhKbDrADNErKXFwxQ2WCYzis5CMnYVkFERcU6J1+292
	CFtbYtnC18wQtq3EunXvoWpsJDZdXcAIYctLbH87h3kBI/sqRtHUguSC4qT0IkO94sTc4tK8
	dL3k/NxNjJBY793BePuA9SHGKqATJzJLiSbnA1NFXkm8obGZkYWpiamxkbmlGVWElcR51Vqs
	A4UE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUwuk/mOL81S9DvZWncQ8fy2wvZVlamLVVkWDjx
	082fV3u0sz5fZLdnfqh8WmZztsGU+ftiTqlyf77NU3qq//Pt034vVuXn7Ll9M+X1+WnbH37T
	jfUQlub9O8FzypTfrOc8nksnCt286ZhlIXq89/H1/osLGZ+bFOX25iTv7InxW3nw2yH57PoN
	25RYijMSDbWYi4oTAZnDfVoiAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAJsWRmVeSWpSXmKPExsVy+t9jQV2H1LJAg0nvWCyu373FbHFpkbvF
	nr0nWSwu75rDZvFjer3Fj13nmS32dTxgcmD32DnrLrtHy75b7B67F3xm8ujbsorR4/MmuQDW
	qAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zBygK5QU
	yhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhHWMGc03v7IV/FWtaJ79iL2BcZNC
	FyMnh4SAicSfk7eYIGwxiQv31rN1MXJxCAlMZ5RYcncFE4TzmlHi4JQWdpAqXgFdif1rtrOB
	2MICsRLfr/9n7mLk4GAT0JbYvN8AJCwkoCjxdv9dVpCwiICaxIRnqSBjmAXOMkr8m9fECFLD
	IqAqsWrTLLCRnAKuEvNvvmeC6HWRaDkwAWw8v4CoxMnWT2D1zAJVEm8fdkIdqiSxu70T6hxB
	iR+T77FMYBSchaRsFpIURFxTonX7b3YIW1ti2cLXzBC2rcS6de+hamwkNl1dwAhhy0tsfzuH
	eQEj+ypG0dSC5ILipPRcQ73ixNzi0rx0veT83E2M4ETyTGoH48oGi0OMAhyMSjy8Au6lgUKs
	iWXFlbmHGFWA5jzasPoCoxRLXn5eqpII7zWpskAh3pTEyqrUovz4otKc1OJDjBMZgcExkVlK
	NDkfmP7ySuINjU3MjCyNzCyMTMzNaSmsJM57oNU6UEggPbEkNTs1tSC1COYoJg5OqQbG8PWx
	ruV2JpFprB8cDbad8k/+wrztQLeS6K/D0oeEljAd+q628R1bdPdLkZ+e7g7LHt4t2Reu1Sry
	QO3ID2tb5ytz7Gtvfmup0Upq1vnnJhLJcZDtxzdNrwvfGKQ/tC+/vfOSePpi81kW3TeXlwi9
	Xm+5bvMVzZjr8g6ti9L1FdychKWX7GxVYinOSDTUYi4qTgQAi+t0kqMDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-9Zrfk5B9PyKPqtr18E4o
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

=46rom c01e285324793a86c2c90c8451ed6feb04b3d310 Mon Sep 17 00:00:00 2001
From: Namjae Jeon <namjae.jeon@samsung.com>
Date: Tue, 23 Apr 2013 17:00:52 +0900
Subject: [PATCH 5/7] f2fs: add tracepoints to debug the block allocation
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
linux-f2fs-devel@lists.sourceforge.net

Add tracepoints to debug the block allocation & fallocate.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Pankaj Kumar <pankaj.km@samsung.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
[Jaegeuk: enhance information]
Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/data.c              |  2 ++
 fs/f2fs/file.c              |  1 +
 include/trace/events/f2fs.h | 64
+++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 67 insertions(+)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 8e8b14d..1220b5c 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -55,6 +55,8 @@ int reserve_new_block(struct dnode_of_data *dn)
 	if (!inc_valid_block_count(sbi, dn->inode, 1))
 		return -ENOSPC;
=20
+	trace_f2fs_reserve_new_block(dn->inode, dn->nid, dn->ofs_in_node);
+
 	__set_data_blkaddr(dn, NEW_ADDR);
 	dn->data_blkaddr =3D NEW_ADDR;
 	sync_inode_page(dn);
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 71efa37..0e56db2 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -546,6 +546,7 @@ static long f2fs_fallocate(struct file *file, int
mode,
 		inode->i_mtime =3D inode->i_ctime =3D CURRENT_TIME;
 		mark_inode_dirty(inode);
 	}
+	trace_f2fs_fallocate(inode, mode, offset, len, ret);
 	return ret;
 }
=20
diff --git a/include/trace/events/f2fs.h b/include/trace/events/f2fs.h
index 6f7cf7a..56b6240 100644
--- a/include/trace/events/f2fs.h
+++ b/include/trace/events/f2fs.h
@@ -514,6 +514,70 @@ TRACE_EVENT(f2fs_get_victim,
 		__entry->free)
 );
=20
+TRACE_EVENT(f2fs_fallocate,
+
+	TP_PROTO(struct inode *inode, int mode,
+				loff_t offset, loff_t len, int ret),
+
+	TP_ARGS(inode, mode, offset, len, ret),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(ino_t,	ino)
+		__field(int,	mode)
+		__field(loff_t,	offset)
+		__field(loff_t,	len)
+		__field(loff_t, size)
+		__field(blkcnt_t, blocks)
+		__field(int,	ret)
+	),
+
+	TP_fast_assign(
+		__entry->dev	=3D inode->i_sb->s_dev;
+		__entry->ino	=3D inode->i_ino;
+		__entry->mode	=3D mode;
+		__entry->offset	=3D offset;
+		__entry->len	=3D len;
+		__entry->size	=3D inode->i_size;
+		__entry->blocks =3D inode->i_blocks;
+		__entry->ret	=3D ret;
+	),
+
+	TP_printk("dev =3D (%d,%d), ino =3D %lu, mode =3D %x, offset =3D %lld, "
+		"len =3D %lld,  i_size =3D %lld, i_blocks =3D %llu, ret =3D %d",
+		show_dev_ino(__entry),
+		__entry->mode,
+		(unsigned long long)__entry->offset,
+		(unsigned long long)__entry->len,
+		(unsigned long long)__entry->size,
+		(unsigned long long)__entry->blocks,
+		__entry->ret)
+);
+
+TRACE_EVENT(f2fs_reserve_new_block,
+
+	TP_PROTO(struct inode *inode, nid_t nid, unsigned int ofs_in_node),
+
+	TP_ARGS(inode, nid, ofs_in_node),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(nid_t, nid)
+		__field(unsigned int, ofs_in_node)
+	),
+
+	TP_fast_assign(
+		__entry->dev	=3D inode->i_sb->s_dev;
+		__entry->nid	=3D nid;
+		__entry->ofs_in_node =3D ofs_in_node;
+	),
+
+	TP_printk("dev =3D (%d,%d), nid =3D %u, ofs_in_node =3D %u",
+		show_dev(__entry),
+		(unsigned int)__entry->nid,
+		__entry->ofs_in_node)
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

--=-9Zrfk5B9PyKPqtr18E4o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJRdmUHAAoJEEAUqH6CSFDSJVEP/16scfjz6GW0nO76gpYnfp78
yW6S1eUknVa0uELbrRay32yy2TdirtEld+dch8XhoPwbgEDFTJyS+PyN47Yuh2cS
gMTiEMmiqmUbcSRwCj7zE1hiyQh3xPSCLIXiDbpp4qV0SvsD7FbAlI2lM6y/TYza
htlwjrPCLnTyU1cX73tfNNLbaZ9hm8bpn0LlLOCT5eDQ6R289dYhl/BYsJ4jG8Hf
cgYsMPVFD1THt8xDVhbADbOgtWNZPAhALx6JY415X9rgUG43tZqIqqlJ2jYubIZg
yn9W9pvKvJQ1jQ8KkYt0i8wxie4t1vGXs9/zbMne9xZgwhlcz+CwsAF3shAfFx7S
/LDidI8fzlQYFKGChsKbfMulXJUNuCgd+v/FryU3yheyUfA4OsKNQXwsoA+4wXej
5mXAv4kD45f4PCrYzPd8/HMps36fVC6iI/+yRhiokc2OmXGOFyuA2uXzG1EoYebE
g6YfUvhkyytu9WmCO/dl2+iWOIqIWUheqlXmteCVn8Hv8LDcyz4JKTz5hNmUMdHA
+RDEcJ7JWjGKopqxM4n867kddoE1xwLITorTsI79jj2rJfOudnLJeDEMe57o4yeB
/Ur5yh6on8YxIH/dzKQdzwGhHD/XnUj2Ce/D+gKwJR3Oq8hiignNZTgrc67DTIRs
ARXivUO1jfDtGsPSckuj
=xdtH
-----END PGP SIGNATURE-----

--=-9Zrfk5B9PyKPqtr18E4o--

