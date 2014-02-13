Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877AbaBMSZ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 13:25:58 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:42233 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239AbaBMSZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 13:25:54 -0500
Date: Thu, 13 Feb 2014 18:05:26 +0000
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Yadwinder Singh Brar <yadi.brar01@gmail.com>
Message-ID: <20140213180526.GU28112@sirena.org.uk>
References: <CAKew6eUtuQEHJJ9G+g54LRoH8sXzqixDBUEjCjFyRDJTRP00Nw@mail.gmail.com>
 <1392295024-4862-1-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gw/jrspf8iiPX0nu"
Content-Disposition: inline
In-Reply-To: <1392295024-4862-1-git-send-email-k.kozlowski@samsung.com>
X-Cookie: Oh no, not again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 07/14] regulator: s2mps11: Copy supported regulators from
 initconst
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gw/jrspf8iiPX0nu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 13, 2014 at 01:37:03PM +0100, Krzysztof Kozlowski wrote:
> Add __initconst to 'regulator_desc' array with supported regulators.
> During probe choose how many and which regulators will be supported
> according to device ID. Then copy the 'regulator_desc' array to
> allocated memory so the regulator core can use it.

Please don't bury individual patches in the middle of replies to other
patch serieses, that makes things more confusing and difficult to
manage.  Please also try to avoid sending only one patch from a series
to some people - at least also CC everyone on the cover letter so that
it's clear what the overall goal is and what the dependencies are.

--gw/jrspf8iiPX0nu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS/QljAAoJELSic+t+oim9Hm4P/3mAVh/85kwgOPuPdvG8HCgU
bR0iUxBXcE70IMwzQHCT6CWw3yclCatmkcbR2Jz2yXyfxNGCnts8plClCBb05k0x
UEAA8KlhxEKMUWo3giStEPnLiIPf4iOmfrneXvZ6HlUWbOcWqKwmi4eTqtSil6y1
6vteM/92PzU7tv7BBszh56+BU74k1+3cz3orEpZ+6WCG7lF8yVrf21bGOdxWYSc0
AL9+v89UdZG9PD0XY+K7YnM3HtrzTRaSyifDufhs4NToyf1N4xkWuxZGTKiZf7MK
QwMcpVd3URgNmoXI82AUwVEVPumDTIzWSLyz1e+fD+30n/Dq35x+trJlXPnUbct+
6kyLUrQ7J267GZHWi9WO269AceG0QXqjpwiZ/kqZ+eI9dtJ54KptS7LZTF80uE8t
No3S/u5wbIg6DVDqYJNvkKiOd06Yb59w5eu5GFyz2PHy5x0KEqauJFl4XNMPr1j5
bdxoPlPghIGD1a09oG1cx3qGPYCQg+dB9bLwxDKtVvYdvKqmUJfTlOA5DxNRdZJE
GcVOALxNoUWLXNLKXCAGQvlxV8LZuhZ0DUobkKFd1JtX9sgLYl5ep72PlvwTX89R
zhakzu6xy1c8nQMFO42NvHTZ3t/7SxYUcsrPHyyK8z+WjDet2Hpr8M/tsnKYbK1c
Al4BPZKtIAYTKcbX6WmU
=cbI2
-----END PGP SIGNATURE-----

--gw/jrspf8iiPX0nu--
