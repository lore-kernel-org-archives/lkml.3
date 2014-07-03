Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759184AbaGCRJS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 13:09:18 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:38376 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752324AbaGCRJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 13:09:16 -0400
Date: Thu, 3 Jul 2014 12:08:22 -0500
From: Felipe Balbi <balbi@ti.com>
To: Javier Martinez Canillas <javier@dowhile0.org>
CC: Sebastian Reichel <sre@kernel.org>, Felipe Balbi <balbi@ti.com>,
        Robert Nelson <robertcnelson@gmail.com>,
        Tony Lindgren <tony@atomide.com>, Aaro Koskinen <aaro.koskinen@iki.fi>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux kernel <linux-kernel@vger.kernel.org>,
        <linux-serial@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH] tty: serial: Add 8250-core based omap driver
Message-ID: <20140703170822.GB5814@saruman.home>
Reply-To: <balbi@ti.com>
References: <20140702190944.GA567@drone.musicnaut.iki.fi>
 <CAOCHtYgxMeA+Arfe40XeFDEKuCJ8qo1RqNR0hYBGr_Wp6sRfdA@mail.gmail.com>
 <20140703073411.GX28884@atomide.com>
 <20140703132509.GA5814@saruman.home>
 <CAOCHtYi0JwRO12gHa+KFGH1k7pPk4TL40igwhzRRxutw-tqf6A@mail.gmail.com>
 <20140703140736.GF5814@saruman.home>
 <20140703154425.GC23309@earth.universe>
 <20140703155240.GU5814@saruman.home>
 <20140703160622.GE23309@earth.universe>
 <CABxcv=nGPyK7SeQZ+W1ZEfBPQ-RraVTawyYuKOGz02df0g=6Qg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tRjCiSMHexiP9I5N"
Content-Disposition: inline
In-Reply-To: <CABxcv=nGPyK7SeQZ+W1ZEfBPQ-RraVTawyYuKOGz02df0g=6Qg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--tRjCiSMHexiP9I5N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 03, 2014 at 06:19:47PM +0200, Javier Martinez Canillas wrote:
> On Thu, Jul 3, 2014 at 6:06 PM, Sebastian Reichel <sre@kernel.org> wrote:
> > Hi,
> >
> > On Thu, Jul 03, 2014 at 10:52:40AM -0500, Felipe Balbi wrote:
> >> > DT is supposed to contain information about the hardware, so it
> >> > should stay the same? I think there is no non-hackish way to decide
> >>
> >> compatible would change, at a minimum.
> >
> > why? I would expect it to stay the same (and the current patch uses
> > the same compatible strings).
> >
>=20
> Exactly, the new driver must support all the compatible strings
> defined in Documentation/devicetree/bindings/serial/omap_serial.tx
> (which already does as you pointed out).
>=20
> Otherwise the current drivers/tty/serial/omap-serial.c could never be
> removed since that would mean breaking DT backward compatibility.

that settles it then... good. I'll start testing this next week.

--=20
balbi

--tRjCiSMHexiP9I5N
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTtY4GAAoJEIaOsuA1yqREm0YP/j/hpexePJe1EtVF2/Q9g595
hLO3AT927yMX/kpxtzLrM53nOtJTtLRy2QTPKLZ/m/6TVhTteESAh7dCm+MFGQTt
MUSKuvtZo2WSxruxLwLgG8JW4fspGv2dCWk30MYSXS8zq1YJsPT0dLV2ahWAz5c9
sAnLI2n9DmSBFNRdEJ65VMg1x3lDlQEunq7/FEe6zXfiWKEEFsrYwbCMvGKqJmY6
NzZVnPuv/aL2oR3ga3dL15EVBCyu1n/g+slELHHLnPwg1JzFGwdzoCZpM+q/o05u
z09pRzqIA41ogjQIZrKw8UvBFdyc7hP2yq4oVpNu+OxkK2djgR9Q79OQJKlPygEU
TbilykpkV2N4108UwYM6K5IQ28/QbQ8Fj8CPfkeXsRRYNYbPKjVL13YAnyOMsWIH
YAEZSaiBKm+uES9dex78dL9XGb/iZuX3ZTE4obdxtKAZHo1z8ghCHXmoWhxwve0p
vIV8s/DLorBG49yGZlR+Zyrt+uzghu2uIsLR3czmvIiHPafSVd0kEyflNl/fVGh/
JN3uuXjXWviD/Sak58dPVw0cogk75Yil0fLciYDg1zeebiSPC12lHoot5nunbcwC
F7GzPABNJOlJ7OL/p4/KqhoreulbzGlwQxF3a+/B+9O/3raITq4IBj113AcIP3Z+
UsjOuPaDFoKFpx7HFAsA
=1yn1
-----END PGP SIGNATURE-----

--tRjCiSMHexiP9I5N--
