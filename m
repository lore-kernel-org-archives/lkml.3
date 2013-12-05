Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753689Ab3LEVnu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 16:43:50 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:41965 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753224Ab3LEVnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 16:43:46 -0500
Date: Thu, 5 Dec 2013 21:43:41 +0000
From: Mark Brown <broonie@kernel.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Milo Kim <milo.kim@ti.com>, Lee Jones <lee.jones@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-pwm@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>
Message-ID: <20131205214341.GC29268@sirena.org.uk>
References: <1380082975-6022-1-git-send-email-milo.kim@ti.com>
 <20131204103431.GC26589@ulmo.nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WbkWELb8d/6oR4nB"
Content-Disposition: inline
In-Reply-To: <20131204103431.GC26589@ulmo.nvidia.com>
X-Cookie: It's clever, but is it art?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v4 0/4] LP3943 MFD driver for a GPIO expander and a PWM
 generator
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WbkWELb8d/6oR4nB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 04, 2013 at 11:34:32AM +0100, Thierry Reding wrote:
> On Wed, Sep 25, 2013 at 01:22:55PM +0900, Milo Kim wrote:

> >   mfd: add LP3943 MFD driver
> >   gpio: add LP3943 I2C GPIO expander driver
> >   pwm: add LP3943 PWM driver
> >   Documentation: add LP3943 DT bindings and document

> I suspect that given the build-time dependencies Lee may want to take
> all four patches through the MFD tree, so I've acked the PWM parts.

FWIW this isn't an issue with new MFDs - since the function drivers will
depend on the core driver it's not possible to enable them in Kconfig
until the core driver is also merged and you don't get bisect issues.

--WbkWELb8d/6oR4nB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSoPOJAAoJELSic+t+oim90fgP/Rr9rCPDaQciOglENW/i2AnN
Yk5bbdeAeNSjI3GhIdprtb3C/MjqJAGo+TOmDU7HLo1vzIVM54CumZCYqg6qQwKu
W0X3jadh/PMhDW8v04ixxxNoT7Ag9qCWdGIdO/z2lKq3sDWGEn7nFmRmCQQSK8sx
u2C+uvrnI98XQ7klNEc/y6yrqAAy/NOKX708INrS4sMFtkLSvory8N512pS53SUM
+2g3hx3LYVvLhBy30nmT7kHRvbC1aSDUmEOPW3XCOFKq5wzqTVy9F2/Ftno0W+I/
9efSSOD7DgtUWe1mDUZbjA7H+Fbpzp+gNY+9L24mGrD8uTL/Vk7QMvsIpW/2grce
xuEf66JAKeytsFFkbNcmQSB+NV8rivLyfxJ661a4wVDAFJg7uw46neRoGnCjZqXs
xinFj2bC4479zkW3PiobTIeh7AHBmKpca7x/7HD1+FqDrpk3vL5SAq7KwAflCRBt
WqR2JlqRwX19GuGoVWhJq2sYmx0wUdVRvRTzJhoJeZwMrIsZVd/W9C/sbJh3qKgX
u4vDtO1jwUpMwKddbKIOt5/rjOm4lMmdNG9akwdsR7iplcstIQn9IkMEww4CALM9
z3r0SModw7MrOVAdEjq9Re7gI+RDhY/NCfhsazieBh7gan5cA9NEGK9pQrTNRicX
TQJj9JyQ55eNErjHPGsq
=4LdU
-----END PGP SIGNATURE-----

--WbkWELb8d/6oR4nB--
