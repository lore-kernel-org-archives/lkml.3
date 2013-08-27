Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183Ab3H0RTM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 13:19:12 -0400
Received: from sauhun.de ([89.238.76.85]:44533 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752513Ab3H0RTL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 13:19:11 -0400
Date: Tue, 27 Aug 2013 19:18:55 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Tomasz Figa <t.figa@samsung.com>, devicetree-discuss@lists.ozlabs.org,
        Archit Taneja <archit@ti.com>, Tomasz Figa <tomasz.figa@gmail.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-gpio@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        grant.likely@secretlab.ca
Subject: Re: [PATCH v5] gpio: pcf857x: Add OF support
Message-ID: <20130827171854.GA2988@katana>
References: <1377590559-14279-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
 <521C63A0.10902@ti.com>
 <1830640.BeoA2uHWDI@amdc1227>
 <2400176.9Vcd5TUYl9@avalon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="h31gzZEtNLTqOjlF"
Content-Disposition: inline
In-Reply-To: <2400176.9Vcd5TUYl9@avalon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--h31gzZEtNLTqOjlF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> The driver should support the same chip models reardless of whether it's =
used=20
> with or without DT. If an entry in the OF table has no corresponding entr=
y in=20
> the I2C table I would consider that as a driver bug.

Linus Walleij posted a patch to support DT only probing, but too many
side-effects showed up. Some were fixable (probe regressions) and some
need more work, if feasible at all. Most prominent is that runtime
instantiation of i2c slaves currently needs an entry in the i2c table.


--h31gzZEtNLTqOjlF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSHN9+AAoJEBQN5MwUoCm2K1cP/3zpfYNXdtAE0fr/YCTZbSzO
VZn3LjZXj1zh7FNsySEPkXwVtX2j5ckfJ9/550BNRA5qvOeoCb+ij7/LN7skkoRg
82JxWLmVyZFA8+QVW8uWSKHq/iqNT2nNFoAsocDBOvRoTHnekBQfODqJR8SbrSPd
GaBwKJH3WDz0PUhZxpupjeoFM538/VSS9cRgIO6uX1vEj85PpnKYqCNpHHIJQlo/
zJPcDODmIQv8vfaDUS8/nlYwbD93smLkrIl0mzau0nj63zyQkNowIjJ0r/9FqSNc
Kd9SbqRWMkrBWFuG2zpWcMfziucBQerlgMqD9hJs0gTm/a6hzl/YRwSJ8atAFmaG
52ApjQ4cHU08TiPXP8ljC5xuT4LPEbX9zPrjFZpFkGf9BNd033RFPZCHnSbqwayI
UdBujDuCabPn8CGxuLPJ1eY8CwUt/6/tOAP1j2OeWFH0j0rE/pZTDoQ5m8HVg91E
86+rlfdBXd4+0iF8Uw0oyL4gznAPxqFSiyy+d/K7AMfEBDPaA7y9OW5N30NL7NUO
CjhgzyAyzxYNbvGE1MUfdrJjzkuVXi7OqOYYVuneVaBz63a7PWhWn3PCWiqZWX8h
rzDHB959I3IFecyj82ylYGcTabjmeKBWbi1XzVsrxEgssNlTKkYz/Q62NbDwMn6C
o5hTtR9YHwD9Fk+Uytyv
=FPRk
-----END PGP SIGNATURE-----

--h31gzZEtNLTqOjlF--
