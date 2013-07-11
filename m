Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271Ab3GKQhN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 12:37:13 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:46591 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999Ab3GKQhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 12:37:10 -0400
Date: Thu, 11 Jul 2013 18:37:08 +0200
From: "maxime.ripard@free-electrons.com" <maxime.ripard@free-electrons.com>
To: Hector Palacios <hector.palacios@digi.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "fabio.estevam@freescale.com" <fabio.estevam@freescale.com>,
        Marek Vasut <marex@denx.de>, "cb@sgoc.de" <cb@sgoc.de>
Subject: Re: MXS persistent bits driver
Message-ID: <20130711163708.GW11243@lukather>
References: <51DE5F1A.8010209@digi.com>
 <20130711082413.GU11243@lukather>
 <51DE734A.80206@digi.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="A6Z7MKnLVMfR85kG"
Content-Disposition: inline
In-Reply-To: <51DE734A.80206@digi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--A6Z7MKnLVMfR85kG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Hector,

On Thu, Jul 11, 2013 at 10:56:42AM +0200, Hector Palacios wrote:
> On 07/11/2013 10:24 AM, maxime.ripard@free-electrons.com wrote:
> >>I haven't seen this is supported upstream. Is anybody working on that?
> >>Where would such a driver fit?
> >
> >Christoph Baumann recently started porting the Freescale's driver to
> >newer release.
> >
> >http://lists.infradead.org/pipermail/linux-arm-kernel/2013-July/181569.h=
tml
> >
> >This needs quite a lot of work, but it's ongoing.
> >
> >Also, about where to put such a driver, I started a discussion about
> >this last week. Mostly, that would be part of MTD, from what is out of
> >the discussion so far.
> >
> >http://lists.infradead.org/pipermail/linux-arm-kernel/2013-July/182002.h=
tml
>=20
> I was talking about RTC persistent bits, not OTP bits, but I they
> also fit in your EEPROM like model. I like it!

Oops, sorry, I read your mail too quickly.

But it's true that it would fit quite well in the EEPROM stuff we're
discussing.

Feel free to participate, and I'll let you know if something come out of
it.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--A6Z7MKnLVMfR85kG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR3t80AAoJEBx+YmzsjxAg3XsQAIaUjfX2ebrOH4mtIdsZfadq
4BUAJ/vb/YJdO5MBrlUKxxlu/lU7Q/gC3ydJ+jFxzXtpfD94v7yHu4He1ivYra4X
2mJXL00VjskUqrU/4BdzGrX80T14P/0Kw/H+6cwP00zvu0f11yONSGwMkrMPaiHL
M86bdojSCv2SwPN2Vo1E2oJ9C6jsSVNjxOGHho2X/s7pd2oPN9LSy+nJc0m9CqY2
hL0KIAqkBo7ExRhNxXefVzJm05NENzl5EHxCTXQ7ZHoZ53GlDrSfarMa0mGifGCk
arn2hjwTiNLWs54pVOinSD6QHR1oE2BD9VJSezJ60g7kb+lJmxTdtTQpYefXS+wk
oOQImvPaAtT35nltvn+ItRatjt49gXsYCuzyMg8RQgDZ90GsdoaZXqj9LrpwDQWc
u4b1cHo72bAyYxbMdYdT3upSMt8wvLEN9NDrmzQVfH8Owubd8/Qv9iIfooKhmRmi
WEVU07QmC0QMDnVFpCAmVZHOC4ug6iXS2ulRGO3gbWN3hBkJPUBcyN+AloBtTu2s
2s2HXhhWQ9ZdrrmUdvy1Tr0q/Uy/jc4j08r6aeQyVRKhyxmZVXxGE+XRcWeqD8i+
toaRtFHdI/WeMbZQIYy5gOVDljNpNYPLpWlF+hG9Ott4rYGV2/k/z6nmN0nzGbP8
n5yKt9SgihhJcJ+f6cdC
=jAqQ
-----END PGP SIGNATURE-----

--A6Z7MKnLVMfR85kG--
