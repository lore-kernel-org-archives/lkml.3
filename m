Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756220Ab3AOIC3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 03:02:29 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:11574 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611Ab3AOIC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 03:02:28 -0500
X-AuditID: cbfee61b-b7f616d00000319b-e3-50f50d12965e
Message-id: <1358236943.8234.56.camel@kjgkr>
Subject: Re: [PATCH 4/4] f2fs: add blk plugging support in f2fs
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Date: Tue, 15 Jan 2013 17:02:23 +0900
In-reply-to: <CAKYAXd_tnM1arONxpx0pvnftGHvdxwLWJSFXVfdzrAUJe5taWQ@mail.gmail.com>
References: <1357969323-9396-1-git-send-email-linkinjeon@gmail.com>
 <1358128249.23942.6.camel@kjgkr>
 <CAKYAXd-f_rLJ5YdtsOX40XiGcNFivPTiXJ5kt03E-AOpuinMMQ@mail.gmail.com>
 <1358217615.8234.35.camel@kjgkr>
 <CAKYAXd_tnM1arONxpx0pvnftGHvdxwLWJSFXVfdzrAUJe5taWQ@mail.gmail.com>
Organization: samsung
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary="=-d1X//NyzqymR402E8j5y"
X-Mailer: Evolution 3.2.3-0ubuntu6
MIME-version: 1.0
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnleLIzCtJLcpLzFFi42I5/e+Zoa4Q79cAg/M9OhZ79p5ksbi8aw6b
	A5PH501yAYxRXDYpqTmZZalF+nYJXBlLTpxgKvivVPFo8WG2BsZPsl2MnBwSAiYS83uOMUHY
	YhIX7q1n62Lk4hASWMYoMfHyOVaYop6lj5kgEosYJVa9XAvlvGaUeHz8NBtIFa+AjsStyZeZ
	uxg5OIQF7CXW3aoCMdkEtCU27zcAqRASUJR4u/8uK0hYREBNYsKzVJApzAK7GCWOHV3CAlLD
	IqAqseTFUmYQm1MgWGL2lb2sEKumM0k8OroQLMEvICpxsvUTI4jNLFAlsenVTxaIQ5Ukdrd3
	skOcIyjxY/I9qKECEt8mH2IBWSwhICux6QAzyEwJgUfsEgsaX0H1SkocXHGDZQKj+CwkY2ch
	GQUR15Ro3f6bHcLWlli28DUzhG0rsW7de6gaG4lNVxcwQtjyEtvfzmFewMi+ilE0tSC5oDgp
	PddIrzgxt7g0L10vOT93EyMkKqV3MK5qsDjEKMDBqMTDe1P3S4AQa2JZcWXuIUYVoDmPNqy+
	wCjFkpefl6okwuvzDijNm5JYWZValB9fVJqTWnyIMRno04nMUqLJ+cBEklcSb2hsbGJmYmpi
	bmlqbkqasJI4L+OpJwFCAumJJanZqakFqUUwW5g4OKUaGGck+my6vPfUvl3SE5tMlhc+9t/h
	/7L423v2BTWbd/UJ597s6TT9P9fyioiwxtZm65vzevSkvra+v83OlzXj/a9t1+WDDl64HnxS
	Z95tzqXnb2Xf3nvi4bvORQv6EyVMotOXszAH55vcl4lbWskVPp1z3prjvwPd2h/KzS18svLY
	c4vb868Gn12vxFKckWioxVxUnAgA1/NUXRoDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGKsWRmVeSWpSXmKPExsVy+t9jAV0h3q8BBgveqVrs2XuSxeLyrjls
	DkwenzfJBTBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gCNVlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFmLDlxgqngv1LF
	o8WH2RoYP8l2MXJySAiYSPQsfcwEYYtJXLi3nq2LkYtDSGARo8Sql2uZIJzXjBKPj59mA6ni
	FdCRuDX5MnMXIweHsIC9xLpbVSAmm4C2xOb9BiAVQgKKEm/332UFCYsIqElMeJYKMoVZYBej
	xLGjS1hAalgEVCWWvFjKDGJzCgRLzL6ylxVi1XQmiUdHF4Il+AVEJU62fmIEsZkFqiQ2vfrJ
	AnGoksTu9k52iHMEJX5MvscygVFwFpKyWUhSEHFNidbtv9khbG2JZQtfM0PYthLr1r2HqrGR
	2HR1ASOELS+x/e0c5gWM7KsYRVMLkguKk9JzjfSKE3OLS/PS9ZLzczcxgmP+mfQOxlUNFocY
	BTgYlXh4b+p+CRBiTSwrrsw9xKgCNOfRhtUXGKVY8vLzUpVEeH3eAaV5UxIrq1KL8uOLSnNS
	iw8xJgODYyKzlGhyPjBN5ZXEGxqbmBlZGplZGJmYm5MmrCTOy3jqSYCQQHpiSWp2ampBahHM
	FiYOTqkGRtskEXGWXb4d3TqzzPxtrj9TOKnvupFpYsbqQ3O17zKGZaRMt7PVsHNbvWZ9wao8
	9eenGFb8Oxnlwy5i+Kp64qa56iI8wtn/xaZdmyAfXMHSqHpF5ta7zqq7a3e2v31/IqpihqrS
	EtbDbvf+XPhx6OULM5lJ3cfrC7VSzh3nvfkxe32I8trD3EosxRmJhlrMRcWJAPiL93xJAwAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-d1X//NyzqymR402E8j5y
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> Yes, You're right. I agree block plug is not needed in f2fs. So plz
> ignore this patch.
> note =3D> Regardless of the intent in the patch, it has already been
> used in writepages (f2fs uses generic_writepages).
> So to make the overall code consistent, either we should remove blk
> plug from entire F2FS write part or change f2fs_write_data_pages to
> include blk plug properly - like the code change for this part we
> share in the patch.

Agreed. :)
How about this patch?

=46rom 09e11ac9734cd085f9a92c46098fb083091f5429 Mon Sep 17 00:00:00 2001
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Date: Tue, 15 Jan 2013 16:45:24 +0900
Subject: [PATCH] f2fs: remove the blk_plug usage in
f2fs_write_data_pages

From: Namjae Jeon <namjae.jeon@samsung.com>

Let's consider the usage of blk_plug in f2fs_write_data_pages().
We can come up with the two issues: lock contention and task awareness.

1. Merging bios prior to grabing "queue lock"
 The f2fs merges consecutive IOs in the file system level before
 submitting any bios, which is similar with the back merge by the
 plugging mechanism in attempt_plug_merge(). Both of them need to
acquire no queue lock.

2. Merging policy with respect to tasks
 The f2fs merges IOs as much as possible regardless of tasks, while
 blk-plugging is conducted on a basis of tasks. As we can understand
 there are trade-offs, f2fs tries to maximize the write performance with
 well-merged bios.

As a result, if f2fs produces many consecutive but separated bios in
writepages(), it would be good to use blk-plugging since f2fs would be
able to avoid queue lock contention in the block layer by merging them.
But, f2fs merges IOs and submit one bio, which means that there are not
much chances to merge bios by attempt_plug_merge().

However, f2fs has already been used blk_plug by triggering
generic_writepages()
in f2fs_write_data_pages().
So to make the overall code consistency, I'd like to remove blk_plug
there.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/data.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 3aa5ce7..b1347fc 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -547,6 +547,15 @@ redirty_out:
=20
 #define MAX_DESIRED_PAGES_WP	4096
=20
+static int __f2fs_writepage(struct page *page, struct writeback_control
*wbc,
+			void *data)
+{
+	struct address_space *mapping =3D data;
+	int ret =3D mapping->a_ops->writepage(page, wbc);
+	mapping_set_error(mapping, ret);
+	return ret;
+}
+
 static int f2fs_write_data_pages(struct address_space *mapping,
 			    struct writeback_control *wbc)
 {
@@ -563,7 +572,7 @@ static int f2fs_write_data_pages(struct
address_space *mapping,
=20
 	if (!S_ISDIR(inode->i_mode))
 		mutex_lock(&sbi->writepages);
-	ret =3D generic_writepages(mapping, wbc);
+	ret =3D write_cache_pages(mapping, wbc, __f2fs_writepage, mapping);
 	if (!S_ISDIR(inode->i_mode))
 		mutex_unlock(&sbi->writepages);
 	f2fs_submit_bio(sbi, DATA, (wbc->sync_mode =3D=3D WB_SYNC_ALL));
--=20
1.8.0.1.250.gb7973fb

--=20
Jaegeuk Kim
Samsung

--=-d1X//NyzqymR402E8j5y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJQ9Q0PAAoJEEAUqH6CSFDSqigP/3t0uT+Lx6nXcYav2BQj44/x
y9ip/+6Up78bQLDBw2Rd7DG15w1PncSwNxwk/T9soL/P9gB0bRyLE+zWnDfWQIpY
eJ6srMtOLowOwS+9v3VccG3JDjymTQ2Z7qhtA0JG738a4FA5YyOYFL0I/01brAvV
A321MWHT6ZHWYAk7LYG+8YcFxmrRSxhK6XJIsv0tzZ48OqomVYayf8TElvj1OjKz
p6fPzIPQTwa+eFisSPFDKqXXnn47RN8sa2dP97hPA90jGGog2mJkKZUsi7jHSfNr
wd/ViL5Wz6g4sp7qvIuOomWzctcfHJmf6mc+hhDqvwmZ40UBD6ATVLCHnQ1hkYuM
d3YpQB8NKSu19TD3HTuCH1Sw+FHGTwEnbAkdEq8rFldwswvzS7N0ntiYXpksy3mY
qi0PnlYPMPGC4N16aIcy4UDQAlX5DZC8a2ctGlADNTh2v2aIlVpZBF39ALhumnaS
WFTFFL5R92jl53PKL1XeP3APItISeZNKOmk6GK67ZGMVX1LpfE0rOcDxnR46WDuj
9S52WIWMz3WrZnlGE5LRxfvuOaxryJZwpkrP0xOyGUYsQItbwbmzdIC4PQ5oSkx3
rQAHwwXnJzauxHr9sQbHdtWyKPeZsM0yQlM2LFE2fpR5PRKD2tpgRmcN4s5c+ksi
2AYBZr2BB4ZLiIGNcSHJ
=EV8M
-----END PGP SIGNATURE-----

--=-d1X//NyzqymR402E8j5y--

