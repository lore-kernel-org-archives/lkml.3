Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683AbaKZUpO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 15:45:14 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:39814 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895AbaKZUpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 15:45:12 -0500
Date: Wed, 26 Nov 2014 20:43:04 +0000
From: Mark Brown <broonie@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Message-ID: <20141126204304.GB7712@sirena.org.uk>
References: <1415180871-25293-1-git-send-email-k.kozlowski@samsung.com>
 <20141110110022.GX21424@x1>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ut8Pu+B8B/aO50sZ"
Content-Disposition: inline
In-Reply-To: <20141110110022.GX21424@x1>
X-Cookie: Celebrity voices impersonated.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 0/3] regulator: max77686/802: Cleanup
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ut8Pu+B8B/aO50sZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 10, 2014 at 11:00:22AM +0000, Lee Jones wrote:
> On Wed, 05 Nov 2014, Krzysztof Kozlowski wrote:

> > Everything should be pulled at once (preferrably regulator tree).
> > Rebased on next-20141105.

> I'm happy for that to happen, so long as Mark sends me a tagged commit
> to pull from.

The branches for these drivers are getting a bit big and pulling in
other stuff in the core - it seems like it'd be as easy to just wait
till after the merge window for the deletion of the old code...

--ut8Pu+B8B/aO50sZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUdjtXAAoJECTWi3JdVIfQfUMH/R/r1WHvn7jOEHeWKas3NQjI
icLsiMErnYoEWDE2Z729QhWsopWwinUPgCtTKVh3iYQm0WnY9DPtn0NqDCgzvG96
FLaaq1FJxfZLoDGA5Hoyym1EX9talbnPnjMxMQ7gCPKekd3WZa//Ag0/qDi0jvHI
ZKQrgkq/UIv3YuRfqkot2gly/OP2xoJwJyVTlMZbaMUTArUOUxT6B30DZ0zFAz8n
XgdhvzsCQAJzjbFCDtRsSadct1L3EOgPerpNRk5+9hqQ1GYEDRpJo+TlHP73oEHH
fFvRyzPyGErqqgqhZB7GAHxfqSc0FmlXOuQ8GTWpNuWfmJtkzWBAdGTGxB6h+Pk=
=aQ8m
-----END PGP SIGNATURE-----

--ut8Pu+B8B/aO50sZ--
