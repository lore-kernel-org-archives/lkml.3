Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934881AbaGPSnh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 14:43:37 -0400
Received: from mail.kernel.org ([198.145.19.201]:60690 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752329AbaGPSnf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 14:43:35 -0400
Date: Wed, 16 Jul 2014 20:43:30 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: Re: [PATCH v2] power: poweroff: gpio: convert to use descriptors
Message-ID: <20140716184330.GC6438@earth.universe>
References: <1404729272-17873-1-git-send-email-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="E13BgyNx05feLLmH"
Content-Disposition: inline
In-Reply-To: <1404729272-17873-1-git-send-email-linus.walleij@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--E13BgyNx05feLLmH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Jul 07, 2014 at 12:34:32PM +0200, Linus Walleij wrote:
> This switches the GPIO poweroff driver to use GPIO descriptors
> rather than numeral GPIOs. We get rid of the specific inversion
> handling as GPIO descriptors know if they are active low or
> high and can assert the line properly, so we do not need to
> check the flag OF_GPIO_ACTIVE_LOW returned from the old call
> of_get_gpio_flags() anymore.
>=20
> Also convert to use managed resources and use dev_* message
> printing while we're at it.

I added this patch to [0], which I use to queue patches until I get
access to battery.git.

[0] https://git.kernel.org/cgit/linux/kernel/git/sre/linux-power-supply.git=
/commit/?h=3Ddev&id=3D81324804b10c775fc328dbd417114791aa01d5e1

-- Sebastian

--E13BgyNx05feLLmH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJTxsfSAAoJENju1/PIO/qafXgP/iPVpMerCFoW9rHw+eLET4R0
a14EDnVuCSsFczje7zjLv8Eg7XLnk+aaCkEMXG4xiTnu/ZmqZiJukAZzdFkA2b4E
aHc2oNJH5E+fYkGoob+Na10LCGnylkuXnLdHjDF39DbgrSZOzhCQXRiYvfU3ez3Q
geNGrpX1eYDlOQ8diVdEHbzxJM84MgLYTFANWF7UPm6+h6eSpPH0nGAbQDE4U5It
C12sw7t1cffTQaCXKhQIB3lpN281n8BJOw9dibzS2pcqbJtIKMRVXBPNf0GJC5d/
QfRRt0vv3Z4hwyfDD2JNV0MbFQGg1gAwU9Db6WfjDYO4hVDSYH/tjlSzYWYPsHKp
yLRMAiUgNL9J1zDCyj45HoDQvqOQL9sbf8XM7zHTjNHlgOgv/jNFNwGwkDlgeVjg
jiNcSVrHwcTtt859Rdn4OxoAwMfNcaN+/3uZV6pysoqOy3N6AbG1D/vcCl0h4zUX
RzG77aWjgdaI0cRIS0ejrrycyrPlzSnU3c22dfTuMtjQ6U4zPKkJQivSl6ilCjh1
6zOoj6ezm9YW3RlVjo+YPVmNRMQFJg3LusSYmGUsx7sVxGAnR/NUbAs72xKf3OB+
HsDa6lBv4djYwXi5RD6QCUgO6/guHBrrbJUcFo3SMOY7I4+4zx47FjJcfTt3pau1
epOyz0n+C009ODPu/tOg
=BouM
-----END PGP SIGNATURE-----

--E13BgyNx05feLLmH--
