Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757568Ab3BAU5F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 15:57:05 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:58980 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756673Ab3BAU5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 15:57:01 -0500
Date: Fri, 1 Feb 2013 22:56:00 +0200
From: Felipe Balbi <balbi@ti.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>
CC: <balbi@ti.com>, Matt Porter <mporter@ti.com>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Chris Ball <cjb@laptop.org>, Russell King <linux@arm.linux.org.uk>,
        "Cousson, Benoit" <b-cousson@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
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
Message-ID: <20130201205600.GA31762@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1359742975-10421-1-git-send-email-mporter@ti.com>
 <1359742975-10421-2-git-send-email-mporter@ti.com>
 <5022f635a527470dbd0be932063e9cd2@DFLE72.ent.ti.com>
 <20130201184915.GP2244@beef>
 <510C1D0E.6030401@mvista.com>
 <20130201185820.GE29898@arwen.pp.htv.fi>
 <510C2A47.1090607@mvista.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2oS5YaxWCcQjTEyO"
Content-Disposition: inline
In-Reply-To: <510C2A47.1090607@mvista.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--2oS5YaxWCcQjTEyO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

hi,

On Fri, Feb 01, 2013 at 11:49:11PM +0300, Sergei Shtylyov wrote:
> > good point, do you wanna send some patches ?
>=20
>    I have already sent them countless times and even stuck CPPI 4.1 suppo=
rt (in
> arch/arm/common/cppi41.c) in Russell's patch system. TI requested to remo=
ve the
> patch. :-(

sticking into arch/arm/common/ wasn't a nice move. But then again, so
wasn't asking for the patch to be removed :-s

> > I guess to make the MUSB side simpler we would need musb-dma-engine glue
> > to map dmaengine to the private MUSB API. Then we would have some
> > starting point to also move inventra (and anybody else) to dmaengine
> > API.
>=20
>    Why? Inventra is a dedicated device's private DMA controller, why make
> universal DMA driver for it?

because it doesn't make sense to support multiple DMA APIs. We can check
=66rom MUSB's registers if it was configured with Inventra DMA support and
based on that we can register MUSB's own DMA Engine to dmaengine API.

> > Once that's done, we drop MUSB's private API.
>=20
>    Don't think it's a good idea.

see above.

--=20
balbi

--2oS5YaxWCcQjTEyO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRDCvfAAoJEIaOsuA1yqREUjQP/RqhK6sXFPDiZQokepbVHvh1
/QY/xwmvqJ5sC+OJn99FrQ0Lp+4awceYRrx3d/aLbZ2ato58jLpdXNMOSyYiJR5R
gE4nNYafHmv070vFnkt87M9VsEZY7hERUh0UjNoqcREKYLSJ5Te0CkN2Dfewx4Ub
dX3UQKVxjjCsxcNEg2+Ssyw1+oMTbjkSjkAwQbet8ZFsZSqXXoJ5xuRh1Ik2VD0M
Xuc+MAAWbzilgcyM7C9Yxw5cvlan7ei6hsPgAq2kNai7WK2lm47h+enwW41q/nbs
iXIhXM7qFHpwsByG3K3Rpkmtsg75SM8ymyNohdxb5odwh4Evzw2Z/ed6Vu+t0JK6
vK1/mSOP7QtQCNFcO0gOvLT3NCavEf372bTLiKNWvSb1KecC4BB84tJ+oGrGxCKS
BnhVKCKtq5PqGBoBxv29JVaTgNh0djr804bLYssB9RNvnigYh8ZD6CCLr8aDT8P5
fyZWjXY74K8N8sfTHBYASUIhC7IVeDDFApt/0UKt8+OLPwJ9aLxXHhx+xBG96Im9
d0Jx31hInwZ+2l7ZZr8CE/1Oy79qtAX2ANJOjSSuR8SGah+ipW40Er2nYbN0+0hx
QiDPcezowX/2yVF7HNQjiYfAoq3pwiESXlPfN3/BnAwIsP5p/HGT9nRun2yiQJL1
U0qONWBg4L7gNQUFhURD
=dgm9
-----END PGP SIGNATURE-----

--2oS5YaxWCcQjTEyO--
