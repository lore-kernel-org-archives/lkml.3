Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875Ab3EHLM1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 07:12:27 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:41439 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774Ab3EHLM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 07:12:26 -0400
Date: Wed, 8 May 2013 12:12:10 +0100
From: Mark Brown <broonie@kernel.org>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20130508111210.GG7478@sirena.org.uk>
References: <A874F61F95741C4A9BA573A70FE3998F82E5C95D@DQHE06.ent.ti.com>
 <20130507160431.GV7478@sirena.org.uk>
 <A874F61F95741C4A9BA573A70FE3998F82E5C9C8@DQHE06.ent.ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KiOS11rrlPLUJaFM"
Content-Disposition: inline
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F82E5C9C8@DQHE06.ent.ti.com>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 212.183.132.60
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] regulator: support operating mode in the device tree
 structure
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KiOS11rrlPLUJaFM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 07, 2013 at 11:46:12PM +0000, Kim, Milo wrote:

> It's my intention to guarantee same operations in the DT as the regulator
> constraints in the platform side.
> In case a regulator has specific 'valid_modes_mask', the operating mode i=
s=20
> unable to be set with the device tree.
> For some regulator drivers such as LP8720/5 and LP8788, this patch would =
be
> useful because there is no difference between configuration in the platfo=
rm side
>  and the device tree.

I understand what the patch is doing but there's no reason why the
device tree binding needs to map directly onto our internal
configuration and indeed in cases where we didn't make ideal choices
that's not what we want to do.  Providing a binding that corresponds to
what the chip itself calls the configuration seems more useful.

--KiOS11rrlPLUJaFM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRijMHAAoJELSic+t+oim9mIsP/2gJijJgHjdRDoUy6SNnELFv
FrRiq/sk1vzYE27U3eGxWimqywwY/Z1/FQ9w6oU/giPeusJv72AoYSHLNVX8vXS3
/lQ6KU0RZMvQ3ZzSw7bIbivddtlsB0dhprTMB5PCd21S6J4nn6ffXosi8LIFDVDc
OyznHFp78tDGvLsr6Ipce3xaf9R6w2zmQyXIw7PTYBmKymuUz5IXO+EY4i8Ztan3
AEkCDWpBuVP9P5bjjl7dZvtvGdaF7MYfzMHnDfR9+7g9oUwgXfFGeyGh76wkxs9K
3/qrCWXoqdAlCb1jPbf6gLMth19MwcqUUnQVTrcVFtiI5nqKF1Em9dT0ZDSLSlUc
WVFcdtxyADps/FleZaxyLNhoi440FneErpqyRC0508KGJYsd7GoaHhCmlLDWMSjW
XK/VVXxGIJ9ByTc3Fke2bOPIdhLVx2lRhxHO0v8jtZXV4gXVi0PR6ziZwj0E3IkZ
TlVAX/Hy9GKi5clLu7Qf2YyWjYOiXCX7MI2MlEixUbQrjVjTD4p8bkUvbwSmwIBP
Efza/Stcj7yN20/e+DldDMRE1chOA03JcUUszyyf3sh3bxEC6qvP1k7KCk0v//k5
Y505gnAUVHyVG0QVd+Vr9kd3ICZhB1VqhdDoLWGDY5T6WHoBpI1b3o5kdlVvFnFs
M7yTr9gvrZiEeetZtUwp
=KhY4
-----END PGP SIGNATURE-----

--KiOS11rrlPLUJaFM--
