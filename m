Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933131Ab3HNTKh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 15:10:37 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:51005 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933112Ab3HNTKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 15:10:35 -0400
Date: Wed, 14 Aug 2013 20:10:28 +0100
From: Mark Brown <broonie@kernel.org>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Eric Miao <eric.y.miao@gmail.com>, robert.jarzmik@free.fr,
        kernel-janitors@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, linux-arm-kernel@lists.infradead.org,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Message-ID: <20130814191028.GP2401@sirena.org.uk>
References: <1376340564-7975-1-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="D8QxnvyRlKGQJxl7"
Content-Disposition: inline
In-Reply-To: <1376340564-7975-1-git-send-email-Julia.Lawall@lip6.fr>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/16 v2] sound/soc/pxa/mioa701_wm9713.c: Avoid using
 ARRAY_AND_SIZE(e) as a function argument
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--D8QxnvyRlKGQJxl7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 12, 2013 at 10:49:24PM +0200, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
>=20
> Replace ARRAY_AND_SIZE(e) in function argument position to avoid hiding t=
he
> arity of the called function.

Applied the incremental bit of this, thanks.

--D8QxnvyRlKGQJxl7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSC9YhAAoJELSic+t+oim9ymEP+wSn7S9g6F/pfcebCIbtMVpb
VbbfHhzp2OMv+o3ukEblE9BP+HT07QgQomhTBUUFSrhTu9owcDVePbzr6boG5XMh
UN5AZOvPR0wEMdnYEtOXnJoi1Cr0nDMXigZjg5OHL2jwa7hJiV2hKQCMXQsZqcWY
nthplxPqPgaot1c4L18LvTfS1hiiH6+mSUv7gDbe+VOQYYTt6uFv4I3JLQL0v3Wg
qtJL4YsZM7gfMsCwuED8fkLTYJlOBRgYuQrdkgvO667fX7GdZTEJEPeClh1XFRRy
TBL8Jc35FqvbBIW07xP3++QvagbL5Eh2ohz0LzXftbXpjI5QAvT2sQmjJT3agfRU
9lgZ3GSGcM/D5oBJxGOdKRLz6Ul0hTHcpHhTfSgyuAosi38h+GhvioIqIPyx48GW
jOR0+MfSyFsUZUktTVw3H+SRZWhoMVAOYdEyDX/OhfxOHR76sA97yB2qfYNmN/CZ
XdVGL7HzcqhJkGlGLcyW9sHila6nqdcrhigTnjkvoOqBk09/Q2F28tQVnT30LxO6
IkydCSjJ0704jD4VAnJG5MFx7mGnlvk3nE/TyX0R7zh7CRwWjR76g8CpHCtNvSNO
prbAPsFEHWPevoW+O0Cb+oVnH/HSJM7GifBtjHIdILangYPXMDMgojqIsnVAVMCj
ip/gyyc37ghppezt0S+T
=55Gx
-----END PGP SIGNATURE-----

--D8QxnvyRlKGQJxl7--
