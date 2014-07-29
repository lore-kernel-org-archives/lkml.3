Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224AbaG2Plx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 11:41:53 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:47076 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbaG2Plv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 11:41:51 -0400
Date: Tue, 29 Jul 2014 10:40:57 -0500
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
Message-ID: <20140729154057.GE17808@saruman.home>
Reply-To: <balbi@ti.com>
References: <1406582183-696-1-git-send-email-balbi@ti.com>
 <1406582183-696-30-git-send-email-balbi@ti.com>
 <20140729121425.GR29045@atomide.com>
 <20140729141522.GB17808@saruman.home>
 <20140729152052.GV29045@atomide.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ryJZkp9/svQ58syV"
Content-Disposition: inline
In-Reply-To: <20140729152052.GV29045@atomide.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--ryJZkp9/svQ58syV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 29, 2014 at 08:20:52AM -0700, Tony Lindgren wrote:
> * Felipe Balbi <balbi@ti.com> [140729 07:18]:
> > Hi,
> >=20
> > On Tue, Jul 29, 2014 at 05:14:25AM -0700, Tony Lindgren wrote:
> > > * Felipe Balbi <balbi@ti.com> [140728 14:19]:
> > > > now that we don't need to support legacy board-files,
> > > > we can completely switch over to a linear irq domain
> > > > and make use of irq_alloc_domain_generic_chips() to
> > > > allocate all generic irq chips for us.
> > >=20
> > > This patch seems to somehow break off-idle for omap3=20
> > > where it no longer wakes up.
> >=20
> > Sure your bisection is correct ? This patch just switches from legacy
> > irq domain to linear irq domain.
>=20
> Yes, I tried it a few times. Just enabling
> retention idle hangs too with this patch.
>=20
> Maybe it's omap3_prcm_irq_setup that relies on
> 11 + OMAP_INTC_START? There may be other such issues

lol.

OMAP4 has the same nonsense.

--=20
balbi

--ryJZkp9/svQ58syV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT18CJAAoJEIaOsuA1yqREyAMP/ixf3WMCrPWBsFoUCBySxGzw
XKkKP9N6WuMKBnNVvMRox+0UQLfXuWkwMSBjhBdExBQG2A5x4xBT+ao/3NC6y7gj
9jcbkyuJmowvtl8GZNw2TUOZEfl7KgYe044RHH4SgmJOI5EYcB5aMASGC94B7Qtq
wXeFNNA09DH1Ah9Hz0rDO/HHatIkpPepyzH8JGjCt8g4XjAeai4Kq/7H4mODoGpG
bv8gnxhEqKkgQBWQ/91GPedR9e3SiKpd9duxGshUAZL0SIYghOJQozuMDHE9O6wX
byffQvkMExe0XErAJddAO9bUDPzem3NAtnzgPQbgV15l2Vgjo72RC0H5zjEXpDoU
7EncQPjc5ln07JL7XkVe31D+OW5w/U2nrz9QEGtO26zXbgohSkkdIwJra5LRPf0q
P5g3OqJQzT2hNr0qpOKDZH2Cqae4DR2BmA0KqBF37l5/U6Ijy/m7HxCHs7e0N3r7
NUflye9ih/ny3W+3eNlCI2cwT7x4aKpwIzGmPGgQ0e5hBvPy4k4BPUW9Qp9PaTGd
rymnMt6WqxD2JKT0CY//BAsIdciC9aRzp+0u07zsfwpzp6NmqNiFERaobw0S3KVZ
02+mYqM5YqFIWJNz0mpX/J7bE47jK37JSiQNRWBvqJtENl99UdcrFHCvuyolNdqQ
JJhSZKpgXFfyRtCic5CI
=agBE
-----END PGP SIGNATURE-----

--ryJZkp9/svQ58syV--
