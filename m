Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754319AbaEEEZJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 00:25:09 -0400
Received: from top.free-electrons.com ([176.31.233.9]:35423 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751090AbaEEEZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 00:25:07 -0400
Date: Sun, 4 May 2014 23:21:47 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Mark Brown <broonie@kernel.org>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: Re: [PATCH] spi: Force the registration of the spidev devices
Message-ID: <20140505042147.GE11606@lukather>
References: <1398705774-12361-1-git-send-email-maxime.ripard@free-electrons.com>
 <20140429183758.GH15125@sirena.org.uk>
 <20140430180609.GC3000@lukather>
 <20140501011811.GF3245@sirena.org.uk>
 <20140501223629.GJ3000@lukather>
 <20140502174048.GV3245@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BQPnanjtCNWHyqYD"
Content-Disposition: inline
In-Reply-To: <20140502174048.GV3245@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BQPnanjtCNWHyqYD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 02, 2014 at 10:40:48AM -0700, Mark Brown wrote:
> > i2c-dev works great in these cases, because you always have access to
> > all the bus, and all the devices, except if the device is already used
> > by someone. The patch I suggested is an attempt to mimic this.
>=20
> It seems better to implement something like this at the device model
> level, provide a way to have a default UIO driver for anything on a
> given bus.  I don't see anything bus specific apart from saying what the
> default driver to use is and it avoids the icky code fiddling about with
> what devices are bound and the races that might be involved duplicated
> in individual buses.

Hmmm, yes, that's probably a great long-term way of dealing with this,
but I don't see it happening soon.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--BQPnanjtCNWHyqYD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTZxHbAAoJEBx+YmzsjxAguHcP/1LgErzSVAuc2Fbo+te3I4ff
Hmcd2Q0lekO/abNgGJwiFLvB4BZ2RXufh/cQdABkVjV3dNwC0W+XnQuckX6yHWME
TIJ2gpPGVh2iaQRoU9BHPxRfCNuQuoSaedLAZMGQzhrxXyGGIktbmb+jMqYJ4/58
ryUF5cMX+3rzI12eZv0zUJUNsNvPZlgC46dc6qAWqy6RMuNFKVZtnuQKUgDsXQHA
6zKgJaxuNXBiS5YDAJsGdbTffql+HHjW1JvXK4W4cCmqKDEjXbTXs++yiA4ZlzU8
6FCiKJAGU4uYsrgqWRWSwbLH2u8LBYRA0rX+FEozfeine0DsmZwD+qhMwKzJjAAI
u+R+VmMSAp/dRTzKOR0gOsxSLCJqiqxiZpzkSsh+L2HXy907Irr8cBpoRzp9S9Lq
ZuUV5tFtlNllKmvrUe+anmJ891+4y10aOxrK3cta7xaEdtWS1SSBRec28LADVrmL
sSllZpq7x4ZpC9QMUBlKNWkjsjzVsiWskLsDYMB2hoyX/tX6GaeWrvlA9NJiKWjZ
UX2l552ZdvFPSKWZTH+Jxz6vmyBPlrOy4u4VvP1sc74hlXsLAuHdA+cBr6kXG7jR
2zyoUMqDssPbkyocofy6807S8sgkWudAzN5s2fK/Q+i3ca4x1TC/tbsDmycPi6RD
rrWeC7bcLQQG7qY0E3Ci
=ovOX
-----END PGP SIGNATURE-----

--BQPnanjtCNWHyqYD--
