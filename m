Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523Ab3LRN2T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 08:28:19 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:59361 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754016Ab3LRN2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 08:28:17 -0500
Date: Wed, 18 Dec 2013 13:28:09 +0000
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Message-ID: <20131218132809.GR28455@sirena.org.uk>
References: <1387286601-21646-1-git-send-email-k.kozlowski@samsung.com>
 <1387286601-21646-2-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5vb8QKeSi34BFwx0"
Content-Disposition: inline
In-Reply-To: <1387286601-21646-2-git-send-email-k.kozlowski@samsung.com>
X-Cookie: Haste makes waste.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/5] regulator: s5m8767: Add symbols for hard-coded
 DVS_RAMP register
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5vb8QKeSi34BFwx0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 17, 2013 at 02:23:17PM +0100, Krzysztof Kozlowski wrote:
> Add symbols for hard-coded values of BUCK_RAMP field in DVS_RAMP
> register. This simplifies a little the code as register update is called
> only once.

Applied, thanks.

--5vb8QKeSi34BFwx0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSsaLmAAoJELSic+t+oim9PJ0P/A5FpkftgxgfeHX7KGKDVG4p
20yPxtXM99dcw5rnysyxafld6pck14DCq64TdZzuU3YMW/E8uDGa4uwTGjBdo66T
0bfjT/GfbsASGVdben56iOlAgJd5XIiQVP59tiQ93HtASGwIfzPxZZ6YY/938qqZ
aWf1IguwTZ9TpB3ceDrC/G0SKWl5rztklpbghi4u1jlsp3uBoljzZWc3z6dC7Asf
2qHOio924DsefpglwAB4PEv2bOzGXRRwVa2i+IF9fu94mfVQZRt3EutKQ8kkBEsw
eLghj3ssq/uyJieJdAjIapekeh8Ndj7SbryZXZap8ezu5Ywa5Iv7NdV3lbpbf/yk
ix0u/vFiVp01gWDsEI8f6B/6hfM9z3JyfF+pXUlXIBnBmIJZmvCFRS1Gq3yobD8g
2Y/X1U2CrHnJorX882yHbpiy5BoGXI9BpbYw/o+gsE7zu7HlCigS2qdLFbnr3gOZ
SS5na7qJUeJjUtabLmr5Lluxs+rb/3hwNOLZG62KEQztAuGA+12LIpRdJCgy6tKp
jJhdseLRGbUx4WPjKAgqrOd4zIcZC6AJpu1nz8v2ngPyGsHpIJmKa/WFbWmFwBv1
7YF8s8KZmqU++GMvNF9EX9NbLubwhGk3fBIrZCFH9AUlsDC41IlKffv2p6ufg8fW
6NbwYAF6+ffigZqpZ/kR
=5vWZ
-----END PGP SIGNATURE-----

--5vb8QKeSi34BFwx0--
