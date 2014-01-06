Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751634AbaAFMUn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 07:20:43 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:47741 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbaAFMUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 07:20:41 -0500
X-Greylist: delayed 433 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Jan 2014 07:20:41 EST
Date: Mon, 6 Jan 2014 12:20:34 +0000
From: Mark Brown <broonie@kernel.org>
To: Fabio Estevam <fabio.estevam@freescale.com>
Cc: shawn.guo@linaro.org, dmitry.torokhov@gmail.com,
        linux-kernel@vger.kernel.org, festevam@gmail.com
Message-ID: <20140106122034.GP31886@sirena.org.uk>
References: <1389010395-375-1-git-send-email-fabio.estevam@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SNyXRwFkCoXpEvJj"
Content-Disposition: inline
In-Reply-To: <1389010395-375-1-git-send-email-fabio.estevam@freescale.com>
X-Cookie: Go climb a gravity well!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: anatop-regulator: Remove unneeded kstrdup()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SNyXRwFkCoXpEvJj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 06, 2014 at 10:13:15AM -0200, Fabio Estevam wrote:
> We can simply pass the regulator name via of_get_property() instead of making
> a copy via kstrdup().

Applied, thanks.

--SNyXRwFkCoXpEvJj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSyp+PAAoJELSic+t+oim9POQP/A78wKhvJZxTXLcJoQJ3kyB8
NR+znBB5u3oO9lOXjn4uB+fh5MQKnGD+O/wNS7aOKcohieEU4V3WOQbXfFGE/FTA
I8ht+OokVzOlY39cAA0G4TPnKq/2WWlubRg1XoBRDmdYhRjOUzrm3U49Y/bHczQb
sKoNobv5thccU6+HCdCizpoqOcjfaZ4sSpyARBgoo8d8jU8w5hUbkwxw2w/ROVkz
x3e43uIhQs+IxYZkX7S3BqXY6ubmy/UVqE//hmfAAQf9sYnCPYg/Rs7kO5jhgicT
z5kSN5k8zqtxcg8max3RusEMb6HJeJ0Z75kjSqXothXZtOf4cug0cyLX8rSQ7ewi
OdPB5vVne7EHrtbSRzQ8kS5AbpaORd2+S3FS8hQoWifT9cOsQh70mufceqEU1fAd
2iCXp4mSVfSqFME5Nxkz+ePArnqcKYCUhF4SEqxPzSjK0xpPRIHrFilouURWe5/z
ANiVmkBc4HStuHrPrgxqb2ireENtByQsVxxiHqqlF4MMZRvU8JQTo34HxTzcXp7l
S6IxRlCbRJ7INNUBYD0szXZGjml6idIvsXFREfh/rJsbJQJOE7Rs7OEcE8VF4Gij
7wzx3rUsoZvMDgnCg/pzrK+tEeefrnGrRgiNVAAC+HGu5JbIB6rd8xRWJDTYClJx
4CCD7mX0KBpdNBCj6J0I
=p1/x
-----END PGP SIGNATURE-----

--SNyXRwFkCoXpEvJj--
