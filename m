Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751708Ab3GDJWz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 05:22:55 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:55328 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769Ab3GDJWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 05:22:53 -0400
Date: Thu, 4 Jul 2013 10:22:49 +0100
From: Mark Brown <broonie@kernel.org>
To: Yadwinder Singh Brar <yadi.brar01@gmail.com>
Cc: Yadwinder Singh Brar <yadi.brar@samsung.com>, linux-kernel@vger.kernel.org,
        sbkim73@samsung.com, Liam Girdwood <lgirdwood@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@linaro.org>
Message-ID: <20130704092249.GK27646@sirena.org.uk>
References: <1372072858-6559-1-git-send-email-yadi.brar@samsung.com>
 <1372072858-6559-4-git-send-email-yadi.brar@samsung.com>
 <20130703180511.GA374@sirena.org.uk>
 <CAKew6eVs+D4Yf+9=e+0fj0UaZQ98gJ-1=CX30_H0p-xnF75gaw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zLM+hZtO9R0ndG7f"
Content-Disposition: inline
In-Reply-To: <CAKew6eVs+D4Yf+9=e+0fj0UaZQ98gJ-1=CX30_H0p-xnF75gaw@mail.gmail.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/4] mfd: s2mps11: Add device tree support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zLM+hZtO9R0ndG7f
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 04, 2013 at 10:37:30AM +0530, Yadwinder Singh Brar wrote:

> -  Currently ramp-delay (= 0) if not defined in DT, leaves the
> hardware with default

That's just an issue in the code if that is the case, you can test for
the presence of a property independently of getting its value.

> - As ramp time is inversely propositional to ramp-rate(i.e. ramp-delay ,
> its wrongly named, my mistake :( ) so it may look weired to use ramp-rate =0
> as no ramp(ramp_time = 0).

I think it's fairly obvious what's going on there, it fits in with the
general pattern that a lower number is faster too.

> I had below idea in my mind, I dropped it because I thought it may be
> to early to put common code as no other driver in mainline appeared
> with this requirement yet but probably may come.

There are plenty of drivers that could configure this, it's just that
it's normally done either in hardware or the bootloader rather than by
the OS.

--zLM+hZtO9R0ndG7f
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR1T7lAAoJELSic+t+oim98PsP/jGJ7RQm7iw2i6lZ3bZR87G7
QxDEK8Q9E1RHbecsBsY5sC17ja/JN+CZPegefPyO3Tn3mlD5NOXQuteRBw6s282Z
sutDbvbyWRZQFuNsNPpX0T0/pg/y9C7s0tR11VgCY2yJKe5ERMWFFgW+a4c8oaJb
89IU+9V4l5g8BQPzRrtBu5EcY72dAi43JUCxE9q/T7heyM5axWMPWUTLhEvxvzi4
FOahGEWWzAQrOEF235+pg+9xai7HMUL93UT2olKKQkv4QLWlskjrY2Mu+UO28nWv
6V9MrkoaCH1SYyZS0meknV8Ev1H3t6Z87LHy19P63ZbJPy9LBQKu0IlznGyWhHLS
JftahzVd5TaTUq7nxIZDdyFewDnKRZwxyBRIwPk/tjEnfjpm1eT4eco9JzfVR8XV
5euxuSIMyF6Y4T97JTPCuZtmIrRq8Jz0+RzR/tlwZRd4KKSHkeatUTG0wk4K0zB+
/Zga5lqD7zFY2TcSYAiXF0yTma/kD7Ig3Azfq86qS4++3bdUJQsoDxYDuWtVIv7p
1w24xwUvfmSFBnzTD4xnvr1b4Wyiw+T6VIHIb9Ad2y3mSM7NDZtGMLZRwEfKzbbV
6HH2prZyurzMjL4TohvdZpQVxpPetf2EU3o+XeNfR1cUYcZdB3Ste0iCOVfAKEju
ttWDL0fzZM9T5E7ggBR1
=vWX9
-----END PGP SIGNATURE-----

--zLM+hZtO9R0ndG7f--
