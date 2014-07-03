Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932437AbaGCNZ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 09:25:56 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:56060 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932381AbaGCNZx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 09:25:53 -0400
Date: Thu, 3 Jul 2014 08:25:09 -0500
From: Felipe Balbi <balbi@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: Robert Nelson <robertcnelson@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, Felipe Balbi <balbi@ti.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux kernel <linux-kernel@vger.kernel.org>,
        <linux-serial@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH] tty: serial: Add 8250-core based omap driver
Message-ID: <20140703132509.GA5814@saruman.home>
Reply-To: <balbi@ti.com>
References: <1404316809-20637-1-git-send-email-bigeasy@linutronix.de>
 <20140702160932.GF5541@saruman.home>
 <20140702190944.GA567@drone.musicnaut.iki.fi>
 <CAOCHtYgxMeA+Arfe40XeFDEKuCJ8qo1RqNR0hYBGr_Wp6sRfdA@mail.gmail.com>
 <20140703073411.GX28884@atomide.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YZ5djTAD1cGYuMQK"
Content-Disposition: inline
In-Reply-To: <20140703073411.GX28884@atomide.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--YZ5djTAD1cGYuMQK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 03, 2014 at 12:34:11AM -0700, Tony Lindgren wrote:
> * Robert Nelson <robertcnelson@gmail.com> [140702 12:27]:
> > On Wed, Jul 2, 2014 at 2:09 PM, Aaro Koskinen <aaro.koskinen@iki.fi> wr=
ote:
> > > Hi,
> > >
> > > On Wed, Jul 02, 2014 at 11:09:32AM -0500, Felipe Balbi wrote:
> > >> > It has been only tested as console UART.
> > >> > The tty name is ttyS based instead of ttyO. How big is the pain he=
re,
> > >> > what could be the easiest way to provide compatibility?
> > >>
> > >> have been considering that myself for months. You could pass an opti=
onal
> > >> argument to serial8250_register_8250_port() but that only solves par=
t of
> > >> the problem :-(
>=20
> Some kind of compability layer sure would be nice.
>=20
> > > When ttyS -> ttyO change was done on OMAP, compatibility was not an i=
ssue.
> > > Why should we care about it now?
> >=20
> > It would be a good opportunity to force everyone to update their bootlo=
ader. ;)
> >=20
> > Besides the BeagleBoard forum is quiet now, no one is complaining
> > about that old (ttyS -> ttyO) transition anymore..
>=20
> How about a Kconfig option to provide ttyO by default? The not even
> do that if kernel has cmdline option nottyomap.

what about single zImage ? I don't want to use ttyO on my
Allwinner/Exynos/Snapdragon/whatever SoC just because OMAP is in the
same image ;-)

--=20
balbi

--YZ5djTAD1cGYuMQK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTtVm1AAoJEIaOsuA1yqREmHQP/jOx0ytw38RHB0+6ae9HTG/0
Gk4ZrLxew8xmGjD89LhjxU1RXRptqPcz1Q670scS+OBwTog1TE018yINU/NFge0g
5hZBcpOq/HluzbWDmnuGCCvPuv/qF3fameIVw8P/hgO5rBpXZ5OpXvhQyPcGLgp7
nekVZ1nGKiW1vzGUSbbnUF1CcVR3vvPfjF3mEn3Q4ydaY+e7Gc7L0ajlUrZnYEJ2
5lao7bi/fEHOnaZytktxQ+jtjkYyoHqpDYGX+pPpUsJLsALzOyGfn9XhdsMWnUsh
DsHQhKt2/Acj5O7B1hPX99a9zj3UVLgE/TsIQ1kre6ftu+4vuaiinSrqw3Th2nXe
iflpOE13kW0PyalKClbGWuH+1TGM00M4cDRsu3M3FcTxS31y/cz18DcvIuEdTOOM
bgAvIsdQnE6NRacyCeKuRWET4QdzgBPKG6gHxlLy+Bbv90uW+JKD7/57n0vMpHOB
GLFFs+9oHNFusoFducYrXjhiaQ1rnT8xu5HXwlXO7Ab5iUUYgmoD28SO+Zft/B8O
r+wDVReqtAayDPbtrPCixlUxHVoD5YRm4kKabn2brwTUcJdTaiWcZeBoxEA905Oh
csnrqoCMcZeqYsFAlCMQKBYaFAXR0b45O7hHvWRh4HWve9+RuRa6Tlp9ujuakFk7
Lgau3Is9x9PGGcuZFFi/
=l8r6
-----END PGP SIGNATURE-----

--YZ5djTAD1cGYuMQK--
