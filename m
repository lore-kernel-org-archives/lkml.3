Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236Ab3DWKjt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 06:39:49 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:26347 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204Ab3DWKjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 06:39:46 -0400
X-AuditID: cbfee68d-b7feb6d000007be8-ba-517664f1699e
Message-id: <1366713528.31792.10.camel@kjgkr>
Subject: Re: [PATCH v4 1/7] f2fs: add tracepoints for sync & Inode operations
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: rostedt@goodmis.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Pankaj Kumar <pankaj.km@samsung.com>
Date: Tue, 23 Apr 2013 19:38:48 +0900
In-reply-to: <1366388920-18812-1-git-send-email-linkinjeon@gmail.com>
References: <1366388920-18812-1-git-send-email-linkinjeon@gmail.com>
Organization: samsung
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary="=-14VGBAi/5yLhVXEqi1dV"
X-Mailer: Evolution 3.2.3-0ubuntu6
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjleLIzCtJLcpLzFFi42I5/e+Zoe7HlLJAg4nL+Cyu373FbHFpkbvF
	nr0nWSwu75rDZvFjer3Fj13nmS32dTxgcmD32DnrLrtHy75b7B67F3xm8ujbsorR4/MmuQDW
	KC6blNSczLLUIn27BK6MBbutC9aEVpzc/ZOxgfGLWxcjJ4eEgInEuo6PTBC2mMSFe+vZuhi5
	OIQEljFK9Hd8YYYpWnznDxNEYjqjxK47n5khnNeMEp/efwFr5xXQlbg7cQ4riC0s4CtxYc98
	oCIODjYBbYnN+w1AwkICihJv999lBQmLCKhJTHiWCjKGWeAso8S/eU2MIDUsAqoS0+a1s4DY
	nAKuEg8X7mKH6HWROLTrBdgqfgFRiZOtn8DqmQWqJD4f/csKcaiSxO72TnaIcwQlfky+xwKy
	QEJgIYfEx13T2CAWCEh8m3yIBeQICQFZiU0HoJ6UlDi44gbLBEbxWUjGzkIyCiKuKdG6/Tc7
	hK0tsWzha2YI21Zi3br3UDU2EpuuLmCEsOUltr+dw7yAkX0Vo2hqQXJBcVJ6kaFecWJucWle
	ul5yfu4mRkik9+5gvH3A+hBjFdCJE5mlRJPzgYkiryTe0NjMyMLUxNTYyNzSjCrCSuK8ai3W
	gUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoYw72Ob1Bc5rF3+p5jD6cmdfzay347kPGolcsx
	rmP2k04cfrPH0/1G1ys/nYBNAqqPD+l/DOrKfqnGe8/jzt4TJ39FOt7sT1nL2OYWOPfm20mr
	IlZEvnZKXS0bPK2gNdXn6s2wkE9WT+93z1MULIyrUS9e/yJT8L9fYsjlB1ViE8/Osbux3GbD
	VCWW4oxEQy3mouJEADpk3NghAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnk+LIzCtJLcpLzFFi42I5/e+xoO7HlLJAg38r2C2u373FbHFpkbvF
	nr0nWSwu75rDZvFjer3Fj13nmS32dTxgcmD32DnrLrtHy75b7B67F3xm8ujbsorR4/MmuQDW
	qAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zBygK5QU
	yhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhHWMGQt2WxesCa04ufsnYwPjF7cu
	Rk4OCQETicV3/jBB2GISF+6tZ+ti5OIQEpjOKLHrzmdmCOc1o8Sn91/AqngFdCXuTpzDCmIL
	C/hKXNgzH6iIg4NNQFti834DkLCQgKLE2/13WUHCIgJqEhOepYKMYRY4yyjxb14TI0gNi4Cq
	xLR57SwgNqeAq8TDhbvYIXpdJA7tegG2il9AVOJk6yewemaBKonPR/+yQhyqJLG7vZMd4hxB
	iR+T77FMYBSchaRsFpIURFxTonX7b3YIW1ti2cLXzBC2rcS6de+hamwkNl1dwAhhy0tsfzuH
	eQEj+ypG0dSC5ILipPRcQ73ixNzi0rx0veT83E2M4DTyTGoH48oGi0OMAhyMSjy8Au6lgUKs
	iWXFlbmHGFWA5jzasPoCoxRLXn5eqpII7zWpskAh3pTEyqrUovz4otKc1OJDjBMZgcExkVlK
	NDkfmPzySuINjU3MjCyNzCyMTMzNaSmsJM57oNU6UEggPbEkNTs1tSC1COYoJg5OqQZGvVQn
	2dSjzk1OZ83OCXBa73yav0D38AGnd3/cgjfP42p+HM1QcU8i82Z6rRYro5qU1Gtts4SsnLYN
	Be63bujum3XqutUz+bqXRRodl1ZPf3g5WlymlDNFS/gB64TpF+f4XHpwRO681dpNkcpLzXyv
	GZwxjUqx2TjL5lrO+ZxZ7NnpfZ9+SrkrsRRnJBpqMRcVJwIA+0vBNqIDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-14VGBAi/5yLhVXEqi1dV
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

=46rom a2a4a7e4abb27c833d4e09ac1d434ab48a64062c Mon Sep 17 00:00:00 2001
From: Namjae Jeon <namjae.jeon@samsung.com>
Date: Sat, 20 Apr 2013 01:28:40 +0900
Subject: [PATCH 1/7] f2fs: add tracepoints for sync & inode operations
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
linux-f2fs-devel@lists.sourceforge.net

Add tracepoints in f2fs for tracing the syncing
operations like filesystem sync, file sync enter/exit.
It will helf to trace the code under debugging scenarios.

Also add tracepoints for tracing the various inode operations
like building inode, eviction of inode, link/unlike of
inodes.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Pankaj Kumar <pankaj.km@samsung.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
[Jaegeuk: combine and modify the tracepoint structures]
Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/file.c              |   7 +-
 fs/f2fs/inode.c             |  13 ++-
 fs/f2fs/namei.c             |   3 +
 fs/f2fs/super.c             |   5 ++
 include/trace/events/f2fs.h | 195
++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 219 insertions(+), 4 deletions(-)
 create mode 100644 include/trace/events/f2fs.h

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 07be88d..0b0ba26 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -25,6 +25,7 @@
 #include "segment.h"
 #include "xattr.h"
 #include "acl.h"
+#include <trace/events/f2fs.h>
=20
 static int f2fs_vm_page_mkwrite(struct vm_area_struct *vma,
 						struct vm_fault *vmf)
@@ -116,9 +117,12 @@ int f2fs_sync_file(struct file *file, loff_t start,
loff_t end, int datasync)
 	if (inode->i_sb->s_flags & MS_RDONLY)
 		return 0;
=20
+	trace_f2fs_sync_file_enter(inode);
 	ret =3D filemap_write_and_wait_range(inode->i_mapping, start, end);
-	if (ret)
+	if (ret) {
+		trace_f2fs_sync_file_exit(inode, need_cp, datasync, ret);
 		return ret;
+	}
=20
 	/* guarantee free sections for fsync */
 	f2fs_balance_fs(sbi);
@@ -153,6 +157,7 @@ int f2fs_sync_file(struct file *file, loff_t start,
loff_t end, int datasync)
 	}
 out:
 	mutex_unlock(&inode->i_mutex);
+	trace_f2fs_sync_file_exit(inode, need_cp, datasync, ret);
 	return ret;
 }
=20
diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
index 60105b7..91ac7f9 100644
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -16,6 +16,8 @@
 #include "f2fs.h"
 #include "node.h"
=20
+#include <trace/events/f2fs.h>
+
 void f2fs_set_inode_flags(struct inode *inode)
 {
 	unsigned int flags =3D F2FS_I(inode)->i_flags;
@@ -91,13 +93,16 @@ struct inode *f2fs_iget(struct super_block *sb,
unsigned long ino)
 {
 	struct f2fs_sb_info *sbi =3D F2FS_SB(sb);
 	struct inode *inode;
-	int ret;
+	int ret =3D 0;
=20
 	inode =3D iget_locked(sb, ino);
 	if (!inode)
 		return ERR_PTR(-ENOMEM);
-	if (!(inode->i_state & I_NEW))
+
+	if (!(inode->i_state & I_NEW)) {
+		trace_f2fs_iget(inode);
 		return inode;
+	}
 	if (ino =3D=3D F2FS_NODE_INO(sbi) || ino =3D=3D F2FS_META_INO(sbi))
 		goto make_now;
=20
@@ -139,11 +144,12 @@ make_now:
 		goto bad_inode;
 	}
 	unlock_new_inode(inode);
-
+	trace_f2fs_iget(inode);
 	return inode;
=20
 bad_inode:
 	iget_failed(inode);
+	trace_f2fs_iget_exit(inode, ret);
 	return ERR_PTR(ret);
 }
=20
@@ -239,6 +245,7 @@ void f2fs_evict_inode(struct inode *inode)
 	struct f2fs_sb_info *sbi =3D F2FS_SB(inode->i_sb);
 	int ilock;
=20
+	trace_f2fs_evict_inode(inode);
 	truncate_inode_pages(&inode->i_data, 0);
=20
 	if (inode->i_ino =3D=3D F2FS_NODE_INO(sbi) ||
diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index 1dbf11d..c57fd18 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -18,6 +18,7 @@
 #include "node.h"
 #include "xattr.h"
 #include "acl.h"
+#include <trace/events/f2fs.h>
=20
 static struct inode *f2fs_new_inode(struct inode *dir, umode_t mode)
 {
@@ -235,6 +236,7 @@ static int f2fs_unlink(struct inode *dir, struct
dentry *dentry)
 	int err =3D -ENOENT;
 	int ilock;
=20
+	trace_f2fs_unlink_enter(dir, dentry);
 	f2fs_balance_fs(sbi);
=20
 	de =3D f2fs_find_entry(dir, &dentry->d_name, &page);
@@ -255,6 +257,7 @@ static int f2fs_unlink(struct inode *dir, struct
dentry *dentry)
 	/* In order to evict this inode,  we set it dirty */
 	mark_inode_dirty(inode);
 fail:
+	trace_f2fs_unlink_exit(inode, err);
 	return err;
 }
=20
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 541f21ff..b015b6c 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -29,6 +29,9 @@
 #include "segment.h"
 #include "xattr.h"
=20
+#define CREATE_TRACE_POINTS
+#include <trace/events/f2fs.h>
+
 static struct kmem_cache *f2fs_inode_cachep;
=20
 enum {
@@ -134,6 +137,8 @@ int f2fs_sync_fs(struct super_block *sb, int sync)
 {
 	struct f2fs_sb_info *sbi =3D F2FS_SB(sb);
=20
+	trace_f2fs_sync_fs(sb, sync);
+
 	if (!sbi->s_dirty && !get_pages(sbi, F2FS_DIRTY_NODES))
 		return 0;
=20
diff --git a/include/trace/events/f2fs.h b/include/trace/events/f2fs.h
new file mode 100644
index 0000000..03bb0db
--- /dev/null
+++ b/include/trace/events/f2fs.h
@@ -0,0 +1,195 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM f2fs
+
+#if !defined(_TRACE_F2FS_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_F2FS_H
+
+#include <linux/tracepoint.h>
+
+#define show_dev(entry)		MAJOR(entry->dev), MINOR(entry->dev)
+#define show_dev_ino(entry)	show_dev(entry), (unsigned long)entry->ino
+
+DECLARE_EVENT_CLASS(f2fs__inode,
+
+	TP_PROTO(struct inode *inode),
+
+	TP_ARGS(inode),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(ino_t,	ino)
+		__field(ino_t,	pino)
+		__field(umode_t, mode)
+		__field(loff_t,	size)
+		__field(unsigned int, nlink)
+		__field(blkcnt_t, blocks)
+		__field(__u8,	advise)
+	),
+
+	TP_fast_assign(
+		__entry->dev	=3D inode->i_sb->s_dev;
+		__entry->ino	=3D inode->i_ino;
+		__entry->pino	=3D F2FS_I(inode)->i_pino;
+		__entry->mode	=3D inode->i_mode;
+		__entry->nlink	=3D inode->i_nlink;
+		__entry->size	=3D inode->i_size;
+		__entry->blocks	=3D inode->i_blocks;
+		__entry->advise	=3D F2FS_I(inode)->i_advise;
+	),
+
+	TP_printk("dev =3D (%d,%d), ino =3D %lu, pino =3D %lu, i_mode =3D 0x%hx, =
"
+		"i_size =3D %lld, i_nlink =3D %u, i_blocks =3D %llu, i_advise =3D 0x%x",
+		show_dev_ino(__entry),
+		(unsigned long)__entry->pino,
+		__entry->mode,
+		__entry->size,
+		(unsigned int)__entry->nlink,
+		(unsigned long long)__entry->blocks,
+		(unsigned char)__entry->advise)
+);
+
+DECLARE_EVENT_CLASS(f2fs__inode_exit,
+
+	TP_PROTO(struct inode *inode, int ret),
+
+	TP_ARGS(inode, ret),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(ino_t,	ino)
+		__field(int,	ret)
+	),
+
+	TP_fast_assign(
+		__entry->dev	=3D inode->i_sb->s_dev;
+		__entry->ino	=3D inode->i_ino;
+		__entry->ret	=3D ret;
+	),
+
+	TP_printk("dev =3D (%d,%d), ino =3D %lu, ret =3D %d",
+		show_dev_ino(__entry),
+		__entry->ret)
+);
+
+DEFINE_EVENT(f2fs__inode, f2fs_sync_file_enter,
+
+	TP_PROTO(struct inode *inode),
+
+	TP_ARGS(inode)
+);
+
+TRACE_EVENT(f2fs_sync_file_exit,
+
+	TP_PROTO(struct inode *inode, bool need_cp, int datasync, int ret),
+
+	TP_ARGS(inode, need_cp, datasync, ret),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(ino_t,	ino)
+		__field(bool,	need_cp)
+		__field(int,	datasync)
+		__field(int,	ret)
+	),
+
+	TP_fast_assign(
+		__entry->dev		=3D inode->i_sb->s_dev;
+		__entry->ino		=3D inode->i_ino;
+		__entry->need_cp	=3D need_cp;
+		__entry->datasync	=3D datasync;
+		__entry->ret		=3D ret;
+	),
+
+	TP_printk("dev =3D (%d,%d), ino =3D %lu, checkpoint is %s, "
+		"datasync =3D %d, ret =3D %d",
+		show_dev_ino(__entry),
+		__entry->need_cp ? "needed" : "not needed",
+		__entry->datasync,
+		__entry->ret)
+);
+
+TRACE_EVENT(f2fs_sync_fs,
+
+	TP_PROTO(struct super_block *sb, int wait),
+
+	TP_ARGS(sb, wait),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(int,	dirty)
+		__field(int,	wait)
+	),
+
+	TP_fast_assign(
+		__entry->dev	=3D sb->s_dev;
+		__entry->dirty	=3D F2FS_SB(sb)->s_dirty;
+		__entry->wait	=3D wait;
+	),
+
+	TP_printk("dev =3D (%d,%d), superblock is %s, wait =3D %d",
+		show_dev(__entry),
+		__entry->dirty ? "dirty" : "not dirty",
+		__entry->wait)
+);
+
+DEFINE_EVENT(f2fs__inode, f2fs_iget,
+
+	TP_PROTO(struct inode *inode),
+
+	TP_ARGS(inode)
+);
+
+DEFINE_EVENT(f2fs__inode_exit, f2fs_iget_exit,
+
+	TP_PROTO(struct inode *inode, int ret),
+
+	TP_ARGS(inode, ret)
+);
+
+DEFINE_EVENT(f2fs__inode, f2fs_evict_inode,
+
+	TP_PROTO(struct inode *inode),
+
+	TP_ARGS(inode)
+);
+
+TRACE_EVENT(f2fs_unlink_enter,
+
+	TP_PROTO(struct inode *dir, struct dentry *dentry),
+
+	TP_ARGS(dir, dentry),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(ino_t,	ino)
+		__field(loff_t,	size)
+		__field(blkcnt_t, blocks)
+		__field(const char *,	name)
+	),
+
+	TP_fast_assign(
+		__entry->dev	=3D dir->i_sb->s_dev;
+		__entry->ino	=3D dir->i_ino;
+		__entry->size	=3D dir->i_size;
+		__entry->blocks	=3D dir->i_blocks;
+		__entry->name	=3D dentry->d_name.name;
+	),
+
+	TP_printk("dev =3D (%d,%d), dir ino =3D %lu, i_size =3D %lld, "
+		"i_blocks =3D %llu, name =3D %s",
+		show_dev_ino(__entry),
+		__entry->size,
+		(unsigned long long)__entry->blocks,
+		__entry->name)
+);
+
+DEFINE_EVENT(f2fs__inode_exit, f2fs_unlink_exit,
+
+	TP_PROTO(struct inode *inode, int ret),
+
+	TP_ARGS(inode, ret)
+);
+#endif /* _TRACE_F2FS_H */
+
+ /* This part must be outside protection */
+#include <trace/define_trace.h>
--=20
1.8.1.3.566.gaa39828



--=20
Jaegeuk Kim
Samsung

--=-14VGBAi/5yLhVXEqi1dV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJRdmS4AAoJEEAUqH6CSFDS+0kP/1ijkX1abBK/SI7reLkT3FaQ
jyYas2SLV1KGNQubmbw9vBwOh8zt3EskmV5609dyyYLc+Ipbm4JF86XaxZK8soH1
4sosuVmQf4iC+K6ddaenl5FFxcbB6caEoOZB1Am4sSP7gWZz8HEnsAEp2uz6xodY
MlQ4IXpkkpGsSpk6KZX9zmJUAFTcyaXSXhmJxPP62ZdyF9PsqNvRzq+L3/UQ8Zig
I7gQd45qCRZE8614NzA+YANwSPNEnqPJDOWBoIgh8pHJG64xl+Mgmg39CSgZuThr
iDEiv+3zdd7l4xUyrAedDaQ5loyqLiG1bAqlvVNtHilHqF4RJy/rT+9FUeURXnpK
mtVDtkXZZNXySKtM7CTB+93C9YrjVjnbkTRlb9eaFK850j+LnGc/2mvQ859cenz9
o+Jp7h8ha0WOBxZtynjHx1kybOY18fFl5JLQZ5sIEzr1t2cn7/lHyLAEuLrwCnrG
a9yS+NY5GMOlnYacxdwzPkrQ5l2T3lieG8ERGBGBvi3w/IzJVwvxHaF/jNr7oZAW
yuOB7JKAhwtGjeaOcjozqojDm0/62gcwCqNkp/HLMcLWcWLjNAVKeU1faqdX1PFe
dxOSG+xMCDq44rHgzPM0iVx22df+gmbxXETnnCt4b6h6AiQCPsDLph37hH5Tz9R5
RT99cQh1qd6oeBzZzYng
=2WK2
-----END PGP SIGNATURE-----

--=-14VGBAi/5yLhVXEqi1dV--

