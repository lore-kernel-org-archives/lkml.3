Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608Ab3BEQrL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 11:47:11 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33768 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754654Ab3BEQrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 11:47:08 -0500
Date: Tue, 5 Feb 2013 16:47:05 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Cyril Chemparathy <cyril@ti.com>, balbi@ti.com,
        Sergei Shtylyov <sshtylyov@mvista.com>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Lindgren <tony@atomide.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Vinod Koul <vinod.koul@intel.com>, "Nair, Sandeep" <sandeep_n@ti.com>,
        Chris Ball <cjb@laptop.org>, Matt Porter <mporter@ti.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "Cousson, Benoit" <b-cousson@ti.com>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Landley <rob@landley.net>, Dan Williams <djbw@fb.com>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>
Subject: Re: [PATCH v7 01/10] ARM: davinci: move private EDMA API to
 arm/common
Message-ID: <20130205164705.GG4720@opensource.wolfsonmicro.com>
References: <20130201213003.GW2637@n2100.arm.linux.org.uk>
 <20130204154153.GA18237@arwen.pp.htv.fi>
 <510FF1A6.403@mvista.com>
 <20130204164712.GB4269@arwen.pp.htv.fi>
 <510FF5C9.3030600@mvista.com>
 <20130204170216.GC4269@arwen.pp.htv.fi>
 <51100A72.6030909@ti.com>
 <CACRpkdZihnp3_Df==QRWxQupgi7W_YXZxc-MxkusVH6J+Vx56A@mail.gmail.com>
 <5110369B.9060901@ti.com>
 <CACRpkda8xBB35CwuBH76xXcC341TeRs1ZuwzDD0LtuXc4ifQTw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mMdCh5/a0q2ATNCM"
Content-Disposition: inline
In-Reply-To: <CACRpkda8xBB35CwuBH76xXcC341TeRs1ZuwzDD0LtuXc4ifQTw@mail.gmail.com>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mMdCh5/a0q2ATNCM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 05, 2013 at 05:21:48PM +0100, Linus Walleij wrote:

> For IRQ mode, use the completion callback to push each cookie
> to NAPI, and thus let the IRQ drive the traffic.

The whole purpose of NAPI is to avoid taking interrupts for completion
of transfers.  Anything that generates interrupts when NAPI is in
polling mode is defeating the point.

--mMdCh5/a0q2ATNCM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRETeCAAoJELSic+t+oim9GqAP/3am0bSTpCOIFDsaJ+svUe0t
eEe+hUMNmvB0rKJPZ9JbQaPStBOB6Q+kFMKa/9hSJcBXRm2cl2mTaD7FSzZUcf+2
xmbNBwQKiNO06H8vO9w2y7vzgJChWQomTigho9rt1PXUaoULfEpVw+PWA1gr8bAR
GRmArdAxk9t4hUbResVSGYVTICViNGd6w1ekLl0FLjorshEv/U7fnyhVn1fv5Hwc
smxTMeSEXI8iah2N/BIh0uL4Obiutdz/LnIVJSO24nVQllLfoAa/4SzW6OdyT2Py
nBlQtf7YhwwyBKykanNEawru54N09TMIomZkSF8izVpF6XNGpzbDiq0G/EKDCG+a
5TuitPwoEoi1sLjKv6jZB4BUXQsAI5n8Hi7wUAwrHbcONKJSMxGdVxXA/8B1f/O2
dc6jv1N8ghL0EADVBEsmQ6/4NEXMEicFX7rkA7Uwzr+mmXGdilGhBeJdzxA+9V5p
8s5Lj9fikJLzksK5j21Ju1cNie9rFIWZGOY57/R6f4cINwScSk4mwnMr9WyjustH
DneXGu4Rtux1xWX0RfMnFnVD42QvMPtOlHIQKLBt30O7+QHhf+QqXX5oAkYPrKas
8hYXaRzTMGDrBxXVTO0a6h8Hq4vGShNmEAIh9qSJyS78p+2V23EY+jWg1aUqY5t1
8mc5LqO8rk3I3a+VEQ/j
=DsCQ
-----END PGP SIGNATURE-----

--mMdCh5/a0q2ATNCM--
