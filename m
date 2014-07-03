Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756619AbaGCOIa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 10:08:30 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:57909 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755079AbaGCOI1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 10:08:27 -0400
Date: Thu, 3 Jul 2014 09:07:36 -0500
From: Felipe Balbi <balbi@ti.com>
To: Robert Nelson <robertcnelson@gmail.com>
CC: Felipe Balbi <balbi@ti.com>, Tony Lindgren <tony@atomide.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux kernel <linux-kernel@vger.kernel.org>,
        <linux-serial@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH] tty: serial: Add 8250-core based omap driver
Message-ID: <20140703140736.GF5814@saruman.home>
Reply-To: <balbi@ti.com>
References: <1404316809-20637-1-git-send-email-bigeasy@linutronix.de>
 <20140702160932.GF5541@saruman.home>
 <20140702190944.GA567@drone.musicnaut.iki.fi>
 <CAOCHtYgxMeA+Arfe40XeFDEKuCJ8qo1RqNR0hYBGr_Wp6sRfdA@mail.gmail.com>
 <20140703073411.GX28884@atomide.com>
 <20140703132509.GA5814@saruman.home>
 <CAOCHtYi0JwRO12gHa+KFGH1k7pPk4TL40igwhzRRxutw-tqf6A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Y/WcH0a6A93yCHGr"
Content-Disposition: inline
In-Reply-To: <CAOCHtYi0JwRO12gHa+KFGH1k7pPk4TL40igwhzRRxutw-tqf6A@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Y/WcH0a6A93yCHGr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 03, 2014 at 08:34:44AM -0500, Robert Nelson wrote:
> On Thu, Jul 3, 2014 at 8:25 AM, Felipe Balbi <balbi@ti.com> wrote:
> > On Thu, Jul 03, 2014 at 12:34:11AM -0700, Tony Lindgren wrote:
> >> * Robert Nelson <robertcnelson@gmail.com> [140702 12:27]:
> >> > On Wed, Jul 2, 2014 at 2:09 PM, Aaro Koskinen <aaro.koskinen@iki.fi>=
 wrote:
> >> > > Hi,
> >> > >
> >> > > On Wed, Jul 02, 2014 at 11:09:32AM -0500, Felipe Balbi wrote:
> >> > >> > It has been only tested as console UART.
> >> > >> > The tty name is ttyS based instead of ttyO. How big is the pain=
 here,
> >> > >> > what could be the easiest way to provide compatibility?
> >> > >>
> >> > >> have been considering that myself for months. You could pass an o=
ptional
> >> > >> argument to serial8250_register_8250_port() but that only solves =
part of
> >> > >> the problem :-(
> >>
> >> Some kind of compability layer sure would be nice.
> >>
> >> > > When ttyS -> ttyO change was done on OMAP, compatibility was not a=
n issue.
> >> > > Why should we care about it now?
> >> >
> >> > It would be a good opportunity to force everyone to update their boo=
tloader. ;)
> >> >
> >> > Besides the BeagleBoard forum is quiet now, no one is complaining
> >> > about that old (ttyS -> ttyO) transition anymore..
> >>
> >> How about a Kconfig option to provide ttyO by default? The not even
> >> do that if kernel has cmdline option nottyomap.
> >
> > what about single zImage ? I don't want to use ttyO on my
> > Allwinner/Exynos/Snapdragon/whatever SoC just because OMAP is in the
> > same image ;-)
>=20
> What if we just kept it simple, leave the ttyO driver enabled and add
> a warning (pr_info) that it's deprecated.  It's not like it's broken,
> it just won't get later features or devices support added.

Fine by me, I'd switch to 8250 as soon as it's merged though :-) would
be nice to get an example DTS change just so I can start testing on the
boards I have around.

--=20
balbi

--Y/WcH0a6A93yCHGr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTtWOoAAoJEIaOsuA1yqREQmkQAKTtW2FusWULZTfVRTngk906
z11o+d8+ryjq4kod+GZ3xuYkk/JsS51+B+g0Sr+yDTZ+ol2zf9/ikq2FaCrb5vwL
eMrvADZ63tgQcbHjQFdfmdlzYew05p4AwOubFCH7wG0fXCMVNnt6xQx/N7fxsK/7
Z08oI4J57payqOA0KE8Yz4vKQXRIUzf+8KjR6SPMHlYF908Hz9tnRVhadU9361AC
JBQLJgScJgp3afR+ZrHOIIKsfxHqW1byZoFJwJfc+7t6WP6TuRpC1Ckwr7CKljmb
Oih49AWGhfR9gmW9faz3XWugDo0RKncIedpvw2wyk0otgTtxsMIjO6MA/fv01++5
HHbpY9PMMfGaR7dXljAnV/hYCz4oXj9NkMsORuReCufT8QwPlKdPGDo9Ja4AAD6t
MYBbsRuPoaEewYVA5PgNBNT2HbUjyf7GXk/fzq/4CTkTXaiAL0TY1xtJKoOQK0X7
Ogmtmrg8z3omQOVwuydk8X4rQNA2hFTg1AejUEom7kIz+gaio3oLNBoUW+MRtSQ5
ZL/oYlX5pLeolLQvb/c6tLpisG9LBz8yTN+myDMsWKMSGcsC6Zy2hMg0wAuEUpzX
YCl5VlQmD+WU7hRYLziVZjsjLs7YEo5deykCmp0R2uCYYi23rfeJVoMAchzXYqNF
OpbtXHr08qKLULkNA6EA
=WqE6
-----END PGP SIGNATURE-----

--Y/WcH0a6A93yCHGr--
