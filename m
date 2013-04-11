Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933918Ab3DKQmQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 12:42:16 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58268 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760111Ab3DKQmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 12:42:15 -0400
Date: Thu, 11 Apr 2013 17:42:12 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Tero Kristo <t-kristo@ti.com>, Aaro Koskinen <aaro.koskinen@iki.fi>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [RESEND][PATCH 3/3] regulator: twl: Remove TWL6030_FIXED_RESOURCE
Message-ID: <20130411164212.GH9243@opensource.wolfsonmicro.com>
References: <1365693520.4218.1.camel@phoenix>
 <1365693650.4218.4.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EWehNWXqjd1oOl26"
Content-Disposition: inline
In-Reply-To: <1365693650.4218.4.camel@phoenix>
X-Cookie: Your love life will be... interesting.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EWehNWXqjd1oOl26
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 11, 2013 at 11:20:50PM +0800, Axel Lin wrote:
> TWL6030_FIXED_RESOURCE is not used now, remove it.
>=20
> TWL6030_FIXED_RESOURCE is not used since commit e76ab829cc
> "regulator: twl: Remove references to the twl4030 regulator"
>=20
> twl6030_fixed_resource is removed by commit 029dd3cef
> "regulator: twl: Remove another unused variable warning".

OK, they had actually been applied but the push failed as there was a
similarly named tag there as well.  Pushed now thanks.

--EWehNWXqjd1oOl26
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRZufdAAoJELSic+t+oim9+ukP/iE/1u6paQHEbSroShGReEdx
0wXakmz1OU6gQ00ZOfTLgMVqUmZbh3kgiFcQ1zK82IjmelzaDFQMCVYPIi9QIq6P
6YHYJeAnFgo0ROd+sz5Xh+CNV/WQxXQMMygUX0a2pf9Rv1xWewB+wjO3fbxI9E7X
+mkdujw3f2KnlKK90qvaDWNdwrCtFuVWVtNsPyZ+Hv/BvcO+92ZwPU+iDbUrOfWi
omuukfyb0fXsZfiFZTH0XoWY5H+gDslpCILBVtsq6I9UVIO/wICeCRgd52nKH03z
i6m4ldweBKfPzmCdT+e61L8St1ndgkKnFW6urVwjByR1kPsVT5VC+zpfTqPPDfWJ
f446VqSSd+yeqXiYIsJLJ3JaKu6vZcwhlsaF0AIKai1de4jhiMrFpPHT6INg0QGG
c14iK8jvKfLvvFQXCJBWQUMlrbTLk6TkLPlK0ES1gb5hTKD566OmVj39LvWgfIG5
rAjYGxFyjxwfEFAeNe0z4NJD9mvP78xJiRYLGlW6h7KIIclktrquWJaqSGWzzZ2l
YjeVqxfUI79JaEFHe21ChTatcqlgzMDfIKatlV2rRwPsJaTuwFLY50un/IZWL9RD
kNt/7hheYvp9ib+H8MCRBMuZvyWY6CFj4/Rshmn0fQO/ta+jVDMzPLFJK+TQXRTB
MltVpZ4BkyKh7K5UWGBp
=B5mA
-----END PGP SIGNATURE-----

--EWehNWXqjd1oOl26--
