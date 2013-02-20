Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934247Ab3BTRbP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 12:31:15 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48737 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758457Ab3BTRbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 12:31:13 -0500
Date: Wed, 20 Feb 2013 17:31:10 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Laxman Dewangan <ldewangan@nvidia.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH] spi: tegra114: add spi driver
Message-ID: <20130220173109.GU2726@opensource.wolfsonmicro.com>
References: <1361281115-20436-1-git-send-email-ldewangan@nvidia.com>
 <5123C18A.9010604@wwwdotorg.org>
 <5124C18F.6070108@nvidia.com>
 <20130220131112.GE2726@opensource.wolfsonmicro.com>
 <5124CEF5.3060605@nvidia.com>
 <512506F9.2030508@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GVLQrlG8+/jMfW4X"
Content-Disposition: inline
In-Reply-To: <512506F9.2030508@wwwdotorg.org>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GVLQrlG8+/jMfW4X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 20, 2013 at 10:25:13AM -0700, Stephen Warren wrote:

> But, please do think this approach through fully. The DT binding needs
> to define which clock-names the driver requires to be present, and any
> optional clock names. DT bindings are supposed to be immutable, or
> perhaps extendible in a completely backwards-compatible fashion. This
> implies that you need to have thought through the entire list of clocks
> that the driver might want in the DT clock-names property when you first
> write the DT binding documentation...

Since we can extend the list of clocks it doesn't seem like there's much
issue here, especially if some of them are optional?

Though in general it seems like this sort of mux really should be in the
clock stuff anyway.

--GVLQrlG8+/jMfW4X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRJQhXAAoJELSic+t+oim9vM0QAIP3yNkcZm/yjd+tmqgy79CO
RDzj4VEy/nTtmLTKuSYjR0lod8hanjJg1LuV08UhEtRdbw8swdyNCjboPzFd0Nm7
EdDQV1nsFqTlFMP5OIvxiKbDbfXERDh7kKvT7MDeu0pyLZFpIBP1OwzxPYS161bo
29SsHwkZ2vKk/5nE8PJKhaBDDPjk01fpzoqPYSfBBGbr+0XGU3Ncd/Tc4quKmNbw
yctRoAE76mEPGkHERqYkwavV8x9T+dG9bdbJbkd2IuRM33cISleHpT3DnFQ/4Thy
I8oPD+fmGNp4yX1/A4nofpRbkpdxIY6U8BEn+4RNGFQD7Y42GC3g0x2CER0ZwfYm
2ePqL/pRnalBzPxkKrpVCkuA746rdnl0lylngFIORE8U6GGWgqWZpBOKMzctRvUt
Rbi9YYJ+mvk+KWRSUe1O4S9OWAw7XXDCZdhLLZySLXE42DMRU6mkbytAR4Z3rM65
J7hVbiBkZSvGFt0Mhv0rLjtck1kYI13y/78imrHVVRvan9CfKTJwFbDWIaahFn71
72V/ybPum/i69tEzsPtRh25YMCFSMpAZC7cx+X2e3wsTD9vvkEQgtZikRGlceQR1
ASaqkli0d9qrQu7YQSwCc1IfdexFxSOecxuegV25IFd6Ds5sOQ24UfC0PXREjaAr
7ai84Tjka1EfkJ+WN2y1
=ED6S
-----END PGP SIGNATURE-----

--GVLQrlG8+/jMfW4X--
