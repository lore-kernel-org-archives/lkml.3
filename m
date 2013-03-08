Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933513Ab3CHCjd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 21:39:33 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:55938 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754830Ab3CHCjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 21:39:31 -0500
X-AuditID: cbfee690-b7f6b6d000004563-fe-51394f62fdc6
Message-id: <1362710332.14386.38.camel@kjgkr>
Subject: Re: [PATCH 4/5] f2fs: align f2fs maximum name length to linux based
 filesystem
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Date: Fri, 08 Mar 2013 11:38:52 +0900
In-reply-to: <CAKYAXd8VzmxdrUq-vCbhDpLWirmUUxRjj_-5FUmNutBG5cojVA@mail.gmail.com>
References: <1362195678-20785-1-git-send-email-linkinjeon@gmail.com>
 <1362287099.14386.13.camel@kjgkr>
 <CAKYAXd8VzmxdrUq-vCbhDpLWirmUUxRjj_-5FUmNutBG5cojVA@mail.gmail.com>
Organization: samsung
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary="=-o9OKe71PX4R3KWu113o2"
X-Mailer: Evolution 3.2.3-0ubuntu6
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkleLIzCtJLcpLzFFi42I5/e+ZgW6Sv2WgwarHKhYXd6daXL97i9ni
	0iJ3iz17T7JYXN41h83ix/R6BzaPnbPusnvsXvCZyaNvyypGj8+b5AJYorhsUlJzMstSi/Tt
	ErgyTkz/wVLw3aziz/ZWpgbGBr0uRk4OCQETiWW9C1khbDGJC/fWs3UxcnEICSxjlJj+fDaQ
	wwFW9K8rHqRGSGA6o8TZjiKImteMEivuLGYESfAK6Eq8/ABSz8khLBAp8aLlJFgvm4C2xOb9
	BhC9ihJv999lBQmLCKhJTHiWCjKGWWAXo8Sxo0tYQOIsAqoSk97EgJRzCgRLLFq3jRWidT2j
	xJrFpSA2v4CoxMnWT2BbmQWqJNbMu8QOcb6SxO72TnaIawQlfky+xwIyX0JgIofEtPMHwBpY
	BAQkvk0+xALxlqzEpgPMEL2SEgdX3GCZwCg+C8nYWUhGQcQ1JVq3/2aHsLUlli18zQxh20qs
	W/ceqsZGYtPVBYwQtrzE9rdzmBcwsq9iFE0tSC4oTkovMtErTswtLs1L10vOz93ECInnCTsY
	7x2wPsRYBXTiRGYp0eR8YDrIK4k3NDY2MTMxNTG3NDU3pYqwkjiv/CWZQCGB9MSS1OzU1ILU
	ovii0pzU4kOMTBycUg2Mdim5O/dM27rb8Eyr3HP9k6oTNxz/Vy9Q1N/pd7v9yYIDSzj4fy9P
	rOiq03pen7uXpVvFOGu6/NzvX52CnH9kKMnL91hx9SQ/Xml0LnEm71/BMO7Ls760bZ7jN0Xk
	a8ESp/+TuFXlVjak/Lo2K3JCmdM6Z9NbXIJModt/Blkqxi+pmaf80KdLiaU4I9FQi7moOBEA
	2O1k8xQDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpik+LIzCtJLcpLzFFi42I5/e+xoG6Sv2WgwbYPshYXd6daXL97i9ni
	0iJ3iz17T7JYXN41h83ix/R6BzaPnbPusnvsXvCZyaNvyypGj8+b5AJYohoYbTJSE1NSixRS
	85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOAVisplCXmlAKFAhKLi5X0
	7TBNCA1x07WAaYzQ9Q0JgusxMkADCesYM05M/8FS8N2s4s/2VqYGxga9LkYODgkBE4l/XfFd
	jJxAppjEhXvr2UBsIYHpjBJnO4q6GLmA7NeMEivuLGYESfAK6Eq8/DAbrEhYIFLiRctJNpA5
	bALaEpv3G0D0Kkq83X+XFSQsIqAmMeFZKsgYZoFdjBLHji5hAYmzCKhKTHoTA1LOKRAssWjd
	NlaI1vWMEmsWl4LY/AKiEidbP4FtZRaoklgz7xI7xJlKErvbO9khrhGU+DH5HssERsFZSMpm
	IUlBxDUlWrf/ZoewtSWWLXzNDGHbSqxb9x6qxkZi09UFjBC2vMT2t3OYFzCyr2IUTS1ILihO
	Ss811CtOzC0uzUvXS87P3cQIThbPpHYwrmywOMQowMGoxMNbsckiUIg1say4MvcQowrQnEcb
	Vl9glGLJy89LVRLh/S1jGSjEm5JYWZValB9fVJqTWnyIcSIjMDQmMkuJJucDU1xeSbyhsYmZ
	kaWRmYWRibk5LYWVxHkZTz0JEBJITyxJzU5NLUgtgjmKiYNTqoFx6k7/nNd3n9+xyNNYsCDq
	2EyNrnhOlTkSfy4Khv/m3jF3y0zZbfOf/8ndld+i/711+4FFtSun/Fx3YVHssoYLP1alnVM4
	sIFb8MlDh1op7+Xnf4vobC+Yqvuaa0GN9OXSf0eM2BZfEHCLtRRJLBSvvLShTsetdn0xV5hY
	r9eTnAftiUfP55c1KrEUZyQaajEXFScCAG9FPnuVAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-o9OKe71PX4R3KWu113o2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

2013-03-04 (=EC=9B=94), 15:25 +0900, Namjae Jeon:
> 2013/3/3, Jaegeuk Kim <jaegeuk.kim@samsung.com>:
> > We should not change the on-disk layout.
> > Instead, simply we can deal with it by changing original condition chec=
k
> > like below.
>=20
> Even though the changes you suggested are ok. But there is one doubt.
> By not changing the on-disk layout and just taking care of the limits
> using the code is just causing confusion and looks a make-shift
> arrangement.
> Even though =E2=80=98256=E2=80=99 is the space reserved for the name =E2=
=80=98on-disk=E2=80=99 but by
> changing the code =E2=80=93 we are limiting it to use =E2=80=98255=E2=80=
=99.
> If we chance the on-disk to make use of =E2=80=98255=E2=80=99 bytes it al=
lows for
> keeping all code intact and also like the code changes suggested, it
> will still refer only the =E2=80=98255=E2=80=99 bytes.
>=20
> More so, changing the on-disk allows for =E2=80=981byte=E2=80=99 which is=
 still padded
> at the same position to be used in future. Otherwise, this =E2=80=98extra=
=E2=80=99
> byte will continue to exist without having that to be used for some
> extra work.

Agreed, but it still needs to change a couple of names.
How about this?

=46rom 2ce7f345559d967bc1c79959885dff9f0a713e32 Mon Sep 17 00:00:00 2001
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Date: Sun, 3 Mar 2013 13:58:05 +0900
Subject: [PATCH] f2fs: align f2fs maximum name length to linux based
filesystem
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
linux-f2fs-devel@lists.sourceforge.net

The maximum filename length supported in linux is 255 characters.
So let's follow that.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/dir.c           |  3 +++
 fs/f2fs/namei.c         |  2 +-
 fs/f2fs/super.c         |  2 +-
 include/linux/f2fs_fs.h | 17 +++++++++--------
 4 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
index a1f3844..2851ae6 100644
--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -189,6 +189,9 @@ struct f2fs_dir_entry *f2fs_find_entry(struct inode
*dir,
 	unsigned int max_depth;
 	unsigned int level;
=20
+	if (namelen > F2FS_NAME_LEN)
+		return NULL;
+
 	if (npages =3D=3D 0)
 		return NULL;
=20
diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index 1a49b88..d4a171b 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -197,7 +197,7 @@ static struct dentry *f2fs_lookup(struct inode *dir,
struct dentry *dentry,
 	struct f2fs_dir_entry *de;
 	struct page *page;
=20
-	if (dentry->d_name.len > F2FS_MAX_NAME_LEN)
+	if (dentry->d_name.len > F2FS_NAME_LEN)
 		return ERR_PTR(-ENAMETOOLONG);
=20
 	de =3D f2fs_find_entry(dir, &dentry->d_name, &page);
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 8c11764..1c7f595 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -180,7 +180,7 @@ static int f2fs_statfs(struct dentry *dentry, struct
kstatfs *buf)
 	buf->f_files =3D sbi->total_node_count;
 	buf->f_ffree =3D sbi->total_node_count - valid_inode_count(sbi);
=20
-	buf->f_namelen =3D F2FS_MAX_NAME_LEN;
+	buf->f_namelen =3D F2FS_NAME_LEN;
 	buf->f_fsid.val[0] =3D (u32)id;
 	buf->f_fsid.val[1] =3D (u32)(id >> 32);
=20
diff --git a/include/linux/f2fs_fs.h b/include/linux/f2fs_fs.h
index f9a12f6..df6fab8 100644
--- a/include/linux/f2fs_fs.h
+++ b/include/linux/f2fs_fs.h
@@ -139,7 +139,7 @@ struct f2fs_extent {
 	__le32 len;		/* lengh of the extent */
 } __packed;
=20
-#define F2FS_MAX_NAME_LEN	256
+#define F2FS_NAME_LEN		255
 #define ADDRS_PER_INODE         923	/* Address Pointers in an Inode */
 #define ADDRS_PER_BLOCK         1018	/* Address Pointers in a Direct
Block */
 #define NIDS_PER_BLOCK          1018	/* Node IDs in an Indirect Block
*/
@@ -165,7 +165,8 @@ struct f2fs_inode {
 	__le32 i_flags;			/* file attributes */
 	__le32 i_pino;			/* parent inode number */
 	__le32 i_namelen;		/* file name length */
-	__u8 i_name[F2FS_MAX_NAME_LEN];	/* file name for SPOR */
+	__u8 i_name[F2FS_NAME_LEN];	/* file name for SPOR */
+	__u8 i_reserved2;		/* for backward compatibility */
=20
 	struct f2fs_extent i_ext;	/* caching a largest extent */
=20
@@ -362,10 +363,10 @@ struct f2fs_summary_block {
 typedef __le32	f2fs_hash_t;
=20
 /* One directory entry slot covers 8bytes-long file name */
-#define F2FS_NAME_LEN		8
-#define F2FS_NAME_LEN_BITS	3
+#define F2FS_SLOT_LEN		8
+#define F2FS_SLOT_LEN_BITS	3
=20
-#define GET_DENTRY_SLOTS(x)	((x + F2FS_NAME_LEN - 1) >>
F2FS_NAME_LEN_BITS)
+#define GET_DENTRY_SLOTS(x)	((x + F2FS_SLOT_LEN - 1) >>
F2FS_SLOT_LEN_BITS)
=20
 /* the number of dentry in a block */
 #define NR_DENTRY_IN_BLOCK	214
@@ -377,10 +378,10 @@ typedef __le32	f2fs_hash_t;
 #define SIZE_OF_DENTRY_BITMAP	((NR_DENTRY_IN_BLOCK + BITS_PER_BYTE -
1) / \
 					BITS_PER_BYTE)
 #define SIZE_OF_RESERVED	(PAGE_SIZE - ((SIZE_OF_DIR_ENTRY + \
-				F2FS_NAME_LEN) * \
+				F2FS_SLOT_LEN) * \
 				NR_DENTRY_IN_BLOCK + SIZE_OF_DENTRY_BITMAP))
=20
-/* One directory entry slot representing F2FS_NAME_LEN-sized file name
*/
+/* One directory entry slot representing F2FS_SLOT_LEN-sized file name
*/
 struct f2fs_dir_entry {
 	__le32 hash_code;	/* hash code of file name */
 	__le32 ino;		/* inode number */
@@ -394,7 +395,7 @@ struct f2fs_dentry_block {
 	__u8 dentry_bitmap[SIZE_OF_DENTRY_BITMAP];
 	__u8 reserved[SIZE_OF_RESERVED];
 	struct f2fs_dir_entry dentry[NR_DENTRY_IN_BLOCK];
-	__u8 filename[NR_DENTRY_IN_BLOCK][F2FS_NAME_LEN];
+	__u8 filename[NR_DENTRY_IN_BLOCK][F2FS_SLOT_LEN];
 } __packed;
=20
 /* file types used in inode_info->flags */
--=20
1.8.1.3.566.gaa39828




--=20
Jaegeuk Kim
Samsung

--=-o9OKe71PX4R3KWu113o2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJROU88AAoJEEAUqH6CSFDSv1YP/259fGP63PkHotho2Vk5JIAV
bQRuclM1KuTAwfFI4MNsPNLeTtFeLR1AhSPns0XuA8ItWrnMIlftMLOkjv07FTzS
Jeq6/0/Fw4/glQ0/b9pDXJaSxy8fdDADkBzlucEmmtBtbcI5t6PYSVqbXwlxRf1I
ozs0Hn651RhDR/vJwQsewaF+bSbmm3Ub79wd8e9Zy3wxHirwASTZyQAnaoiZutYG
ZDX8Nfr/I+mk6iMQDY14RXBmKIgVVP6jG//gVPP8FCa6HXV9PNTn1oDp3heRgFE4
YVwT4+m9gjXR4hM9HFS8DFCBY7JvVyL6Yuc5JVRARlZ80xtnYz2G5Hql3yC/ofQ9
c/Gzi5bxzq17jlML1tVFVF8f/dSG6TTEXT939IoKjWyoscXboQrSc2Lxp5pfrYES
IqwBwjspQzFgMNHQ8KJ5nk+65jx08RKv5OQ9HM4WHiBB31BHxlIMwarhewVu4Aad
efkESLhMJjAGxqURRx4WfVXP+Zz9pupyMOD4g1mLTqRtUU/fB6EAIJltUkltP3BM
cTnuoy/xaxboi2MGNNFtFqBg3mx1KAs6oTY5SYUt06OXqzaYYYraosx8pL0q9o7U
4cLuB19C3eYRrD6UeKS5Uw80ds7Zptzyt9fE/8U5cVpMixEl3Xvq+jQpzJzc7YMP
JWbq08+EhPuTzOyjFfKM
=fk8l
-----END PGP SIGNATURE-----

--=-o9OKe71PX4R3KWu113o2--

