Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759768Ab3DCINp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 04:13:45 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:12906 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759693Ab3DCINk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 04:13:40 -0400
X-AuditID: cbfee68d-b7f786d000005188-b0-515be4b2a6ca
Message-id: <1364976769.4353.11.camel@kjgkr>
Subject: Re: [PATCH 3/9 v2] f2fs: remove redundant lock_page calls
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Date: Wed, 03 Apr 2013 17:12:49 +0900
In-reply-to: <CAKYAXd_rkU5t=OOxjTu0CtKHfrTYkbJuJ2ZFNd=aaRsuToHU7A@mail.gmail.com>
References: <1364799360-23145-1-git-send-email-jaegeuk.kim@samsung.com>
 <1364799360-23145-3-git-send-email-jaegeuk.kim@samsung.com>
 <CAKYAXd_rkU5t=OOxjTu0CtKHfrTYkbJuJ2ZFNd=aaRsuToHU7A@mail.gmail.com>
Organization: samsung
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary="=-006IVRJAovTliGRfMyUl"
X-Mailer: Evolution 3.2.3-0ubuntu6
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKIsWRmVeSWpSXmKPExsVy+t8zA91NT6IDDda/UrW4fvcWs8WlRe4W
	e/aeZLG4vGsOmwOLx85Zd9k9di/4zOTxeZNcAHMUl01Kak5mWWqRvl0CV8bxmS9ZCq7qVJw6
	sIe9gbFDtYuRk0NCwETi2cobrBC2mMSFe+vZuhi5OIQEljFKHO29yNLFyAFW1NuoChGfzihx
	4et5VgjnNaPEqbcn2EC6eQV0JLbPO8MMYgsLOEk8PPyPGaSZTUBbYvN+A5CwkICixNv9d1lB
	wiICahITnqWChJkFMiXmvJ4MdgOLgKrE3W8rwUo4BYIl7j/2g9h0hlFi39HzYDX8AqISJ1s/
	MUL0VklMvPKfCeJ+JYnd7Z3sENcISvyYfI8FpFlC4C+7xN81+5ggFghIfJt8COovWYlNB5gh
	eiUlDq64wTKBUXwWkrGzkIyCiGtKtG7/zQ5ha0ssW/iaGcK2lVi37j1UjY3EpqsLGCFseYnt
	b+cwL2BkX8UomlqQXFCclF5kqFecmFtcmpeul5yfu4kREre9OxhvH7A+xFgFdOJEZinR5Hxg
	3OeVxBsamxlZmJqYGhuZW5pRRVhJnFetxTpQSCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUAyO/
	s6KtRoLWSpY3glp7xLLFbi8SPBiy/VOvofr8O4yrjzxtlb6/TvcNY/DMViOVw+pJKb80jGsv
	ymY+OVN4ZPnOi0XL9mm41mfpHDK6IW8SpJtpcMVpo/9prre/rv2TrWC9ef5RkfOuyS7irXaC
	B6R/v72u1BH1Un/+66suQhJpja3nRCrqDiqxFGckGmoxFxUnAgA9N2SCCAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGKsWRmVeSWpSXmKPExsVy+t9jQd1NT6IDDWafVrC4fvcWs8WlRe4W
	e/aeZLG4vGsOmwOLx85Zd9k9di/4zOTxeZNcAHNUA6NNRmpiSmqRQmpecn5KZl66rZJ3cLxz
	vKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtA2JYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+
	IUFwPUYGaCBhHWPG8ZkvWQqu6lScOrCHvYGxQ7WLkYNDQsBEorcRyOQEMsUkLtxbz9bFyMUh
	JDCdUeLC1/OsEM5rRolTb0+wgVTxCuhIbJ93hhnEFhZwknh4+B8zyCA2AW2JzfsNQMJCAooS
	b/ffZQUJiwioSUx4lgoSZhbIlJjzejIriM0ioCpx99tKsBJOgWCJ+4/9IDadYZTYd/Q8WA2/
	gKjEydZPjBC9VRITr/xngrhTSWJ3eyc7xDWCEj8m32OZwCg4C0nZLCQpiLimROv23+wQtrbE
	soWvmSFsW4l1695D1dhIbLq6gBHClpfY/nYO8wJG9lWMoqkFyQXFSem5hnrFibnFpXnpesn5
	uZsYwUnhmdQOxpUNFocYBTgYlXh4T3yJChRiTSwrrsw9xKgCNOfRhtUXGKVY8vLzUpVEeDmP
	RwcK8aYkVlalFuXHF5XmpBYfYpzICAyOicxSosn5wFSWVxJvaGxiZmRpZGZhZGJuTkthJXHe
	A63WgUIC6YklqdmpqQWpRTBHMXFwSjUwhjlfP75SwCDqi2XairZ13ybN+lW+3VQsSJXXaOud
	p7VLd3NFffrCHJvvX/NgrtIk8aVHw4SyXG2291x4ZrPpe9jM+jc8dVk7XCO2OpsfTb7edbVl
	rrfL95fNVSIzDxdu+uL+fkOKsfGSGzMj9Sq0zj7VeHRNm/V0981cHktBr42Tl+5/fm/zeSWW
	4oxEQy3mouJEAJF03ZCJAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-006IVRJAovTliGRfMyUl
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

Agreed, and send v2.

Change log from v1:
 o remain read_node_page and remove the lock part

=46rom 04006aecac2882c574fe8a7de926bc52c73a8ad1 Mon Sep 17 00:00:00 2001
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Date: Sun, 31 Mar 2013 12:47:20 +0900
Subject: [PATCH] f2fs: remove redundant lock_page calls
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
linux-f2fs-devel@lists.sourceforge.net

In get_node_page, we do not need to call lock_page all the time.

If the node page is cached as uptodate,

1. grab_cache_page locks the page,
2. read_node_page unlocks the page, and
3. lock_page is called for further process.

Let's avoid this.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/node.c | 44 +++++++++++++++++++++++++++-----------------
 fs/f2fs/node.h |  3 +++
 2 files changed, 30 insertions(+), 17 deletions(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 10cbee9..e3484b5 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -847,6 +847,12 @@ fail:
 	return ERR_PTR(err);
 }
=20
+/*
+ * Caller should do after getting the following values.
+ * 0: f2fs_put_page(page, 0)
+ * LOCKED_PAGE: f2fs_put_page(page, 1)
+ * error: nothing
+ */
 static int read_node_page(struct page *page, int type)
 {
 	struct f2fs_sb_info *sbi =3D F2FS_SB(page->mapping->host->i_sb);
@@ -859,10 +865,8 @@ static int read_node_page(struct page *page, int
type)
 		return -ENOENT;
 	}
=20
-	if (PageUptodate(page)) {
-		unlock_page(page);
-		return 0;
-	}
+	if (PageUptodate(page))
+		return LOCKED_PAGE;
=20
 	return f2fs_readpage(sbi, page, ni.blk_addr, type);
 }
@@ -874,6 +878,7 @@ void ra_node_page(struct f2fs_sb_info *sbi, nid_t
nid)
 {
 	struct address_space *mapping =3D sbi->node_inode->i_mapping;
 	struct page *apage;
+	int err;
=20
 	apage =3D find_get_page(mapping, nid);
 	if (apage && PageUptodate(apage)) {
@@ -886,30 +891,36 @@ void ra_node_page(struct f2fs_sb_info *sbi, nid_t
nid)
 	if (!apage)
 		return;
=20
-	if (read_node_page(apage, READA) =3D=3D 0)
+	err =3D read_node_page(page, READA);
+	if (err =3D=3D 0)
 		f2fs_put_page(apage, 0);
+	else if (err =3D=3D LOCKED_PAGE)
+		f2fs_put_page(apage, 1);
 	return;
 }
=20
 struct page *get_node_page(struct f2fs_sb_info *sbi, pgoff_t nid)
 {
-	int err;
-	struct page *page;
 	struct address_space *mapping =3D sbi->node_inode->i_mapping;
+	struct page *page;
+	int err;
=20
 	page =3D grab_cache_page(mapping, nid);
 	if (!page)
 		return ERR_PTR(-ENOMEM);
=20
 	err =3D read_node_page(page, READ_SYNC);
-	if (err)
-		return ERR_PTR(err);
+	if (err < 0)
+		return ERR_PTR(ret);
+	else if (err =3D=3D LOCKED_PAGE)
+		goto got_it;
=20
 	lock_page(page);
 	if (!PageUptodate(page)) {
 		f2fs_put_page(page, 1);
 		return ERR_PTR(-EIO);
 	}
+got_it:
 	BUG_ON(nid !=3D nid_of_node(page));
 	mark_page_accessed(page);
 	return page;
@@ -923,10 +934,9 @@ struct page *get_node_page_ra(struct page *parent,
int start)
 {
 	struct f2fs_sb_info *sbi =3D F2FS_SB(parent->mapping->host->i_sb);
 	struct address_space *mapping =3D sbi->node_inode->i_mapping;
-	int i, end;
-	int err =3D 0;
-	nid_t nid;
 	struct page *page;
+	int err, i, end;
+	nid_t nid;
=20
 	/* First, try getting the desired direct node. */
 	nid =3D get_nid(parent, start, false);
@@ -936,12 +946,12 @@ struct page *get_node_page_ra(struct page *parent,
int start)
 	page =3D grab_cache_page(mapping, nid);
 	if (!page)
 		return ERR_PTR(-ENOMEM);
-	else if (PageUptodate(page))
-		goto page_hit;
=20
 	err =3D read_node_page(page, READ_SYNC);
-	if (err)
-		return ERR_PTR(err);
+	if (err < 0)
+		return ERR_PTR(ret);
+	else if (err =3D=3D LOCKED_PAGE)
+		goto page_hit;
=20
 	/* Then, try readahead for siblings of the desired node */
 	end =3D start + MAX_RA_NODE;
@@ -956,7 +966,7 @@ struct page *get_node_page_ra(struct page *parent,
int start)
 	lock_page(page);
=20
 page_hit:
-	if (PageError(page)) {
+	if (!PageUptodate(page)) {
 		f2fs_put_page(page, 1);
 		return ERR_PTR(-EIO);
 	}
diff --git a/fs/f2fs/node.h b/fs/f2fs/node.h
index d009cdf..271a61c 100644
--- a/fs/f2fs/node.h
+++ b/fs/f2fs/node.h
@@ -29,6 +29,9 @@
 /* vector size for gang look-up from nat cache that consists of radix
tree */
 #define NATVEC_SIZE	64
=20
+/* return value for read_node_page */
+#define LOCKED_PAGE	1
+
 /*
  * For node information
  */
--=20
1.8.1.3.566.gaa39828




--=20
Jaegeuk Kim
Samsung

--=-006IVRJAovTliGRfMyUl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJRW+SBAAoJEEAUqH6CSFDSAlsP/Rod1VqkaEJcDgb3uns+iRMn
dv4gahcIszg3EL42MFRYp0EhPX9qawAQd4TU/fmEtEpfq4ycvR0Jk3Bqrg6wAAq6
FkQYxICxB14ydmtiLkOvYrd0cGSEu0zUFzQXgWAxfkBIBBe31Ar1W6bQR+zn1Hiw
inuAMKWjtUu9vxNyWNA0uQhG/gJ4au8sLdpmeq8Dm+ZKHrAVCMeyJvNbIP1OTK3K
NEw4SOdHnpUT0GsZpUHwucwEn6HVBlbzJxD7lzc3fkJmw807PyuFkLF2hClQrORr
cBv7D/HK7ir+yojPsZe5vDv2Zj2HzX0T5c7rvK/QHnuk29nPbBgTzckJTc2tQ+Tp
GjrqVgpMUvQ6pHMP+1h9B97Ud37vrfArOFJ648/xixBX2FH1M5KGmqWDz9FKqTr7
ok1L6SPwaC4ooK+QmAjMbUaIqcs2Y4oT6OhCYgQlwf0frLpyiMTyLKa21L3h2JYl
MTYJZ8xVIt2gsl+ofiWUt8hzav3TjfKDJ8ej/xUUFsuNAmLd7UpoakejuLAKuYyA
7dMPOd+wWQJXIQ76qRT5OGvCdws/A5wH/EfZKetd7BuaSC4hhQmQpdNpftbqCqaZ
zrOQZ3zwqbfC02+bER/9sBUkTJiHrcQw49ct6i5ugdI0h09LPnIF8v3Nte51I/3H
A17p5OIy5JSkHFmPplg8
=axMp
-----END PGP SIGNATURE-----

--=-006IVRJAovTliGRfMyUl--

