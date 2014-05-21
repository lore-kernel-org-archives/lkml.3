Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526AbaEUVvF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 17:51:05 -0400
Received: from mail.kernel.org ([198.145.19.201]:33632 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752629AbaEUVvC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 17:51:02 -0400
Date: Wed, 21 May 2014 23:50:55 +0200
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
Message-ID: <20140521215055.GA26362@earth.universe>
References: <1399739870-13526-1-git-send-email-sre@kernel.org>
 <1399739870-13526-10-git-send-email-sre@kernel.org>
 <20140514215503.GM27426@atomide.com>
 <20140520003538.GD15793@atomide.com>
 <20140521182513.GA26285@earth.universe>
 <20140521184319.GL17417@atomide.com>
 <20140521194527.GM17417@atomide.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="azLHFNyN32YCQGCU"
Content-Disposition: inline
In-Reply-To: <20140521194527.GM17417@atomide.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, May 21, 2014 at 12:45:28PM -0700, Tony Lindgren wrote:
> * Tony Lindgren <tony@atomide.com> [140521 11:44]:
> > * Sebastian Reichel <sre@kernel.org> [140521 11:26]:
> > > The hwmod data may be wrong. The information from commit
> > > 398917ce161e10d3c66afaefdb89c73c64c4b02d was simply
> > > interpolated from all information I found. The OMAP3
> > > public TRM does not contain *any* information about the
> > > ssi IP-Core.
>=20
> Yeah seems to be just reserved..

Right. The only documentation of the SSI module is existing
code sent by Carlos / included in the maemo kernel.

> > It's probably something with the sysc or idlemodes that
> > keeps things from idling. Maybe wrong address? Or wrong
> > flags? I'm pretty sure it was the first .dts patch out of
> > these two as the second one alone did not apply.
>=20
> Hmm yeah below is probably how it should be, does this
> work for you? With this fix applied and your ssi dts
> patches n900 keeps hitting off-idle for me.

I can confirm, that the N900 hits idle states when the DT
patch and the hwmod patch is applied. I have not actually
tested if it also works without your hwmod patch.

There are still problems with the idle state if the driver is
actually loaded (and I see 100% runtime pm usage in powertop),
but that can be fixed later.

Feel free to add Tested-by/Acked-By to the hwmod patch.

-- Sebastian

--azLHFNyN32YCQGCU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJTfR+/AAoJENju1/PIO/qavZ4QAIehHB4nCf6yk5nJMRxwUpkz
tJTS/V7RBwRXHrX2+BiKPnuh4mzJBioSCntERZx+nEp+g3hA8XyiyXWYCRCdYk/w
vHVRxZ3BHIH93EDEkYYqfOp5njE83ePZ2IP72DZZoXIF914Xsehfzhi8s/VkYiGj
rLbkxM7xRVC06sFM9/OIR/SmGFLyMQu2gFOBjij43L30Vg3qPYxYCf6EFwqxAWiq
Fpg2JXEYn1ALXThyXIlW9bZeOOEz0EWzl0CRw++t68f9Vk1P5fcUWRRfP6mVLpcf
AL+ScouvgAEjkJQk+hfGOUud3TMbx/9+F9IoH8Vhxdr4rB+Z840eCu8tPdy0o6hE
ReFO/lcYWLHzv+QLbqbC0uz5o86BqXxSdG6BnCLMQsYiXZIQug9f/WPyQ+KegQx6
WhQiYenpYBTgNQgA4Fm6KrLJyZ9lxWwVhb9unA6dWXUbfw+QiX7IeELQD0J/S5N0
YOYDTMTy/mgvk9cUGRcgNWwUKI4e6QS4up58uxSNnTw0qxcT6d503nbeWFUzLdvt
1bThm7qxSkwkvcojKP7/4QmZAVEUR3djGM0XWcmyC91InNorzQoLoPbR1A7jEILM
KCch4C8fPROyReHqUfLL3XHAO0h+81wvl7BrK9Y6BrAniCT7TvnRuNARMYHfje1V
ew0fRPFYuKNuUO+STCWW
=d8ch
-----END PGP SIGNATURE-----

--azLHFNyN32YCQGCU--
