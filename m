Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756668Ab3BFHpp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 02:45:45 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:46491 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750756Ab3BFHpm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 02:45:42 -0500
Date: Wed, 6 Feb 2013 09:45:08 +0200
From: Felipe Balbi <balbi@ti.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: Tony Lindgren <tony@atomide.com>, Felipe Balbi <balbi@ti.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Sergei Shtylyov <sshtylyov@mvista.com>, Matt Porter <mporter@ti.com>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Chris Ball <cjb@laptop.org>, "Cousson, Benoit" <b-cousson@ti.com>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Vinod Koul <vinod.koul@intel.com>, Rob Landley <rob@landley.net>,
        Dan Williams <djbw@fb.com>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v7 01/10] ARM: davinci: move private EDMA API to
 arm/common
Message-ID: <20130206074508.GB22064@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1359742975-10421-1-git-send-email-mporter@ti.com>
 <20130204154153.GA18237@arwen.pp.htv.fi>
 <20130205182848.GJ25185@atomide.com>
 <201302052226.30754.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wq9mPyueHGvFACwf"
Content-Disposition: inline
In-Reply-To: <201302052226.30754.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--wq9mPyueHGvFACwf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 05, 2013 at 10:26:30PM +0000, Arnd Bergmann wrote:
> On Tuesday 05 February 2013, Tony Lindgren wrote:
> > * Felipe Balbi <balbi@ti.com> [130204 07:46]:
> > >=20
> > > Current DMA abstraction is quite poor, for example there's no way to
> > > compile support for multiple DMA engines. Code also makes certain, IMO
> > > unnecessary, assumptions about the underlying DMA engine (abstraction=
 is
> > > poor, as said above but it we could follow MUSB's programming guide w=
hen
> > > it comes to programming DMA transfers).
> > >=20
> > > Considering all of the above, it's far better to use DMA engine and g=
et
> > > rid of all the mess.
> >=20
> > How about just disable MUSB DMA support if ARCH_MULTIPLATFORM for now?
> > That way MUSB can be fixed up first to support ARCH_MULTIPLATFORM
> > using PIO while sorting out the DMA related issues.
>=20
> Sounds ok to me. Someone still needs to do the work to make the non-DMA
> variants of MUSB coexist in one kernel, but as we discussed erlier, that
> should be much simpler.

Yeah, I'm cooking some patches to at least make it buildable. Dropping
unnecessary dependencies and marking da8xx and davinci as depending on
BROKEN seems to be the easiest way; those two glues hasn't seen a real
patch since 2010 or so.

--=20
balbi

--wq9mPyueHGvFACwf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJREgoEAAoJEIaOsuA1yqRE1usP/R//BpO3v7devKDdQBLwvF8l
phPe3rz8ETV1nVYLYYrbmBtfDf5DBMD0D0FcehZyPDXcXUeQnlijhTRXVFpyH0Zy
SIE5djOk1Tn16H06zw0igs5BOo9ErOLL3lBu5wg3fkXehdd81pmGBJKAooEkj2jw
GSJlsvId2MST7VOuzA0ZX+4hwE0GWSD9H4L0qPiShZXT4fPtLB0KdYWINYe5ydsU
h1Doapg3ur93Hvaz1otV+a219TMBa3zmtORPnKDeTMKgZmuAPIKJBX2fCY1CmYuh
c6C5F6xKS6iYsqO+TsDXFM9r2gN0qUG2Y/2nhTsRDP5wNZVqVTQcLlUeSjPPCrI6
TCp6uQyBjvyMWY8U+sBO0Rvq181PQytCujeH5rcwT5V4Y1Yq0dp+2466jk3STesY
9Md48ZZYIboKmjkXcN0gE1Ypge79Cdofrxt/fFvPrAro8jw+mSb7GA2nMD8Jts/D
eKsd6r53u6dBRcrYhTXroWuHKv+lyEffxbmSWmSk3SBM0+LIgEgCyhLycwYq1MyG
Y12kgteqKgMJlGJbpWmYDJ1szi7KUIrMRwUviRWIKt8NebZrvEcAPyxWy521uKYe
1gTYGDyw05BP0VlWff8JRAWF027uUBac1tacfpnCg9LtAA0HSTK6gZ2Gb7EYGG81
NyGEb7Y2apxrUalPd+aF
=J3m8
-----END PGP SIGNATURE-----

--wq9mPyueHGvFACwf--
