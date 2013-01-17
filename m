Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756690Ab3AQKvW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 05:51:22 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:46150 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037Ab3AQKvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 05:51:21 -0500
Date: Thu, 17 Jan 2013 12:51:04 +0200
From: Felipe Balbi <balbi@ti.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Fabio Baltieri <fabio.baltieri@linaro.org>, Felipe Balbi <balbi@ti.com>,
        Ulf Hansson <ulf.hansson@linaro.org>, <linux-usb@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Mian Yousaf KAUKAB <mian.yousaf.kaukab@stericsson.com>
Subject: Re: [PATCH] usb: musb: ux500: use clk_prepare_enable and
 clk_disable_unprepare
Message-ID: <20130117105104.GN10814@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1357577261-31536-1-git-send-email-fabio.baltieri@linaro.org>
 <CACRpkdZD1i_tvDf6XFyk5muYjtDziQaMNGK6vvihhFJVztXUjw@mail.gmail.com>
 <20130110133818.GA22710@balto.lan>
 <CACRpkdbmgQ0xDfkbgqc=zDqMDUK0O6uQOf3kX9v1+=+N5s42bw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Sk71+Upln2BLuDmg"
Content-Disposition: inline
In-Reply-To: <CACRpkdbmgQ0xDfkbgqc=zDqMDUK0O6uQOf3kX9v1+=+N5s42bw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sk71+Upln2BLuDmg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 17, 2013 at 11:46:30AM +0100, Linus Walleij wrote:
> On Thu, Jan 10, 2013 at 2:38 PM, Fabio Baltieri
> <fabio.baltieri@linaro.org> wrote:
> > On Thu, Jan 10, 2013 at 12:23:32PM +0100, Linus Walleij wrote:
> >> On Mon, Jan 7, 2013 at 5:47 PM, Fabio Baltieri
> >> <fabio.baltieri@linaro.org> wrote:
> >>
> >> > This patch converts the module to use clk_prepare_enable and
> >> > clk_disable_unprepare variants as required by common clock framework.
> >> >
> >> > Without this the system crash during probe function.
> >> >
> >> > Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
> >>
> >> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> >
> > Thanks for the ACK.  This bug was here unnoticed since 3.6 merge window,
>=20
> Then it should have Cc: stable@kernel.org..

just added to my tree.

--=20
balbi

--Sk71+Upln2BLuDmg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ99eYAAoJEIaOsuA1yqRENC4P/3oRQd7UA8l1OceYB1MGG1rx
U6MT2HDCwVU2DBI+TFV3PasCUMW3XX211HFnc98OLngsKR/vmYzM/bWZ3ZVvdEk7
XhBe67+3GRhAaqEK3UnudqYrVhhH164Rtq8UJu6WCax7ngDr9aG+0iaViIIawMqx
v8yeG1BGGg/b9qv4yePHl8+t3GkBlxiYavn0Yxa3wTwWUVmG317kDuV/eu7Yk90O
01J6hE9LDe6k+ovY0MGK0P+eQU8fGuEqGY3kAW3MzMTqbXdtCtArWNV34L/55TDT
ULr0mjZVqZ0yK7uu8z2kUvmq/5psttP35E6HgZFiLE1UTeaVpo263iS/exN+XDFs
UTTToRfiRQytXsyN9Yd0SNktFnt0fymuJZ3kiR1Tbr2SahX/TSFZ4EbDmI4pkuLQ
MUtW4DLzEHRm6c/B89hNAGC59no7yjeZQIdUh9WnmYvbf2acfmIqxYJn6AL8YXnM
NVoh3LJfrlUdtlEJuSWYoq7et6sPQQHxwCVPtr+DGtGziK2atbJldIKUNJpgq9B3
TOHmKQ+SALT5Kt6dfADP4rQ5W1cOpH84KLE8cefSpkh+Y4Bjy4m5p8/zlg6P41Qo
cROU85BS+onulU7gIf5L5LgbkcSf2q/kL1zTq/nachF+Jcktpw9lg/XhuoJ/Di26
UTT9ESue2k7wYxHtxLNS
=QEjX
-----END PGP SIGNATURE-----

--Sk71+Upln2BLuDmg--
