Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757815AbaLKM7g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 07:59:36 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55593 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444AbaLKM7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 07:59:33 -0500
Date: Thu, 11 Dec 2014 12:58:37 +0000
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
Message-ID: <20141211125837.GV11764@sirena.org.uk>
References: <1418226513-14105-1-git-send-email-a.hajda@samsung.com>
 <1418226513-14105-5-git-send-email-a.hajda@samsung.com>
 <20141210160720.GS11764@sirena.org.uk>
 <548976D2.7080005@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5FNPeqk0egs0iuvD"
Content-Disposition: inline
In-Reply-To: <548976D2.7080005@samsung.com>
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


--5FNPeqk0egs0iuvD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 11, 2014 at 11:49:54AM +0100, Andrzej Hajda wrote:
> On 12/10/2014 05:07 PM, Mark Brown wrote:
> > On Wed, Dec 10, 2014 at 04:48:22PM +0100, Andrzej Hajda wrote:

> >> Regulators supports various methods of lookup.
> >> The patch adds restrack support only to DT based regulators.

> > Why, what does this mean and how might one use it?  I've not looked at
> > the code since I don't know what it's supposed to accomplish...

> Looking at this patch makes no sense without looking at cover letter
> or at the patch adding restrack framework. In short adding restrack support
> to regulators will allow to:

I did look at the cover letter and glance at the first couple of patches
but I still can't tell what this is really intended to do.  There's a
lot of implementation detail but not a lot of high level overview so
it's not very clear to me how exactly this solves problems or how it is
different to the component framework, it sounds very similar.

I'd expect someone reading the change in the regulator API to have at
least some idea how this fits in with the rest of the API and how to use
it, and probably more importantly I'd expect to be able to understand
why this is DT only.

--5FNPeqk0egs0iuvD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUiZT9AAoJECTWi3JdVIfQt+cH/0dvoIx1Mg0GgnLlbSrzaC/+
e9DXQHbh/ynUlqjM60wKCz/xo0mD/glSQQbZaCkpADoBWObnLDnydaGEg8w9fGub
bN2gDtOcelvibN4ID1nZshRFHWFa1ubdGksf8v2nqvX7cvmdVcw0XLKIjiVlp4aI
UVhr3RIqZEn4cCmw4FfrAxrxXMJfm9ehl5mecBKRuUlVGWFgw49AEG2GjKnnt2fM
KogSkZdKOQpaWRQpst+wGnDnOUpYooe3ojfxBIxv6aZyCndXtUMO4Lr+55yhp5n7
v+j0yRBmUmOPckm+MYU2/Ops09ROpD/FlShbb3jf+HxgLdy6W/kK45N11oadLu4=
=wRH4
-----END PGP SIGNATURE-----

--5FNPeqk0egs0iuvD--
