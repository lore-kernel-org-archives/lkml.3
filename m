Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759993Ab3ICLVl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 07:21:41 -0400
Received: from top.free-electrons.com ([176.31.233.9]:36992 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759979Ab3ICLVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 07:21:39 -0400
Date: Tue, 3 Sep 2013 13:21:36 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: oliver+list@schinagl.nl
Cc: arnd@arndb.de, gregkh@linuxfoundation.org,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        linus.walleij@linaro.org, linux-kernel@vger.kernel.org,
        andy.shevchenko@gmail.com, tomasz.figa@gmail.com,
        linux-sunxi@googlegroups.com, Oliver Schinagl <oliver@schinagl.nl>
Subject: Re: [PATCHv7 1/2] ARM: sunxi: Initial support for Allwinner's
 Security ID fuses
Message-ID: <20130903112136.GC2630@lukather>
References: <1378204408-1415-1-git-send-email-oliver+list@schinagl.nl>
 <1378204408-1415-2-git-send-email-oliver+list@schinagl.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bAmEntskrkuBymla"
Content-Disposition: inline
In-Reply-To: <1378204408-1415-2-git-send-email-oliver+list@schinagl.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bAmEntskrkuBymla
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 03, 2013 at 12:33:27PM +0200, oliver+list@schinagl.nl wrote:
> From: Oliver Schinagl <oliver@schinagl.nl>
>=20
> Allwinner has electric fuses (efuse) on their line of chips. This driver
> reads those fuses, seeds the kernel entropy and exports them as a sysfs
> node.
>=20
> These fuses are most likely to be programmed at the factory, encoding
> things like Chip ID, some sort of serial number, etc. and appear to be
> reasonably unique.
> While in theory, these should be writeable by the user, it will probably
> be inconvenient to do so. Allwinner recommends that a certain input pin,
> labeled 'efuse_vddq', be connected to GND. To write these fuses however,
> a 2.5 V programming voltage needs to be applied to this pin.
>=20
> Even so, they can still be used to generate a board-unique mac from,
> board unique RSA key and seed the kernel RNG.
>=20
> On sun7i additional storage is available, this is initially used for an
> UEFI BOOT key, Secure JTAG key, HDMI-HDCP key and vendor specific keys.
>=20
> Currently supported are the following known chips:
> Allwinner sun4i (A10)
> Allwinner sun5i (A10s, A13)
> Allwinner sun7i (A20)
>=20
> Signed-off-by: Oliver Schinagl <oliver@schinagl.nl>

Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--bAmEntskrkuBymla
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSJcZAAAoJEBx+YmzsjxAgfx0P/RVmmpDk2eiogvM7N6D4h9wm
B3JJyZkTYpoMNx/Fwqu3npXAIQ1pwgkmq7il3cqDpHaa3X9b1/yXGgEWto1iKtjs
lZRmOpDDsxnclxDHfldpJMVrOtU7O8Dg68pINqi9pn0eF91FzvR5eYmtDQSIc1X7
O5oNjRU1o+FMbrI31sObUJYDV9X82srPx9QW5HAEq8kDzlvKNOplfojTgGbkhYxc
AbwEbqkQIOPNg8JpwwYxtDSZV5pEotWoXWrugF0a0hjQgE5PVh1koqmFzcBA/G7Z
qggKBiCJN4MvcJFwgcd+eSna80kBpr9DRd73eDyiR3cCIjhsZhHWLlgrDixUbIU5
tdD4WeyeFvcgoNFxlIgljRrwX+eY1HkYVEIaYI0CJ1T8eHHFxZBreYspwSu4op5h
yi3N/ZZ7S049n4LpV5Xlt0JtpfemBQP42nO11fRHwarOjbQkHTuLLhfvYWpbEbm1
8UbShm+Tl7EvDrAIa/GnNy0jNJYJvOaS2LugnIXBoj8f/MBNI3IZiMKXBexGlmcO
cM8+gRDp4vBHSv/7SAZtwZnDUEa4xP4HcDQa45evZuQ3AiJQJ2zNEcSa4NFixqQL
pgJUYJVnBFZZKZy8WLkzF3BQGW36wKqlp/icF9Ln6r/nscIl8bramUik3gv9jGLN
Q2Xjklq6kX9rIKzKUcU5
=tUKu
-----END PGP SIGNATURE-----

--bAmEntskrkuBymla--
