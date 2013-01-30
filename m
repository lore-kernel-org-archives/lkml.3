Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753080Ab3A3COL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 21:14:11 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44880 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751722Ab3A3COJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 21:14:09 -0500
Date: Wed, 30 Jan 2013 10:13:59 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Axel Lin <axel.lin@ingics.com>,
        Graeme Gregory <gg@slimlogic.co.uk>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        AnilKumar Ch <anilkumar@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: clear state each invocation of
 of_regulator_match
Message-ID: <20130130021357.GD4945@opensource.wolfsonmicro.com>
References: <1359486073-26504-1-git-send-email-swarren@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RhUH2Ysw6aD5utA4"
Content-Disposition: inline
In-Reply-To: <1359486073-26504-1-git-send-email-swarren@wwwdotorg.org>
X-Cookie: You dialed 5483.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RhUH2Ysw6aD5utA4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 29, 2013 at 12:01:13PM -0700, Stephen Warren wrote:
> From: Stephen Warren <swarren@nvidia.com>
>=20
> of_regulator_match() saves some dynamcially allocated state into the
> match table that's passed to it. By implementation and not contract, for
> each match table entry, if non-NULL state is already present,
> of_regulator_match() will not overwrite it. of_regulator_match() is

Applied, thanks.

--RhUH2Ysw6aD5utA4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRCIHZAAoJELSic+t+oim9XagP/0QiVe8p6854AGmxE86e3Wi6
usc9shbjGmZDE99Nuu1nIVjA0iNwvqQGL8Qgug0uhRg1khnvY470Aamox5IN7OGT
XqQxacq4rAO4KyOPqkrDUhmvAqbACix0wdifx89QsvZMk9D9YOP9syXYwA9Smhvd
FFA2gie17SS2H3eqn4WIgCXupOXuLIg41RPdyRGT0V/jmWLB7soR/wgC5CsuufWk
cXmT47j6Ncrod3z1J7Rntr80vPFgotCntVVms15jIOtSEd3XQKmH169yeuoWwgcz
ERQRXp5oejj8at+C0QbCQ4PPDVAUAQKJ9Oa1kHcd2uDeT2lg6v9y7Sqp1kJFLHVh
gB4zB/Y1/DEv3FDEeub6aPtJQrVocjn/GEi2GF3vqRUZHjrLYO71WPMkRarLgIKZ
atP43heXNUcMde6WeKZVzcUoTZ2v0m8KNKpgRKnyZrlOK/nQD9uXCO35UWV2hC5Z
veNML6QypCyYr6s3bVVcnaBGmMemKrpP7HXHodVLxJOZHmyvNU5s1d2MJvAWwltQ
e0PSsUZvWY6Uudbd4ZpaENGjkpVLg2gQtdGzlYejmwcnmDBoTiuH07xJJHaArXD/
TVgRwpOesCtThQ+OZW1IMok3AwL3zGEt/XpmlaDFeJ0OrWhBGoPfkMcHSw1n0qa6
aygnt4GuIsrdM1l2vE25
=lhAj
-----END PGP SIGNATURE-----

--RhUH2Ysw6aD5utA4--
