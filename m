Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230Ab3HLIdZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 04:33:25 -0400
Received: from top.free-electrons.com ([176.31.233.9]:52585 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754028Ab3HLIdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 04:33:21 -0400
Date: Mon, 12 Aug 2013 10:33:19 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Emilio Lopez <emilio@elopez.com.ar>, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv3 4/9] pinctrl: sunxi: Add Allwinner A20 pins set
Message-ID: <20130812083319.GN2911@lukather>
References: <1375610330-18185-1-git-send-email-maxime.ripard@free-electrons.com>
 <1375610330-18185-5-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Yq3EGcigLBTDQpeG"
Content-Disposition: inline
In-Reply-To: <1375610330-18185-5-git-send-email-maxime.ripard@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Yq3EGcigLBTDQpeG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

On Sun, Aug 04, 2013 at 11:58:45AM +0200, Maxime Ripard wrote:
> The Allwinner A20 is pin-compatible with the older A10, so the two pin
> set are quite similar. However, since the A20 has new features, we can't
> just use the A10 pin set as is, and we need to define our own for the
> A20.

I'd like this to get merged in 3.12, do you have any comments on this
patch?

It's mostly just another round of pin sets additions for yet another
SoC, like we already had a few times.

Hopefully, it will be the end of it, unless if Allwinner release a new
SoC.

The only missing feature now is the gpio irq support for the A31 that
had a slightly different interrupts handling. Anyway, this support will
likely be in 3.13.

Thanks,
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--Yq3EGcigLBTDQpeG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSCJ3PAAoJEBx+YmzsjxAge/oQAIAhUbKul2vssUGw3k94aDvH
PzOTxrLVII8sOoemz9fj1JkXuUuQFh7m07JC1fYZhEr2R98Ctr5rUs7ZAxaT8ugy
+JzwAIGQTtmmO/v9mnMrA2FZw6fz0KYVmQnY9TqfaYKhPvOGoyAxIeIYlC5NrsDj
ZPk2I2hHyr31exUJGiteF5lokV3ZIYSJWYKPo2Xg4OFms10h1/o/Syza2cHQsVX/
TlGzQijfce17JJ6Ef5PSGujaXbqvscSBu9iEMNVhgcfJUZYZkpGsT1YI8BfrL9r1
NUxnullbrEnkXZ4BaTp0vq3n4Wkpq1HTlO1/1W+/0Pfk5uQxzZUMlSs+iE5zcL98
wpRY95Z2gou7WWEzews6nWoiopG9gbdvIFR3cSAgvMpX/pvn6D8yVY+4Onvc3go8
opvl6SAQ/6TX38sl68elTiKePnRT2KgC2CkBcqjurT7tWSGNxYCTMkdivq+DPvoD
I5Xh2wmBYwYSnmN/LtW9vXlon0uNlQ6tLpk937GYCloiCXlDiBCArShGRWAXpRNB
p+bxJkOfOD54Dd4ObINvmYDWHhAfwwKuFc29O403FGfEEJKlGLy2quezDFRUdw/a
WRmqzB0Vfd65JVGORDRFQuVrTmVr8iuJLa2oBoXthS9A3sNt8sPae9KdAtIAwQTb
WBKtZbg6mApP9cvOjYhU
=kkU6
-----END PGP SIGNATURE-----

--Yq3EGcigLBTDQpeG--
