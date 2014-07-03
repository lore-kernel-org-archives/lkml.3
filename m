Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932289AbaGCPxc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 11:53:32 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:34003 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759254AbaGCPx3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 11:53:29 -0400
Date: Thu, 3 Jul 2014 10:52:40 -0500
From: Felipe Balbi <balbi@ti.com>
To: Sebastian Reichel <sre@kernel.org>
CC: Felipe Balbi <balbi@ti.com>, Robert Nelson <robertcnelson@gmail.com>,
        Tony Lindgren <tony@atomide.com>, Aaro Koskinen <aaro.koskinen@iki.fi>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux kernel <linux-kernel@vger.kernel.org>,
        <linux-serial@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH] tty: serial: Add 8250-core based omap driver
Message-ID: <20140703155240.GU5814@saruman.home>
Reply-To: <balbi@ti.com>
References: <1404316809-20637-1-git-send-email-bigeasy@linutronix.de>
 <20140702160932.GF5541@saruman.home>
 <20140702190944.GA567@drone.musicnaut.iki.fi>
 <CAOCHtYgxMeA+Arfe40XeFDEKuCJ8qo1RqNR0hYBGr_Wp6sRfdA@mail.gmail.com>
 <20140703073411.GX28884@atomide.com>
 <20140703132509.GA5814@saruman.home>
 <CAOCHtYi0JwRO12gHa+KFGH1k7pPk4TL40igwhzRRxutw-tqf6A@mail.gmail.com>
 <20140703140736.GF5814@saruman.home>
 <20140703154425.GC23309@earth.universe>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="e1+sTVyxRliB/aPL"
Content-Disposition: inline
In-Reply-To: <20140703154425.GC23309@earth.universe>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--e1+sTVyxRliB/aPL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 03, 2014 at 05:44:26PM +0200, Sebastian Reichel wrote:
> Hi,
>=20
> On Thu, Jul 03, 2014 at 09:07:36AM -0500, Felipe Balbi wrote:
> > On Thu, Jul 03, 2014 at 08:34:44AM -0500, Robert Nelson wrote:
> > > On Thu, Jul 3, 2014 at 8:25 AM, Felipe Balbi <balbi@ti.com> wrote:
> > > > On Thu, Jul 03, 2014 at 12:34:11AM -0700, Tony Lindgren wrote:
> > > >> * Robert Nelson <robertcnelson@gmail.com> [140702 12:27]:
> > > >> > On Wed, Jul 2, 2014 at 2:09 PM, Aaro Koskinen <aaro.koskinen@iki=
=2Efi> wrote:
> > > >> > > Hi,
> > > >> > >
> > > >> > > On Wed, Jul 02, 2014 at 11:09:32AM -0500, Felipe Balbi wrote:
> > > >> > >> > It has been only tested as console UART.
> > > >> > >> > The tty name is ttyS based instead of ttyO. How big is the =
pain here,
> > > >> > >> > what could be the easiest way to provide compatibility?
> > > >> > >>
> > > >> > >> have been considering that myself for months. You could pass =
an optional
> > > >> > >> argument to serial8250_register_8250_port() but that only sol=
ves part of
> > > >> > >> the problem :-(
> > > >>
> > > >> Some kind of compability layer sure would be nice.
> > > >>
> > > >> > > When ttyS -> ttyO change was done on OMAP, compatibility was n=
ot an issue.
> > > >> > > Why should we care about it now?
> > > >> >
> > > >> > It would be a good opportunity to force everyone to update their=
 bootloader. ;)
> > > >> >
> > > >> > Besides the BeagleBoard forum is quiet now, no one is complaining
> > > >> > about that old (ttyS -> ttyO) transition anymore..
> > > >>
> > > >> How about a Kconfig option to provide ttyO by default? The not even
> > > >> do that if kernel has cmdline option nottyomap.
> > > >
> > > > what about single zImage ? I don't want to use ttyO on my
> > > > Allwinner/Exynos/Snapdragon/whatever SoC just because OMAP is in the
> > > > same image ;-)
> > >=20
> > > What if we just kept it simple, leave the ttyO driver enabled and add
> > > a warning (pr_info) that it's deprecated.  It's not like it's broken,
> > > it just won't get later features or devices support added.
> >=20
> > Fine by me, I'd switch to 8250 as soon as it's merged though :-) would
> > be nice to get an example DTS change just so I can start testing on the
> > boards I have around.
>=20
> DT is supposed to contain information about the hardware, so it
> should stay the same? I think there is no non-hackish way to decide

compatible would change, at a minimum.

--=20
balbi

--e1+sTVyxRliB/aPL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTtXxIAAoJEIaOsuA1yqREMHUQAJJkqk7Mqi4xgRBwJD9m8qWS
KmbZmqzb0kqC/4u6uLPDJ09GIi5dSYR5fgRbp6q/QT3TvTG5cgSdUq6cmfpdNWBS
2Xer67eo8Ep0oGKM5Bx5jqJmygoVKQt6DBbGo/9wc5qaL1AVJoQeuZD0isDovN/1
FTa9OiGJSfuyix+jYIk9+kgF4ShdCFip5SCF0qICntY5L+5NaxTinA01sbz7rz+C
AMbpD/C8tpjM2DrsNE4VB7wTCwv7vh/WEeExoS8oHFh/jH0VVgwcZ2WwidvE6hsZ
MFCgbPPsWTl86IZez1k4SyUnMwPWhxfWJztk3yoSsJxDJrBJfF0wmUPa7NlX/qGA
4dWSYyYdQ7rk1JQ9eCFdp6o+WMesIH4KC6gvMRRDFZZR7sqUdc+ZmbjBbdwkC3v3
mnIkvbQ+uYNs49554l3ACnABdSQjyJVjVg3s2R+38OEDC0JNrtjFNPHoSgbI3oRP
dgPN4xKJztU8mDZ2kgoWRozMsjmpVoPv63Dnm2FL7/YqMc6shfimB/g+1m0iDBuL
pm5YwI21lvGVm6eEItQ8loRn+Wzqdgi8K/THYor8p2oLh6kiHT/37CkgoETG5XI5
OHWFNUeqSJEbVipyRQwsdHLkmQJW8RcUX/Yr9uZlMvTxMtu2JsonmJlRegSC7uA6
XFauLn0q3IzlGRA+KHxc
=+O5v
-----END PGP SIGNATURE-----

--e1+sTVyxRliB/aPL--
