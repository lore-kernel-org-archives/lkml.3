Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932409AbaLJQI0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 11:08:26 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54482 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932167AbaLJQIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 11:08:24 -0500
Date: Wed, 10 Dec 2014 16:07:20 +0000
From: Mark Brown <broonie@kernel.org>
To: Andrzej Hajda <a.hajda@samsung.com>
Cc: open list <linux-kernel@vger.kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mike Turquette <mturquette@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Inki Dae <inki.dae@samsung.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "moderated list:ARM/CLKDEV SUPPORT" 
	<linux-arm-kernel@lists.infradead.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        "open list:DRM PANEL DRIVERS" <dri-devel@lists.freedesktop.org>,
        "moderated list:ARM/S5P EXYNOS AR..." 
	<linux-samsung-soc@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        boris.brezillon@free-electrons.com
Message-ID: <20141210160720.GS11764@sirena.org.uk>
References: <1418226513-14105-1-git-send-email-a.hajda@samsung.com>
 <1418226513-14105-5-git-send-email-a.hajda@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="W/1XGRQlv2BMqnS3"
Content-Disposition: inline
In-Reply-To: <1418226513-14105-5-git-send-email-a.hajda@samsung.com>
X-Cookie: I don't get no respect.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC 04/15] regulator: add restrack support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--W/1XGRQlv2BMqnS3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 10, 2014 at 04:48:22PM +0100, Andrzej Hajda wrote:
> Regulators supports various methods of lookup.
> The patch adds restrack support only to DT based regulators.

Why, what does this mean and how might one use it?  I've not looked at
the code since I don't know what it's supposed to accomplish...

One very high level thing is that anything that only works for DT only
seems to be a non-starter, the API should be hiding details of the
firmware interface.

--W/1XGRQlv2BMqnS3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUiG+3AAoJECTWi3JdVIfQmAwH/jiUhtG2zZjX7a2DvVgSimtx
Ed87dh0BkNgWFNjrbsMbEBlThMTPHFJDPrA3jOuXvBkOeW1AENCdWLpHUmNhMiL5
XG1hWqS3RaPMYdFK1UBH18hzrn7QwdBh2WbTcRU5lMyvM2tCiQVMFS/LNNivcYhJ
lY1y5Ol0cTLU0uTh12vSNK53x4tsgbWCAFYOn91F3Kh572wnTYvo3WVub8Cv/7wP
KjOMQ24tzUD4fWFL2LNkRF8XM1yXesB6JdTogtXxyv0wh0GhF0bYVxeMcHFKqWoq
BqEQllGFsJHEvYSghmd2m0cd3D1csRDkmOfFUDnkoTMjtzPQsPvzk4Ti+Nr2zIs=
=1JPy
-----END PGP SIGNATURE-----

--W/1XGRQlv2BMqnS3--
