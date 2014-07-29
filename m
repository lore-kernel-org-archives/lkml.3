Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891AbaG2OMi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 10:12:38 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:37698 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750960AbaG2OMg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 10:12:36 -0400
Date: Tue, 29 Jul 2014 09:10:45 -0500
From: Felipe Balbi <balbi@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: Felipe Balbi <balbi@ti.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        <bcousson@baylibre.com>, <linux@arm.linux.org.uk>,
        <khilman@deeprootsystems.com>, <tglx@linutronix.de>,
        <jason@lakedaemon.net>, <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 30/35] irqchip: add irq-omap-intc.h header
Message-ID: <20140729141045.GA17808@saruman.home>
Reply-To: <balbi@ti.com>
References: <1406582183-696-1-git-send-email-balbi@ti.com>
 <1406582183-696-31-git-send-email-balbi@ti.com>
 <20140729120133.GQ29045@atomide.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PEIAKu/WMn1b1Hv9"
Content-Disposition: inline
In-Reply-To: <20140729120133.GQ29045@atomide.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--PEIAKu/WMn1b1Hv9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 29, 2014 at 05:01:33AM -0700, Tony Lindgren wrote:
> * Felipe Balbi <balbi@ti.com> [140728 14:19]:
> > OMAP INTC irqchip driver will be moved under
> > drivers/irqchip/ soon but we still have a dependency
> > with mach-omap2 when it comes to idle functions.
> >=20
> > In order to make it easy to share those function
> > prototypes with OMAP PM code, we introduce this new
> > header.
> >=20
> > Signed-off-by: Felipe Balbi <balbi@ti.com>
> > ---
> >  arch/arm/mach-omap2/board-3430sdp.c        |  1 +
> >  arch/arm/mach-omap2/board-am3517crane.c    |  1 +
> >  arch/arm/mach-omap2/board-am3517evm.c      |  1 +
> >  arch/arm/mach-omap2/board-cm-t35.c         |  1 +
> >  arch/arm/mach-omap2/board-cm-t3517.c       |  1 +
> >  arch/arm/mach-omap2/board-devkit8000.c     |  1 +
> >  arch/arm/mach-omap2/board-ldp.c            |  1 +
> >  arch/arm/mach-omap2/board-omap3beagle.c    |  1 +
> >  arch/arm/mach-omap2/board-omap3logic.c     |  1 +
> >  arch/arm/mach-omap2/board-omap3pandora.c   |  1 +
> >  arch/arm/mach-omap2/board-omap3stalker.c   |  1 +
> >  arch/arm/mach-omap2/board-omap3touchbook.c |  1 +
> >  arch/arm/mach-omap2/board-overo.c          |  1 +
> >  arch/arm/mach-omap2/board-rx51.c           |  1 +
> >  arch/arm/mach-omap2/board-ti8168evm.c      |  1 +
> >  arch/arm/mach-omap2/common.h               |  9 ---------
> >  arch/arm/mach-omap2/cpuidle34xx.c          |  1 +
> >  arch/arm/mach-omap2/irq.c                  |  1 +
> >  arch/arm/mach-omap2/pm24xx.c               |  1 +
> >  arch/arm/mach-omap2/pm34xx.c               |  1 +
> >  include/linux/irqchip/irq-omap-intc.h      | 32 ++++++++++++++++++++++=
++++++++
> ...
>=20
> > +void omap2_init_irq(void);
> > +void omap3_init_irq(void);
> > +void ti81xx_init_irq(void);
>=20
> I think these will all go away with DT based booting?
> So it might be worth waiting for that rather than churn
> all these files, or..

you just asked me to rebase this series because now we had OMAP3 idle
working with DT. And now, you're asking me to hold on to this series
because not everything is DT-based yet.

This is the third time I rebase the series after a long hiatus and it
always comes out to the same result -> "let's wait some more".

--=20
balbi

--PEIAKu/WMn1b1Hv9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT16tlAAoJEIaOsuA1yqREc4UQALJHSBnbJk9KCadv1ZUsweUh
Y98XYFijoUvEnfR7HSiUqqnsMf9rsNiP0WGeHSAttFoy5BjujSVadDXifDyyzDR4
coqguVVP3c6LOjA6Ii16g6eAA+zLwCgFbtLRgpyWR+AaKEMRQg2w3IzWq0VT2meu
mDcXnltUF/5AfHrVptCL+q0plk58Ovwqv/Eim1J2LX0AJjEDWwhkqfF3+LcACvqe
7mhpDCDVGWb5aky/AxRXmJkRFT39aFZapKUN87Ofi5HUt60ohdBec6LP/mh4MTEy
jaKxNByfJS6eGOuDJmrWTNME8stEvp5qe71YZ5aPR4LYPnXTrC8XHEg+WiJ2ukQe
97XFlW8n4mUo4CeMsNe+MaWvmfDB3fho5OF8Y4ZDABa3L5eSLK7XuKGO+RjJF8eC
rf1xx7EE/lctnE5gkk4uuyZVc1MNh/+AvekdxV7e3pSWPydkgnRTBxWPDfnReuOQ
DH6vaEPGmUPyf8KUx0pis7kR3uKWFFQi9M/TpTolU9n5ddcuGH90t9UnVyB+ry6n
Gp8xaGWjcKdl2iaBedAxYYgYlZyjoXvlFz6evry1CzKEEjl4gm6eDTJgyVf170qq
9z4UH04pZFt8XhmX/oEFkmNpgATt2ubuEptyA++ZQPpfgY+KbuR2lsWIV27hx0LU
WmEgku/R/MDuiDXp+OKO
=bmm6
-----END PGP SIGNATURE-----

--PEIAKu/WMn1b1Hv9--
