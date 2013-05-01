Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752464Ab3EAEj0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 00:39:26 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:41340 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157Ab3EAEjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 00:39:18 -0400
X-AuditID: cbfee68d-b7f016d000007930-4d-51809c74f842
Message-id: <1367383096.16581.36.camel@kjgkr>
Subject: Re: [PATCH v3] f2fs: use f2fs_iget_nowait again
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Date: Wed, 01 May 2013 13:38:16 +0900
In-reply-to: <1367290734.16581.18.camel@kjgkr>
References: <1367230878-10113-1-git-send-email-jaegeuk.kim@samsung.com>
 <1367290734.16581.18.camel@kjgkr>
Organization: samsung
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary="=-jKmkGtYyAhKpAdCTAgG9"
X-Mailer: Evolution 3.2.3-0ubuntu6
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFIsWRmVeSWpSXmKPExsVy+t8zfd2SOQ2BBtMnSFlcWuRusWfvSRaL
	y7vmsDkwe+xe8JnJ4/MmuQCmKC6blNSczLLUIn27BK6M+7u3sRUcV6loOb+GvYHxkFwXIyeH
	hICJxOpb01khbDGJC/fWs3UxcnEICSxjlNj/bj4LXNHVSewQiUWMEn+fT2CFcF4zSrycNgOs
	nVdAV2LTvT9gHcICFhLrXhxh7GLk4GAT0JbYvN8AJCwkoCjxdv9dVpCwCJB9+b0TiMks4CGx
	61gpiMkioCpx+aQaSDGngJ7Em6ebWSAasyUe/f4CZvMLiEqcbP3ECGIzC1RJrHozkR3iSiWJ
	3e2d7BC3CEr8mHyPBeRICYG37BJLGyaANbMICEh8m3yIBWSXhICsxKYDzBC9khIHV9xgmcAo
	PgvJ2FlIRkHENSVat/9mh7C1JZYtfM0MYdtKrFv3HqrGRmLT1QWMELa8xPa3c5gXMLKvYhRN
	LUguKE5KLzLUK07MLS7NS9dLzs/dxAiJ0N4djLcPWB9irAI6cSKzlGhyPjDC80riDY3NjCxM
	TUyNjcwtzagirCTOq9ZiHSgkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qBMab64CXXpUbXmMSE
	Pvl0Myn8uqBdaVfsueFQ8cJGZRGNI48fLD3+OWmGINvKgo0Su17Uykq8Dph+LqZo/e9mE41X
	bJyH9K0uP9nClz6h+37Lj/p+zjuXpPR33fj4r/737OeT4u87rDt4qY3b4sEtmY17BBx6p4te
	uHJPW+NZ5sXMnRzJ1y3N1yixFGckGmoxFxUnAgBEu1R1/QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNKsWRmVeSWpSXmKPExsVy+t9jAd2SOQ2BBhOmiVpcWuRusWfvSRaL
	y7vmsDkwe+xe8JnJ4/MmuQCmqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3Ml
	hbzE3FRbJRefAF23zBygHUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrG
	jPu7t7EVHFepaDm/hr2B8ZBcFyMnh4SAicTqq5PYIWwxiQv31rN1MXJxCAksYpT4+3wCK4Tz
	mlHi5bQZrCBVvAK6Epvu/WEBsYUFLCTWvTjC2MXIwcEmoC2xeb8BSFhIQFHi7f67rCBhESD7
	8nsnEJNZwENi17FSEJNFQFXi8kk1kGJOAT2JN083s0A0Zks8+v0FzOYXEJU42fqJEcRmFqiS
	WPVmItSVShK72zvZIW4RlPgx+R7LBEbBWUjKZiFJQcQ1JVq3/2aHsLUlli18zQxh20qsW/ce
	qsZGYtPVBYwQtrzE9rdzmBcwsq9iFE0tSC4oTkrPNdQrTswtLs1L10vOz93ECI7/Z1I7GFc2
	WBxiFOBgVOLh3XGhPlCINbGsuDL3EKMK0JxHG1ZfYJRiycvPS1US4eWY0hAoxJuSWFmVWpQf
	X1Sak1p8iHEiIzA0JjJLiSbnA5NWXkm8obGJmZGlkZmFkYm5OS2FlcR5D7RaBwoJpCeWpGan
	phakFsEcxcTBKdXAWDvD3N35t4qVs6TVwy9vQ6L4NPrzjjXkXLFRyu5xYVyr52o0W+W65ebo
	EqcVQSyy5tEHhd/P6BFduIGn6qawot2SwLSutSVlIt9T+uW/+Bu4JtV4ZL4o09tR6VAusyJ3
	cn10v7+SUW921vmzkftWv+oXOvRawONswH/jkrxNfIvOb+aUOqDEUpyRaKjFXFScCAAEgHGu
	fgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-jKmkGtYyAhKpAdCTAgG9
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

change log from v2:
  o slighly change the previous approach

=46rom 42e49df33bacafc20434e39fc127c9722c9f8691 Mon Sep 17 00:00:00 2001
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Date: Tue, 30 Apr 2013 11:33:27 +0900
Subject: [PATCH] f2fs: avoid deadlock during evict after f2fs_gc
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
linux-f2fs-devel@lists.sourceforge.net

o Deadlock case #1

Thread 1:
- writeback_sb_inodes
 - do_writepages
  - f2fs_write_data_pages
   - write_cache_pages
    - f2fs_write_data_page
     - f2fs_balance_fs
      - wait mutex_lock(gc_mutex)

Thread 2:
- f2fs_balance_fs
 - mutex_lock(gc_mutex)
 - f2fs_gc
  - f2fs_iget
   - wait iget_locked(inode->i_lock)

Thread 3:
- do_unlinkat
 - iput
  - lock(inode->i_lock)
   - evict
    - inode_wait_for_writeback

o Deadlock case #2

Thread 1:
- __writeback_single_inode
 : set I_SYNC
  - do_writepages
   - f2fs_write_data_page
    - f2fs_balance_fs
     - f2fs_gc
      - iput
       - evict
        - inode_wait_for_writeback(I_SYNC)

In order to avoid this, even though iput is called with the
zero-reference
count, we need to stop the eviction procedure if the inode is on
writeback.
So this patch links f2fs_drop_inode which checks the I_SYNC flag.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/f2fs.h  |  1 +
 fs/f2fs/gc.c    |  1 +
 fs/f2fs/super.c | 19 +++++++++++++++++++
 3 files changed, 21 insertions(+)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 20aab02..beb3f06 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -846,6 +846,7 @@ enum {
 	FI_INC_LINK,		/* need to increment i_nlink */
 	FI_ACL_MODE,		/* indicate acl mode */
 	FI_NO_ALLOC,		/* should not allocate any blocks */
+	FI_ON_GC,		/* indicate inode is on gc */
 };
=20
 static inline void set_inode_flag(struct f2fs_inode_info *fi, int flag)
diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index 1496159..258b786 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -345,6 +345,7 @@ repeat:
 	}
 	new_ie->inode =3D inode;
 	list_add_tail(&new_ie->list, ilist);
+	set_inode_flag(F2FS_I(inode), FI_ON_GC);
 }
=20
 static void put_gc_inode(struct list_head *ilist)
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 5835aaf..6ac1f42 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -98,6 +98,24 @@ static struct inode *f2fs_alloc_inode(struct
super_block *sb)
 	return &fi->vfs_inode;
 }
=20
+static int f2fs_drop_inode(struct inode *inode)
+{
+	int drop =3D generic_drop_inode(inode);
+
+	/*
+	 * This is to avoid a deadlock condition like below.
+	 * writeback_single_inode(inode)
+	 *  - f2fs_write_data_page
+	 *    - f2fs_gc -> iput -> evict
+	 *       - inode_wait_for_writeback(inode)
+	 */
+	if (inode->i_state & I_SYNC &&
+			is_inode_flag_set(F2FS_I(inode), FI_ON_GC))
+		drop =3D 0;
+	clear_inode_flag(F2FS_I(inode), FI_ON_GC);
+	return drop;
+}
+
 static void f2fs_i_callback(struct rcu_head *head)
 {
 	struct inode *inode =3D container_of(head, struct inode, i_rcu);
@@ -232,6 +250,7 @@ static int f2fs_show_options(struct seq_file *seq,
struct dentry *root)
=20
 static struct super_operations f2fs_sops =3D {
 	.alloc_inode	=3D f2fs_alloc_inode,
+	.drop_inode	=3D f2fs_drop_inode,
 	.destroy_inode	=3D f2fs_destroy_inode,
 	.write_inode	=3D f2fs_write_inode,
 	.show_options	=3D f2fs_show_options,
--=20
1.8.1.3.566.gaa39828



--=20
Jaegeuk Kim
Samsung

--=-jKmkGtYyAhKpAdCTAgG9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJRgJw4AAoJEEAUqH6CSFDS8TkP/2ON+R8+dLShPdEf9kNm9XiY
/BEZwJ7dazgr4Xi4HVMJW2T40FVyHQsGsGj7BNVyN9MXgC+wazCKXDqNmvu6z4Ai
3czaUHWmDn8ZoN8kMM4tkQyMWeJ0iIu3JZ9w+HKmBbgZpPvA1iSRE3FcJ+3XVNM7
d6ObPAaDhDr8kyX0qhu5P8qsee6kGd7E6PhXu6bWgm7cPYperxyYSzThvD9Sfo/2
iN7lDElPkEcv7tuLgVNZtzjTM0jTgXJTnBuZTOLAjjpN+MDsLCfhWYVgfDsUzCOp
4/YDHJmV0939H7lofKgOE7y3e1DirbkDeq+6dqm+WYQhJ1NVMOuo3Br1fuTkrayv
ANF0nX4s94sG2NOK8rpDm9IW+MJMJ+/ddNCErodOLNYo4h25puGcS6Gj1yDhfQZF
ay45Pj1KdnRUlU/XfXz7X5i/cpgVsabcs7j6b7Tp+MqXbP8Ejr1W31A8fpzBshks
qO4LreJleNZsIMvW2loBUuD9/0zVW49lNcIpPcgfUWqqjVXUTohuccpIiU6xnMsS
iQWSoVSh/ukxTQTCW4Oir22T5toCWoE9giXQ2NcP9GWQtxeP3NIFckXKJpzWrtTg
kVLu/OkZlHx5GZGrwbuSDT7tXEIi/TuzqZGulYSPVGeHTKhnvjbJefvlWaxCiISB
UjCKRknZbWoCCiL7b6Ei
=lAXl
-----END PGP SIGNATURE-----

--=-jKmkGtYyAhKpAdCTAgG9--

