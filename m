Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756856Ab3K2OuK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 09:50:10 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:51282 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755363Ab3K2OuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 09:50:08 -0500
Date: Fri, 29 Nov 2013 14:49:43 +0000
From: Mark Brown <broonie@kernel.org>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Misael Lopez Cruz <misael.lopez@ti.com>
Message-ID: <20131129144943.GC27568@sirena.org.uk>
References: <1385733827-19831-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JAtnJwvplI04zgov"
Content-Disposition: inline
In-Reply-To: <1385733827-19831-1-git-send-email-peter.ujfalusi@ti.com>
X-Cookie: Boycott meat -- suck your thumb.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 0/5] ASoC/MFD: twl6040: Remove codec driver local reg
 cache
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JAtnJwvplI04zgov
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 29, 2013 at 04:03:42PM +0200, Peter Ujfalusi wrote:

> Is this close enough of what you had in mind when asked me to look at this?

Yes, this is exactly the sort of thing I was looking for - thanks!

> twl4030 codec is going to be a bit more complicated AFAIK but it will come
> eventually.

Yup, they're both more complicated than most of these devices otherwise
I'd have thrown some changes out myself - all the fiddling around inside
the cache data makes them more difficult to work with.

--JAtnJwvplI04zgov
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSmKmDAAoJELSic+t+oim9AvkP/R1oa4xSjeTzguylhziNPmi6
PwJj+cxioIB7BkOkuSliLKBeoLqy3OraJsT3p673LJGfuCwJlDYNYhX7HHoWJ57Y
ct+Qcw6SMGIpAhDOdT8AggSTW36FBg2LJ+Jej4KIdT+FWnBAG+6mmcVoX8mQEo3S
xztLmZSy7qO8t3wE9uMLnIr70rbgsxdsR5uBDsp5cUODdeoxaQZXTp00tVOpY3VZ
nPn0t7OGVwzPIOm6SJUrktnST4yHQg/z4gHns6G+1t+4AfunjUj+O9VlGKIR84S1
/8wi1AWfWGc8o74J9L5FI9Ki175gtMkNm7zwGH2hWkLNXG+Ry6WXkarNxLpi3TqT
ZixPqIlXbaFZAFcP0mslBBm9UsVRDDSVeh8B9mViAel159ifNQ3Bn5LMUH3ZVMZQ
oVE6+YIoANtuG2L+1665LXKX5dpQknEZfEhkwiCZ7LxFkmSZbMFozdFdUYUcUhHt
8H/5Jioajv8NA28K4l3aNJP5EiCwqMFs4gWCpzRASiEvAx21d2wro7hx7QZU1nVc
uP87usJsMo+q6YGb2EzdkBBmrORNzif7vIhpXioDGdgAprTpabYsYeir8z3oxtpx
W2q4wGAlWL/yVXltrPaABzPjUxmWUNIbq9FBd8NIoL/FSBPoLlYsW3oVnRgziCO+
yvrKpunUQayC0mWNHVb0
=UAgv
-----END PGP SIGNATURE-----

--JAtnJwvplI04zgov--
