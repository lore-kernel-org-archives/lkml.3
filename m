Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757352Ab3BAT3c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 14:29:32 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55684 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755768Ab3BAT33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 14:29:29 -0500
Date: Fri, 1 Feb 2013 20:29:23 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, khali@linux-fr.org,
        ben-linux@fluff.org, grant.likely@secretlab.ca,
        devicetree-discuss@lists.ozlabs.org, sjg@chromium.org,
        grundler@chromium.org, naveenkrishna.ch@gmail.com,
        broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH v4] i2c: exynos5: add High Speed I2C controller driver
Message-ID: <20130201192923.GA23176@pengutronix.de>
References: <1354021236-28596-2-git-send-email-ch.naveen@samsung.com>
 <1359734084-10594-1-git-send-email-ch.naveen@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="u3/rZRmxL6MmkK24"
Content-Disposition: inline
In-Reply-To: <1359734084-10594-1-git-send-email-ch.naveen@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--u3/rZRmxL6MmkK24
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 01, 2013 at 09:24:44PM +0530, Naveen Krishna Chatradhi wrote:
> Adds support for High Speed I2C driver found in Exynos5 and later
> SoCs from Samsung. This driver currently supports Auto mode.
>=20
> Driver only supports Device Tree method.
> Note: Added debugfs support for registers view, not tested.
>=20
> Signed-off-by: Taekgyun Ko <taeggyun.ko@samsung.com>
> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> ---
> Help please,
>=20
> Usual reads and writes are happening. But, when i try doing
> i2cdetect -y 0 0x10 0x59; It throws me continous interrupts at 0x1a
> i2cdetect -y 0 0x50 0x64; It throws me continous interrupts at 0x63
>=20
> There are eeproms from 0x50 till 0x58
> wm8994 codec at 0x1a
>=20
> Kindly, can anyone explain this behaviour.

You select I2C_FUNC_SMBUS_EMUL, but make sure your hardware really
supports I2C_FUNC_SMBUS_QUICK. That would be my first guess. Also, which
eeprom do you have? Check its datasheet, some in deed use 8 addresses.

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--u3/rZRmxL6MmkK24
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlEMF5MACgkQD27XaX1/VRuM3QCbBcAfzGgPKWsLTrkhFvLpB53t
S6IAn2f/VN+TgMX6H6KfBdwS2PNuXyRh
=mwNd
-----END PGP SIGNATURE-----

--u3/rZRmxL6MmkK24--
