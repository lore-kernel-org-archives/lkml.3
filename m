Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751844Ab3GXJm7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 05:42:59 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:33746 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255Ab3GXJm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 05:42:57 -0400
Date: Wed, 24 Jul 2013 10:42:28 +0100
From: Mark Brown <broonie@kernel.org>
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Cc: Robin Gong <b38343@freescale.com>, shawn.guo@linaro.org,
        grant.likely@linaro.org, rob.herring@calxeda.com, rob@landley.net,
        lgirdwood@gmail.com, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20130724094228.GY9858@sirena.org.uk>
References: <1374398247-11384-1-git-send-email-b38343@freescale.com>
 <20130724083041.GC4332@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XauJzKcUIZVdj07X"
Content-Disposition: inline
In-Reply-To: <20130724083041.GC4332@pengutronix.de>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v4] regulator: pfuze100: add pfuze100 regulator driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XauJzKcUIZVdj07X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 24, 2013 at 10:30:41AM +0200, Steffen Trumtrar wrote:
> On Sun, Jul 21, 2013 at 05:17:27PM +0800, Robin Gong wrote:

>=20
>  static struct regulator_ops pfuze100_fixed_regulator_ops =3D {
> 	.list_voltage =3D regulator_list_voltage_linear,
> +	.set_voltage_sel =3D regulator_set_voltage_sel_regmap,
>  };

This doesn't make much sense, you're adding a set voltage operation to a
fixed voltage regulator...

--XauJzKcUIZVdj07X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR76GBAAoJELSic+t+oim9JDQP/3R73sFk0jCjk3Gai7BdJINx
W63STLi2xcYtsWYEJWmcyi1P6BXYmeCYtYI4EtFoRRXYT+kuTkDUO6qowXAvp+T9
PyyRrfHmHvGWg6HofYuT34t++f8sPikYwFMMonah8Jqwbu3iQq8YPKz8zbclgTJd
ZgwUzmFJaYz2Ws9Vm9VvDSGyAFtnAOLpkwoh8s0rgiegsXWpKvUyDxSzD+M5cabH
Wkw0s1IOUMajr8jRbJ6OeDdQZucIDXhanyrkjY4BIUMJnTOwdm9fKfZ5+TKzsARK
j2teBozTO/IOGkTpXjfxqTH355/0AnfWgTmyFQxqGdH81digQBv0jjWgiJbtq/4h
sfrkYN9wQNC8fpbi81C+AanyaJy3FxNTWV+FwybbqX0hTp/mjDD9kh9sVN4P+euk
JTu+MBsxVyAfMKLpt4PyKaMPWOeGr7q5huHKkVce7RXKhjvd4zNkLJmZ/3+xultR
jcJdjfQteqX55OdGqnpOmAdZjgIS1aGjftB6HjfZr0H7dkHSvjhWuPVVRUd3cvSb
FBorrRPdjCxlfxxcYLXsPiKz5jLNeeg5cppS9m1WZWuqe3VL1Mv2npDrCqJiFK1W
xuDcuy5pZL9FxF3KaqDhc0+tIE6H9+UQoEThZh5yw4j7xsO1QH9J3HR2yVCS7ScD
Sl+rN5Pi3FcFzTOxRvGw
=UfOo
-----END PGP SIGNATURE-----

--XauJzKcUIZVdj07X--
