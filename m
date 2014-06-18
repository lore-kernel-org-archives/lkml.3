Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966420AbaFRMZI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 08:25:08 -0400
Received: from top.free-electrons.com ([176.31.233.9]:52880 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S966264AbaFRMZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 08:25:04 -0400
Date: Wed, 18 Jun 2014 14:24:38 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Chen-Yu Tsai <wens@csie.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Rob Herring <robh+dt@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Emilio Lopez <emilio@elopez.com.ar>,
        Linus Walleij <linus.walleij@linaro.org>, linux-serial@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@googlegroups.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Luc Verhaegen <libv@skynet.be>
Subject: Re: [PATCH v2 16/20] mfd: sun6i-prcm: Add support for Allwinner A23
 PRCM
Message-ID: <20140618122438.GR19730@lukather>
References: <1403016777-15121-1-git-send-email-wens@csie.org>
 <1403016777-15121-17-git-send-email-wens@csie.org>
 <20140618082953.GO21030@lee--X1>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wlFCko3yyTbBmKK8"
Content-Disposition: inline
In-Reply-To: <20140618082953.GO21030@lee--X1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wlFCko3yyTbBmKK8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 18, 2014 at 09:29:53AM +0100, Lee Jones wrote:
> > The Allwinner A23 SoC has a PRCM unit like the previous A31 SoC.
> > The differences are the AR100 clock can no longer be modified,
> > the APB0 clock has different divisors, and some clock gates are
> > gone.
> >=20
> > This patch adds a compatible with a modified subdevice list for
> > the A23.
> >=20
> > Signed-off-by: Chen-Yu Tsai <wens@csie.org>
> > ---
> >  .../devicetree/bindings/mfd/sun6i-prcm.txt         |  2 +-
> >  drivers/mfd/sun6i-prcm.c                           | 30 ++++++++++++++=
++++++++
> >  2 files changed, 31 insertions(+), 1 deletion(-)
>=20
> The patch looks fine to me, but I'm concerned about the size of the
> patch set and the amount of subsystems it touches.
>=20
> I am guessing that this patch can just be taken independently though.
> Please correct me if I'm wrong.

I have a bit of the same concern. We have several comments on the
previous patches, so I'm not even sure this patch can go as is.

It would be much easier if you (ChenYu) could introduce first a very
basic with just the UART support, and then, as separate series,
clocks, PRCM, MMC, and so on.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--wlFCko3yyTbBmKK8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJToYUGAAoJEBx+YmzsjxAgFgQQAIFV39VFywpdemlvomlVoRUb
fUY1PHfrAoAVH+mOtGjzI6XnU7z2P9JJkD4982XdvEHMPQXNBCnDB5jKWjv3syMG
qPXPpi5iCIWNnzaJD0gJ5U4Hd2f8EoyY6yA1NyVk4xzAUjfhbmyeRxgGTgciHBrr
ScmAqp+ZGnfW4EV+e+BrAJwf64q4AtqBIORTAWm+iYAv7Zpt6TH1tW9IZzwiXE7e
IRb4Mx9VwLLnLxqCNeEfx4sCf9zpy5Z6j08lh+aKkNd+XywHzaZxrto+5CjsmCqv
kSPxpfz9/H6lVBXa1PeaBkiFk/FewR+DutX5/CIgLMoHXgyZLmIEesiN+yca3FMe
hrmHCZC18R9If5s6Aeq6p1cTiwD+atkqtYvOaZv14io7h5bXteSkO50hjHIbTM3F
K19TYh5T6sG3YOhV2pCwsncCr3xjdUboUV20/J1oobuurEY+2BUusfWZTkRVxk2f
rcL5IVyahKnoZJq8Mmgx6JHmuHN12U3fifCEQjVdWZ9KImVZnPO1b32TlQwLBnSo
kelWqFLARA03boq9fNeg6z9Bqta/s6VV5HsCT96dvK3KmPsYnL52DKI9ah6zf+Ez
Ag5IqMPGm5DlI9R7aAN9WLfEul1SAs9x8DDzD/djPFkrE9fFNdYpFA/eBwFUEB7t
c6zjASzuBICp1Gl4NLTZ
=tKvn
-----END PGP SIGNATURE-----

--wlFCko3yyTbBmKK8--
