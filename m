Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561AbaDDKPW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 06:15:22 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:51128 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444AbaDDKPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 06:15:18 -0400
Date: Fri, 4 Apr 2014 11:14:58 +0100
From: Mark Brown <broonie@kernel.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: lgirdwood@gmail.com, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Message-ID: <20140404101458.GQ14763@sirena.org.uk>
References: <1396600198-7288-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NphB68aIrRU2wdue"
Content-Disposition: inline
In-Reply-To: <1396600198-7288-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Cookie: To make an enemy, do someone a favor.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: core: Fix typo in of_regulator.h
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NphB68aIrRU2wdue
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 04, 2014 at 09:29:58AM +0100, Charles Keepax wrote:
> Fix a typo from my patch adding of_regulator_put_match in the patch:

Applied, thanks.

--NphB68aIrRU2wdue
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTPoYfAAoJELSic+t+oim9Pr4P/R1w7e+V6BsOCMhwPkjnmv4a
68TZGJ6F4omWrRPPfPH9JGdrgtOmNQSuwI+uwbmu0wctIGd1A7MiajogPMzlYPUL
paWPw3gxBQfL/Dmxuggth1GPoxm6eNWq/cuzgTg1A6a+iw68gx9Czk6bgJSoI/TD
LXRQ491zFHYeMwSEbQFSJM7WId4N1pKDldzROlLl9JCK/F7SIOH9UgipW5+4ZD0R
RGZk2u5S8U82jwst5S11eXZzPHpLsSevuK8AoszYgRr1sYEBe35z6xOkD0sPIYpD
6b70Z4SSEBW6WW2rfmgyzCkQM5dL/9QAWEdKirz3Qv/uAUt/b44K9zRFU3aVViEw
6If9CwnbTA4rB0TXf6M6V+w6cb4gDJgGobbkcyZ9Tlfl99Wk0cuNFm6agavmIbDX
dK1phI1NUp7IcZPXmAUo5vIp4LIGd9AittjmVi6wKKomhjcwvu609ToWNN5IjHfX
cqlsIN7KZHzT4jY/95+YSAnRUfxf9J5kxgvZj33WCq4t+E00rGL3n9NJZFWr5aFD
hxAp3yC7zS9wnKAjOSdcB+4T/p+GNL4jeraptFPGv98w9Pw1Zo8am3680MEtFG8l
Y1KZhpfm5pdVHrUc47Fpd4B3fn7OcYK35y9earxwo1rQwb8sE9KPLagFPjVBWGPe
QgYt5W+y6WutKzoaMPl0
=otNo
-----END PGP SIGNATURE-----

--NphB68aIrRU2wdue--
