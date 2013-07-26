Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932100Ab3GZMWX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 08:22:23 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:37535 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757366Ab3GZMWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 08:22:22 -0400
Date: Fri, 26 Jul 2013 14:22:19 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Mike Turquette <mturquette@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>, albert.u.boot@aribaud.net,
        Emilio Lopez <emilio@elopez.com.ar>, linux-kernel@vger.kernel.org,
        shuge@allwinnertech.com, linux-sunxi@googlegroups.com,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        Olof Johansson <olof@lixom.net>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 03/10] ARM: sunxi: Add the Allwinner A31 compatible to
 the machine definition
Message-ID: <20130726122219.GA3056@lukather>
References: <1374618312-19001-1-git-send-email-maxime.ripard@free-electrons.com>
 <1374618312-19001-4-git-send-email-maxime.ripard@free-electrons.com>
 <20130726123500.58136be1@skate>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sdtB3X0nJg68CQEu"
Content-Disposition: inline
In-Reply-To: <20130726123500.58136be1@skate>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sdtB3X0nJg68CQEu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Thomas,

On Fri, Jul 26, 2013 at 12:35:00PM +0200, Thomas Petazzoni wrote:
> Dear Maxime Ripard,
>=20
> On Wed, 24 Jul 2013 00:25:05 +0200, Maxime Ripard wrote:
> > The Allwinner A31 is a quad-Cortex-A7 based SoC, which shares a lot of
> > differences with the previous SoCs from Allwinner, like the PIO, I2C,
>=20
> "shares a lot of differences" ? I suppose you meant "has a lot of
> similarities", or "shares a number of hardware blocks", or something
> like that?

Yep

> > UARTs, timers, watchdog IPs, but also differs but droping the WEMAC
>=20
> "but also differs but droping" ?

*by* dropping.

> > ethernet controller and most notably droping the in-house IRQ
> > controller in favor of a ARM GIC one.
>=20
> droping -> dropping
>=20
> </nitpick> :)

Right.

Thanks!

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--sdtB3X0nJg68CQEu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR8mn7AAoJEBx+YmzsjxAgBlIP+QFydypNUoAOSJ2ji05XxSv3
3QddTXicJWhODHQ4MEhJPsmlVPlFedndN0opxCvUijearDs56kLmAIewweI+M0oY
/IttuVX+KuXBjMu9OL/6bc20yWqgaB7728oDIsa4veiCUxC8m36a/jZp80IgzscD
UjL2xIURkJkDkS/hCvUrL9pls+nSd8YtvJhOGZGGH53/2wTejjxIb2dntxO+YARw
BcZTgzfY3RkpflwiJK825XiXmfWiCU+wY18G9ZCT1HAYllUbCL1jvxbkgDywRVM9
ZvR3OaCUlxg+tGGMlnHxFI+Yt+sJ328pO+O4kv3ysiBz4jbppfp/U8hT+TLAB4CR
WRAvN6u0LtdJ5oPX4og5lSdyud6eAfYJZApeD7vh8xwN1fdezADTk28mw2CkB5K3
23S0XZZeS8fxutCaGLGHDV4LzcY+R87BuaYohtDJ98jMn9aDAsj6fELQOF32UcFd
XFZhOhq8VsMUsppDV25rB3a1Smb5aqA1PpXxczwAlSqOFCy+fcEtzb56b2UPjFLS
hmOLyMYomdkT0ZrsK5/2BAydmLfdhrDo34PAE7FuxryJf7VNapE3dt0JW4b5DGkr
XELyuu57ifuu23HIcLxKJ6MnD8oGaKekAug6HIDxDyf2NZ8jpoqgdY9IgW+pRCwl
o2TrPGxIjt/s3P6Cbhd+
=2qQJ
-----END PGP SIGNATURE-----

--sdtB3X0nJg68CQEu--
