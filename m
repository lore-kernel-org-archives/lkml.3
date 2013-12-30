Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755670Ab3L3L5P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 06:57:15 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:60354 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755574Ab3L3L5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 06:57:14 -0500
Date: Mon, 30 Dec 2013 11:56:52 +0000
From: Mark Brown <broonie@kernel.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org
Message-ID: <20131230115652.GJ31886@sirena.org.uk>
References: <1388048943-5540-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JUntuW47Nl+13QpX"
Content-Disposition: inline
In-Reply-To: <1388048943-5540-1-git-send-email-sachin.kamat@linaro.org>
X-Cookie: Go climb a gravity well!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/1] regulator: s2mps11: Clean up redundant code
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JUntuW47Nl+13QpX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 26, 2013 at 02:39:03PM +0530, Sachin Kamat wrote:
> BUCK 3 and 4 share the same ramp delay. Hence make it a fall through
> case instead of duplicating the code.

Applied, thanks.

--JUntuW47Nl+13QpX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSwV+AAAoJELSic+t+oim9UzwP/igN6xF1Z2SIq/GIfEdJ7z6e
601KK1itxB/RgQdgDm9h/EuiMo2X3ps2HEwxLdyCnLNy0qsMeTridB2pb+FTHx/Q
9isrHGvxCKw3vQHkN9mrRHC2gQbkapqjWD1glubdR2DB0smp10BYeNvdSci9HwB/
KVJPeh6eEgZvFyb06YtmDaVt9ob5IVp3tC/dX2iDvuyGzkKariCv4n60N3PQAcXs
5PH93l/NvfC9trCPnk2N/r/DMY/S88BXTOasAI8UkVzKT4VWjk6qQHUQZkeczWnQ
z7xmwCdz+kgM52Q3f39mefO2u6S2DDqbFQCP85/gLSuaxNtAQFHGa1QETOES+RDi
z6PRqHqRbWU5nz2Jfax2bTnPzsF/u9k38mIVJrINEPE4/bCxSG9RQOn9Qt9K20Bc
yDRJFVnUeqnM8oasy1ZlGWnOVqmBu25XIlLm1xVt70w0noaiVYhmZqvZPpNxYYGv
VWK932YVJYhNtZPf/ET7pYXd38g4X8ImQdC2zErjHRtqC1iQTxxXvDCoAKZkF/oQ
C+2WKHSMMQFjnCkmzl8cgTCW9gjdlpy/f/f3fz9RFbZgxQSekT1tMqxTdL0HPjfT
jzTV9kEDObJZrE1KN7MgROF/eNS6ioXbJjfdFjGqD5JeAIl+RT8mDJZuZXAo1/+S
TR1q7KUMFRkDIQpPvtv1
=4J4T
-----END PGP SIGNATURE-----

--JUntuW47Nl+13QpX--
