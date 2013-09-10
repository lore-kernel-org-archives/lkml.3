Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753690Ab3IJRMy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 13:12:54 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:40093 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324Ab3IJRMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 13:12:53 -0400
Date: Tue, 10 Sep 2013 18:12:28 +0100
From: Mark Brown <broonie@kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Krystian Garbaciak <krystian.garbaciak@diasemi.com>,
        Philipp Zabel <p.zabel@pengutronix.de>, linux-kernel@vger.kernel.org
Message-ID: <20130910171228.GW29403@sirena.org.uk>
References: <1378727367-8941-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TSoBXhsGT8MFtrg5"
Content-Disposition: inline
In-Reply-To: <1378727367-8941-1-git-send-email-geert@linux-m68k.org>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] regulator: da9063: Fix PTR_ERR/ERR_PTR mismatch
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TSoBXhsGT8MFtrg5
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 09, 2013 at 01:49:26PM +0200, Geert Uytterhoeven wrote:
> If CONFIG_OF=3Dn:
>=20
> drivers/regulator/da9063-regulator.c: In function =E2=80=98da9063_parse_r=
egulators_dt=E2=80=99:

Applied both, thanks.

--TSoBXhsGT8MFtrg5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSL1L5AAoJELSic+t+oim9kjQP/1Sk1vE3Dg+T45ohI3381LAq
Z+EhpCN5NwoBAGiwfrymR/KJnsibYpqYHhTJi6quCydDsLUBHkrPIdpyomUMiRIi
/NIOcn2QQ6tiRZCYNypUpkehF8Z67L+gUtNtCTa0g8kgsVeD9Y4hdoszbaWuWFrA
ywVEW20B/z5QHYplTiB3AFVHf1B4JZ5YE4cOxnIIddOn927q/IOiuwleFLXh41gA
1KXUntGqxj/pmJRK0tQ8wRR8o4D2HaWW3A48f7pNo3O2oSQpx/YNyhTdbzEkdnki
GOGSMaWvsEbs2chRiMFYEpbmXf0+MdVHb3igOwT7653VWmo8lQTW6VcKyhHLpI7U
sN86QFVpUl2LCRMPIiYwuNOtIvHzMpYvcxxuSEWNeshONgkTxDejIsnB6AWy8JK/
ria1ypVi/6X5x118vGNviKE3AV7yqHEx5uw7o1wqjlQlgetgKLuH1NMfyJ2cxFcP
JMnd5cMShCNuwkqjqXBZ+ZzdiKA0Ple2SOVh+2t3Jr+uN1XaXVFDR7zjBrUM346q
n5giDfD19Uxr2qt+ZGfRmQrSe2sRuiwGca/UxIgBv0fP0S/ZcZBKfXKronjaucP7
o4HDW5UFx1w34FCQcoA+eS5JEVYAR7+G4ynMrysoZI1AiPkeRncWm/pbhydYbnm8
q4yCmFTP6ft6KL2d8LIO
=YZ+1
-----END PGP SIGNATURE-----

--TSoBXhsGT8MFtrg5--
