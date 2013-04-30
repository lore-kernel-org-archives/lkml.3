Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759007Ab3D3C77 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 22:59:59 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:47271 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475Ab3D3C74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 22:59:56 -0400
X-AuditID: cbfee68f-b7f066d000003683-10-517f33a984ed
Message-id: <1367290734.16581.18.camel@kjgkr>
Subject: Re: [PATCH] f2fs: use f2fs_iget_nowait again
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Date: Tue, 30 Apr 2013 11:58:54 +0900
In-reply-to: <1367230878-10113-1-git-send-email-jaegeuk.kim@samsung.com>
References: <1367230878-10113-1-git-send-email-jaegeuk.kim@samsung.com>
Organization: samsung
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary="=-XaXEiLAgP4hBYuFGqc9b"
X-Mailer: Evolution 3.2.3-0ubuntu6
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNIsWRmVeSWpSXmKPExsVy+t8zfd2VxvWBBvPfmVpcWuRusWfvSRaL
	y7vmsDkwe+xe8JnJ4/MmuQCmKC6blNSczLLUIn27BK6MQ//+sRfclq5Y9+sZewPjDvEuRk4O
	CQETiZXzTzBD2GISF+6tZ+ti5OIQEljGKNGy9BgrTNGme9OgEosYJWbemMsC4bxmlJiwYAYT
	SBWvgK5E+5czYLawgKnEqQU7gbo5ONgEtCU27zcACQsJKEq83X8XLCwCZF9+7wRiMgt4SOw6
	VgpSwSKgKrHkw3k2EJsTKNzR3MMC0ekusejCPrBz+AVEJU62fmIEsZkFqiQ296+AOlNJYnd7
	JzvEMYISPybfA7tSQuAtu8SiZ59ZIBYISHybfIgFZK+EgKzEpgNQv0tKHFxxg2UCo/gsJGNn
	IRkFEdeUaN3+mx3C1pZYtvA1M4RtK7Fu3XuoGhuJTVcXMELY8hLb385hXsDIvopRNLUguaA4
	Kb3IWK84Mbe4NC9dLzk/dxMjJEb7dzDePWB9iLEK6MSJzFKiyfnAGM8riTc0NjOyMDUxNTYy
	tzSjirCSOK9ai3WgkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBkauIwp1HC/8d/A7SeZ526p6
	ff9vo/mf/6fphR1/rgq/6tPV3n3c9Gsl0/7ph6Z++xHF2naNge1St+h17rcFH9+u8flqHczT
	xH3UjWNbVZWqaPwuSU63eRUhiqzaLF4Lr+8wL2m6qJKgqjtnoyv/Ye6itYZd05b+8pvk65IQ
	05lnujNnPnvBTiWW4oxEQy3mouJEAOtC+vb+AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDKsWRmVeSWpSXmKPExsVy+t9jAd2VxvWBBvPOGFpcWuRusWfvSRaL
	y7vmsDkwe+xe8JnJ4/MmuQCmqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3Ml
	hbzE3FRbJRefAF23zBygHUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrG
	jEP//rEX3JauWPfrGXsD4w7xLkZODgkBE4lN96axQdhiEhfurQeyuTiEBBYxSsy8MZcFwnnN
	KDFhwQwmkCpeAV2J9i9nwGxhAVOJUwt2snYxcnCwCWhLbN5vABIWElCUeLv/LlhYBMi+/N4J
	xGQW8JDYdawUpIJFQFViyYfzYGs5gcIdzT0sEJ3uEosu7GMFsfkFRCVOtn5iBLGZBaokNvev
	YIU4U0lid3snO8QxghI/Jt9jmcAoOAtJ2SwkKYi4pkTr9t/sELa2xLKFr5khbFuJdeveQ9XY
	SGy6uoARwpaX2P52DvMCRvZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmbGMEJ4Jn0DsZVDRaH
	GAU4GJV4eHcsqQsUYk0sK67MPcSoAjTn0YbVFxilWPLy81KVRHjreOsDhXhTEiurUovy44tK
	c1KLDzFOZAQGx0RmKdHkfGDayiuJNzQ2MTOyNDKzMDIxN6elsJI478FW60AhgfTEktTs1NSC
	1CKYo5g4OKUaGKPDLU8GrzadoT35+Olt786zRbwzPS6rv3RS81a1yMk3kqSu7pr45EnlrFec
	Hmt92O+evPx7lojnFRbR9P3pfBb7Jd/fnmUrNv27aDebA795mr681gSdiMwUW881drd3HW94
	dOHlW989C4onnXJw2tB3cfpHqxuPTR9XqUusDVgh+3lBxsP13ziUWIozEg21mIuKEwEAKfOM
	fwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-XaXEiLAgP4hBYuFGqc9b
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

change log from v1:
 o found another deadlock case, so change the approach

=46rom 145b6ee0b2523bad0e28c09f4ac5bb050cd22085 Mon Sep 17 00:00:00 2001
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
 fs/f2fs/super.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index b015b6c..e1c54e4 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -99,6 +99,13 @@ static struct inode *f2fs_alloc_inode(struct
super_block *sb)
 	return &fi->vfs_inode;
 }
=20
+static int f2fs_drop_inode(struct inode *inode)
+{
+	if (inode->i_state & I_SYNC)
+		return 0;
+	return generic_drop_inode(inode);
+}
+
 static void f2fs_i_callback(struct rcu_head *head)
 {
 	struct inode *inode =3D container_of(head, struct inode, i_rcu);
@@ -233,6 +240,7 @@ static int f2fs_show_options(struct seq_file *seq,
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

--=-XaXEiLAgP4hBYuFGqc9b
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJRfzNuAAoJEEAUqH6CSFDSq2IP/3p0Wjaqxfr4XfcckqXBSo2n
dQ3iCgYakLRFkXTnSXFQdqqSdeYFhZRvMW0W51sRTAhKwGLCk3pL57CFO3YW5mIU
0YY4j1KsiZ+d0I6E+JF11lHDSKUXm6tTmEgNAysu61EsBy+qw75QNq4hlmvrCjmw
z4oFsG/qr+IlLjuInqRdeW6RfH3sFNkpKtfRBlWzUvrrnJqybilC0Y3cOEqHdkTe
HfvzVL3hbTA+8y4JbVlrHYuzmUVH5Dx0r07M+f54kBfIzz6jIbbSoPyfBFoyAmke
7l9YH2XaPs5sYkzVjyTKPqB3PnI+F0icMUJl5dZdEIrCN0A14JjuVpi4DY6gIWli
gB08HzKJSnbrYbFpqQvinJJkLzkssGwQdMGRmLZeEKwdqIhGOjCuq6AmEb5/LcQ8
FKsXeMoI9n6ML4p2imFgGsXpsdAirpYuKSHW+s5zBUZxUXLZQGaO6jvNTXgWGI5q
dllZF2Ptdag7MVrz2pFgUg6vBjjTla3kmpZVYCLNJKSftkzoLrZq1lUC7XWnaHvg
pIAl99sp21+c/+XkND5dOTwTU4MQBOmXBY6knNfUyyg2VvmipbTrhfvLt22gGzEf
dzUcQhlp4mpk3o5IHizFJuU4OuzyvcfZ0LqAoqN+W3mjD+Js3jmx0Bzk9600HtSO
sh+ACtT4SjpgfWeTWqWh
=43jh
-----END PGP SIGNATURE-----

--=-XaXEiLAgP4hBYuFGqc9b--

