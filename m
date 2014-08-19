Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214AbaHSPfy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 11:35:54 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:48847 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096AbaHSPfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 11:35:52 -0400
Date: Tue, 19 Aug 2014 10:34:51 -0500
From: Mark Brown <broonie@kernel.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Thierry Reding <treding@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        Xiubo Li <Li.Xiubo@freescale.com>
Message-ID: <20140819153451.GB24407@sirena.org.uk>
References: <1408400044-2560-1-git-send-email-swarren@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TakKZr9L6Hm6aLOc"
Content-Disposition: inline
In-Reply-To: <1408400044-2560-1-git-send-email-swarren@wwwdotorg.org>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 216.80.66.37
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regmap: fix of_regmap_get_endian()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TakKZr9L6Hm6aLOc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 18, 2014 at 04:14:04PM -0600, Stephen Warren wrote:
> From: Stephen Warren <swarren@nvidia.com>
>=20
> Commit d647c199510c ("regmap: add DT endianness binding support") has
> some issues. Specifically, if config->reg_format_endian is not explicitly
> set, it will be zero, i.e. REGMAP_ENDIAN_DEFAULT. The switch statement

Please respin this against current code, as Xiubo said Javier fixed some
of this already.

--TakKZr9L6Hm6aLOc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT826YAAoJELSic+t+oim9564P/1X7X+dE/fgXtYF8HbAjPg8M
FEE9PXIj/YlGTqu8to5ZSeemMd8gVyGKqH6EQ40+OHfd8EADi98sfD46gZ/dqb8P
0ZzGZ8fxKAo34AZ7bmD6QOG6zUeJ7aGiW73DrluKVFzYpPpblMLtbWqHL8A05kL9
ALfsszbpwiaoSQfKoKa1gaufd4DwkEM7nrx7Hok7ayUHWOf/YJRRZ7Fr0bB4PPLs
UHcaJYAK/6Y5koVyejSx7gRsCxiAk7xtLs3Yo5sH6nuzeLxYweEg6vCNVP5o9Z5p
OVnE4g5qaY1ZiWMJfJQIsYwxJ9oqhrDKYaksws0Fv4wbF3vd0UKtGlkAwMUxjNBZ
o6DJxRONvxGdjYMKtZEgIaiznFuslor5PIxpYHicl/2IzGiFFyI4+RVTeoopYxMX
eIa13DY/c4oiV9KZF6VTxxVVAT6XE6MAorYhvbCMKGbEKaJZlpKCq6zkpA0mbp13
IXFx6UVtb/BTcLYTjgWTzEUbYK0P6mg2FbvQ4BxgoWmHXkUqid1rdG3H3cDPN/vI
ztA2IsMOwlwBWICF/ZoWirJ3LpkESkc0mt1ZpNQ+AQ4j04ih5nZcydxXMsNExYTG
5ghrPABrTgpCL7jMKgPiKtrZSEh74lybh1+sSmS+3v2rhm7M0t7+sqS1UAtsgLE2
YalOYJEijYx/NA8Lh70t
=++yZ
-----END PGP SIGNATURE-----

--TakKZr9L6Hm6aLOc--
