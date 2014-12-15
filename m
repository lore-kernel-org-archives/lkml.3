Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750805AbaLORXB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 12:23:01 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:60654 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbaLORW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 12:22:57 -0500
Date: Mon, 15 Dec 2014 17:22:02 +0000
From: Mark Brown <broonie@kernel.org>
To: Flora Fu <flora.fu@mediatek.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Matthias Brugger <matthias.bgg@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Rob Herring <robh+dt@kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, Liam Girdwood <lgirdwood@gmail.com>,
        arm@kernel.org, Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        srv_heupstream <srv_heupstream@mediatek.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        HenryC Chen <henryc.chen@mediatek.com>,
        Menghui Lin <menghui.lin@mediatek.com>,
        Olof Johansson <olof@lixom.net>, Sascha Hauer <kernel@pengutronix.de>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Eddie Huang <eddie.huang@mediatek.com>,
        Dongdong Cheng <dongdong.cheng@mediatek.com>
Message-ID: <20141215172202.GI11764@sirena.org.uk>
References: <1417752479-4749-1-git-send-email-flora.fu@mediatek.com>
 <20141209101341.GV30369@pengutronix.de>
 <CABuKBe+whgVryssULCu2MAXRu3u+pYwM2nN3ToTEGpEvniQ6Jw@mail.gmail.com>
 <3015972.tvmzP0zTdv@wuerfel>
 <1418292255.2315.12.camel@mtksdaap41>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JCIJwDXlZmsNNBnR"
Content-Disposition: inline
In-Reply-To: <1418292255.2315.12.camel@mtksdaap41>
X-Cookie: I don't get no respect.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3 1/8] soc: mediatek: Add PMIC wrapper for MT8135 and
 MT6397 SoC
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JCIJwDXlZmsNNBnR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 11, 2014 at 06:04:15PM +0800, Flora Fu wrote:
> On Tue, 2014-12-09 at 12:20 +0100, Arnd Bergmann wrote:

> > If it looks like i2c messages, would it be more appropriate to make
> > it appear as an i2c controller then?

> Although the message looks like I2C command, it is not I2C.
> Form source code, the software does not touch any I2C i/o or protocols.
> It depends SoC and has specific initial flow, read and write transfer
> state. It is not able to an i2c controller.

What Arnd is suggesting is that if the flow for using it is similar
enough to I2C you can push it through the I2C framework anyway even
though it'll never be possible to use it with generic devices.

> That's why we consider its a proprietary hardware with specific
> protocols. How about let it appear in driver/soc?

That's another option, though I'm not sure that's what the arm-soc
people are looking for.

--JCIJwDXlZmsNNBnR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUjxi6AAoJECTWi3JdVIfQw7wH/1AIX1p59noFFxlhkujylKr4
VBb6gyyUHBI5lFpWiDgk5Qe6auX4FaSdY3kro+chPto0uBJmAZsFE2kfu1JMlbJj
Jz4cqyfmOri5J+c7MG/0fQCv+2LyTSAhloDdjf8X6Y4pvRQmA0Mau3B1jHX2XYeH
s60qEawadTn37taFsj7qhkIrO9Weqs6IloejYXO+cmmrjJHdtc5NZZv2dPeGK5Ji
jESpOqy7T1b73IczBJsMCaFxZponQ8yLlkjNEjF2YjVwhmQBBOBFmGM7dt7BBcRa
j7tEq9EWcRCTJ5FbBuHRkN9Zb1rVzUINh2VGqt99BJ01z/pndWhdQA8D/oTNjVM=
=a5Zx
-----END PGP SIGNATURE-----

--JCIJwDXlZmsNNBnR--
