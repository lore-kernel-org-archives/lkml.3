Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756865Ab3HGPhO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 11:37:14 -0400
Received: from sauhun.de ([89.238.76.85]:43352 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751281Ab3HGPhM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 11:37:12 -0400
Date: Wed, 7 Aug 2013 17:37:09 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH 02/12] drivers/i2c/busses: don't use
 devm_pinctrl_get_select_default() in probe
Message-ID: <20130807153708.GJ2978@katana>
References: <1373471889-18107-1-git-send-email-wsa@the-dreams.de>
 <1373471889-18107-2-git-send-email-wsa@the-dreams.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tAmVnWIZ6lqEAvSf"
Content-Disposition: inline
In-Reply-To: <1373471889-18107-2-git-send-email-wsa@the-dreams.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tAmVnWIZ6lqEAvSf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 10, 2013 at 04:57:37PM +0100, Wolfram Sang wrote:
> Since commit ab78029 (drivers/pinctrl: grab default handles from device c=
ore),
> we can rely on device core for setting the default pins. Compile tested o=
nly.
>=20
> Acked-by: Linus Walleij <linus.walleij@linaro.org> (personally at LCE13)
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>

Applied to for-next, thanks!


--tAmVnWIZ6lqEAvSf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSAmmkAAoJEBQN5MwUoCm2bHoP/iNtk37KWc2nWQT+dGhISokW
xdgW6SKAkGMd+8RNb8l+HHeaOsbRvGIYwvHvJMt1p0lLIVIcI/HfFdE+2wfD3ACd
5Cx0Mq9UJQdctFefyEBwjhCQCkUsKQnLjlj/Q52FWpmBTQDBmMA8lpCG/S9FrLji
gupFMxxTulPVZaf9EYxzWt/M28SOOgpoJdCkeR6g6eYaqG4NSiRRAfQl++oNb7CO
CM8e/g84LD7wdA5n9vEeg2nudUiPZ0z+R77PmGxM815SsA8dYx1cbFECtCy3vybz
Y1/7jY4OlexBlG0qsXcqpF3QMIGiI+eYflqSb37bz3yARYmRr44R6Ti0rX2hF0aq
qYfcbyEEkX9Ilv3jsA/E2kQy3xbPSFgHN/v64MiIHVmwyEn11uz0vuSJgrarJs5k
h6ftDt4PUN57xkuGrMuoux/A9LaWPkSZ8jqYkZd+ezvBr6uz4ukXEie2zg6bxhJ6
nv/vO/zibdq0gz3i00TKXlcZRqnioef9IcoeSf9lSvP2M/Jb5gMJ97wxuEIOCW1t
MO4tW6w5MJ5CW7i3MzCyDu4nJwZtVzBDJ/NeLQDaC44U2gxIJwPkdYxF4i0Hk7+X
BFaGMlzzKkDsYMygsGftl0m0iJELFjOTRLKBG53KfFixLQ+N/FGnfiMQWjkIBZD4
bvNdL3UBgFXN8mn9c2NK
=zKOz
-----END PGP SIGNATURE-----

--tAmVnWIZ6lqEAvSf--
