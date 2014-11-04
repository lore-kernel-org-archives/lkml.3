Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753051AbaKDTsu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 14:48:50 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:37839 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073AbaKDTsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 14:48:47 -0500
Date: Tue, 4 Nov 2014 19:47:29 +0000
From: Mark Brown <broonie@kernel.org>
To: Mike Looijmans <mike.looijmans@topic.nl>
Cc: lgirdwood@gmail.com, linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Message-ID: <20141104194729.GV3815@sirena.org.uk>
References: <1414668415-597-1-git-send-email-mike.looijmans@topic.nl>
 <20141030165133.GB18557@sirena.org.uk>
 <54573860.4060708@topic.nl>
 <20141103120919.GE3815@sirena.org.uk>
 <545795D8.1040600@topic.nl>
 <20141103151058.GP3815@sirena.org.uk>
 <5457BD85.2070901@topic.nl>
 <54589472.8030305@topic.nl>
 <20141104113417.GG3815@sirena.org.uk>
 <5458D636.3000401@topic.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CuZtzLgFeSWyzOuB"
Content-Disposition: inline
In-Reply-To: <5458D636.3000401@topic.nl>
X-Cookie: Some optional equipment shown.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2] Add ltc3562 voltage regulator driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CuZtzLgFeSWyzOuB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 04, 2014 at 02:35:50PM +0100, Mike Looijmans wrote:

> I still need help with one thing that isn't clear to me though. The DT is
> parsed when calling regulator_register. But then how do I fetch my "private"
> settings in there BEFORE the regulator gets enabled? The feedback resistors
> and regulator mode must be set to the correct board before the output is
> enabled, otherwise it may damage the chip and its periferals.

Add a callback for this.  Javier and/or Krzysztof were looking at this
for some other stuff, though I think they were intending to add core
functionality for their specific feature.

--CuZtzLgFeSWyzOuB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUWS1RAAoJECTWi3JdVIfQXHcH/0gHe0s8dr66qq0bHYRAYyT/
NB+d1MFD3HI636VBgHMV9ZH6WOuzAVii19L7ZuyaDJyx9EZA5drQVRnXzAIuuMgU
d4q7YSJ8rH2t5MBkU2d5Ck9Q9Ti4baTkLM/5jaPSJgBVjbOkQqo7X4nNoOLmvLzu
WDyPIYtmQjrlv9KnqgkL7bu6UZ6RZX+rAUpcAxRtg1ZkXMaBFJW5lVs8JTs/lGoH
dTfm/dxiNNlckSfja1P1a7R67CTKIZWx15prwjO4c0HAF5g3we1LLtugmOmOtIl6
tGsQM2RH4yRYDEYWvxIk/TCQ8x6c8x67TlXT9ge5Kxe7ldt2GdFL4ttBbAEKHm8=
=cJTC
-----END PGP SIGNATURE-----

--CuZtzLgFeSWyzOuB--
