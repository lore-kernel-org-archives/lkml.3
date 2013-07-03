Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932624Ab3GCIzW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 04:55:22 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:49860 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932215Ab3GCIzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 04:55:18 -0400
Date: Wed, 3 Jul 2013 10:55:05 +0200
From: "maxime.ripard@free-electrons.com" <maxime.ripard@free-electrons.com>
To: plagnioj@jcrosoft.com
Cc: linux-fbdev@vger.kernel.org, FlorianSchandinat@gmx.de,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "fabio.estevam@freescale.com" <fabio.estevam@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        "brian@crystalfontz.com" <brian@crystalfontz.com>,
        hector.palacios@digi.com
Subject: Re: [PATCH RESEND] video: mxsfb: fix color settings for 18bit data
 bus and 32bpp
Message-ID: <20130703085505.GG2969@lukather>
References: <51C01DE1.8030300@digi.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bFsKbPszpzYNtEU6"
Content-Disposition: inline
In-Reply-To: <51C01DE1.8030300@digi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bFsKbPszpzYNtEU6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jean-Christophe,

On Tue, Jun 18, 2013 at 10:44:17AM +0200, Hector Palacios wrote:
> For a combination of 18bit LCD data bus width and a color
> mode of 32bpp, the driver was setting the color mapping to
> rgb666, which is wrong, as the color in memory realy has an
> rgb888 layout.
>=20
> This patch also removes the setting of flag CTRL_DF24 that
> makes the driver dimiss the upper 2 bits when handling 32/24bpp
> colors in a diplay with 18bit data bus width. This flag made
> true color images display wrong in such configurations.
>=20
> Finally, the color mapping rgb666 has also been removed as nobody
> is using it and high level applications like Qt5 cannot work
> with it either.
>=20
> Reference: https://lkml.org/lkml/2013/5/23/220
> Signed-off-by: Hector Palacios <hector.palacios@digi.com>
> Acked-by: Juergen Beisert <jbe@pengutronix.de>
> Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>

I don't see this patch in your for-next branch.

It would be really great to have it for 3.11 if possible.

Could you take a look at this patch please?

Thanks,
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--bFsKbPszpzYNtEU6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR0+bpAAoJEBx+YmzsjxAgUhwP/iV0i0SDisdJtZA8ixm7mhM0
qY3QcWXPXaOGw7smEoEZ/fFX8IBuweXYyb31bR9KNBHMjFdfFCYK9sv1f7RPd3UP
uXDpiyhmtvC86SqoZlGlfG8jSzTgjz/YnyvO6zbEmKBJuxAh/FkWgLCH3Ex88hj9
5d63AzLaareVJqe4S66PzJKUaeRvCWi1bJfmRTxDm6L7I4cKlkRYik0iPGdrIQCt
+X9AmV2CROVMxubqHLct/jOakPkmANIaShnaoGca06+i7h/wGV3VFUDw5mYQbKb9
tN+hs4I4SCUp5yVLpsHQUrvCgm6E1L7xlm/j7wIc7i0ereUk6PvUERjoKXsVeYNy
x4KFRQjJiWSdV72KEgUs+g5+n+rPht4kveVOOGdKVgnJoUm+iSJlSZPyr4FCQsbX
367GHxNN+DeGUkZhXvmpfFbH0ywizfq6ns+ykfnA2x5b36zPo8W47M4Go8JD0DTx
ECmv50gVJ07W8exujivSnBUIhaLi5tTP0YlmctIkOHmyyCwfFkl4Bu6e4JzkT/aG
3NTDtFMbJo3XZEy8LOVURm2MlnKl28ZTwuZsFQajBl2jeJKLAU9uowQ6tArpSODd
v7g7zTfnQBVv8sNOb2eJfJDraqLhl7awjyDmxnG1tyrNH09Qbt7NvkcgDBhPh3+m
M4fPnZK8rfh4E0qtpgOs
=G49y
-----END PGP SIGNATURE-----

--bFsKbPszpzYNtEU6--
