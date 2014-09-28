Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801AbaI1Kta (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 06:49:30 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50226 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbaI1Kt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 06:49:28 -0400
Date: Sun, 28 Sep 2014 11:48:51 +0100
From: Mark Brown <broonie@kernel.org>
To: Jianqun <xjq@rock-chips.com>
Cc: Jianqun <jay.xu@rock-chips.com>, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, heiko@sntech.de, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.de, grant.likely@linaro.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, huangtao@rock-chips.com,
        cf@rock-chips.com
Message-ID: <20140928104851.GR27755@sirena.org.uk>
References: <1410506806-15327-1-git-send-email-jay.xu@rock-chips.com>
 <1410507036-15442-1-git-send-email-jay.xu@rock-chips.com>
 <20140912134446.GT7960@sirena.org.uk>
 <54275C43.8010205@rock-chips.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Rnz0oC2K6vQ5doJs"
Content-Disposition: inline
In-Reply-To: <54275C43.8010205@rock-chips.com>
X-Cookie: You are magnetic in your bearing.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 92.40.249.138
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] ASoC: rockchip-max98090: add documentation for
 rockchip-max98090 driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Rnz0oC2K6vQ5doJs
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 28, 2014 at 08:54:27AM +0800, Jianqun wrote:

Please fix your mailer to word wrap within paragraphs.

> =E5=9C=A8 09/12/2014 09:44 PM, Mark Brown =E5=86=99=E9=81=93:
> > On Fri, Sep 12, 2014 at 03:30:36PM +0800, Jianqun wrote:
> >> Add documentation for rockchip-max98090 driver, which is need by rockc=
hip
> >> board using a max98090.

> > Can this use simple-card (perhaps after a bit of extension)?
> I haven't ever try simple-card, is there any sample usage for me from oth=
er vendor ?

$ git grep -l simple-audio-card
Documentation/devicetree/bindings/sound/simple-card.txt
arch/arm/boot/dts/kirkwood-openrd-client.dts
arch/arm/boot/dts/kirkwood-t5325.dts
arch/arm/boot/dts/r8a7740-armadillo800eva-reference.dts
arch/arm/boot/dts/sh73a0-kzm9g-reference.dts
arch/arm/boot/dts/vf610-twr.dts
sound/soc/generic/simple-card.c

> >> +- rockchip,audio-codec : The phandle of the MAX98090 audio codec.

> > Is the driver really specific to this CODEC?

> I think yes, we need to add two gpio for mic and hp detect, but simple-ca=
rd driver hasn't them

That'd be the "possibly with some extensions" bit then...  if they're
just isolated GPIOs there's not really much board specific about having
them.

--Rnz0oC2K6vQ5doJs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUJ+eSAAoJECTWi3JdVIfQprwH/jpU43m2FVwCxdorrZylCftl
kkry0nlH2ddvD2LiQJMZKrfq538rY/2aPLAHzrBGWufyBZ/1BvTWhh5MQV/1/bT3
C0mCniXU1svixSkATR1Zxaz3maUQmRiZvOE8+u4aEQz0kG3IRPOXUPW4suUGdboL
mm/2nmcbgfRyERimwunUrEs6M8OyCfEboPgdTypretGQo75c09gVVQW0oYjPrkx/
o/YPApkuF5OeiiDMYirCfaZ3ASOPpmx8TaInRzIPw07rsFE0K3Ri4OPZGnc+XxOd
aUo9TD09fXUolexFZhzk2pDcF4V/WkfngZTQCEFBHCWwiXDqMf7PwJM4fxiOX8I=
=0XVn
-----END PGP SIGNATURE-----

--Rnz0oC2K6vQ5doJs--
