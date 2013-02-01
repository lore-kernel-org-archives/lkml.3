Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757373Ab3BAS7c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 13:59:32 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:47739 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757236Ab3BAS71 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 13:59:27 -0500
Date: Fri, 1 Feb 2013 20:58:20 +0200
From: Felipe Balbi <balbi@ti.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>
CC: Matt Porter <mporter@ti.com>, Tony Lindgren <tony@atomide.com>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        "Cousson, Benoit" <b-cousson@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Vinod Koul <vinod.koul@intel.com>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Landley <rob@landley.net>, Dan Williams <djbw@fb.com>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Chris Ball <cjb@laptop.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v7 01/10] ARM: davinci: move private EDMA API to
 arm/common
Message-ID: <20130201185820.GE29898@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1359742975-10421-1-git-send-email-mporter@ti.com>
 <1359742975-10421-2-git-send-email-mporter@ti.com>
 <5022f635a527470dbd0be932063e9cd2@DFLE72.ent.ti.com>
 <20130201184915.GP2244@beef>
 <510C1D0E.6030401@mvista.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RE3pQJLXZi4fr8Xo"
Content-Disposition: inline
In-Reply-To: <510C1D0E.6030401@mvista.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--RE3pQJLXZi4fr8Xo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Feb 01, 2013 at 10:52:46PM +0300, Sergei Shtylyov wrote:
> Hello.
>=20
> On 02/01/2013 09:49 PM, Matt Porter wrote:
>=20
> >>> Move mach-davinci/dma.c to common/edma.c so it can be used
> >>> by OMAP (specifically AM33xx) as well.
>=20
> >> I think this should rather go to drivers/dma/?
>=20
> > No, this is the private EDMA API. It's the analogous thing to
> > the private OMAP dma API that is in plat-omap/dma.c. The actual
> > dmaengine driver is in drivers/dma/edma.c as a wrapper around
> > this...same way OMAP DMA engine conversion is being done.
>=20
>   Keeps me wondering why we couldn't have the same with CPPI 4.1 when I p=
roposed
> that, instead of waiting indefinitely for TI to convert it to drivers/dma/
> directly. We could have working MUSB DMA on OMAP-L1x/Sitara all this time=
=2E.. Sigh.

good point, do you wanna send some patches ?

I guess to make the MUSB side simpler we would need musb-dma-engine glue
to map dmaengine to the private MUSB API. Then we would have some
starting point to also move inventra (and anybody else) to dmaengine
API.

Once that's done, we drop MUSB's private API.

--=20
balbi

--RE3pQJLXZi4fr8Xo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRDBBMAAoJEIaOsuA1yqREl64P/1L6sI+7Q0wkbE+G/SzHutfJ
EvDFskR7FIk4c3nWFb57t8m7drRueQcReuCRHicfzrwxPRzWGhSVNfOCHTn+2H4e
D5fP9/vH99cxaEbckBYz28NUT0f6qv+1O8pFT3YI6ggb4crbYBp9k36ZYeO4V9g8
Ek2WVRIXY7WGo15K+hW4LP5zV36iwJIzeWg7T6NNddenRA4mkQtP/kDtVTxBCs8G
ew5mQ9pOYOO9iLwovKwuVSqB3gW7ekKWK5PaJqvMYB4op04tGSjKZbYHNeusxdF0
sMRbdqfbIxKybdI1nE3Gno0Z0KaogYJzSyVJZrsrj9ao7Q/NMcMuVmPW5iToj66I
twcezMYZOh0QcPSJfY9LOsrfIPx3giQq4CbS/KB2p8fW3MZtlKiTlFrhaw8t9P9d
oIhIi5autXnbAnt6tP3rnTi39Vg61/8l5x2thzsjaH581n1OAvayEWuLg/GBQK52
ZpBomWcRl2lJN63WPCrqI50GVmSe4Bjh4QFyZJ4HFNqoskxfwatNRMhdnWZ167pr
ak/XCR2kTwg/8ExBqaJZWsfuKQL9MqGMGscYiY4krCA5/qfH3O1gGcLhsug7ETfn
P6W0qeOlLAm0vhQUAUwM1TZEVfrqa9Ltbpn9itPu5wnK9XYdIe88rSsJXWDb/K1r
Y46NwB5l1mxXXQCkiauY
=htAV
-----END PGP SIGNATURE-----

--RE3pQJLXZi4fr8Xo--
