Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753696AbaG2ORA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 10:17:00 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:59717 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753347AbaG2OQ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 10:16:59 -0400
Date: Tue, 29 Jul 2014 09:15:22 -0500
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
Subject: Re: [PATCH 29/35] arm: omap: intc: switch over to linear irq domain
Message-ID: <20140729141522.GB17808@saruman.home>
Reply-To: <balbi@ti.com>
References: <1406582183-696-1-git-send-email-balbi@ti.com>
 <1406582183-696-30-git-send-email-balbi@ti.com>
 <20140729121425.GR29045@atomide.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FkmkrVfFsRoUs1wW"
Content-Disposition: inline
In-Reply-To: <20140729121425.GR29045@atomide.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--FkmkrVfFsRoUs1wW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jul 29, 2014 at 05:14:25AM -0700, Tony Lindgren wrote:
> * Felipe Balbi <balbi@ti.com> [140728 14:19]:
> > now that we don't need to support legacy board-files,
> > we can completely switch over to a linear irq domain
> > and make use of irq_alloc_domain_generic_chips() to
> > allocate all generic irq chips for us.
>=20
> This patch seems to somehow break off-idle for omap3=20
> where it no longer wakes up.

Sure your bisection is correct ? This patch just switches from legacy
irq domain to linear irq domain.

> Other than that, this whole series boots fine for me.

good

--=20
balbi

--FkmkrVfFsRoUs1wW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT16x6AAoJEIaOsuA1yqRE3B0P/jxVV9udi5sGpFs3nrqKzwGO
SlfI6OO+xFzerEXXlf0NmPNIVpdtw5TfjYcx12cBMAGG9w8OZovJ0QOo0AT+LNwU
8dzI2PErV3XVfmOOaz/51peLQ3bYN3n9n9215eBp0ABHtHVUd7/R6yG2KtRFqTWR
PYoSebRnJflkwHDn5Fay3X8/rW8ZUF4LupLnjygPuQTIO3xT70a2rBBYABTG+DUy
0xzk+IJ8HT6qLdezHJjkiXikbFkJoO/mpVg+YhXvW5vHy7pJGASkPmhUyY2LPEva
UJniXfp3f4E6jRfizz2g7Lws8Xu2xMvqix4+uVeGFZQ7o7ZbUBEgBWcdxtJ9TK6O
CVQPmYEiywlCCq/Wo1kTxt7JgyuZj2vWL9wggZ62Zn6wnhIfFss2iJlmOVOhlP7m
WHQl+90oibOXee9r7eWxynz08Gd5gScH2YvJvMQmc7TobUZutXcOQZQwNnEsSdvs
CoKODxB8gjtOpc8+uF3EV921+EVeCwyuwjvZ/PHzAGGvY0i+bsdRx23Xki7GdPAA
VW0yVztHbeuDDcs7ca8aZorcazooknLf2SfIUNe2u/dJjhWIT+cGD0rK5kkWDxSr
ieqofqYRF6Kb9ah0z3xCNKTqqXqjyk0vIrIB8O+gRECTowYtYnWJPuG2Q3vBZOOT
G/1qSy9SPH0k5TD6vjJU
=sLSv
-----END PGP SIGNATURE-----

--FkmkrVfFsRoUs1wW--
