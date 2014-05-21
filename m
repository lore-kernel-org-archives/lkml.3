Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256AbaEUUJi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 16:09:38 -0400
Received: from mail.kernel.org ([198.145.19.201]:58388 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753190AbaEUUJf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 16:09:35 -0400
Date: Wed, 21 May 2014 22:09:28 +0200
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
        Aaro Koskinen <aaro.koskinen@iki.fi>, Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCHv5 09/10] DTS: ARM: OMAP3-N900: Add SSI support
Message-ID: <20140521200928.GA27602@earth.universe>
References: <1399739870-13526-1-git-send-email-sre@kernel.org>
 <1399739870-13526-10-git-send-email-sre@kernel.org>
 <20140514215503.GM27426@atomide.com>
 <20140520003538.GD15793@atomide.com>
 <20140521182513.GA26285@earth.universe>
 <20140521184319.GL17417@atomide.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="5vNYLRcllDrimb99"
Content-Disposition: inline
In-Reply-To: <20140521184319.GL17417@atomide.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5vNYLRcllDrimb99
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, May 21, 2014 at 11:43:19AM -0700, Tony Lindgren wrote:
> > > Just noticed that this patch seems to somehow break idle
> > > modes on n900, so dropping both dts changes for now.
> > >=20
> > > Basically the n900 debug LEDs won't ever go off with
> > > these two dts patches enabled, even without the modem
> > > drivers loaded. I did not dig deeper, but it's probably
> > > something related to hwmod using this data for some
> > > settings.
> >=20
> > Is hwmod data interpreted at all without the DT entries?
>=20
> Yes for autoidling unused devices. We parse that with
> omap_device_build_from_dt().

That function seems to parse DT stuff. What I meant was
not without the *driver*, but without the *DT entry*.

I think the hwmod entries are completly ignored until there
is a DT device?

> > The hwmod data may be wrong. The information from commit
> > 398917ce161e10d3c66afaefdb89c73c64c4b02d was simply
> > interpolated from all information I found. The OMAP3
> > public TRM does not contain *any* information about the
> > ssi IP-Core.
>=20
> It's probably something with the sysc or idlemodes that
> keeps things from idling. Maybe wrong address? Or wrong
> flags? I'm pretty sure it was the first .dts patch out of
> these two as the second one alone did not apply.
> =20
> > > Sorry did not notice it earlier as I did not have the
> > > PM regression fix patches merged with my testing branch.
> >=20
> > I hoped to see working modem in 3.16, which will probably
> > be used for the next Debian stable :(
>=20
> That would indeed be nice, let's try to debug it as we
> still have few days.

I will have a look at it now.

> I'm finally able to test for PM regressions with DT patches,
> too > bad we did not have that earlier because of multiple issues.

Yes. More time would have been nice.

> Anyways, this dts issue should not prevent merging the
> driver changes, I'm all for that!

Of course, driver changes are unrelated. They are already
in linux-next btw.

-- Sebastian

--5vNYLRcllDrimb99
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJTfQf3AAoJENju1/PIO/qaWU0P/3vysiu5gPpGFreQQu57RqGP
lVzlQ5xczUbYN+Z8FGUR6VzPXD0/uTsAer7EXrwe+h7WeMdeQo7m4w6UEi6urCWD
n4X6eW7rnT7DeFhEY0dWRgWXTDQMGz+EmhWjfeclMkKVQEa6R3MFXfi79Vbr3BL8
BMddwDOjTjtPZCngwWxLoWrZLcvM+rDJ4XlBzi+XyvQGKJufoJgpXDinK63YqIdG
eE8VNP8D1xJLri5Hiaz7reHRW8EgyJbkqMjWrY1jskyyfiZRae0PAIPhfRc2b1Wa
tQFiZd+pMaga0N8JbEh1cjgx90wyRSskcn0x0MSXqs6RVj3bX03qxZgVApKA2JpJ
kK0sqWhtQdM4qol6x+TyezvMF+1qoQKP4OfvpDsNpbUtGx1cWK/Ae0EVSP6LgRMC
lWl2GMP3/J0UiHcqMM7ncDt67XfjSnuzON656w1DOAJBK3gJyLb2miU0umJEQnlP
IHgUxZ3kwSMFfCfjWSopZFujeBpsz30rVK0tWV/jPs3mVpYGW6F0KoS84ZwwTOdV
d5FnBl7PspkjLDvi8pZxSGvmEl3i3nUZtJXlmZHip1eCDCzwmOBc7zood478PP07
ZTpZzQ3iVWi/YjctAqzAGHtqRe53r/dKRrD0UFtiKVZdqNpxlPRNe+j3ErT1sdrr
zaHuSiOvdVHxHn5UwuPu
=NHrf
-----END PGP SIGNATURE-----

--5vNYLRcllDrimb99--
