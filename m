Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197AbaFKWZM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 18:25:12 -0400
Received: from sauhun.de ([89.238.76.85]:47848 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751797AbaFKWZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 18:25:10 -0400
Date: Thu, 12 Jun 2014 00:25:04 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Max Schwarz <max.schwarz@online.de>
Cc: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org,
        Heiko =?utf-8?Q?St=C3=BCbner?= <heiko@sntech.de>,
        Maxime Ripard <maxime.ripard@free-electrons.com>, kfx@rock-chips.com
Subject: Re: [PATCH v6] i2c: add driver for Rockchip RK3xxx SoC I2C adapter
Message-ID: <20140611222504.GC3109@katana>
References: <5192968.EzcUiXba22@typ>
 <1956748.HoDAyYWJMb@typ>
 <8609129.ZdoNIueQ2G@typ>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gr/z0/N6AeWAPJVB"
Content-Disposition: inline
In-Reply-To: <8609129.ZdoNIueQ2G@typ>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gr/z0/N6AeWAPJVB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 11, 2014 at 10:34:37PM +0200, Max Schwarz wrote:
> Driver for the native I2C adapter found in Rockchip RK3xxx SoCs.
>=20
> Configuration is only possible through devicetree. The driver is
> interrupt driven and supports the I2C_M_IGNORE_NAK mangling bit.
>=20
> Signed-off-by: Max Schwarz <max.schwarz@online.de>

Applied to for-next, thanks!


--gr/z0/N6AeWAPJVB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTmNdAAAoJEBQN5MwUoCm2SG8QAK/C13XA/UVf3pj3B5Bt1hxv
7IZ5QndbVS6saU6mq8stfLKyi4CW04PD8Jktm+DkPKusgAYwpWmWz507sh+MSGAK
gRSNU6eoBVenbhs2ueA6IPdfYVoQ5SN+J6UiPs/Y635WbYy3ZuCYiCXRbl7V4HFb
sFIYiIV1ymRsvVFPezxwem8cGzk+T5mJmTQckJbxoB7FgJRvLEYg9MLg3JDVv6CN
6V4wmWQCi4YqQEVJS6eQPWRgcKrlD6jwH0StHP5+CKMoVDNG08+ghxe4cQ9EnKEd
0/l0FF88A9uNEiq7wHUdGuoVo9huYbHQjLbGoZyPDxC7xo4023LxWrGb2A3K6gAP
6wT6jj0UXk3RX/jTJa6mgREP70GiWrBJx762vV1xYca3/xW6Ga3HO0K0nP27L5UY
fGKMujOcL7SqtoSSt8BJWTyd2jO3Q3X4VuAkj4053rplVxmupxTrY1yXOseqNIR4
NQYEf+PweFn/pSQjBWKgfmKgUs8Ih8zI0p1/GNBK6kd6A/y4MTZiELKLO3707haw
KKA9dsJUKhbrigDNhDGEly60zlYqJTjxHI/olUf0BNT5JkJxrB+rvi+ua0yaLTxu
Oak8HmZBWk5DZIiJt8/SIW9sU66xzSMna10+uR6AXVpaLoyYILS7IrfuBvA4/Lba
uWxI62PIxsJ8O4uEFFlW
=gCOe
-----END PGP SIGNATURE-----

--gr/z0/N6AeWAPJVB--
