Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036Ab3DWKl5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 06:41:57 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:54054 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755515Ab3DWKly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 06:41:54 -0400
X-AuditID: cbfee68d-b7feb6d000007be8-5f-517665709a81
Message-id: <1366713655.31792.16.camel@kjgkr>
Subject: Re: [PATCH v4 7/7] f2fs: add tracepoints to debug checkpoint request
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: rostedt@goodmis.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Pankaj Kumar <pankaj.km@samsung.com>
Date: Tue, 23 Apr 2013 19:40:55 +0900
In-reply-to: <1366389010-19017-1-git-send-email-linkinjeon@gmail.com>
References: <1366389010-19017-1-git-send-email-linkinjeon@gmail.com>
Organization: samsung
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary="=-79Sn5JKXRf9uosJPqNJl"
X-Mailer: Evolution 3.2.3-0ubuntu6
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjleLIzCtJLcpLzFFi42I5/e+ZgW5BalmgwaoXehbX795itri0yN1i
	z96TLBaXd81hs/gxvd7ix67zzBb7Oh4wObB77Jx1l92jZd8tdo/dCz4zefRtWcXo8XmTXABr
	FJdNSmpOZllqkb5dAlfG05urmAveyFfcbdjA3MD4SLqLkZNDQsBEYs2GPSwQtpjEhXvr2boY
	uTiEBJYxSvzbvocVpmjK+kUsEInpjBIHHs2AqnrNKPFr2X4mkCpeAV2Jta8mgNnCAr4Shxq2
	MXcxcnCwCWhLbN5vABIWElCUeLv/LitIWERATWLCs1SQMcwCZ4GWzWtiBKlhEVCVaH3SywRS
	wyngKvFiPx9Eq4vEvlnLwA7lFxCVONn6CaycWaBK4vvpY1APKEnsbu9kh7hGUOLH5HtgN0sI
	zOWQ+HrsOjPEfAGJb5MPsYDMlxCQldh0gBmiV1Li4IobLBMYxWchGTsLySiIuKZE6/bf7BC2
	tsSyha+ZIWxbiXXr3kPV2EhsurqAEcKWl9j+dg7zAkb2VYyiqQXJBcVJ6UWGesWJucWleel6
	yfm5mxghkd67g/H2AetDjFVAJ05klhJNzgcmirySeENjMyMLUxNTYyNzSzOqCCuJ86q1WAcK
	CaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYBQ9x7RkrnzDc656A8k5DxIT3ZU+SN7uK9wQ1/PQ
	XcDk/JMXEr9zg3jjFibtE5vAEdLGsiz3n7bfRa7QdbsfJXsvOpIT+nei7JrCdfOb/xskr5j3
	4n/yXqkdgvyu4T7N//XF5eaFmzaubZh4J2aLp3V8u+iZljTJRWx3uRts0//zbt5a5xOhosRS
	nJFoqMVcVJwIAJVSlYQhAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnk+LIzCtJLcpLzFFi42I5/e+xoG5BalmgwbwTmhbX795itri0yN1i
	z96TLBaXd81hs/gxvd7ix67zzBb7Oh4wObB77Jx1l92jZd8tdo/dCz4zefRtWcXo8XmTXABr
	VAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QFUoK
	ZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjKc3VzEXvJGvuNuwgbmB8ZF0
	FyMnh4SAicSU9YtYIGwxiQv31rN1MXJxCAlMZ5Q48GgGlPOaUeLXsv1MIFW8AroSa19NALOF
	BXwlDjVsY+5i5OBgE9CW2LzfACQsJKAo8Xb/XVaQsIiAmsSEZ6kgY5gFzjJK/JvXxAhSwyKg
	KtH6pJcJpIZTwFXixX4+iFYXiX2zloHdwy8gKnGy9RNYObNAlcT308eg7lSS2N3eyQ5xjaDE
	j8n3WCYwCs5CUjYLSQoirinRuv03O4StLbFs4WtmCNtWYt2691A1NhKbri5ghLDlJba/ncO8
	gJF9FaNoakFyQXFSeq6RXnFibnFpXrpecn7uJkZwGnkmvYNxVYPFIUYBDkYlHl4B99JAIdbE
	suLK3EOMKkBzHm1YfYFRiiUvPy9VSYT3mlRZoBBvSmJlVWpRfnxRaU5q8SHGiYzA0JjILCWa
	nA9Mfnkl8YbGJmZGlkZmFkYm5ua0FFYS5z3Yah0oJJCeWJKanZpakFoEcxQTB6dUA+PizU9n
	GGr9zskXuTSn9PtUgaayffFLJOL5/UtKTxeKH5KfNDX0v+mOzg1PHms7/JNYerNxKssj22DW
	qjVX/wQ92K54WftDThin5qW8lM0dlSFqrrWPArWlf0a3PWUsmVQezNIcVe33S3N7jNT+Y1N7
	zCUEHE+brogSPMGf87L6/ZJnTt+Tm5RYijMSDbWYi4oTAf7ozDiiAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-79Sn5JKXRf9uosJPqNJl
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

=46rom 2af4bd6ca556d690ee166200abd16fdbe749782e Mon Sep 17 00:00:00 2001
From: Namjae Jeon <namjae.jeon@samsung.com>
Date: Tue, 23 Apr 2013 18:26:54 +0900
Subject: [PATCH 7/7] f2fs: add tracepoints to debug checkpoint request
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
linux-f2fs-devel@lists.sourceforge.net

Add tracepoints to debug checkpoint request.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Pankaj Kumar <pankaj.km@samsung.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
[Jaegeuk: change expressions]
Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/checkpoint.c        |  7 +++++++
 include/trace/events/f2fs.h | 24 ++++++++++++++++++++++++
 2 files changed, 31 insertions(+)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index be6aa2e..f54b83b 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -20,6 +20,7 @@
 #include "f2fs.h"
 #include "node.h"
 #include "segment.h"
+#include <trace/events/f2fs.h>
=20
 static struct kmem_cache *orphan_entry_slab;
 static struct kmem_cache *inode_entry_slab;
@@ -714,9 +715,13 @@ void write_checkpoint(struct f2fs_sb_info *sbi,
bool is_umount)
 	struct f2fs_checkpoint *ckpt =3D F2FS_CKPT(sbi);
 	unsigned long long ckpt_ver;
=20
+	trace_f2fs_write_checkpoint(sbi->sb, is_umount, "start block_ops");
+
 	mutex_lock(&sbi->cp_mutex);
 	block_operations(sbi);
=20
+	trace_f2fs_write_checkpoint(sbi->sb, is_umount, "finish block_ops");
+
 	f2fs_submit_bio(sbi, DATA, true);
 	f2fs_submit_bio(sbi, NODE, true);
 	f2fs_submit_bio(sbi, META, true);
@@ -738,6 +743,8 @@ void write_checkpoint(struct f2fs_sb_info *sbi, bool
is_umount)
=20
 	unblock_operations(sbi);
 	mutex_unlock(&sbi->cp_mutex);
+
+	trace_f2fs_write_checkpoint(sbi->sb, is_umount, "finish checkpoint");
 }
=20
 void init_orphan_info(struct f2fs_sb_info *sbi)
diff --git a/include/trace/events/f2fs.h b/include/trace/events/f2fs.h
index ae2da92..b2b2f72 100644
--- a/include/trace/events/f2fs.h
+++ b/include/trace/events/f2fs.h
@@ -645,6 +645,30 @@ TRACE_EVENT(f2fs_submit_write_page,
 		(unsigned long long)__entry->block)
 );
=20
+TRACE_EVENT(f2fs_write_checkpoint,
+
+	TP_PROTO(struct super_block *sb, bool is_umount, char *msg),
+
+	TP_ARGS(sb, is_umount, msg),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(bool,	is_umount)
+		__field(char *,	msg)
+	),
+
+	TP_fast_assign(
+		__entry->dev		=3D sb->s_dev;
+		__entry->is_umount	=3D is_umount;
+		__entry->msg		=3D msg;
+	),
+
+	TP_printk("dev =3D (%d,%d), checkpoint for %s, state =3D %s",
+		show_dev(__entry),
+		__entry->is_umount ? "clean umount" : "consistency",
+		__entry->msg)
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

--=-79Sn5JKXRf9uosJPqNJl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJRdmU4AAoJEEAUqH6CSFDSrWoQAI0bGu2bKu346DPbO9GUqimd
syIdwnaaMBraoTBc4yWr0CkUYR5zUTIPKicCH0C3SSH5lboxwEpET8QmzHtcpiVk
BZyVoYuGtpkTHoBlH+wJh+7sQeIzt4QDJpafz+R6nq9nuiKSHTCpEYPqLxjpaprT
JLYUMB3mw/s7V4JoPVoRiuBEBeSPRylxLwlj3EcaMsncxC/JBObeQWkuUqYSRf4e
5r2g3fP+3z/gfbUaloNdAG2/r8OVezDrShJRGTcG6re7l7qa19opygWWQbgKh/o3
okzlLNvY+M61PhPnfCwwEkPdineK/WMCCAwytBNyTLZ3DYf5OIHdofpmDci7mpeL
krGlupXdBxxkUxyAFVHyUsHAInz6G0LZY4GW+meyNavXkcoUVyMD+zJL6vAK0F7s
Dh+j6NCrGM/VADX+Aws5NIInpSnhvnZOkFjmnLhpXRYvs1KFGPtebhTNTifqE63n
nFJ74Sojotb7N0gutBl7z3svqGAkVDoiNZNOhP5RMNKdEHRzIlO1CLdEbVFKtbwB
OPc6HIYo/a/aBflG338DFYXs7w6Q2ixlm99CcLCHVrTdDJOoAql+3K4F6NsbVx/D
YMbJrtbLshQbsO1tFH5vEZAgZ0mmU5ajbmxZAA3aQE17WxNHMSNaGpNlLHgX2u5B
Q5Z8bj8PLcJsTo5gqDLL
=MVC2
-----END PGP SIGNATURE-----

--=-79Sn5JKXRf9uosJPqNJl--

