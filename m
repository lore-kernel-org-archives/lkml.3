Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757198AbaCRTw1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 15:52:27 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54333 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755314AbaCRTwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 15:52:25 -0400
Date: Tue, 18 Mar 2014 19:51:59 +0000
From: Mark Brown <broonie@kernel.org>
To: Paul Handrigan <paul.handrigan@cirrus.com>
Cc: Brian Austin <brian.austin@cirrus.com>,
        Nicolin Chen <Guangyu.Chen@freescale.com>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <rob@landley.net>, <lgirdwood@gmail.com>, <grant.likely@linaro.org>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <alsa-devel@alsa-project.org>,
        <lars@metafoo.de>
Message-ID: <20140318195159.GQ11706@sirena.org.uk>
References: <1394538091-19513-1-git-send-email-Guangyu.Chen@freescale.com>
 <20140318131033.GC11706@sirena.org.uk>
 <alpine.DEB.2.02.1403180936200.14838@heelrod>
 <alpine.DEB.2.00.1403181202310.7177@phandrigan-desktop>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="W2IRJ2e1E3eviBXu"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1403181202310.7177@phandrigan-desktop>
X-Cookie: Turn the other cheek.
User-Agent: Mutt/1.5.22 (2013-10-16)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3] ASoC: cs42888: Add codec driver support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--W2IRJ2e1E3eviBXu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 18, 2014 at 12:08:02PM -0500, Paul Handrigan wrote:
> On Tue, 18 Mar 2014, Brian Austin wrote:

> >Driver looks good to me. I think we should name it the cs42xx8 since this
> >actually covers CS42448 and CS42888. The CS42888 is derived from the
> >CS42448.

> V3 looks good. As Brian said, the name should be changed to cs42xx8.

Great, so if Nicolin resubmits with the rename when he gets back he can
add acks from both of you?  The driver looked fine to me too.

--W2IRJ2e1E3eviBXu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTKKPcAAoJELSic+t+oim9Hf0P/3rELI7VwR3LxlMlYZU+9r6B
sgnvrD/uHk5LbNY5qAflhMdPFZ21652qQ7gMFZWuvU/TslS56B3vh5Ps79AyxLt3
IjjWPZcjYR/FOdZYEikh6eSuWzBXXZhlJovCLI7Bk5yikpgqO2BoJvSfllfPq6MO
6azixef+wLPYqxmb7SDQVPWEggwOm49D/8OaG4rrneSGWJ0rheH7OxQOBXXixjO1
RxY5riSQuMXNeYwuO05MueNtMfMZR83ZFMKrR6h34oqEWEoEG69fCCas7lwoSW5X
ZqrTOuaWn1N0eq1UqH8X6WRthrbTK9XYldAmee7VY78E+9rCyPz9EjfUE/tzdAzH
OlYMGKlxb6Q06shngFL/6jNbqd3hKQtTmyJSupWsWka4WxcR7gzh+E8HiLtDlNgq
L9+ub00dXyqWBzTYpUAiCRq7WxyRsjOU1YWrkFO97txWnp+KP2fRTY8ApkKkV1La
f5yduYlsw1wS3NDTlL5R9x58XRtJXxfkpjgl+T/mRFyzMOA/HGpQ4M8qPaIeC4td
MpQiPAwbuazUlXTOg0dni/FjQAii0ZAw+euY1YFRmOLsE8fEfXOc2eo2pmjgTM+R
56kOa0q3qbUW4Q7qYzWMM8Gi8EFWwg4YBnM1ZtLhvRoDMjeIGwdk4Zq+ldU4AzQM
8cAd0dPkmZAgjZVcNXcc
=+khg
-----END PGP SIGNATURE-----

--W2IRJ2e1E3eviBXu--
