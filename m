Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752407Ab3AWCVz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 21:21:55 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39426 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751263Ab3AWCVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 21:21:52 -0500
Date: Wed, 23 Jan 2013 10:21:42 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sekhar Nori <nsekhar@ti.com>
Cc: Matt Porter <mporter@ti.com>, Tony Lindgren <tony@atomide.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Benoit Cousson <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Vinod Koul <vinod.koul@intel.com>, Rob Landley <rob@landley.net>,
        Chris Ball <cjb@laptop.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Arnd Bergmann <arnd@arndb.de>, Dan Williams <djbw@fb.com>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH v5 00/14] DMA Engine support for AM33XX
Message-ID: <20130123022133.GA5727@opensource.wolfsonmicro.com>
References: <1358281974-8411-1-git-send-email-mporter@ti.com>
 <50FEB6B2.5020303@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tThc/1wpZn/ma/RB"
Content-Disposition: inline
In-Reply-To: <50FEB6B2.5020303@ti.com>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tThc/1wpZn/ma/RB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 22, 2013 at 09:26:34PM +0530, Sekhar Nori wrote:
> On 1/16/2013 2:02 AM, Matt Porter wrote:

> > This series adds DMA Engine support for AM33xx, which uses
> > an EDMA DMAC. The EDMA DMAC has been previously supported by only
> > a private API implementation (much like the situation with OMAP
> > DMA) found on the DaVinci family of SoCs.

> Will you take this series through the OMAP tree? Only 1/14 touches
> mach-davinci and I am mostly okay with it except some changes I just
> requested Matt to make in another thread.

Is this series somewhere near actually getting merged then? It seemed
like there was lots of stuff going on.

--tThc/1wpZn/ma/RB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ/0enAAoJELSic+t+oim9ffsQAI5Ur3zy+yOwyevsnZw8bB12
7bBbRS8xk9pMMDyncxZ/7KU/B7IXSjWbTHS+4un1gPpIVEA6I3J25inPDFJIkh6I
0vpuGOf3CWpKtKb8vYFG3e6j4ibk+fz2ZBzq7gx3snPEyb/nOTwuutGrU41TAGhF
YC63hsoC4olgKL3eZgaqa1T0jQixK/aRFWQ8GVvy8MLDgoGZiCMS5rwtc+d/qJzv
r0+woqcmx0UCEHMaSk+WBBJ1ncRBxSCOIvGXY7J9x+rcQxbizmnOlRsOHbBKfTI3
o5np5K7wPR0nyQSVR0YLKjlQnM2PP1X4VRXFvKoqyTKGEr7TlXhU87yiv0O3K0Eu
anRUphgIIcuCBy8DcpxMO3QHkVHgsiMDKippR3a///bxyYy+VRO6FZCa/GJx9X7j
z2GHXEX7oioB0HfLPEiBFBuOKXFlGwp9SIoebF7it4fnKjrmW8qoTMtZaltDE9eu
FVah1IGDQKlgI9XSqOK+OqD4muz/Lb/e6MdpLDOAtk86AfrfS2iHbq138SSA3DgN
IjBlPjRuDKJucPYitiYHvfmxNtzsmbOsMnA86OfnBxuSOUZMaHUyQGe37q3hJXUJ
BbSrrGN2gP6KdutaSooB/ua5XR4A6TDBX7nA3Zi4wmGfyA4Pl7e857eqtJSL6QP4
atfb6xpp6+wpPEWlFGlE
=FwkO
-----END PGP SIGNATURE-----

--tThc/1wpZn/ma/RB--
