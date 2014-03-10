Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591AbaCJJqw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 05:46:52 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:51346 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022AbaCJJqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 05:46:51 -0400
Date: Mon, 10 Mar 2014 09:46:44 +0000
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <20140310094644.GN28112@sirena.org.uk>
References: <1394444239-6425-1-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dh6y2JP9i7RgBdNN"
Content-Disposition: inline
In-Reply-To: <1394444239-6425-1-git-send-email-k.kozlowski@samsung.com>
X-Cookie: Oh no, not again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: max8660: Remove regulator_dev pointer from
 state container
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dh6y2JP9i7RgBdNN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 10, 2014 at 10:37:19AM +0100, Krzysztof Kozlowski wrote:
> Don't store pointer to regulator_dev returned by
> devm_regulator_register() in state container. It isn't used anywhere
> outside of max8660_probe() function.

Applied, thanks.

--dh6y2JP9i7RgBdNN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIbBAEBAgAGBQJTHYoBAAoJELSic+t+oim9kXsP+LXQ6vJpoCBoCPvxuGNlAF9G
ggutmPjVXW+u5WOPv8iGyxeoIYi/ciru/dTwPmhP695PveOaSlSFcD4WDdo3n4zi
he9thd58IavaOGlwxQfoUZlPS1Sl1tQ3uDNWvzsqKhXPg1u+D13RvADY/kwR6/u2
7z9fQD7Tc95FBx/bx9sxwmoY/rofYarOiPEagtv6FKE5qKmXARhRYNjNEIr8qLJA
P0xtjsnKD0Vd40dQIHAQI4Lm4ncXNhE/6KZxJWWj4N939AVrLosZzWQwIPYi+U/4
Fy5k9PP8ktSFekIoCA3VQf9KO1F0aanqzhSGpatPXQPpJAH99y+h7PGkRzC2WqCV
rQW1g8ga33v9MetNR6NbYwlWand4aFQdoSv4Rk9K/3VNlgA03XM8F4o2NZXldZDZ
f/gTT2ndj+vn7ebCBgXjxalBn5Ksi2MrzPwIMvan+Mj8cI0SHbV7VMNndEZe7mER
2Ca27Je+OhzcP8wtwYIxmaHxSQ9PjP3ep/nP1vq5I6j74M0MVaLqwHkx92PP0kPB
W5ug6lIEB+j3/nfvPySGtaC5QuhQZQSGqVRLAkleBOrvRk2X91XhwWwCADiQOW2j
IhQxVa+MDY4W4S+14zhubD4vW3boMIJpoa0OCCZNLxSSRSOZ9hk8UVLAhiPaNt0r
2rwwFKuQD4A3h5FvQNQ=
=jq1w
-----END PGP SIGNATURE-----

--dh6y2JP9i7RgBdNN--
