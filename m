Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962AbaEVAGH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 20:06:07 -0400
Received: from mail.kernel.org ([198.145.19.201]:37925 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752101AbaEVAGD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 20:06:03 -0400
Date: Thu, 22 May 2014 02:05:58 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Tony Lindgren <tony@atomide.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        Carlos Chinea <cch.devel@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        =?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>,
        Joni Lapilainen <joni.lapilainen@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, Pavel Machek <pavel@ucw.cz>,
        Paul Walmsley <paul@pwsan.com>
Subject: Re: [PATCHv5 09/10] DTS: ARM: OMAP3-N900: Add SSI support
Message-ID: <20140522000558.GC29118@earth.universe>
References: <1399739870-13526-1-git-send-email-sre@kernel.org>
 <1399739870-13526-10-git-send-email-sre@kernel.org>
 <20140514215503.GM27426@atomide.com>
 <20140520003538.GD15793@atomide.com>
 <20140521182513.GA26285@earth.universe>
 <20140521184319.GL17417@atomide.com>
 <20140521194527.GM17417@atomide.com>
 <20140521215055.GA26362@earth.universe>
 <20140521220807.GB14520@atomide.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="/Uq4LBwYP4y1W6pO"
Content-Disposition: inline
In-Reply-To: <20140521220807.GB14520@atomide.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/Uq4LBwYP4y1W6pO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, May 21, 2014 at 03:08:07PM -0700, Tony Lindgren wrote:
> * Sebastian Reichel <sre@kernel.org> [140521 14:51]:
> > On Wed, May 21, 2014 at 12:45:28PM -0700, Tony Lindgren wrote:
> >=20
> > Right. The only documentation of the SSI module is existing
> > code sent by Carlos / included in the maemo kernel.
>=20
> That's probably better than any documentation though :)

Both have their advantages. Just with the code its hard to add
features like context loss checks.

> > > > It's probably something with the sysc or idlemodes that
> > > > keeps things from idling. Maybe wrong address? Or wrong
> > > > flags? I'm pretty sure it was the first .dts patch out of
> > > > these two as the second one alone did not apply.
> > >=20
> > > Hmm yeah below is probably how it should be, does this
> > > work for you? With this fix applied and your ssi dts
> > > patches n900 keeps hitting off-idle for me.
> >=20
> > I can confirm, that the N900 hits idle states when the DT
> > patch and the hwmod patch is applied. I have not actually
> > tested if it also works without your hwmod patch.
> >=20
> > There are still problems with the idle state if the driver is
> > actually loaded (and I see 100% runtime pm usage in powertop),
> > but that can be fixed later.
> >=20
> > Feel free to add Tested-by/Acked-By to the hwmod patch.
>=20
> OK thanks for testing.

You are welcome.

> I'll apply your dts changes as soon as I have an ack from Paul on
> the hwmod changes. Probably best to queue them together to avoid
> PM breaking.

Ok. Sounds legit.

-- Sebastian

--/Uq4LBwYP4y1W6pO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJTfT9mAAoJENju1/PIO/qaBJ8P+wYxFppWYeqJc8XYemc/Dxf4
qVLjw0FD69M2ElkTkVekQ+QT6AxWeGy8g+kTKaov3p1tkyoPGQxGjcFejI63/giM
Q+vGv1ojv3sMzx9gNFFVc7tgfqudAL+OWUJdFEdGeYwwvS4WqcmqM81a87FESo/C
BZIl5wcaXOa+kVu3aLAqPS21z3qoMvrleHcoGKOzRGHwP6J06iq8B3x99GMHVsEX
V19kWoyN7lIPxaLGBfjARcEN6AuKsJ4npW191qVbYWHOxyltlb+6nkgDAMu5ZFv7
Z7iTP2GcFpV6+Bgbqyx5T8kDFq95QzE17uM6aAKrlLO/W0zy/B/bAeVTx0R0J3Ki
dTyGvP8yl5uOkxB5Ozcb9yQ0iiN21WWMEBS+Q5lWDdrJkjaFyliUpFoZllyZSOzS
ruorXFAp3FuLdk0RIQK10DidXriPA/pXPVI46mK6wKNsyQk8OuT29MGz2l7DjhOu
oRC5M3j2Xkdc1zwfzz2XLVAc/YuJ6fQC4C5CwbSovlmeLYz47bLYv0EKOe6ugb3Z
3JsW4XkheBWBj4hi2uHfieMJHVdVu1LvCxhA05841ipSAiDf4T0+3vOEpmC0TtHK
UeCNfR9Wp/JYUyI7CMBlDQfgDlesnBzHCnNSCqtP9KP5kHlfa9ymM426TDTy+xIw
aJ5eSo79+niU5E83dlfa
=LoPK
-----END PGP SIGNATURE-----

--/Uq4LBwYP4y1W6pO--
