Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932979AbaLDS3P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 13:29:15 -0500
Received: from sauhun.de ([89.238.76.85]:34335 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754226AbaLDS3O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 13:29:14 -0500
Date: Thu, 4 Dec 2014 19:29:11 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Sekhar Nori <nsekhar@ti.com>,
        Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        linux-i2c@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>
Subject: Re: [PATCH v3 3/5] i2c: recovery: change input parameter to
 i2c_adapter for prepare/unprepare_recovery
Message-ID: <20141204182910.GH7944@katana>
References: <1417448047-15236-1-git-send-email-grygorii.strashko@ti.com>
 <1417448047-15236-4-git-send-email-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wayzTnRSUXKNfBqd"
Content-Disposition: inline
In-Reply-To: <1417448047-15236-4-git-send-email-grygorii.strashko@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wayzTnRSUXKNfBqd
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 01, 2014 at 05:34:05PM +0200, Grygorii Strashko wrote:
> This patch changes type of input parameter for .prepare/unprepare_recover=
y()
> callbacks from struct i2c_bus_recovery_info * to struct i2c_adapter *.
> This allows to simplify implementation of these callbacks and avoid
> type conversations from i2c_bus_recovery_info to i2c_adapter.
> The i2c_bus_recovery_info can be simply retrieved from struct i2c_adapter
> which contains pointer on it.
>=20
> CC: Sekhar Nori <nsekhar@ti.com>
> CC: Kevin Hilman <khilman@deeprootsystems.com>
> CC: Santosh Shilimkar <ssantosh@kernel.org>
> CC: Murali Karicheri <m-karicheri2@ti.com>
> Acked-by: Uwe Kleine-K=C3=B6nig <u.kleine-koenig@pengutronix.de>
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>

Ah, bus recovery, I need to have a closer look on this one. Scheduled
for 3.20.


--wayzTnRSUXKNfBqd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUgKf2AAoJEBQN5MwUoCm2tPsP/0ydflzbnHvHC01h4WW8TkCZ
zLfZk+qRBntM2CJ8eh7eqLgvEurzSg4shzksDkYMo8djFmZavTmaYpWM1PQmc1Zq
BsHqAkGlSt/T3A6DRXD25zgWuI0V+g7TY035cqHEgeTbFN485+B+W/I3eItvpjcu
9w1ZXNE8+8qpVFXJO7shAK0IcV/O8o5yqzOck6loHRGl9dKz0CNGTT8iDUFCVqTO
PaZ7cG7MKxt24fxmn5A57pd4e7aKzV9HD/tbgXek096Cz7HA+Q1nUp9YBwzavxHi
NVqBisgD5/r19M/Ub2XZXqzj7qKCBm4W4KI96xoyjtDEnVsIZzoJYWG4hHTu0JxJ
eXhEEytYOWV36tuHSFPTTJbXVN9yUW0GBjOrXkww76dHMj58LmfBnlgEN5m/KNO0
UbW9coT0kkW4S8Kzmne1iYh4oMGBFaQ8u9luNrnSibiveF1eGyONyzchfbrirCvA
KhWgR849vjxs59RdoatHfvXXF/ZqkM1wTq/xHkBTicuuc1/6HAV5WZDcHGfYOfFG
5TkBKk3sU0fpf0Tqmrjh6CNFS/VtsbgdxPgVM16fsjgDjkhzTBU0HaGwTtKphr7X
JcGpm159/WlBd9E5xHgQ2oEU6hGJwr+1BmipSIQ5mjqqvjBSeC7dV6ny721qfoVC
3SmOdkYksFGD8LmP+Uwu
=45gn
-----END PGP SIGNATURE-----

--wayzTnRSUXKNfBqd--
