Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752105AbaLOLju (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 06:39:50 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:59983 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458AbaLOLjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 06:39:46 -0500
Date: Mon, 15 Dec 2014 11:38:32 +0000
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
Message-ID: <20141215113832.GX11764@sirena.org.uk>
References: <1418226513-14105-1-git-send-email-a.hajda@samsung.com>
 <1418226513-14105-3-git-send-email-a.hajda@samsung.com>
 <20141212165230.GP11764@sirena.org.uk>
 <548E9BB9.806@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="elthcBrLbYw+6uqa"
Content-Disposition: inline
In-Reply-To: <548E9BB9.806@samsung.com>
X-Cookie: I don't get no respect.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC 02/15] drivers/base: add restrack framework
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--elthcBrLbYw+6uqa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Dec 15, 2014 at 09:28:41AM +0100, Andrzej Hajda wrote:
> On 12/12/2014 05:52 PM, Mark Brown wrote:
> > On Wed, Dec 10, 2014 at 04:48:20PM +0100, Andrzej Hajda wrote:

> > I don't know about anyone else but I'm having a hard time reading the
> > restrack name, it looks like a misspelling of restack to me.

> Any alternative names?

Well, even just res_track would help.

> I will move the code for provider matching to frameworks,
> so it will be easy to add just dev_info after every failed attempt
> of getting resource, including deferring. This is the simplest solution
> and it should be similar in verbosity to deferred probing.

> Maybe other solution is to provide debug_fs (or device) attribute showing
> restrack status per device.

I think both are useful - it's often helpful to have a listing of what
resources have actually been registered, for example to help spot typos.

--elthcBrLbYw+6uqa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUjsg3AAoJECTWi3JdVIfQ0B8H/RvF/DMTN70TqlHNn9pDjcBk
TH7amwHd0crIonpZ/NzYIKbmi3GuwBYmcLgPodqEfd0+0wqYiyvp7mF2WQWtRUlI
KOPghdPrJjDF1k1qJH9XP9bpvqX4k1b+MIWA2SzI0MBkiiXD5g5wZlHmzx+gvBzG
tsRavBntWRbs0k6xBosyoUFJPD3IUQtYOhgYFkS5FhJjg0uFgokHLO0kL2Fl/5Mp
vYALsrJJNhT55jgBlckAy6i+fE9+4qltVqw+bGCEUxOdFwlA5PtdA+PjHZqRu4pE
sWyrpo+P5f47aO7yA9tvgIcjP5KRmbYT/Wa/dvfleWP3xXL85qs1AaeWApeE5Bw=
=G4p5
-----END PGP SIGNATURE-----

--elthcBrLbYw+6uqa--
