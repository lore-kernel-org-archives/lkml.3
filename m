Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756778Ab3D2CmY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Apr 2013 22:42:24 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:9789 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756629Ab3D2CmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Apr 2013 22:42:21 -0400
X-AuditID: cbfee68d-b7f016d000007930-88-517dde0bca04
Message-id: <1367203280.16581.3.camel@kjgkr>
Subject: Re: [PATCH 1/2] f2fs: reorganize f2fs_vm_page_mkwrite
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Date: Mon, 29 Apr 2013 11:41:20 +0900
In-reply-to: <1367107458-2439-1-git-send-email-linkinjeon@gmail.com>
References: <1367107458-2439-1-git-send-email-linkinjeon@gmail.com>
Organization: samsung
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary="=-Pgy511eU+ALbmoBN9LLj"
X-Mailer: Evolution 3.2.3-0ubuntu6
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkleLIzCtJLcpLzFFi42I5/e+ZsS7PvdpAg49TGS0u7k61uH73FrPF
	pUXuFnv2nmSxuLxrDpvFj+n1DmweO2fdZffYveAzk0ffllWMHp83yQWwRHHZpKTmZJalFunb
	JXBlbHhwka1gv2TFkfO72BsY74l2MXJwSAiYSLzdVNHFyAlkiklcuLeerYuRi0NIYBmjxLaG
	pUwQCROJ1R8bWSES0xklFtw6xwjhvGaU+HV9GhtIFa+AjsStXQdYQaYKC9hJdJ9zBTHZBLQl
	Nu83AKkQElCUeLv/LliFiICaxIRnqSBTmAV2MUqc/DsXbAqLgKrE7bVXmEBqOAVcJLZf5YBo
	dZb4c3k+I4jNLyAqcbL1E5jNLFAlcfvdWqgzlSR2t3eyQxwjKPFj8j0WkPkSAr0cEmu6pjJB
	zBeQ+Db5EAvE77ISmw4wQ/RKShxccYNlAqP4LCRjZyEZBRHXlGjd/psdwtaWWLbwNTOEbSux
	bt17qBobiU1XFzBC2PIS29/OYV7AyL6KUTS1ILmgOCm9yFCvODG3uDQvXS85P3cTIySee3cw
	3j5gfYixCujEicxSosn5wHSQVxJvaGxmZGFqYmpsZG5pRhVhJXFetRbrQCGB9MSS1OzU1ILU
	ovii0pzU4kOMTBycUg2M/tfLnk5fLl9oe1dpRb7Sst5Ig5v9CopVeY7cid4RbB+sJkyYnetb
	t9G4eoPjPMcVZ5d837t1CXu+6VMOnsmzWh3OnfuW9dI78ckJLdkPvlOuzBLMEesumPZZqKdH
	N77zlnILm4f7Jva+jkz1+V+fL3pZzay45nJTQCpbkUyQ5YRYM4WMDk8lluKMREMt5qLiRACG
	aqF+FAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmk+LIzCtJLcpLzFFi42I5/e+xoC73vdpAgwMLLS0u7k61uH73FrPF
	pUXuFnv2nmSxuLxrDpvFj+n1DmweO2fdZffYveAzk0ffllWMHp83yQWwRDUw2mSkJqakFimk
	5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYArVZSKEvMKQUKBSQWFyvp
	22GaEBripmsB0xih6xsSBNdjZIAGEtYxZmx4cJGtYL9kxZHzu9gbGO+JdjFyckgImEis/tjI
	CmGLSVy4t56ti5GLQ0hgOqPEglvnGCGc14wSv65PYwOp4hXQkbi16wBQBweHsICdRPc5VxCT
	TUBbYvN+A5AKIQFFibf774JViAioSUx4lgoyhVlgF6PEyb9zwaawCKhK3F57hQmkhlPARWL7
	VQ6IVmeJP5fnM4LY/AKiEidbP4HZzAJVErffrWWCOFNJYnd7JzvEMYISPybfY5nAKDgLSdks
	JCmIuKZE6/bf7BC2tsSyha+ZIWxbiXXr3kPV2EhsurqAEcKWl9j+dg7zAkb2VYyiqQXJBcVJ
	6bmGesWJucWleel6yfm5mxjB6eKZ1A7GlQ0WhxgFOBiVeHgDNtcGCrEmlhVX5h5iVAGa82jD
	6guMUix5+XmpSiK8s28DpXlTEiurUovy44tKc1KLDzFOZASGxkRmKdHkfGCSyyuJNzQ2MTOy
	NDKzMDIxN6elsJI474FW60AhgfTEktTs1NSC1CKYo5g4OKUaGDu/T76a88Fv6a7YU5/nbcrR
	FbtS4uJsdvar2asq+QOV8lPKFO4qPf0is5tzz/tVHb7/1JNiGxxYfHKN5z5Z2mZkyd3luEpJ
	39islOExh47n8u9XZCTt9NeHs/fffB2+ct79JfM8iwQCTBMYdPpNf7ybOsUzbc1x3ZfXfqVL
	xeyV2SeZ+H/KFyWW4oxEQy3mouJEAP/fE22WAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Pgy511eU+ALbmoBN9LLj
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

2013-04-28 (=EC=9D=BC), 09:04 +0900, Namjae Jeon:
> From: Namjae Jeon <namjae.jeon@samsung.com>
>=20
> Few things can be changed in the default mkwrite function
> 1) Make file_update_time at the start before acquiring any lock
> 2) the condition page_offset(page) >=3D i_size_read(inode) should be
>  changed to page_offset(page) > i_size_read
> 3) Move wait_on_page_writeback.
>=20
> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
> ---
>  fs/f2fs/file.c |   12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>=20
> diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
> index 5cc4dd8..dc76f9b 100644
> --- a/fs/f2fs/file.c
> +++ b/fs/f2fs/file.c
> @@ -63,9 +63,10 @@ static int f2fs_vm_page_mkwrite(struct vm_area_struct =
*vma,
>  	f2fs_put_dnode(&dn);
>  	mutex_unlock_op(sbi, ilock);
> =20
> +	file_update_time(vma->vm_file);

Should we update time even if error is occurred below?

>  	lock_page(page);
>  	if (page->mapping !=3D inode->i_mapping ||
> -			page_offset(page) >=3D i_size_read(inode) ||
> +			page_offset(page) > i_size_read(inode) ||

Why? IMO, there was no problem.

>  			!PageUptodate(page)) {
>  		unlock_page(page);
>  		err =3D -EFAULT;
> @@ -76,10 +77,7 @@ static int f2fs_vm_page_mkwrite(struct vm_area_struct =
*vma,
>  	 * check to see if the page is mapped already (no holes)
>  	 */
>  	if (PageMappedToDisk(page))
> -		goto out;
> -
> -	/* fill the page */
> -	wait_on_page_writeback(page);
> +		goto mapped;
> =20
>  	/* page is wholly or partially inside EOF */
>  	if (((page->index + 1) << PAGE_CACHE_SHIFT) > i_size_read(inode)) {
> @@ -90,7 +88,9 @@ static int f2fs_vm_page_mkwrite(struct vm_area_struct *=
vma,
>  	set_page_dirty(page);
>  	SetPageUptodate(page);
> =20
> -	file_update_time(vma->vm_file);
> +mapped:
> +	/* fill the page */
> +	wait_on_page_writeback(page);
>  out:
>  	sb_end_pagefault(inode->i_sb);
>  	return block_page_mkwrite_return(err);

--=20
Jaegeuk Kim
Samsung

--=-Pgy511eU+ALbmoBN9LLj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJRfd3QAAoJEEAUqH6CSFDSEPgP/032U2PNyWDFz+6FDvOEPaPs
KzzxAZbj+Lrpm745+Cv+aNZEiJ3IT2pwuJLirWfB5TSaQ3HWTqkpA8PNeBItMIwx
Cu3II8PAZKKeTq89ZCrogqjCMNrMDB4HktCL9Lemscc9hAW5nOdTlD6OZs4rABvP
rgYg3gmJI5wX39f8JFIuOqZVNBw+OYsTH92lsV4Vx4G3xOyW1+HsDX89XGOhGASb
/MR9XcXT6Cc/kIeGO3iOm2fEhdXbG9g+wbqGw7aeiylsk6brRuOxH4rh3gkKk6Tu
x1Va7CR3yD5ocCFBymp1K/tfc3dicl92r9oGLph1rbeLqLQCiNzjKiW0dH2XV6F2
fHcmJx99c/V7TKoJCApERr0mR4yQMoZt95dInSXgQDHNg0ABDcx9Tdv4vr7fUOoy
/9aQ3Bp7Decq1j4hZyvn/PASx6n99QubXs8C1HjW6gNZbBfMFih6dviTF1ifsRhY
Cz9hHIm9/ohJsc/Jg7r1ffahgcq+mw903/EWeEgDQiocQYA77zhgHNCfgukHZfre
0jQJUQjxwRA8AHNi0agVwSh2TmeAzVGn8pR5L+4e9B1aAheqGMQCdIFhlOhvI9I7
WYDPCsgv+F7AR7lYfHBBTB6KbqLIoEfdXI3UIByOBlCv/U0ATqTjG1IV2G9VB7SA
GnzQd1/ixeEHpyvDM/IG
=dz9C
-----END PGP SIGNATURE-----

--=-Pgy511eU+ALbmoBN9LLj--

