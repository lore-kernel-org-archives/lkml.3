Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932896Ab3GCSFQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 14:05:16 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:36526 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755982Ab3GCSFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 14:05:13 -0400
Date: Wed, 3 Jul 2013 19:05:11 +0100
From: Mark Brown <broonie@kernel.org>
To: Yadwinder Singh Brar <yadi.brar@samsung.com>
Cc: linux-kernel@vger.kernel.org, yadi.brar01@gmail.com, sbkim73@samsung.com,
        lgirdwood@gmail.com, sameo@linux.intel.com, rob.herring@calxeda.com,
        grant.likely@linaro.org
Message-ID: <20130703180511.GA374@sirena.org.uk>
References: <1372072858-6559-1-git-send-email-yadi.brar@samsung.com>
 <1372072858-6559-4-git-send-email-yadi.brar@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ReaqsoxgOBHFXBhH"
Content-Disposition: inline
In-Reply-To: <1372072858-6559-4-git-send-email-yadi.brar@samsung.com>
X-Cookie: Do not overtax your powers.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/4] mfd: s2mps11: Add device tree support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 24, 2013 at 04:50:57PM +0530, Yadwinder Singh Brar wrote:

> + regulator-ramp-delay for BUCKs = [6250/12500/25000(default)/50000] uV/us

> + Optional property for BUCK[2/3/4/6] only:
> + regulator-ramp-disable: boolean, disables ramp delay on hardware.

If these were device specific bindings they ought to be namespaced as
samsung, or similar.  However I think they are generic enough that they
could just be added to the standard regulator bindings, ramp rates are
common enough and units of time are a simple way to express them.  I'd
also suggest just using a ramp delay of zero for no ramp, it's simpler
and will probably fall naturally out of the bindings.

Please just send a separate patch adding these to the generic regulator
binding document instead of this one, we can add generic code/ops for
this later.

--ReaqsoxgOBHFXBhH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR1GfUAAoJELSic+t+oim9heoP/3AtoR4HCqATygA0QheZ0dPe
KjsnZ30m5wDdCgMAEp5voKQ273g4L8Nsg+4nsxIwgtMxZMBY2d9mSd9HHNaZh8ia
PFO9dqYA9A5G8JXEeRu7GOWvdwQ4YRZUCul7XlXQ0LYh8gbG0wlSgPY7CaasSf5p
/FWm7b/s5gjRwpqyqhsv2Acs3KpdXNupCLUD9hHKBFIexsK9bV0/ozbWFzqHtMVC
bSBkfjAY9QWNh8jgXtmMoJI6moHinsodmkfYEDsce8ghfrqfgBEp6EGOtGXsGp9l
FmOROLFpQvKI2muOgfBPK7Q4sowxyi7s3ix02iOjqqCtXjAVAIPw4ndfV4Efyg3d
WJBq0KQ651qXsSxWZ+Xrbf16cmB0tG3v+wOqUW2JOMhfCCq99y6KAxEaXDBpUqfK
F4sBcAV8zeQkeciQw5YlbKW4qF++y/AUOoYCeGHdZ3ymUQCtR1EiRe/kN2d4H0lF
MFNw3MdOFO6dtgzttW+ivhn6PSmLfebiZ9ItNK572nrntd2rU0/zkf09yxtt9xYX
qH6N9WS/NYJVd9eQEyx0rpKgGOSNu9vxg9vx8Xfe//WzmGT2N9wiu6fssiAbAZhb
5bN7GfNJwm+7UnKF39dsS0rUC8p6KU6tXmpabPMzDjrY3ajfhsZL9GHS2DYDoSqQ
/cF1vF8fZH7W0TWzYnvL
=+FMQ
-----END PGP SIGNATURE-----

--ReaqsoxgOBHFXBhH--
