Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932789Ab3CDWZ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 17:25:58 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:35878 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932367Ab3CDWZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 17:25:57 -0500
Date: Tue, 5 Mar 2013 09:25:47 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: error fetching the osd tree
Message-Id: <20130305092547.be2378f0caa8c2139865de87@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__5_Mar_2013_09_25_47_+1100_6aL4NqQkTUAMTEXE"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__5_Mar_2013_09_25_47_+1100_6aL4NqQkTUAMTEXE
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Boaz,

Fetching the osd tree
(git://git.open-osd.org/linux-open-osd.git#linux-next) produces this
error:

fatal: read error: Connection reset by peer

It has been doing that for a few days, now.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__5_Mar_2013_09_25_47_+1100_6aL4NqQkTUAMTEXE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRNR9rAAoJEECxmPOUX5FEZtkP/2w1c/XxWZ1FAANrr0j6JG36
iuAGKS+BABmPooaYAFSMREZ9juNaGqRo7g3ojWAoPXMnbhtXaF0/VLPRC4xPdNj1
0CvbHeZHAc1VP948ZpzUR18gtBJhMh1nrj9x8fmKdziSvcxGPuGT53Nd7IhfFwGc
HxFUOvUWoaYCvgeTBptk3mGQZwmBDNyQM5+t9aVNksAM1OGhldx09SM5dal1wLjo
xpm/xlJ3zd+584W4UJFfFpjT/EFhqH0d0nGMNEotEsB2bc/J3g5o84grWUyDdPGU
MvC7qvrNg4FYhJ/znA3dW8f4cFu8i9ud1WX/qaxfIwK/63ABnBagsWChmq1oSRBh
dAacGiC71KZRN0XuPx16aowVWMHYUnH9q9rv/XCuH1sNcjUgD7hMXsjZONaj17TG
NS+hzcypfCfGsBJObM4MhjYLrDf1rwKuOZ/fNsLPwFql9Ut7SSZWhLlXUDK3ur9u
KzkM1OsrYfC8whvW80RldfPYKfTAOcVTHOgqfGVQcT3stWUPeHxhU0ZOw2tzXpyM
lUY8nW7JGI31dlnJ8F2wVhtJx50n1lQZIvmCG+AxiMn6Yh489bIvpIqQtlnzLOv+
pNaFRDdNX22EnKxENaM0YZhVbBTllTB9XVsDJVI+KyI//WrivC+C6Fa4oD0YsYmQ
L49MA+9om8/c7I9CySjA
=c0Ev
-----END PGP SIGNATURE-----

--Signature=_Tue__5_Mar_2013_09_25_47_+1100_6aL4NqQkTUAMTEXE--
