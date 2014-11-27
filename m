Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751388AbaK0QdI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 11:33:08 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:41057 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848AbaK0QdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 11:33:05 -0500
Date: Thu, 27 Nov 2014 16:30:59 +0000
From: Mark Brown <broonie@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, linux-spi@vger.kernel.org,
        devicetree@vger.kernel.org
Message-ID: <20141127163059.GZ7712@sirena.org.uk>
References: <1417088636-11994-1-git-send-email-lee.jones@linaro.org>
 <1417088636-11994-3-git-send-email-lee.jones@linaro.org>
 <20141127130053.GW7712@sirena.org.uk>
 <20141127145542.GH4628@x1>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dfAulW8sdm/Y0CsS"
Content-Disposition: inline
In-Reply-To: <20141127145542.GH4628@x1>
X-Cookie: Celebrity voices impersonated.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/4] spi: st: Provide Device Tree binding documentation
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dfAulW8sdm/Y0CsS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 27, 2014 at 02:55:42PM +0000, Lee Jones wrote:
> On Thu, 27 Nov 2014, Mark Brown wrote:

> > What do the two different compatible strings mean (for example, should
> > ssc4 be used for version 4 and higher or is it just a quirk for that
> > version)?

> This appears to be historical.  There aren't any functional
> differences i.e. we don't match on them.  I believe the former is a
> more informal, generic name and the latter is the official name of the
> IP block.  The I2C component already upstreamed has the same naming
> conventions by the looks of it.

Probably best to say something or retire one then.

--dfAulW8sdm/Y0CsS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUd1HCAAoJECTWi3JdVIfQOWoH/1hYO3qV5JbFVeE0xphBa4Td
1xry2lXjk5lelhXBiNcpkEq2hLJVXQntjaLu5L2syKi9TvD9JNT6HycJvVv33vU3
jlkcY7A6hM+ol8ExKBH0rcUQS/mWFPqj19+WtKKR01NlP08qaN5KHJmxcAseGxNV
J2Y9t4usSRw2XTtxOXN/R4KcwZqZSFdLA+NPFJv92B9UVnzEnlKCLDxdB8ETSfCS
C7MBYmmYyDvbF1waozT0bLBV2qMLj8L+pA3CGWBW8zZQANL1FNHsC1ciNx3Qa2y7
Di1Mgs1UexxS+zl7OgWGyPc3MQorck6DOPhJkBwct7HliP9egEUCvw1yVsY7dk0=
=mAJ2
-----END PGP SIGNATURE-----

--dfAulW8sdm/Y0CsS--
