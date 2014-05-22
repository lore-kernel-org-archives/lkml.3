Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753167AbaEVCNA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 22:13:00 -0400
Received: from ozlabs.org ([103.22.144.67]:38927 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750965AbaEVCM6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 22:12:58 -0400
Date: Thu, 22 May 2014 12:12:50 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Simon Horman <horms@verge.net.au>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the renesas tree with the arm-soc tree
Message-ID: <20140522121250.0648dfec@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/eG9faOgSaC+6b8uERwIW38S"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/eG9faOgSaC+6b8uERwIW38S
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Simon,

Today's linux-next merge of the renesas tree got a conflict in
arch/arm/boot/dts/r8a7790-lager.dts between commit 637193b2f22c ("Merge
branch 'next/boards' into for-next") from the arm-soc tree and commit
2a3bd7497db1 ("Merge branch 'heads/dt-scif-for-v3.16' into next") from
the renesas tree.

I fixed it up (I used the latter since it kept the trailing semi-colon)
and can carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/eG9faOgSaC+6b8uERwIW38S
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTfV0nAAoJEMDTa8Ir7ZwVWgMP/jiZ1fgVBuelNao/vxaWbtp7
SGi7T491nw5PO70KjrXqBgPp9W4bQX6HXAUa+2gyh38EefNmZJXJ7ikeaJ1VWG2r
CLxnNTIeojq5/K9usflVRkWN0pjMWiNsDYSiYqw6TJKuxrQvo4hs2XvHH5qqcptI
NHhcp34dRC9HcupE2CkqVIjwsF+YM8akQAbHu+og/L7ikgSVZAw7zGpwcFVHNUyQ
KcUsdq8bjnWbnX6YuDBNw3zwPAxsqdhnMWUFNx8POmjVsDjpg0hR+kdK52aXGPAJ
R1Q8QHolsv4Ik85vyRzhMxbdA1NRtpEiiGGNJJWmkZGoLHqUXhYw2hNRneoo+NY6
3qtekC1veeZiLiaAWt+xjlHyLDYf5TiTRerR4Ds2G9ok/Zeu1eTEHv2KS4jP/vSk
4MYEaCO8hycGEGYIEPXaZ6kwtbDDv0fD1T75CsI7ALWIf0Zx17LgF86geVA4axYJ
K2064uslc+kQIXWJ/nZ6P5oAV66KEAuYnbraTRgSyKA6pXSYdV7YR01YaJHPHbHe
QIMQsDX1JEq38ir8D9Y1uwsAtXgvypExxm5oDn2dq0zKWdMiBgpsKdME6cVQlVVi
GBWOnBBUYNH8anDEVYbNAghn5Vq48cmk67LFLwQHunHlzwy0QCaNibRzR2AvF+2N
nxz+/hbKk7ZqqTagA3P3
=VBNc
-----END PGP SIGNATURE-----

--Sig_/eG9faOgSaC+6b8uERwIW38S--
