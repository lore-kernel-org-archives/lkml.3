Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759543Ab3DBA0b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 20:26:31 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:47789 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758444Ab3DBA02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 20:26:28 -0400
Date: Tue, 2 Apr 2013 11:26:27 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the vfs tree
Message-Id: <20130402112627.223048680be1397ad59cdcec@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__2_Apr_2013_11_26_27_+1100_SZq5CFA.y7qgc_2s"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__2_Apr_2013_11_26_27_+1100_SZq5CFA.y7qgc_2s
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

After merging the vfs tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

arch/powerpc/kernel/lparcfg.c:44:31: error: 'proc_ppc64_lparcfg' defined bu=
t not used [-Werror=3Dunused-variable]
cc1: all warnings being treated as errors

Caused by commit dfda3a48f2e7 ("lparcfg: don't bother saving pointer to
proc_dir_entry").

I have used the vfs tree form next-20130328 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__2_Apr_2013_11_26_27_+1100_SZq5CFA.y7qgc_2s
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRWiWzAAoJEECxmPOUX5FEmg0P/3cEKgmDuhbHJZkYQRGXNxz9
CN0m9+YF375u5gEgyQBOl8KBYL4rIDH3IuTz2yTkjE/sg8THuGp0NDaYugF9Nd8M
i1Lsc23O70QMtlDa/J1Wyk0EbVZh6ngqX4IJ7Rm0nsXPs1rJcTwLi4SYXnkvp6tY
Wd8jBs8864Hs/6cM6c7mjwZiDVIrcqqmnjNg2CyYWBdnN98bZFDzNTM2hc1ZPCtk
FI1jb+LOIh96MQAy58GWD4DZH0p36hcf+BizgSktbp9EmjAoQaPtODAgY3SzYiVj
YzcSRp+nAKqKgA8GPQhamKCiyjTNuOITetIpzgfInmYYpCkDtArZEcO0rPOyGLHu
J2NlLDxLIdgusgK30FLBFvBZNmm8Z9NJ8C2vYZ41FDTRWbueqBXtbFjtuj07RP6c
C6JAsrRQ7/ubGtpN1TrXHx5Lwj2ssVLpzca5dPUV5YU8mkIvFaqLWqq3dUEv7Q87
j9taUAe0WUNDFzqxeysN2KomWc/MdYGmJKnlfOqqxaWYdyH41TTeCZOk+4lsuUhN
b06Gwqe0EK4kfXF/5CHszbuKOqHGRNFuuLTRHPwwC+Mth/w1g2UlYPpgZqB9wKdP
DWWNiP14fk895Hwtw8zgw1hxJEwRIH9Cudu3u+qzaMabrBpc8jZMfEzLYeMqaKVB
nMaKlqgEJBRYcsWigFPi
=tUag
-----END PGP SIGNATURE-----

--Signature=_Tue__2_Apr_2013_11_26_27_+1100_SZq5CFA.y7qgc_2s--
