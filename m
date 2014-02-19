Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839AbaBSOdA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 09:33:00 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:47748 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621AbaBSOc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 09:32:59 -0500
Date: Wed, 19 Feb 2014 23:11:02 +0900
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Anton Vorontsov <anton@enomsg.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>
Message-ID: <20140219141102.GA2669@sirena.org.uk>
References: <1392627950-26927-1-git-send-email-k.kozlowski@samsung.com>
 <1392627950-26927-3-git-send-email-k.kozlowski@samsung.com>
 <1392813881.17652.14.camel@AMDC1943>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SpiXHX+fVORj1nzn"
Content-Disposition: inline
In-Reply-To: <1392813881.17652.14.camel@AMDC1943>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.144.10
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3 02/15] mfd: max14577: Rename and add MAX14577 symbols
 to prepare for max77836
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SpiXHX+fVORj1nzn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 19, 2014 at 01:44:41PM +0100, Krzysztof Kozlowski wrote:

> I want to push whole MAX77836 patchset through Lee Jones' MFD tree and I
> still need acks from power and regulator subsystems.

> I would appreciate if you could find time to look at these patches and
> let me know your opinion (or just add Acked-by):
> [PATCH v3 02/15] mfd: max14577: Rename and add MAX14577 symbols...
> [PATCH v3 03/15] mfd: max14577: Rename state container to maxim_core
> [PATCH v3 04/15] mfd: max14577: Add "muic" suffix to regmap and irq_chip

I don't have these patches, I expect it looked like the series was going
to get a respin.

To be honest the number of large patch serieses you've been sending
iterations of (sometimes partial series without context too) doesn't
push them up the priority list, it'd help to rate limit things a bit.

--SpiXHX+fVORj1nzn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTBLtzAAoJELSic+t+oim9LKgP/i5qQe30W0ZMZueGqqSAQn+4
eaULFSi8F+FbX+de37yZCgWuikkKZvrWyGnLzKA/Lu1Xlk0Ja5mt7hCxiBL6B/ud
AhyL4zwPgybAGmh0CCSyRvyQpzor14N3N/54tuxfP/dTYDM7qwtPE9Exovhh4DhV
mCe+EJfXI9TR3LxIsgFK0NGZNbJluOw/LxqJXqgk+YSdsFKHjbdML+vzvNgCtHFt
D4/2lur7hyYVpehO9ZgohpqOYXMzhU35yGh3oTPy1PjSkKCvz9aVi8MNndNQk8Mm
qxTnci33DV+X8NzCofjsDKEmFWXQE7fsogux64NRScqXOfTYqxKlMsSld8SwZa/h
BB5cn38wqtxiGlbrdEVwdhVvvv0OmMiFADSf4lzWRrboDGeQwZGsMAgDW6xbfqU4
RWuxeGG+v9PmX5afWCVOW1KYkCOrwuB6Imvsxv/cT3zhBcsN/Evew/MBJPcpOaON
mWWGm94Ta44pPu8GmZkHbPmbijCiic6BWme60J/aAXgXwWY/OiNNHPAMhTjcasp+
HfqQ+idydbbFB2ZsOwzNsEd/84CGMm4dP51skzUuQvHbPf0dZ/7S0kPB1/jP2xT9
TAjogPnqNP/VEz9Bs6XY7l9NUpNUjBS+mJ3YLHMVjXnOMWOC34+B1Uqez8Z1q3i1
ZwyX4qWHcdLVdV03m7Fl
=b5Hq
-----END PGP SIGNATURE-----

--SpiXHX+fVORj1nzn--
