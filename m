Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759542Ab3GaLuE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 07:50:04 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:47271 "EHLO
	mail.free-electrons.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751098Ab3GaLuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 07:50:01 -0400
Date: Wed, 31 Jul 2013 13:49:57 +0200
From: "maxime.ripard" <maxime.ripard@free-electrons.com>
To: "kevin.z.m" <kevin.z.m.zh@gmail.com>
Cc: Emilio Lopez <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>,
        =?utf-8?B?5a2Z5b2m6YKm?= <sunny@allwinnertech.com>,
        =?utf-8?B?5ZC05Lmm6ICV?= <shuge@allwinnertech.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Re: [PATCH 4/4] ARM: sun6i: Enable clock support in the DTSI
Message-ID: <20130731114957.GD2911@lukather>
References: <1375195462-19566-1-git-send-email-maxime.ripard@free-electrons.com>
 <1375195462-19566-5-git-send-email-maxime.ripard@free-electrons.com>
 <51F86A2E.10505@elopez.com.ar>
 <20130731073724.GA24439@lukather>
 <2013073116110750016327@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WlEyl6ow+jlIgNUh"
Content-Disposition: inline
In-Reply-To: <2013073116110750016327@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WlEyl6ow+jlIgNUh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Kevin,

On Wed, Jul 31, 2013 at 04:11:11PM +0800, kevin.z.m wrote:
> Hi, Maxime,
>=20
> > The problem is a bit more complex than that.
>=20
> > On the A31, the losc clock is actually a mux between an external
> > oscillator running at 32kHz, and the internal oscillator running at
> > 667MHz, that would be scaled down.
>=20
> > Support for this mux is not quite there yet, since I've not seen any
> > documentation for it, but this would allow to just rearrange losc
> > parents and compatible when we will had such support.
>=20
> I think there is some misunderstanding. All allwinner's platforms have=20
> 2 losc clock source. One is the external 32KHz oscillator, and the other
> is internal 32kHz R/C circuit. The internal 32k R/C circuit can't provide
> a very exact clock on 32KHz. The mux is just for select external osc or i=
nternal
> 32KHz R/C. If there is no external 32kHz oscillator, we can replace it wi=
th=20
> internal 32kHz R/C for some low speed but not exact clock requirement.

Thanks for the clarification.

How does one select either the internal or the external 32kHz
oscillator? Is this done in software (I can't find any reference to that
in the user manuals) or in hardware?

Thanks,
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--WlEyl6ow+jlIgNUh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR+PnkAAoJEBx+YmzsjxAgeHgQAJgG2liVnGh8iGS6i6oT9Ypd
DXJpeqWv3TuyidQ0HquF/B+9QJjiyzr/gUnE9agExj84ZFMmm7m5iP3XE68YNVLI
NBUKfEgd4sHgfm9z4+b94832txIoUKdU5dbFCmgZ82COqndyqhk3XlQVl6mo8FFn
1jRgNSlGprrYZ7csGL3nrDELoHNGGO+fyYybculiC1PXq/f5SohN36+1c4Igaxh/
6TJV3ObdILGfEdIOuqhvXPJ98BPmwriYWfuHym8AGD0miJfTk7gTAnYl6QLKOMkx
k1JvemCHVJuxswOJXqfcdKwER6cOQakq2Q6m4XnSL5fj0mgJgERMHo6SrH8DvYRB
fY+9TZN4xmVeergyCb/lcxs/4j7XayG27Kj2nB5cDmM+jXHwWM0s59rFOjuKmDJX
k6xzJr5HsSSIxV5X/1cvud7GrchllNIk7/xeuTf4XD+7fokyRoLYkikMj3SYQcZX
v3W0Ea5cRQbuHndrzEtkeDqPUFh3MExPs7R5unXLW3TR+QzeF1dfI5jxg2eYL2xA
19YFUfqmsfCAiPWIfcHQb7oJXGmI1RYOmzSPHBAxj7Va4V1aLMHMxciS3QZeBcb2
Xm2wKYv16H14EoCt6bS79x2mYUoHNsbKe/cxZ1rd2LYxpz2Bj/3t/v9GI+2aK43B
GEV79GbXU013QQ2XbisO
=A+IT
-----END PGP SIGNATURE-----

--WlEyl6ow+jlIgNUh--
