Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755778AbaHAR5N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 13:57:13 -0400
Received: from sauhun.de ([89.238.76.85]:38420 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752571AbaHAR5L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 13:57:11 -0400
Date: Fri, 1 Aug 2014 19:57:05 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Jisheng Zhang <jszhang@marvell.com>
Cc: laurent.pinchart@ideasonboard.com, khali@linux-fr.org,
        paul.gortmaker@windriver.com, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] i2c: pca954x: put the mux to disconnected state after
 resume
Message-ID: <20140801175705.GE3277@katana>
References: <1406289466-936-1-git-send-email-jszhang@marvell.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wchHw8dVAp53YPj8"
Content-Disposition: inline
In-Reply-To: <1406289466-936-1-git-send-email-jszhang@marvell.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wchHw8dVAp53YPj8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 25, 2014 at 07:57:46PM +0800, Jisheng Zhang wrote:
> pca954x may be power lost during suspend, so after resume we also suffer
> the issue fixed by commit cd823db8b1161ef0d756514d280715a576d65cc3,
>=20
>  "pca954x power-on default is channel 0 connected. If multiple pca954x
>  muxes are connected to the same physical I2C bus, the parent bus will
>  see channel 0 devices behind both muxes by default."
>=20
> What's more, when resume bootloader may also operate the mux, so the
> the channel connected after that may not be the one driver thought.
>=20
> We fix this problem by putting the mux to disconnected state and
> clearing last_chan in the resume hook.
>=20
> Signed-off-by: Jisheng Zhang <jszhang@marvell.com>

Applied to for-next, thanks!


--wchHw8dVAp53YPj8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT29TxAAoJEBQN5MwUoCm2smIQAJkf95N1Fep4A/nuyLxOGlLY
iHlYdI9LzNLWZsXoF7t0r97gfA3lx2ffQBbRlwlJMgJO5ZG8pGBbgCmUHoqMkxTK
zgXoOWbOoW/9zMHpEbGN5EQvJL+wnFqF1ApRgGQmhL7An2IhId66vv3/XivNDPfg
7NXwQrxXZOt9pfXvOJYNBhaIqPJt288FVEPPlahHLARnkDpQCz8oUvWHeQ/ATBOr
LjrYMwQJ4JWgPLMkUgVKv5wRnxlZ8nAkjjYKMUZawPkBd9NZN+JGk00D27a8nCCM
3O8wMML7/8KFNI4KCSdCxOxUWeMUcwbsc22xBvdmryEXb7JOzSjR3t7VucOdAtjZ
gj+0kJrW9UhLcJI9ZLF+p7CaWYVuvy88tzZEghYz2FJ62xGMTyeloYO4+i5pXiUu
lvA5NHHRqJuHksPae/ogFSt4mVp4NVG9UF7VrdIx/Af5w785xyZQNnT/Bm++if95
ACoZ/TijVg95dV2kOyr9LpoRQRnwfvT6GJh22P41wUTyn36gzL2BcWdkmF30Nhod
U3+CvNm6U+1ILhSNZes6mcx8tbZpUU5jw2aAmHYTIaU3Ems2Y8BnvTuB/A/gYLgM
iFxNB43DID9YP+U4ybRQ22k3OfYAs8SX1QZHwnxcW4hI11plFjAXmNB/9VH/o8Gn
Ps0l2SZ5XpzDYs8XbXtQ
=BDTs
-----END PGP SIGNATURE-----

--wchHw8dVAp53YPj8--
