Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382AbaIZB5s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 21:57:48 -0400
Received: from ozlabs.org ([103.22.144.67]:56240 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753321AbaIZB5p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 21:57:45 -0400
Date: Fri, 26 Sep 2014 11:57:34 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: error trying to fetch the devicetree tree
Message-ID: <20140926115734.15aef23e@canb.auug.org.au>
In-Reply-To: <20140925144432.1794fdbe@canb.auug.org.au>
References: <20140925144432.1794fdbe@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/uZ8GbnzS_TguzzatoxU8Udj"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/uZ8GbnzS_TguzzatoxU8Udj
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Grant,

On Thu, 25 Sep 2014 14:44:32 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> Fetching the devicetree tree
> (git://git.secretlab.ca/git/linux-2.6#devicetree/next) failes like this:
>=20
> fatal: Could not read from remote repository.
>=20
> Please make sure you have the correct access rights
> and the repository exists.

I changed to using git://git.secretlab.ca/git/linux (since that is what
you asked Linus to pull) and that seems to work.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/uZ8GbnzS_TguzzatoxU8Udj
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUJMgXAAoJEMDTa8Ir7ZwVqhAP+wWlFPl8rLBtlgmOeKhNICZp
G49w9G7hg9DsKKWZlK9Im/kkE/89p1FnX8Wmf1qxBNpin8qNT4Jh2gjcL/2PBeJC
qzMizibOyDsxduCzL2/kKKmxZ1dQDaZ1UFI/ZZKuHIAaMp547aGSsFSkyG6aPC/W
BucLq0iTW5Fp/Pnsr65wbYxOsK5iJE1YuPmW5PS9TKQY+How0XGcUbMbYD8F2Iqx
+fcxan3lfR4zqLSNUejIXkoHs/JH27/Ns1NYBtRobcG0Kq2CIoMa6HnQLroRFlTO
gW3ilWMZ1RxAubKBGbjXXVujrVv+TzGWJ2CB7nG0+iShtSXUsdhoCYbYjlzEplAA
PtYE+RKWve84EeDcddLGWYpo76GY/Dgkv7FF1fMtLvEM5oF54BKOv7cmPgGJ/9tq
OQdCs7GAIYSIZvJ+Lh7sJXNcnEmnKTRDP2XJbnufIEvZEYT+mRDSwTEbKS87l3WW
m0AItgX0AGpWHDxqLXgwLL6WRVwej9sYAlOoevROVqDfBwPiV91YtIrvGUKWGMtZ
4kPK/EbKSxRwCHb7ANa2oDynrinaviTGAWo9PpJroC4N26oMdz+thNbM+/hh+cja
nGCIZVMgSWgUznyGQpi79e7ObFXCHj/MGF4oe6kYP9pEM4sEJ2ItzKndHAESc7ZF
dlhbxel89zR97GnrAtPP
=qXE8
-----END PGP SIGNATURE-----

--Sig_/uZ8GbnzS_TguzzatoxU8Udj--
