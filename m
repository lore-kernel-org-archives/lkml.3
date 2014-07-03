Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759074AbaGCQ6j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 12:58:39 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:45222 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324AbaGCQ6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 12:58:38 -0400
Date: Thu, 3 Jul 2014 17:58:13 +0100
From: Mark Brown <broonie@kernel.org>
To: Nikesh Oswal <nikesh@opensource.wolfsonmicro.com>
Cc: lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com,
        Nikesh Oswal <Nikesh.Oswal@wolfsonmicro.com>
Message-ID: <20140703165813.GL410@sirena.org.uk>
References: <1404400687-19035-1-git-send-email-nikesh@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9axOBMfiLLqytT81"
Content-Disposition: inline
In-Reply-To: <1404400687-19035-1-git-send-email-nikesh@opensource.wolfsonmicro.com>
X-Cookie: Semper Fi, dude.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: arizona-ldo1: remove bypass functionality
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9axOBMfiLLqytT81
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 03, 2014 at 04:18:07PM +0100, Nikesh Oswal wrote:
> From: Nikesh Oswal <Nikesh.Oswal@wolfsonmicro.com>
>=20
> WM5110/8280 devices do not support bypass mode for LDO1 so remove
> the bypass callbacks registered with regulator core.
>=20
> Signed-off-by: Nikesh Oswal <nikesh@opensource.wolfsonmicro.com>

Please fix your configuration so that these two line up, it raises red
flags that they don't even though it's fairly clear that they're most
likely both for the same person.

I'd recommend not using your corporate mail for community work since if
you reply from it and get a mail footer added (as is standard) people
will tend not to respond positively.

--9axOBMfiLLqytT81
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTtYuiAAoJELSic+t+oim9R44QAIAYeB4615iWhEuXN5S4bx65
mSlk+vXmJfJBevmNx1jGA8pEN7yEW96Ba8tJGWVQX5kOPYS1qD+0i8CmSRvX3jUH
Xtbpw6SEbTzQipVP16d+sJRdyew5Fiiv19ic2B9HGyagkG8lm2WENlJFnFkapOKp
6VEfWGby2dJ87E63yu8GtQeDgPwdByeGkhfiiOsrjJ2ySF1aqwe6ez7FE+6FAccD
4zNeU6rbMtsH9rjuXEzv9fxxrqZJc/gdHRJ2KnIuy0GDSzst1WarX4awDFTVGhnr
rdUyClW/0ZvZ3fXVyJKsNsrxqmFvFT+NDw6SwtH0ISTuW8+lLlHatGWbUxfsqa5N
lBVrTJbd0i0uUTWGr2MVOpLMVGrFvCyoMOaecN4vlIhiKU6i2VvYNj11JprxeR/m
Ggm+mII12jHFymd6/B/A9yQ7TNfQH6PThjoYsr8fATU3A8r7E/VQIknwt/0vPZtE
ES/NU/D30cLvI+QLvzNQaUep+IdgkUDZD8c2m2DXiVfoc2kaV2RogSFX8WI3ENDa
8VRQf6Ip5E9ZgtH/WNfN+841u2bk5U73cw+q6U9dFauLn6jDAfzLpCa1OSzEfVSi
ulNCfQJ7cJJwLZWS02i2+zzuGjQKuuHXtGrSOD4xDmXQaiR3Ta7zrkE9yDsI7qnI
NP3yqF4XOTHcxJBzExpp
=njBQ
-----END PGP SIGNATURE-----

--9axOBMfiLLqytT81--
