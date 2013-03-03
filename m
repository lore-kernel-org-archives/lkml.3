Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751526Ab3CCFFj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 00:05:39 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:18468 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806Ab3CCFFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 00:05:36 -0500
X-AuditID: cbfee690-b7f6b6d000004563-3b-5132da1f4c74
Message-id: <1362287099.14386.13.camel@kjgkr>
Subject: Re: [PATCH 4/5] f2fs: align f2fs maximum name length to linux based
 filesystem
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Date: Sun, 03 Mar 2013 14:04:59 +0900
In-reply-to: <1362195678-20785-1-git-send-email-linkinjeon@gmail.com>
References: <1362195678-20785-1-git-send-email-linkinjeon@gmail.com>
Organization: samsung
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary="=-rT+J0LE9EQSmPGMKDBeO"
X-Mailer: Evolution 3.2.3-0ubuntu6
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmleLIzCtJLcpLzFFi42I5/e+Zoa78LaNAg/knWS0u7k61uH73FrPF
	pUXuFnv2nmSxuLxrDpvFj+n1DmweO2fdZffYveAzk0ffllWMHp83yQWwRHHZpKTmZJalFunb
	JXBl/F8zgaXgv1bF1/XzWBsY96h0MXJySAiYSLyY3cAOYYtJXLi3nq2LkYtDSGAZo0T70qss
	MEXLfq1khEhMZ5Q4cfw3lPOaUeLG66WMIFW8AroSN07eZQaxhQUiJV60nAQaxcHBJqAtsXm/
	AUhYSEBR4u3+u6wgYREBNYkJz1JBxjAL7GKUOHZ0CdgyFgFViT8LzoON4RRwlfiwYw4TSL2Q
	gIvExDYrkDC/gKjEydZPYFuZBaokPtx8xwRxp5LE7vZOdohrBCV+TL7HAjJfQmAqh8TVBS2s
	EPMFJL5NPsQCMlNCQFZi0wFmiF5JiYMrbrBMYBSfhWTsLCSjIOKaEq3bf7ND2NoSyxa+Zoaw
	bSXWrXsPVWMjsenqAkYIW15i+9s5zAsY2VcxiqYWJBcUJ6UXmegVJ+YWl+al6yXn525ihMT0
	hB2M9w5YH2KsAjpxIrOUaHI+MCXklcQbGhubmJmYmphbmpqbUkVYSZxX/pJMoJBAemJJanZq
	akFqUXxRaU5q8SFGJg5OqQZGhWMKCS+zSzcGcH95UmJxO/pqvbCsxTy3yKXPo7Vnr8n/zrZe
	h/mvvPEfvzWtyt6JzIe9D14wyuTau+jWXr1PjHXn69mUQj712LqbL65de2/BFaNWYftLMk+q
	En22n6mva0uRmNATMqXphp9+lo/VI+nrz42E8pJfLdWRuyvw477v2xiPGR5KLMUZiYZazEXF
	iQCxWovhFgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphk+LIzCtJLcpLzFFi42I5/e+xoK7cLaNAgzvTbCwu7k61uH73FrPF
	pUXuFnv2nmSxuLxrDpvFj+n1DmweO2fdZffYveAzk0ffllWMHp83yQWwRDUw2mSkJqakFimk
	5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYArVZSKEvMKQUKBSQWFyvp
	22GaEBripmsB0xih6xsSBNdjZIAGEtYxZvxfM4Gl4L9Wxdf181gbGPeodDFyckgImEgs+7WS
	EcIWk7hwbz1bFyMXh5DAdEaJE8d/M0I4rxklbrxeClbFK6ArcePkXWYQW1ggUuJFy0mgDg4O
	NgFtic37DUDCQgKKEm/332UFCYsIqElMeJYKMoZZYBejxLGjS1hAalgEVCX+LDgPNoZTwFXi
	w445TCD1QgIuEhPbrEDC/AKiEidbP4FtZRaokvhw8x0TxJ1KErvbO9khrhGU+DH5HssERsFZ
	SMpmIUlBxDUlWrf/ZoewtSWWLXzNDGHbSqxb9x6qxkZi09UFjBC2vMT2t3OYFzCyr2IUTS1I
	LihOSs811CtOzC0uzUvXS87P3cQIThjPpHYwrmywOMQowMGoxMP7YpFRoBBrYllxZe4hRhWg
	OY82rL7AKMWSl5+XqiTCm7oHKM2bklhZlVqUH19UmpNafIhxIiMwNCYyS4km5wPTXF5JvKGx
	iZmRpZGZhZGJuTkthZXEeRlPPQkQEkhPLEnNTk0tSC2COYqJg1OqgXH/7UseL6wzNGcHL1h5
	WtZypUPI6xMtDbuDRXeLp659mJgxa9XpCW+Efi2r9n5o1F20QvVBx4/+1fdWd9sKrU5gFrNj
	vH2L+4bkTj+PXfps8hYHnpr72llkR6+PNch0uz6/a2f+b60FP2cJiOjMXr7M5tNxKb8DUiY3
	uLc8fv1Oqv7Js+WdK64psRRnJBpqMRcVJwIAWACeZZcDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-rT+J0LE9EQSmPGMKDBeO
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

We should not change the on-disk layout.
Instead, simply we can deal with it by changing original condition check
like below.

---
=46rom ccc2546eded1efd2d6ed98f8aee7d7ce247cb4a2 Mon Sep 17 00:00:00 2001
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
 include/linux/f2fs_fs.h | 14 ++++++++------
 4 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
index c395c50..4ac8a7b 100644
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
index f9a12f6..7b50991 100644
--- a/include/linux/f2fs_fs.h
+++ b/include/linux/f2fs_fs.h
@@ -139,6 +139,8 @@ struct f2fs_extent {
 	__le32 len;		/* lengh of the extent */
 } __packed;
=20
+/* We can store F2FS_MAX_NAME_LEN, but lets follow linux convention. */
+#define F2FS_NAME_LEN		255
 #define F2FS_MAX_NAME_LEN	256
 #define ADDRS_PER_INODE         923	/* Address Pointers in an Inode */
 #define ADDRS_PER_BLOCK         1018	/* Address Pointers in a Direct
Block */
@@ -362,10 +364,10 @@ struct f2fs_summary_block {
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
@@ -377,10 +379,10 @@ typedef __le32	f2fs_hash_t;
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
@@ -394,7 +396,7 @@ struct f2fs_dentry_block {
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

--=-rT+J0LE9EQSmPGMKDBeO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJRMtn7AAoJEEAUqH6CSFDS+YgQAIqp1P5Z8QJr/R8fwciRNGys
QHQGSSBZI3uJWdsCjpgmck0PVg89BIx7PFnNnLrel5xFuL8VHjIrFDoktWFuZb7L
47GgTHDzahnRsx2LShzJUDtz+iCkKTPiq00V3KZmRJ9u2/HpG14nLquZD6H0o/jt
9Qu28M+CG0HIFatMM6dfIWmmLW+fU+Xs67iwo7aJRtyNe9Q+WbefnHJq6GB2p4FK
230JxUfSXCXTYGyiq1ObQ1Sav4K8h7c+Zt7MiIGryyz/mItgEB5eOE4YI6KxustB
Q1tnEIH15uPqEmpIBf2Id2mEBLQOISMtIXQ7qIONLNEwrUDNFQaQ8+lpkQdWtKGJ
n0xfRDJjADFuchgQRrhOaYFPzhckO+A+AE8myIeXU2skAj9rQJbTAMd3LkERZGTn
jNWI2m3Yo7z9BjmMo9NKk3mDmcySjTxWqkEOajdF6DZHJ9oZ7y+xZdDrbkTniaXW
j2BjeFewakReZq3rI196HIeR3SF/eNpkwrr3oZoq4K74W6KvLAvjzbZsCdaRUppi
6uNytI+yvuCOQoHtAwGZDmZAKvqLn5wI4IKENSrbVWHj1+JzkPk0nx8FIol8PtHd
YDbI7+Jdf2U3MMTfZz4LIik/EP1vylloAo2p7sEhnjwSUNsLhlLijwS1C5cpmuMC
Xye3IJidBuTEOFsnDCWa
=gZax
-----END PGP SIGNATURE-----

--=-rT+J0LE9EQSmPGMKDBeO--

