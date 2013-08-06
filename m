Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007Ab3HFQxx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 12:53:53 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:42432 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755195Ab3HFQxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 12:53:52 -0400
Date: Tue, 6 Aug 2013 17:53:47 +0100
From: Mark Brown <broonie@kernel.org>
To: Steve Twiss <stwiss.opensource@diasemi.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>,
        David Dajun Chen <david.chen@diasemi.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        LKML <linux-kernel@vger.kernel.org>
Message-ID: <20130806165347.GF6427@sirena.org.uk>
References: <201308061437.r76EblmA010507@swsrvapps-01.diasemi.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7mxbaLlpDEyR1+x6"
Content-Disposition: inline
In-Reply-To: <201308061437.r76EblmA010507@swsrvapps-01.diasemi.com>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH V4] DA9210 new driver files
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7mxbaLlpDEyR1+x6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 06, 2013 at 03:30:48PM +0100, Steve Twiss wrote:
> From: Steve Twiss <stwiss.opensource@diasemi.com>
>=20
> I2C driver for the Dialog DA9210 Multi-phase 12A DC-DC Buck.

Applied, thanks.  I made some trivial edits to sort Kconfig and to
remove a blank line at the start of the source file.

--7mxbaLlpDEyR1+x6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSASoYAAoJELSic+t+oim9g9IQAIs04r0h4SdStipBqypaf2nI
gSlF2LwzT+30374D6SZatC138jqmoiLJW6Mpriph8ptyZ1YFLca4YI1uyO1WBqwJ
U8XmtvdIrqn0dEIaoqTESY01FZsxdst7St8mBVy1CukG7ZW7SEeKyQl7GGtyvoMH
QXJsdLcyNj06KKloAvzz2SWaKQTl0m/dijQeIuiExmI2MLAuy6ba32yV4iLEje5+
JV0fepd5GB+OUJIUd0AIvdG+rkw+w2ciUbLQEBfOUEoAlZ0V6FJs0meqwRVp1CDr
5SUZQWx0uXdvf3ZH/KllPiKF1vPpFOM7daAtBg1woRfj7IDJs3hdjlQhx5WqFXkC
VKnuKUkmLTHKD393f4jfuz0LMVXiQBeUfvHhOOiv2Jt/gyzY9ath5YSs+e5ZVaSU
ntfnY7K6GNRxXp4O0EagGTyWX4TinmSI/BlS3uIcNgzooDKTM9L7eB6lA9IsxDdi
V0f13bCVBWSXEuqmJoWz0iGLI8hU7tiV7S/t/HKgzRK/8h6FhoR6oQVc4xxxBwh7
gAyPp/CEsxW4eaT0aK1fzPyfpODOpADqCVKiLqluuW2845GJ08SrW9KyqZEd9Zy2
v1d+RLjyrc/3a08L54Zub6yzXZ5fpJvrPVxt6HUkmU3iGmHzRczMXyeXhV4ybLwk
8m/NErLQSb+gznGoA+N5
=b6Hv
-----END PGP SIGNATURE-----

--7mxbaLlpDEyR1+x6--
