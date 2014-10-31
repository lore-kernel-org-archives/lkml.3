Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759015AbaJaLzT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 07:55:19 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:59013 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757863AbaJaLzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 07:55:16 -0400
Date: Fri, 31 Oct 2014 11:54:11 +0000
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Alexandre Courbot <gnurou@gmail.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>
Message-ID: <20141031115411.GO18557@sirena.org.uk>
References: <1414486356.24949.19.camel@AMDC1943>
 <1414498308.24949.32.camel@AMDC1943>
 <1414579362.18868.11.camel@AMDC1943>
 <5450C63B.3000602@collabora.co.uk>
 <CAAVeFuLncbkNLGxEAj90yMmugRDNjtjeGoV_QYTMDZ7NVMJCmg@mail.gmail.com>
 <1414681386.26703.6.camel@AMDC1943>
 <CAAVeFuJo1wTyxOo4FEZM3=GTejuSHi+mnr=QV6HUeV5mAOCmqg@mail.gmail.com>
 <1414741898.20071.8.camel@AMDC1943>
 <20141031103217.GJ18557@sirena.org.uk>
 <1414755947.7318.3.camel@AMDC1943>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rRB5tibFU002dRFk"
Content-Disposition: inline
In-Reply-To: <1414755947.7318.3.camel@AMDC1943>
X-Cookie: FORCE YOURSELF TO RELAX!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 6/8] regulator: max77686: Add external GPIO control
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rRB5tibFU002dRFk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 31, 2014 at 12:45:47PM +0100, Krzysztof Kozlowski wrote:

> Then I'll add it.

> Mark, what device should be assigned to "config.dev" during registration
> of regulators? The regulator driver's device or its parent (MFD main
> driver)?

> Various drivers do this differently.

Normally the parent device.

--rRB5tibFU002dRFk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUU3hiAAoJECTWi3JdVIfQKAQH/A0korUvhWLnb2phvpqNph0F
d6U4Y1pdFRoevFYHIzkraoEStE5tjb8T+OHdw1Poq2Tgfvg5sDHknb87kNz6SvGU
b7f42UbKEnPHsKvEFri3hanS61b1s9XFywZr24iKNtH15n0ixJpqMSvRmQR1HyTy
C0dOLi27WTHZ183uligg5/7sOjmywqyxrQZUiyImqKE3J5G4Rz4hckXi4kG5149V
xQE4WleTJbACJmnCyv39ZGgc3zfhzJHEuQJwuUwhnplxS17PUjpI7+7HdnyXDH2D
i+qJx1iGdkOHBJwBgOnimj8obI3cpBNH+aCPoeIh25YnHr03/98FhpBMDSYp5Q4=
=CYF1
-----END PGP SIGNATURE-----

--rRB5tibFU002dRFk--
