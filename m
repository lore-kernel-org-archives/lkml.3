Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760909Ab3DBJg2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 05:36:28 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:57401 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760330Ab3DBJg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 05:36:27 -0400
Date: Tue, 2 Apr 2013 11:36:22 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Axel Lin <axel.lin@ingics.com>
Cc: Arun R Murthy <arun.murthy@stericsson.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] pwm: ab8500: Add .owner to struct pwm_ops
Message-ID: <20130402093622.GB4416@avionic-0098.mockup.avionic-design.de>
References: <1364699642.7876.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FkmkrVfFsRoUs1wW"
Content-Disposition: inline
In-Reply-To: <1364699642.7876.1.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:4T311GBQ6uDnglTziT0d9OJQamB45dzNxCLqI4th4z8
 M1Afe5vLMboE9TX0PHCHdopd3H7Wxjp+kluCVxf5xU6pOKwYOY
 M+bAEFbZQO3PPStgYoSqBcXdCeJP+JZgVwmhMpsBgRo4YR4Qt6
 Nc7uIZkz1bUx0y2Hh9F68+EbGVks9M/SAfJtshg8Pu2wBtvxV2
 8QDsCkNC6MMXa/VBTQUmW4NNtK+D0hWVgBd8qZHb7Z3xu0kmQb
 5wnTQ0BkZnFsentn9Cd7TercGLzjOAkZjSWTvcqvJmozssXGx8
 5IchsoujL465cbWCgnqcGuuKJ2yIFZSQa7xo5f+aEvSnBSknBJ
 nGj0ba/VoHxp45f6b69m7xWVsefiQljp/BGJnncVQUkhkjYFtq
 v/RlxedpoQ6d0bcTEZTcWudGC+v9pPgV/GPH62HTllYbgXFLGS
 R7gX5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FkmkrVfFsRoUs1wW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Mar 31, 2013 at 11:14:02AM +0800, Axel Lin wrote:
> Add missing .owner of struct pwm_ops. This prevents the module from being
> removed from underneath its users.
>=20
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
>  drivers/pwm/pwm-ab8500.c |    1 +
>  1 file changed, 1 insertion(+)

All 4 patches applied, thanks.

Thierry

--FkmkrVfFsRoUs1wW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRWqaWAAoJEN0jrNd/PrOh37UP/iuaiYR/0wIzlgfexE46DpSC
X0wGkPfL8YsVfBbA+uId3M65zfk/ELdGjcWR1ab3CTn6irr4CkXluLs/Du+xxGgK
G3+eGtakJh4qXTk9O6U+WikfJoOgTx9UjBIsGstYk+w0HBgaryWWDhdrC3pVMh00
Bee9OHPD8rsQ0jucIRHJ3K7YobyybjlUfl/PudcXCoKhkufwy6VKoI+bx0SEFwi4
+hiFO4PTSVFmrm/MDlkmHWT0iwsFis52EdffM7bv8Pi1HP2xEIvzaNnlHH3vnV8Y
yucfyG/2RGW7e2D+sml2oPG0Q+nm8WBsaayVTija4URAKO0tpri+exb8Vv8rHMfE
finYcTZ64HVi36w8pPjVtQwzvm36JO6vVlCsTNGzJamfDJhE1i1sDWosldckycTd
BGHKpGb740MxdAP30LGRY/aqyXN1qfKhwxXQf2+A2JxOGdmdsH5sW3U3KGyJCdAV
pC3mLigqqombIjeV6gS+x0EeLtTHQewhclV7tgEfi3t2B+HQUHoovCX9qspDQIQR
DfS/SjzeFada5xEq+u3zt15rMmoPvnO7ss4v5jKfhRFCyU/SiYQsMO7ZQZNUOP3y
+nK5MPisemggHfaCi1cWyeXYZ7h1L+eZYWLBkoRrD0rFkz4Uym0AuxM10UbpRVIx
RpFHyWjqxUGOa9IfA8i9
=Dz41
-----END PGP SIGNATURE-----

--FkmkrVfFsRoUs1wW--
