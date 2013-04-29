Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759490Ab3D2UKd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 16:10:33 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:45189 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757031Ab3D2UKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 16:10:31 -0400
Date: Mon, 29 Apr 2013 21:10:14 +0100
From: Mark Brown <broonie@kernel.org>
To: Marek Belisko <marek.belisko@streamunlimited.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Marek Belisko <marek.belisko@gmail.com>, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, rob@landley.net, alsa-devel@alsa-project.org,
        linux-doc@vger.kernel.org, tiwai@suse.de,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        perex@perex.cz
Message-ID: <20130429201014.GF3270@sirena.org.uk>
References: <1366895594-19596-1-git-send-email-marek.belisko@streamunlimited.com>
 <1366895594-19596-3-git-send-email-marek.belisko@streamunlimited.com>
 <517AD46A.2020402@gmail.com>
 <517E64A1.4020402@streamunlimited.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ChQOR20MqfxkMJg9"
Content-Disposition: inline
In-Reply-To: <517E64A1.4020402@streamunlimited.com>
X-Cookie: You will triumph over your enemy.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 2/3] ASoC: spdif_transmitter: Add DT support.
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ChQOR20MqfxkMJg9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 29, 2013 at 02:16:33PM +0200, Marek Belisko wrote:
> Dear Sebastian Hesselbarth,

> >That is very generic and should allow to remove "linux," prefix.

> Not sure if linux, prefix can be removed. I believe (at least what
> documentation said) is that <manufacturer>,<model> must be format
> for compatible.

Yeah, you're supposed to have some prefix.  I guess for stuff that we're
really happy is totally generic we could use "generic" or something but
it doesn't make much practical difference.

--ChQOR20MqfxkMJg9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRftOjAAoJELSic+t+oim9blkP/2E/DYIxp22J+jhTM0RlpPpx
byIIJ7j0AswDo/cn2qFA8ojvncHHMV8Ow5q3cb1qUfAGJCo3zwJDgkgyd8ERL1Mj
pFfKxkoo6ItsVWQDQEOzrrOti3pUqb4rV34P7QiuvaKybw7LNy1QLuw6reLTjsFX
qH/WLkwFtDzPNLXSY8RdPoFCqmT7+NAec4w/BXFQ8+kY1THkpb36FyIiURECpTY3
RCDGLrNffIVZT3lfZdBSHQbmP8pZ6tBPguugKhd7Iq4xZjneojhzaTnzKsF9/tNF
LX9pCSM3FknOfQKydDIEIIBJxUHNN3W/WSObD6nyaLjBPNi/Gj83leMuA/TvIo4B
QYg0zYddrS36osoGihCZBpY45o3gM9ryd1g5VQrlyuQ2biDJc6ZZu7kRm6rH9HPb
lQAmPV3lDuzqxXN7PwaRKyzac6NuLP9H9AQnS3r78iX0eJQnQF97ql0La0Hg24hz
ph1ZT27+0r4BOd0bsEsEBQWFM6+3BNx+t1mk4lJyZuPfFLzPs/GtHKTLJ7v2yasY
dlap1wi6HODgLC29l0nrB4tKcN30BA2y/Os/+xoV1Gx3TK+EndXIzIa/K2aILRmL
rRDDqdC5cjoZzNlUkAD401CN+l64u9MsYoNRaqA49A6NYTu0Kt3j39FpEvTZeIcj
7HKRltDeI4ruM8uNBTzS
=s4kH
-----END PGP SIGNATURE-----

--ChQOR20MqfxkMJg9--
